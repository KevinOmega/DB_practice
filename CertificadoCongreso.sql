CREATE TABLE unicen.certificado_valido (
    id_certificado_valido SERIAL PRIMARY KEY,
    unicodigo INTEGER NOT NULL,
    id_gestion INTEGER NOT NULL,
    id_item_seguimiento INTEGER NOT NULL,
    id_sede INTEGER NOT NULL,
    numero_factura VARCHAR NOT NULL,
    id_congreso_plan_estudio INTEGER NOT NULL,
    fecha_emision DATE NOT NULL DEFAULT NOW()
);
DROP TABLE IF EXISTS unicen.certificado_valido;

DROP FUNCTION IF EXISTS unicen.pagos_generar_certificado_congreso(integer, integer, integer, integer, varchar, integer);
CREATE OR REPLACE FUNCTION unicen.pagos_generar_certificado_congreso(
    p_unicodigo INTEGER, 
    p_id_gestion INTEGER, 
    p_id_sede INTEGER,
    p_id_item_seguimiento INTEGER,
    p_numero_factura VARCHAR,
    p_id_congreso_plan_estudio INTEGER
    ) RETURNS VOID
LANGUAGE plpgsql
AS $function$
BEGIN

    -- Verificar si el certificado ya existe
    IF EXISTS (
        SELECT 1 
        FROM unicen.certificado_valido 
        WHERE unicodigo = p_unicodigo 
          AND id_gestion = p_id_gestion 
          AND id_sede = p_id_sede 
          AND id_item_seguimiento = p_id_item_seguimiento
    ) THEN
        RAISE NOTICE 'El certificado ya existe para este estudiante y congreso.';
        RETURN;
    END IF;

    -- Insertar el nuevo certificado
    INSERT INTO unicen.certificado_valido (
        unicodigo, 
        id_gestion, 
        id_item_seguimiento, 
        id_sede, 
        numero_factura, 
        id_congreso_plan_estudio
    ) VALUES (
        p_unicodigo, 
        p_id_gestion, 
        p_id_item_seguimiento, 
        p_id_sede, 
        p_numero_factura, 
        p_id_congreso_plan_estudio
    );

    RAISE NOTICE 'Certificado generado exitosamente.';
END;
$function$

SELECT id_congreso_plan_estudio,id_item_seguimiento,id_sede, id_gestion, id_plan_estudio, horas,lugar,fevento FROM unicen.congreso_plan_estudio;

select descripcion from item_seguimiento where descripcion LIKE '%CONGRESO%';

select * from unicen.certificado_valido;

select * from  unicen.pagos_listarestudiantexcar(109,106,1);

select * from unicen.factura where numero_factura = '57812';

SELECT * FROM unicen.certificado_valido;

-- ------------------------------------------
DROP FUNCTION IF EXISTS unicen.pagos_obtener_certificado_congreso(integer);


