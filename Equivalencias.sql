select mat.nombre, n.nf, est.nombres from (select nombre, id_materia from unicen.materia where id_materia in (
        select id_materia from unicen.plan_materia where id_plan_estudio IN (
            select id_plan_estudio from unicen.estudiantecareco where unicodigo = 19008
        )
    )   
) mat JOIN (

    select nota.nf,id_materia from nota where unicodigo = 19008
) as n on n.id_materia = mat.id_materia JOIN unicen.estudiante est on est.unicodigo = 19008;



    select nota.nf,id_materia from nota where unicodigo = 19008;

    select * from unicen.tema where contenido != '';


select * from unicen.plan_estudio where id_carrera = 79 and activo = 'ACTIVO';



    select id_eq_homologacion, mat1.nombre, mat2.nombre, TRUE as is_equiv from equivalencia_homologacion where id_plan_estudio = (
        select id_plan_estudio from unicen.estudiantecareco where unicodigo = 19008 and id_sede = 1
    ) JOIN unicen.materia mat1 on mat1.id_materia = id_materia_antigua JOIN unicen.materia mat2 on mat2.id_materia = id_materia_nueva;

    -- UNION


    -- Agregar not in

    select mat1.nombre, mat2.nombre, FALSE as is_equiv from (
        select ROW_NUMBER() OVER (ORDER BY id_materia) as row_id,nombre from  unicen.materia where id_sede = 1 and id_materia IN (
            select id_materia from unicen.plan_materia where id_plan_estudio = 120 and id_sede = 1
        )
        
    ) mat1 FULL OUTER JOIN (
        select ROW_NUMBER() OVER (ORDER BY id_materia) as row_id, nombre from unicen.materia where id_sede = 1 and id_materia IN (
            select id_materia from unicen.plan_materia where id_plan_estudio = (
                select id_plan_estudio from unicen.plan_estudio WHERE activo = 'ACTIVO' AND id_sede = 1 AND id_carrera = 67
            )
        )
    ) mat2 on mat1.row_id = mat2.row_id;



    

select DISTINCT paralelo from unicen.nota;




CREATE TABLE unicen.equivalencia_homologacion (
    id_eq_homologacion SERIAL PRIMARY KEY,
    id_plan_materia_antigua INTEGER NOT NULL,
    id_plan_estudio_antigua INTEGER NOT NULL,
    id_materia_antigua INTEGER NOT NULL,
    id_plan_materia_nueva INTEGER NOT NULL,
    id_plan_estudio_nueva INTEGER NOT NULL,
    id_materia_nueva INTEGER NOT NULL,
    id_sede INTEGER NOT NULL,
    estado VARCHAR(10) NOT NULL DEFAULT 'ACTIVO',
    fecha_creacion TIMESTAMP NOT NULL DEFAULT NOW(),
    ultima_modificacion TIMESTAMP NOT NULL DEFAULT NOW(),

    CHECK (estado IN ('ACTIVO', 'INACTIVO'))   
);


ALTER TABLE unicen.equivalencia_homologacion 
    ADD CONSTRAINT unique_materias_nueva UNIQUE (id_plan_materia_nueva, id_plan_estudio_nueva, id_materia_nueva, id_sede);

ALTER TABLE unicen.equivalencia_homologacion 
    ADD CONSTRAINT unique_materias_antigua UNIQUE (id_plan_materia_antigua, id_plan_estudio_antigua, id_materia_antigua, id_sede);


