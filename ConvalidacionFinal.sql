-- Resetea cada secuencia al MAX actual de su tabla
SELECT setval(
    pg_get_serial_sequence('unicen.materia_externa', 'id_materia_externa'),
    COALESCE((SELECT MAX(id_materia_externa) FROM unicen.materia_externa), 1)
);

SELECT setval(
    pg_get_serial_sequence('unicen.tema_externo', 'id_temaext'),
    COALESCE((SELECT MAX(id_temaext) FROM unicen.tema_externo), 1)
);

SELECT setval(
    pg_get_serial_sequence('unicen.equivalencia_materias', 'id_equivalencia_materias'),
    COALESCE((SELECT MAX(id_equivalencia_materias) FROM unicen.equivalencia_materias), 1)
);

SELECT setval(
    pg_get_serial_sequence('unicen.tema_asociar', 'id_tema_asociar'),
    COALESCE((SELECT MAX(id_tema_asociar) FROM unicen.tema_asociar), 1)
);


select max(id_tema_asociar) from unicen.tema_asociar;

create function seiko_addmateriacarextcontemas(idmateriaexternaorigen integer, codmat character varying, nom character varying, ch integer, iduniext integer, idsd integer, temas jsonb) returns void
    language plpgsql
as
$$
declare
    v_id_materia_externa integer;
    v_max_id_tema_externo integer;
begin
    -- 1. Inserción de la nueva materia externa
    insert into unicen.materia_externa (id_materia_externa, codigo, nombre, detalle, carga_horaria, id_sede, id_universidad_externa)
    values ((select coalesce(max(id_materia_externa), 0) + 1 from unicen.materia_externa), codmat, nom, 'N', ch, idsd, iduniext)
    RETURNING id_materia_externa into v_id_materia_externa;

    -- Obtenemos el ID máximo actual una sola vez y lo guardamos en una variable
    SELECT COALESCE(MAX(id_tema_externo), 0) INTO v_max_id_tema_externo FROM unicen.tema_externo;

    -- 2. Inserción de los temas iterando el JSONB (Usamos WITH ORDINALITY para garantizar el orden)
    INSERT INTO unicen.tema_externo (
        id_temaext,
        id_tema_externo,
        id_materia_externa,
        titulo,
        nombre,
        contenido,
        id_sede,
        estado
    )
    SELECT
        v_max_id_tema_externo + arr.num_fila,
        v_max_id_tema_externo + arr.num_fila,
        v_id_materia_externa,
        arr.value->>'titulotema',
        arr.value->>'nomtema',
        arr.value->>'cont',
        idsd,
        'ACTIVO'
    FROM jsonb_array_elements(temas) WITH ORDINALITY arr(value, num_fila);

    -- 3. ASOCIAMOS LA MATERIA CON EL MISMO QUE TIENE ID_MATERIA_EXTERNA_ORIGEN
    INSERT INTO unicen.equivalencia_materias (id_equivalencia_materias,id_universidad_externa, id_plan_estudio, id_materia, id_materia_externa, carga_horaria, materia_local, materia_externa, cod_mat_externo, cod_mat_local)
    SELECT (SELECT max(id_equivalencia_materias)+1 FROM unicen.equivalencia_materias),iduniext, id_plan_estudio, id_materia, v_id_materia_externa, ch, materia_local, nom, codmat, cod_mat_local
    FROM unicen.equivalencia_materias
    WHERE id_materia_externa = idMateriaExternaOrigen;

    PERFORM setval(
        pg_get_serial_sequence('unicen.tema_asociar', 'id_tema_asociar'),
        COALESCE((SELECT MAX(id_tema_asociar) FROM unicen.tema_asociar), 1)
    );

    -- 4. ASOCIAMOS LOS TEMAS A LA TABLA tema_asociar
    WITH base_json AS (
        -- Extraemos el nuevo id generado y el arreglo de IDs a asociar
        SELECT
            v_max_id_tema_externo + arr.num_fila AS id_tema_externo_nuevo,
            arr.value->'id_temas_asociar' AS arr_asociar
        FROM jsonb_array_elements(temas) WITH ORDINALITY arr(value, num_fila)
    ),
    ids_asociar AS (
        -- Desglosamos el arreglo de primary keys (id_tema_asociar) en filas individuales
        SELECT
            id_tema_externo_nuevo,
            CAST(jsonb_array_elements_text(arr_asociar) AS integer) AS id_tema_asociar_viejo
        FROM base_json
        -- Filtramos por seguridad para asegurarnos de que realmente sea un arreglo
        WHERE jsonb_typeof(arr_asociar) = 'array'
    )
    -- Insertamos recuperando los datos originales mediante un JOIN


    INSERT INTO unicen.tema_asociar (id_tema_externo, id_tema, equivalencia, id_sede)
    SELECT
        ia.id_tema_externo_nuevo,
        orig.id_tema,
        orig.equivalencia,
        idsd -- Usamos el idsd del parámetro para mantener coherencia con la nueva sede
    FROM ids_asociar ia
    JOIN unicen.tema_asociar orig ON orig.id_tema_asociar = ia.id_tema_asociar_viejo;