CREATE OR REPLACE FUNCTION unicen.pagos_obtener_certificado_congreso(
    p_id_certificado_valido INTEGER, p_unicodigo INTEGER
)
RETURNS TABLE (
    unicodigo integer,
    nombre_estudiante VARCHAR,
    descripcion_congreso VARCHAR,
    gestion VARCHAR,
    fecha_emision DATE,
    horas integer,
    lugar character varying,
    fecha_evento date
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        cv.unicodigo,
        CONCAT(e.paterno, ' ', e.materno, ' ', e.nombres):: varchar AS nombre_estudiante,
        isg.descripcion AS descripcion_congreso,
        g.nombre AS gestion,
        cv.fecha_emision,
        cpe.horas,
        cpe.lugar,
        cpe.fevento
    FROM 
        unicen.certificado_valido cv
    JOIN 
        unicen.estudiante e ON cv.unicodigo = e.unicodigo AND cv.id_sede = e.id_sede
    JOIN 
        unicen.item_seguimiento isg ON cv.id_item_seguimiento = isg.id_item_seguimiento AND cv.id_sede = isg.id_sede
    JOIN 
        unicen.gestion g ON cv.id_gestion = g.id_gestion
    JOIN
        unicen.congreso_plan_estudio cpe ON cv.id_congreso_plan_estudio = cpe.id_congreso_plan_estudio AND cv.id_sede = cpe.id_sede AND cv.id_gestion = cpe.id_gestion
    WHERE 
        cv.id_certificado_valido = p_id_certificado_valido AND cv.unicodigo = p_unicodigo;
END;
$$ LANGUAGE plpgsql;
    

SELECT 
        cv.unicodigo,
        CONCAT(e.paterno, ' ', e.materno, ' ', e.nombres):: varchar AS nombre_estudiante,
        isg.descripcion AS descripcion_congreso,
        g.nombre AS gestion,
        cv.fecha_emision
    FROM 
        unicen.certificado_valido cv
    JOIN 
        unicen.estudiante e ON cv.unicodigo = e.unicodigo AND cv.id_sede = e.id_sede
    JOIN 
        unicen.item_seguimiento isg ON cv.id_item_seguimiento = isg.id_item_seguimiento AND cv.id_sede = isg.id_sede
    JOIN 
        unicen.gestion g ON cv.id_gestion = g.id_gestion
    WHERE 
        cv.id_certificado_valido = 1;

SELECT * FROM unicen.pagos_obtener_certificado_congreso(2);

SELECT * FROM unicen.estudiante WHERE unicodigo = 16050;

-- ------------------------------------------------------------------
SELECT * FROM unicen.estudiante WHERE paterno LIKE '%BARROSO%'

12630

SELECT * FROM unicen.sheiko_listarmateriascertificado(12630,100,97,2);

SELECT * FROM unicen.nota WHERE unicodigo = 12630 AND id_sede = 2;

SELECT * FROM unicen.estudiantecareco WHERE unicodigo = 12630 AND id_sede = 2;

SELECT * FROM unicen.plan_estudio WHERE id_plan_estudio = 97 AND id_sede = 2;

SELECT * FROM unicen.plan_estudio where id_plan_estudio = 177 AND id_sede = 2;

SELECT * FROM unicen.plan_estudio where id_plan_estudio = 115 AND id_sede = 1;

SELECT * FROM unicen.plan_materia WHERE id_plan_estudio = 97 AND id_sede = 2;

SELECT * FROM unicen.carrera WHERE id_carrera = 67 and id_sede = 2;

UPDATE unicen.carrera SET id_carrera_tipo = 1 WHERE id_carrera = 67 and id_sede = 2;

SELECT * FROM unicen.carrera WHERE id_carrera = 78 AND id_sede = 1;


SELECT * FROM unicen.carrera WHERE id_carrera = 208 and id_sede = 2;


SELECT * FROM unicen.carrera_tipo;

select * from ciudad WHERE nombre = 'ESPAÑA';

ALTER TABLE unicen.ciudad
ADD CONSTRAINT ciudad_nombre_id_pais_uk UNIQUE (nombre, id_pais);

SELECT nombre, id_pais, COUNT(*) AS c
FROM unicen.ciudad
GROUP BY nombre, id_pais
HAVING COUNT(*) > 1;

select distrito, id_distrito, COUNT(*) AS count from unicen.distrito
GROUP BY distrito, id_distrito HAVING COUNT(*) > 1;

ALTER TABLE unicen.distrito
ADD CONSTRAINT distrito_nombre_id_ciudad_uk UNIQUE (distrito, id_ciudad, id_sede);

SELECT distrito, id_ciudad, id_sede, COUNT(*) AS c
FROM unicen.distrito
GROUP BY distrito, id_ciudad, id_sede
HAVING COUNT(*) > 1;

UPDATE unicen.usuario SET id_sede = 2 where unicodigo = 4137;

SELECT paterno, materno, nombres, unicodigo, id_estudiante from unicen.estudiante where unicodigo = 35893;

SELECT deu.id_deudas_contable,deu.unicodigo,deu.id_estudiante,isg.descripcion,deu.monto_deuda, ges.nombre, deu.estado, deu.freg, deu.observacion,
       deu.id_usuario FROM deudas_contable deu
JOIN gestion ges ON deu.id_gestion = ges.id_gestion
JOIN item_seguimiento isg ON deu.id_item_seguimiento = isg.id_item_seguimiento
where unicodigo = 35893
ORDER BY ges.nombre DESC;

BEGIN ;
commit ;
UPDATE unicen.deudas_contable SET monto_deuda = 0 WHERE id_deudas_contable = 390205;

SELECT paterno,materno, nombres ,unicodigo,id_sede from unicen.estudiante where id_estudiante = 21661;



CREATE OR REPLACE FUNCTION unicen.seiko_actualizartemasmateriaext(id_materia_ext INT, temas JSONB)
RETURNS TABLE (message VARCHAR(100), type VARCHAR(50)) -- Aumentado a 100
LANGUAGE plpgsql
AS $$
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
$$;
SELECT * FROM unicen.materia_externa where id_materia_externa = 2240;

SELECT * FROM unicen.tema_asociar where id_tema_externo IN (
    SELECT id_tema_externo FROM unicen.tema_externo where id_materia_externa = 2240
    );

SELECT  * FROM unicen.congreso_plan_estudio where id_item_seguimiento = 10107;

SELECT  * FROM unicen.item_seguimiento WHERE descripcion LIKE '%IV CONGRESO%';