CREATE OR REPLACE FUNCTION unicen.addMateriasEquivalenciaHomologacion(
    p_id_plan_materia_antigua INTEGER,
    p_id_plan_estudio_antigua INTEGER,
    p_id_materia_antigua INTEGER,
    p_id_plan_materia_nueva INTEGER,
    p_id_plan_estudio_nueva INTEGER,
    p_id_materia_nueva INTEGER,
    p_id_sede INTEGER
) RETURNS VOID AS $$
BEGIN
    INSERT INTO unicen.equivalencia_homologacion (
        id_plan_materia_antigua,
        id_plan_estudio_antigua,
        id_materia_antigua,
        id_plan_materia_nueva,
        id_plan_estudio_nueva,
        id_materia_nueva,
        id_sede,
        estado
    ) VALUES (
        p_id_plan_materia_antigua,
        p_id_plan_estudio_antigua,
        p_id_materia_antigua,
        p_id_plan_materia_nueva,
        p_id_plan_estudio_nueva,
        p_id_materia_nueva,
        p_id_sede,
        'EMPAREJADA'
    );
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION unicen.removeMateriasEquivalenciaHomologacion(
    p_id_eq_homologacion INTEGER
) RETURNS INTEGER AS $$
BEGIN
    DELETE FROM unicen.equivalencia_homologacion
    WHERE id_eq_homologacion = p_id_eq_homologacion AND estado != 'TERMINADO';
    RETURN 1;
EXCEPTION WHEN OTHERS THEN
    RETURN 0;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION unicen.confirmarEquivalenciaHomologacion(
    p_id_plan_estudio_antiguo INTEGER,
    p_id_plan_estudio_nuevo INTEGER,
    p_id_sede INTEGER
)
RETURNS INTEGER AS $$
BEGIN
    UPDATE unicen.equivalencia_homologacion
    SET estado = 'TERMINADO',
        ultima_modificacion = NOW()
    WHERE id_plan_estudio_antigua = p_id_plan_estudio_antiguo
      AND id_plan_estudio_nueva = p_id_plan_estudio_nuevo
      AND id_sede = p_id_sede
      AND estado = 'EMPAREJADA';
      
    RETURN 1;
END;
$$ LANGUAGE plpgsql;




select * from unicen.plan_estudio where activo = 'INACTIVO';


select * from unicen.plan_estudio where id_carrera = 67 AND id_sede = 1;

SELECT * FROM unicen.carrera where id_carrera = 67;


select * from unicen.plan_materia where id_plan_estudio = 120 OR id_plan_estudio = 98;

-- ============================================================================
-- FUNCIÓN: seiko_addequivalenciahomologacion
-- ============================================================================
-- DESCRIPCIÓN:
--   Añade una equivalencia de homologación en la base de datos.
--
-- PARÁMETROS:
--   $1 - Parámetro 1 (tipo desconocido)
--   $2 - Parámetro 2 (tipo desconocido)
--   $3 - Parámetro 3 (tipo desconocido)
--   $4 - Parámetro 4 (tipo desconocido)
--   $5 - Parámetro 5 (tipo desconocido)
--   $6 - Parámetro 6 (tipo desconocido)
--   $7 - Parámetro 7 (tipo desconocido)
--
-- RETORNO:
--   (tipo desconocido)
--
-- EJEMPLO DE EJECUCIÓN:
--   SELECT unicen.seiko_addequivalenciahomologacion(valor1, valor2, valor3, 
--                                                    valor4, valor5, valor6, 
--                                                    valor7);
--
-- NOTAS:
--   - Revisar la definición de la función para conocer tipos exactos de parámetros
--   - Ejecutar con permisos adecuados en el esquema 'unicen'
-- ============================================================================
SELECT unicen.addMateriasEquivalenciaHomologacion(113, 112, 55, 1, 2, 15, 1);

select * from equivalencia_homologacion;


select ROW_NUMBER() OVER (ORDER BY mat.id_materia) as row_id,mat.nombre, mat.id_materia, pm.id_plan_materia from unicen.materia as mat join 
(SELECT pm2.id_plan_materia from unicen.plan_materia as pm2
JOIN unicen.nivel nivel on pm2.id_nivel = nivel.id_nivel 
where pm2.id_plan_estudio = 120 and mat.id_sede = 1 ) pm ON pm.id_materia = mat.id_materia
 where pm.id_plan_estudio = 120 and mat.id_sede = 1; 


select * from plan_estudio WHERE id_sede = 1 ORDER BY id_carrera DESC;