end
$$;

-- FUNCION POR CLAUDE

CREATE OR REPLACE FUNCTION unicen.seiko_addmateriacarextcontemas(
    idmateriaexternaorigen integer,
    codmat  character varying,
    nom     character varying,
    ch      integer,
    iduniext integer,
    idsd    integer,
    temas   jsonb
)
RETURNS void
LANGUAGE plpgsql AS
$$
DECLARE
    v_id_materia_externa integer;
BEGIN
    -- ----------------------------------------------------------------
    -- 1. Inserción de materia_externa — la secuencia genera el ID solo
    -- ----------------------------------------------------------------
    INSERT INTO unicen.materia_externa
        (id_materia_externa ,codigo, nombre, detalle, carga_horaria, id_sede, id_universidad_externa)
    VALUES
        ((SELECT max(id_materia_externa) + 1 from unicen.materia_externa),codmat, nom, 'N', ch, idsd, iduniext)
    RETURNING id_materia_externa INTO v_id_materia_externa;


    -- ----------------------------------------------------------------
    -- 2. Inserción de temas
    --    Problema especial: id_temaext e id_tema_externo deben ser iguales.
    --    Solución: generamos los IDs con nextval en una tabla temporal
    --    para poder reutilizar el mismo valor en ambas columnas
    --    y tener el mapeo disponible en el paso 4.
    -- ----------------------------------------------------------------
    CREATE TEMP TABLE tmp_tema_ids (
        num_fila bigint,
        new_id   integer,
        jdata    jsonb
    ) ON COMMIT DROP;

    -- Generamos un ID de secuencia por cada tema del JSON
    INSERT INTO tmp_tema_ids (num_fila, new_id, jdata)
    SELECT
        arr.num_fila,
        nextval(pg_get_serial_sequence('unicen.tema_externo', 'id_temaext')),
        arr.value
    FROM jsonb_array_elements(temas) WITH ORDINALITY arr(value, num_fila);

    -- Ahora insertamos usando new_id para ambas columnas
    INSERT INTO unicen.tema_externo
        (id_temaext, id_tema_externo, id_materia_externa, titulo, nombre, contenido, id_sede, estado)
    SELECT
        new_id,
        new_id,           -- mismo valor, sin llamar nextval dos veces
        v_id_materia_externa,
        jdata->>'titulotema',
        jdata->>'nomtema',
        jdata->>'cont',
        idsd,
        'ACTIVO'
    FROM tmp_tema_ids;


    -- ----------------------------------------------------------------
    -- 3. Equivalencia — la secuencia genera el ID solo
    -- ----------------------------------------------------------------
    PERFORM setval(
        pg_get_serial_sequence('unicen.equivalencia_materias', 'id_equivalencia_materias'),
        GREATEST(
            (SELECT COALESCE(MAX(id_equivalencia_materias), 0) FROM unicen.equivalencia_materias),
            1
        )
    );

    INSERT INTO unicen.equivalencia_materias
        (id_universidad_externa, id_plan_estudio, id_materia, id_materia_externa,
         carga_horaria, materia_local, materia_externa, cod_mat_externo, cod_mat_local)
    SELECT
        iduniext, id_plan_estudio, id_materia, v_id_materia_externa,
        ch, materia_local, nom, codmat, cod_mat_local
    FROM unicen.equivalencia_materias
    WHERE id_materia_externa = idmateriaexternaorigen;


    -- ----------------------------------------------------------------
    -- 4. Asociación de temas — usamos el mapeo guardado en tmp_tema_ids
    --    La secuencia de tema_asociar genera el ID sola
    -- ----------------------------------------------------------------
     PERFORM setval(
        pg_get_serial_sequence('unicen.tema_asociar', 'id_tema_asociar'),
        GREATEST(
            (SELECT COALESCE(MAX(id_tema_asociar), 0) FROM unicen.tema_asociar),
            1
        )
    );
    INSERT INTO unicen.tema_asociar
        (id_tema_asociar, id_tema_externo, id_tema, equivalencia, id_sede)
    SELECT
        nextval(pg_get_serial_sequence('unicen.tema_asociar', 'id_tema_asociar')),
        t.new_id,
        orig.id_tema,
        orig.equivalencia,
        idsd
    FROM tmp_tema_ids t
    CROSS JOIN LATERAL jsonb_array_elements_text(t.jdata->'id_temas_asociar') AS ta(id_viejo)
    JOIN unicen.tema_asociar orig ON orig.id_tema_asociar = ta.id_viejo::integer
    WHERE jsonb_typeof(t.jdata->'id_temas_asociar') = 'array';