select * from tipo_plan_estudio;



  select * from unicen.plan_materia where id_plan_estudio = 120 AND id_sede = 1;


    select id_eq_homologacion, mat1.nombre, mat2.nombre, TRUE as is_equiv from equivalencia_homologacion where id_plan_estudio = (
        select id_plan_estudio from unicen.estudiantecareco where unicodigo = 19008 and id_sede = 1
    ) JOIN unicen.materia mat1 on mat1.id_materia = id_materia_antigua JOIN unicen.materia mat2 on mat2.id_materia = id_materia_nueva;


SELECT 
    hom.id_eq_homologacion, 
    hom.id_plan_materia_antigua,
    hom.id_materia_antigua, 
    mat1.nombre AS nombre_materia_antigua, 
    niv1.nivel AS semestre_antigua, 
    hom.id_plan_materia_nueva, 
    hom.id_materia_nueva, 
    mat2.nombre AS nombre_materia_nueva, 
    niv2.nivel AS semestre_nueva  
FROM (
    SELECT id_eq_homologacion, id_plan_materia_antigua, id_materia_antigua, id_plan_materia_nueva, id_materia_nueva 
    FROM unicen.equivalencia_homologacion 
    WHERE id_plan_estudio_antigua = 120 AND id_sede = 1 
    AND id_plan_estudio_nueva = (
        SELECT id_plan_estudio FROM unicen.plan_estudio 
        WHERE activo = 'ACTIVO' AND id_sede = 1 AND id_carrera = 67
    ) 
) hom 
JOIN unicen.materia mat1 ON mat1.id_materia = hom.id_materia_antigua 
JOIN unicen.materia mat2 ON mat2.id_materia = hom.id_materia_nueva 
JOIN unicen.plan_materia pm1 ON hom.id_plan_materia_antigua = pm1.id_plan_materia AND hom.id_materia_antigua = pm1.id_materia 
JOIN unicen.nivel niv1 ON pm1.id_nivel = niv1.id_nivel
JOIN unicen.plan_materia pm2 ON hom.id_plan_materia_nueva = pm2.id_plan_materia AND hom.id_materia_nueva = pm2.id_materia 
JOIN unicen.nivel niv2 ON pm2.id_nivel = niv2.id_nivel
WHERE mat1.id_sede = 1 AND mat2.id_sede = 1 AND pm1.id_sede = 1 AND pm2.id_sede = 1

UNION

SELECT 
    0 AS id_eq_homologacion, 
    mat1.id_plan_materia AS id_plan_materia_antigua,
    mat1.id_materia AS id_materia_antigua, 
    mat1.nombre AS nombre_materia_antigua, 
    mat1.sem AS semestre_antigua,
    mat2.id_plan_materia AS id_plan_materia_nueva,
    mat2.id_materia AS id_materia_nueva, 
    mat2.nombre AS nombre_materia_nueva, 
    mat2.sem AS semestre_nueva
FROM (
 SELECT
    ROW_NUMBER() OVER (ORDER BY mat.nombre) AS row_id,
    mat.nombre,
    mat.id_materia,
    pm.id_plan_materia,
    nivel.nombre AS nombre_nivel,
    nivel.nivel AS sem
    FROM unicen.materia AS mat
    JOIN unicen.plan_materia AS pm
    ON pm.id_materia = mat.id_materia
    JOIN unicen.nivel AS nivel
    ON pm.id_nivel = nivel.id_nivel
    WHERE pm.id_plan_estudio = 120
  AND mat.id_sede = 1 AND pm.id_sede = 1 ORDER BY mat.nombre
) mat1 FULL OUTER JOIN(

  SELECT
    ROW_NUMBER() OVER (ORDER BY mat.nombre) AS row_id,
    mat.nombre,
    mat.id_materia,
    pm.id_plan_materia,
    nivel.nombre AS nombre_nivel,
    nivel.nivel AS sem
    FROM unicen.materia AS mat
    JOIN unicen.plan_materia AS pm
        ON pm.id_materia = mat.id_materia
    JOIN unicen.nivel AS nivel
        ON pm.id_nivel = nivel.id_nivel
    WHERE pm.id_plan_estudio = (
        SELECT id_plan_estudio FROM unicen.plan_estudio WHERE activo = 'ACTIVO' AND id_sede = 1 AND id_carrera = 67
    )
    AND mat.id_sede = 1 AND pm.id_sede = 1 ORDER BY mat.nombre
) mat2 ON mat1.row_id = mat2.row_id;


DROP FUNCTION IF EXISTS listequivalenciashomologacion(
    p_id_plan_estudio_antigua INTEGER,
    p_id_plan_estudio_nueva INTEGER,
    p_id_sede INTEGER
);

-- contaduria
SELECT * FROM unicen.carrera WHERE nombre LIKE 'CONTADU%';


SELECT * FROM unicen.plan_estudio WHERE id_carrera = 46;


UPDATE unicen.plan_estudio SET id_carrera = 77 WHERE id_carrera = 46 and id_sede = 1;


SELECT * FROM unicen.carrera WHERE nombre LIKE 'ADMINIS%EMPRESAS' AND id_sede = 1;


select * from plan_estudio WHERE (id_carrera = 63 or id_carrera = 17 or id_carrera = 16) AND id_sede = 1;

UPDATE unicen.plan_estudio SET id_carrera = 74 WHERE id_carrera = 17 and id_sede = 1;


SELECT * FROM unicen.estudiantecareco WHERE unicodigo = 19008 AND id_sede = 1;

SELECT * FROM unicen.plan_estudio WHERe id_plan_estudio = 112;




DROP FUNCTION IF EXISTS unicen.listequivalenciashomologacion(
    p_id_plan_estudio_antigua INTEGER,
    p_id_plan_estudio_nueva INTEGER,
    p_id_sede INTEGER
);

CREATE OR REPLACE FUNCTION unicen.listequivalenciashomologacion(
    p_id_plan_estudio_antigua INTEGER,
    p_id_plan_estudio_nueva INTEGER,
    p_id_sede INTEGER
) RETURNS TABLE(
    id_eq_homologacion INTEGER,
    id_plan_materia_antigua INTEGER,
    id_materia_antigua INTEGER,
    nombre_materia_antigua VARCHAR,
    semestre_antigua INTEGER,
    id_plan_materia_nueva INTEGER,
    id_materia_nueva INTEGER,
    nombre_materia_nueva VARCHAR,
    semestre_nueva INTEGER,
    estado VARCHAR(10)
) AS $$
BEGIN

RETURN QUERY