END;
$$;


-- ACTUALIZAR ANTIGUO
CREATE OR REPLACE FUNCTION unicen.seiko_actualizartemasmateriaext(id_materia_ext integer, temas jsonb)
 RETURNS TABLE(message character varying, type character varying)
 LANGUAGE plpgsql
AS $function$
DECLARE
    v_id_sede INT;
BEGIN
    -- 1. Verificación eficiente con EXISTS (usando un JOIN interno para mayor limpieza)
    IF EXISTS (
        SELECT 1
        FROM unicen.tema_asociar ta
        INNER JOIN unicen.tema_externo te ON ta.id_tema_externo = te.id_tema_externo
        WHERE te.id_materia_externa = id_materia_ext
    ) THEN
        RETURN QUERY SELECT
            CAST('LOS TEMAS DE LA MATERIA CUENTAN CON UNA EQUIVALENCIA DEFINIDA' AS VARCHAR(100)),
            CAST('INFO' AS VARCHAR(50));
        RETURN; -- Buena práctica para salir inmediatamente
    ELSE
        -- 2. Obtener la sede y verificar que la materia exista
        SELECT id_sede INTO v_id_sede
        FROM unicen.materia_externa
        WHERE id_materia_externa = id_materia_ext;

        IF NOT FOUND THEN
            RETURN QUERY SELECT CAST('LA MATERIA EXTERNA NO EXISTE' AS VARCHAR(100)), CAST('ERROR' AS VARCHAR(50));
            RETURN;
        END IF;

        -- 3. Borrado seguro
        DELETE FROM unicen.tema_externo WHERE id_materia_externa = id_materia_ext;

        -- 4. Inserción de nuevos temas
        WITH max_id AS (
            -- NOTA: Lo ideal sería usar una SEQUENCE (e.g., NEXTVAL('seq_tema_externo')).
            -- Solo usar MAX() si la concurrencia es nula.
            SELECT COALESCE(MAX(id_tema_externo), 0) AS max_val
            FROM unicen.tema_externo
        ),
        base_json AS (
            SELECT
                value->>'titulotema' AS titulo,
                value->>'nomtema' AS nombre,
                value->>'cont' AS contenido,
                ROW_NUMBER() OVER () AS num_fila
            FROM jsonb_array_elements(temas)
        )
        INSERT INTO unicen.tema_externo (
            id_temaext,
            id_tema_externo,
            id_materia_externa,
            titulo,
            nombre,
            contenido,
            id_sede,
            estado
        )
        SELECT
            max_id.max_val + base_json.num_fila,
            max_id.max_val + base_json.num_fila,
            id_materia_ext,
            base_json.titulo,
            base_json.nombre,
            base_json.contenido,
            v_id_sede,
            'ACTIVO'
        FROM base_json
        CROSS JOIN max_id;

        -- 5. Retorno exitoso
        RETURN QUERY SELECT
            CAST('TEMAS ACTUALIZADOS CORRECTAMENTE' AS VARCHAR(100)),
            CAST('SUCCESS' AS VARCHAR(50));
    END IF;
END;
$function$





-- ACTUALIZAR CLAUDE

CREATE OR REPLACE FUNCTION unicen.seiko_actualizartemasmateriaext(
    id_materia_ext integer,
    temas jsonb
)
RETURNS TABLE(message character varying, type character varying)
LANGUAGE plpgsql AS
$function$
DECLARE
    v_id_sede INT;