WITH homologadas AS (
    SELECT 
        hom.id_eq_homologacion, 
        hom.id_plan_materia_antigua,
        hom.id_materia_antigua, 
        mat1.nombre AS nombre_materia_antigua, 
        niv1.nivel AS semestre_antigua, 
        hom.id_plan_materia_nueva, 
        hom.id_materia_nueva, 
        mat2.nombre AS nombre_materia_nueva, 
        niv2.nivel AS semestre_nueva,
        hom.estado  
    FROM (
        SELECT hom1.id_eq_homologacion,
               hom1.id_plan_materia_antigua,
               hom1.id_materia_antigua,
               hom1.id_plan_materia_nueva,
               hom1.id_materia_nueva,
               hom1.estado 
        FROM unicen.equivalencia_homologacion hom1
        WHERE hom1.id_plan_estudio_antigua = p_id_plan_estudio_antigua
          AND hom1.id_plan_estudio_nueva   = p_id_plan_estudio_nueva
          AND hom1.id_sede = p_id_sede
    ) hom
    JOIN unicen.materia mat1 ON mat1.id_materia = hom.id_materia_antigua 
    JOIN unicen.materia mat2 ON mat2.id_materia = hom.id_materia_nueva 
    JOIN unicen.plan_materia pm1 ON hom.id_plan_materia_antigua = pm1.id_plan_materia
    JOIN unicen.nivel niv1 ON pm1.id_nivel = niv1.id_nivel
    JOIN unicen.plan_materia pm2 ON hom.id_plan_materia_nueva = pm2.id_plan_materia
    JOIN unicen.nivel niv2 ON pm2.id_nivel = niv2.id_nivel
    WHERE mat1.id_sede = p_id_sede
      AND mat2.id_sede = p_id_sede
      AND pm1.id_sede = p_id_sede
      AND pm2.id_sede = p_id_sede
      ORDER BY mat1.nombre
), no_homologadas AS (
    SELECT 
        0 AS id_eq_homologacion, 
        mat1.id_plan_materia AS id_plan_materia_antigua,
        mat1.id_materia AS id_materia_antigua, 
        mat1.nombre AS nombre_materia_antigua, 
        mat1.sem AS semestre_antigua,
        mat2.id_plan_materia AS id_plan_materia_nueva,
        mat2.id_materia AS id_materia_nueva, 
        mat2.nombre AS nombre_materia_nueva, 
        mat2.sem AS semestre_nueva,
        'NO EMPAREJADA' AS estado
    FROM (
        SELECT
            ROW_NUMBER() OVER (ORDER BY mat.nombre) AS row_id,
            mat.nombre,
            mat.id_materia,
            pm.id_plan_materia,
            nivel.nivel AS sem
        FROM unicen.materia mat
        JOIN unicen.plan_materia pm ON pm.id_materia = mat.id_materia
        JOIN unicen.nivel nivel ON pm.id_nivel = nivel.id_nivel
        WHERE pm.id_plan_estudio = p_id_plan_estudio_antigua
          AND mat.id_sede = p_id_sede
          AND pm.id_sede = p_id_sede
          AND NOT EXISTS (
              SELECT 1
              FROM unicen.equivalencia_homologacion eh
              WHERE eh.id_materia_antigua = mat.id_materia
                AND eh.id_plan_estudio_antigua = p_id_plan_estudio_antigua
                AND eh.id_sede = p_id_sede
                ORDER BY mat.nombre
          )
    ) mat1
    FULL OUTER JOIN (
        SELECT
            ROW_NUMBER() OVER (ORDER BY mat.nombre) AS row_id,
            mat.nombre,
            mat.id_materia,
            pm.id_plan_materia,
            nivel.nivel AS sem
        FROM unicen.materia mat
        JOIN unicen.plan_materia pm ON pm.id_materia = mat.id_materia
        JOIN unicen.nivel nivel ON pm.id_nivel = nivel.id_nivel
        WHERE pm.id_plan_estudio = p_id_plan_estudio_nueva
          AND mat.id_sede = p_id_sede
          AND pm.id_sede = p_id_sede
            AND NOT EXISTS (
                SELECT 1
                FROM unicen.equivalencia_homologacion eh
                WHERE eh.id_materia_nueva = mat.id_materia
                    AND eh.id_plan_estudio_nueva = p_id_plan_estudio_nueva
                    AND eh.id_sede = p_id_sede
                ORDER BY mat.nombre
            )
    ) mat2 ON mat1.row_id = mat2.row_id
)

SELECT *
FROM (
    select * from homologadas
    UNION ALL
    select * from no_homologadas
) t ORDER BY t.estado ASC, t.nombre_materia_nueva;


EXCEPTION WHEN OTHERS THEN
    RAISE EXCEPTION 'Error en listequivalenciashomologacion: % %', SQLSTATE, SQLERRM;
END;
$$ LANGUAGE plpgsql;


select * from unicen.equivalencia_homologacion;

ALTER TABLE unicen.equivalencia_homologacion 
    ADD CONSTRAINT estado_check_equivalencia_homologacion CHECK (estado IN ('ACTIVO', 'EMPAREJADA', 'TERMINADO', 'INACTIVO'));


UPDATE unicen.equivalencia_homologacion SET estado = 'EMPAREJADA' WHERE estado = 'TERMINADO';

SELECT * FROM unicen.listequivalenciashomologacion(14,112,1);

SELECT * FROM unicen.listequivalenciashomologacion(120,
    (SELECT id_plan_estudio FROM unicen.plan_estudio 
        WHERE activo = 'ACTIVO' AND id_sede = 1 AND id_carrera = 67),1);

        SELECT * FROM unicen.listequivalenciashomologacion(120,98,1);

        SELECT id_plan_estudio FROM unicen.plan_estudio 
        WHERE activo = 'ACTIVO' AND id_sede = 1 AND id_carrera = 67


        SELECT
    ROW_NUMBER() OVER (ORDER BY nivel.nivel) AS row_id,
    mat.nombre,
    mat.id_materia,
    pm.id_plan_materia,
    nivel.nombre AS nombre_nivel,
    nivel.nivel AS sem
    FROM unicen.materia AS mat
    JOIN unicen.plan_materia AS pm
    ON pm.id_materia = mat.id_materia
    JOIN unicen.nivel AS nivel
    ON pm.id_nivel = nivel.id_nivel
    WHERE pm.id_plan_estudio = 120
  AND mat.id_sede = 1 AND pm.id_sede = 1 ORDER BY nivel.nivel


  SELECT
    ROW_NUMBER() OVER (ORDER BY nivel.nivel) AS row_id,
    mat.nombre,
    mat.id_materia,
    pm.id_plan_materia,
    nivel.nombre AS nombre_nivel,
    nivel.nivel AS sem
    FROM unicen.materia AS mat
    JOIN unicen.plan_materia AS pm
        ON pm.id_materia = mat.id_materia
    JOIN unicen.nivel AS nivel
        ON pm.id_nivel = nivel.id_nivel
    WHERE pm.id_plan_estudio = 98
    AND mat.id_sede = 1 AND pm.id_sede = 1 ORDER BY nivel.nivel




SELECT 
        hom.id_eq_homologacion, 
        hom.id_plan_materia_antigua,
        hom.id_materia_antigua, 
        mat1.nombre AS nombre_materia_antigua, 
        niv1.nivel AS semestre_antigua, 
        hom.id_plan_materia_nueva, 
        hom.id_materia_nueva, 
        mat2.nombre AS nombre_materia_nueva, 
        niv2.nivel AS semestre_nueva  
    FROM (
        SELECT hom1.id_eq_homologacion,
               hom1.id_plan_materia_antigua,
               hom1.id_materia_antigua,
               hom1.id_plan_materia_nueva,
               hom1.id_materia_nueva 
        FROM unicen.equivalencia_homologacion hom1
        WHERE hom1.id_plan_estudio_antigua = 120
          AND hom1.id_plan_estudio_nueva   = 98
          AND hom1.id_sede = 1
    ) hom
    JOIN unicen.materia mat1 ON mat1.id_materia = hom.id_materia_antigua 
    JOIN unicen.materia mat2 ON mat2.id_materia = hom.id_materia_nueva 
    JOIN unicen.plan_materia pm1 ON hom.id_plan_materia_antigua = pm1.id_plan_materia
    JOIN unicen.nivel niv1 ON pm1.id_nivel = niv1.id_nivel
    JOIN unicen.plan_materia pm2 ON hom.id_plan_materia_nueva = pm2.id_plan_materia
    JOIN unicen.nivel niv2 ON pm2.id_nivel = niv2.id_nivel
    WHERE mat1.id_sede = 1
      AND mat2.id_sede = 1
      AND pm1.id_sede = 1
      AND pm2.id_sede = 1


DROP FUNCTION IF EXISTS listarplanesdeestudioporcarrera(
    p_id_carrera INTEGER,
    p_id_sede INTEGER
);
CREATE OR REPLACE FUNCTION unicen.listarplanesdeestudioporcarrera(
    p_id_carrera INTEGER,
    p_id_sede INTEGER
) RETURNS TABLE(
    id_plan_estudio INTEGER,
    fecha_res DATE,
    activo VARCHAR,
    tipo_plan_estudio VARCHAR
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        pe.id_plan_estudio,
        pe.fecha_res,
        pe.activo,
        tpe.descripcion AS tipo_plan_estudio
    FROM unicen.plan_estudio pe
    JOIN unicen.tipo_plan_estudio tpe ON pe.id_tipo_plan_estudio = tpe.id_tipo_plan_estudio
    WHERE pe.id_carrera = p_id_carrera
      AND pe.id_sede = p_id_sede AND tpe.id_sede = p_id_sede
    ORDER BY activo;
END;
$$ LANGUAGE plpgsql;