BEGIN
    -- ----------------------------------------------------------------
    -- 1. Verificar si los temas actuales ya tienen equivalencias
    -- ----------------------------------------------------------------
    IF EXISTS (
        SELECT 1
        FROM unicen.tema_asociar ta
        INNER JOIN unicen.tema_externo te ON ta.id_tema_externo = te.id_tema_externo
        WHERE te.id_materia_externa = id_materia_ext
    ) THEN
        RETURN QUERY SELECT
            CAST('LOS TEMAS DE LA MATERIA CUENTAN CON UNA EQUIVALENCIA DEFINIDA' AS VARCHAR(100)),
            CAST('INFO' AS VARCHAR(50));
        RETURN;
    END IF;

    -- ----------------------------------------------------------------
    -- 2. Obtener la sede y verificar que la materia exista
    -- ----------------------------------------------------------------
    SELECT id_sede INTO v_id_sede
    FROM unicen.materia_externa
    WHERE id_materia_externa = id_materia_ext;

    IF NOT FOUND THEN
        RETURN QUERY SELECT
            CAST('LA MATERIA EXTERNA NO EXISTE' AS VARCHAR(100)),
            CAST('ERROR' AS VARCHAR(50));
        RETURN;
    END IF;

    -- ----------------------------------------------------------------
    -- 3. Borrado de temas anteriores
    -- ----------------------------------------------------------------
    DELETE FROM unicen.tema_externo WHERE id_materia_externa = id_materia_ext;

    -- ----------------------------------------------------------------
    -- 4. Generar IDs con la secuencia y guardar el mapeo en temporal.
    --    Necesario porque id_temaext e id_tema_externo deben ser iguales,
    --    y además necesitamos el mapeo para el paso 6.
    -- ----------------------------------------------------------------
    CREATE TEMP TABLE tmp_tema_ids (
        num_fila bigint,
        new_id   integer,
        jdata    jsonb
    ) ON COMMIT DROP;

    INSERT INTO tmp_tema_ids (num_fila, new_id, jdata)
    SELECT
        arr.num_fila,
        nextval(pg_get_serial_sequence('unicen.tema_externo', 'id_temaext')),
        arr.value
    FROM jsonb_array_elements(temas) WITH ORDINALITY arr(value, num_fila);

    -- ----------------------------------------------------------------
    -- 5. Inserción de los nuevos temas
    -- ----------------------------------------------------------------
    INSERT INTO unicen.tema_externo (
        id_temaext,
        id_tema_externo,
        id_materia_externa,
        titulo,
        nombre,
        contenido,
        id_sede,
        estado
    )
    SELECT
        new_id,
        new_id,
        id_materia_ext,
        jdata->>'titulotema',
        jdata->>'nomtema',
        jdata->>'cont',
        v_id_sede,
        'ACTIVO'
    FROM tmp_tema_ids;

    -- ----------------------------------------------------------------
    -- 6. Emparejamiento de temas — copia los registros de tema_asociar
    --    tomando los IDs originales desde el campo 'id_temas_asociar'
    --    del JSON, igual que en la función de registro
    -- ----------------------------------------------------------------

    PERFORM setval(
        pg_get_serial_sequence('unicen.tema_asociar', 'id_tema_asociar'),
        GREATEST(
            (SELECT COALESCE(MAX(id_tema_asociar), 0) FROM unicen.tema_asociar),
            1
        )
    );
    INSERT INTO unicen.tema_asociar
        (id_tema_asociar, id_tema_externo, id_tema, equivalencia, id_sede)
    SELECT
        nextval(pg_get_serial_sequence('unicen.tema_asociar', 'id_tema_asociar')),
        t.new_id,
        orig.id_tema,
        orig.equivalencia,
        v_id_sede
    FROM tmp_tema_ids t
    CROSS JOIN LATERAL jsonb_array_elements_text(t.jdata->'id_temas_asociar') AS ta(id_viejo)
    JOIN unicen.tema_asociar orig ON orig.id_tema_asociar = ta.id_viejo::integer
    WHERE jsonb_typeof(t.jdata->'id_temas_asociar') = 'array';

    -- ----------------------------------------------------------------
    -- 7. Retorno exitoso
    -- ----------------------------------------------------------------
    RETURN QUERY SELECT
        CAST('TEMAS ACTUALIZADOS CORRECTAMENTE' AS VARCHAR(100)),
        CAST('SUCCESS' AS VARCHAR(50));
END;
$function$;


select * from unicen.estudiante WHERE materno = 'CERRUTO';