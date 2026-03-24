    
    DROP FUNCTION IF EXISTS unicen.insertarNotasPreHomologadasDar(INTEGER, INTEGER, INTEGER, INTEGER, DOUBLE PRECISION, INTEGER, INTEGER);
    CREATE OR REPLACE FUNCTION unicen.insertarNotasPreHomologadasDar(
        p_unicodigo INTEGER,
        p_id_plan_estudio INTEGER,
        p_id_materia INTEGER,
        p_id_gestion INTEGER,
        p_nota DOUBLE PRECISION,
        p_id_sede INTEGER,
        p_id_usuario INTEGER
    )
    RETURNS INTEGER AS $$
    BEGIN
    INSERT INTO unicen.nota(unicodigo, id_plan_estudio, id_materia,id_gestion, nf, id_sede, paralelo, obs, estnota, est, pp, sp, tp, ef, ast, si, ma, gr, id_grupo,id_usuario )
    VALUES (p_unicodigo, p_id_plan_estudio, p_id_materia, p_id_gestion, p_nota, p_id_sede, 'DAR', '', 
    CASE 
        WHEN p_nota >= 51 THEN 'APROBADO'
        ELSE 'REPROBADO'
    END
    , 'ACTIVO', 0, 0, 0, 0, 0, 0, 0, 0, 1, p_id_usuario);
    RETURN 1;
    
    END;
    $$ LANGUAGE plpgsql;

select unicen.insertarNotasPreHomologadasDar(34504, 112, 1568, 98, 100, 1, 1);

DELETE FROM unicen.nota where unicodigo = 34504 and id_plan_estudio = 112 and id_sede = 1 and paralelo = 'DAR';

select * from unicen.nota where paralelo = 'DAR';

DROP FUNCTION IF EXISTS unicen.listarMateriasHomologadasDar(INTEGER, INTEGER, INTEGER);

DELETE FROM unicen.nota WHERE unicodigo = 34504 AND id_plan_estudio = 112 AND id_sede = 1;


CREATE OR REPLACE FUNCTION unicen.listarMateriasHomologadasDar(
    p_unicodigo INTEGER,
    p_plan_estudio INTEGER,
    p_id_sede INTEGER
)
RETURNS TABLE(
    id_materia INTEGER,
    id_gestion INTEGER,
    gestion VARCHAR,
    cod_materia VARCHAR,
    nombre_materia VARCHAR,
    semestre VARCHAR,
    nota DOUBLE PRECISION,
    con_nota BOOLEAN,
    materia_normal BOOLEAN
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        mat.id_materia,
        nt.id_gestion,
        ges.nombre AS gestion,
        mat.cod_materia,
        mat.nombre,
        nv.nombre,
        nt.nf,
        CASE 
            WHEN nt.nf IS NULL THEN FALSE
            ELSE TRUE
        END AS con_nota,
        CASE 
            WHEN nt.paralelo = 'DAR' OR nt.nf IS NULL THEN FALSE
            ELSE TRUE
        END AS materia_normal

    FROM unicen.plan_materia pm 
    LEFT JOIN (select * from unicen.nota where unicodigo = p_unicodigo and id_plan_estudio = p_plan_estudio and id_sede = p_id_sede) nt 
    ON pm.id_materia = nt.id_materia AND pm.id_plan_estudio = nt.id_plan_estudio AND pm.id_sede = nt.id_sede
    LEFT JOIN unicen.materia mat ON mat.id_materia = pm.id_materia AND mat.id_sede = p_id_sede
    LEFT JOIN unicen.nivel nv ON pm.id_nivel = nv.id_nivel
    LEFT JOIN unicen.gestion ges ON ges.id_gestion = nt.id_gestion
    WHERE pm.id_plan_estudio = p_plan_estudio and pm.id_sede = p_id_sede AND mat.id_materia IS NOT NULL
    ORDER BY nv.nivel, mat.nombre;
END;
$$ LANGUAGE plpgsql;




DROP FUNCTION IF EXISTS unicen.listarGestionesVigentes();
CREATE OR REPLACE FUNCTION unicen.listarGestionesVigentes()
RETURNS TABLE(
    id_gestion INTEGER,
    gestion VARCHAR
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        ges.id_gestion,
        ges.nombre
    FROM unicen.gestion ges
    WHERE EXTRACT(YEAR FROM ges.fecha_fin) <= EXTRACT(YEAR FROM CURRENT_DATE)
    ORDER BY ges.id_gestion DESC;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION unicen.eliminarNotasPreHomologadaDar(
    p_unicodigo INTEGER,
    p_id_plan_estudio INTEGER,
    p_id_materia INTEGER,
    p_id_sede INTEGER
)
RETURNS VOID AS $$
BEGIN
    DELETE FROM unicen.nota 
    WHERE unicodigo = p_unicodigo 
      AND id_plan_estudio = p_id_plan_estudio 
      AND id_materia = p_id_materia 
      AND id_sede = p_id_sede 
      AND paralelo = 'DAR';
END;
$$ LANGUAGE plpgsql;

SELECT * FROM unicen.listarGestionesVigentes();
select * from unicen.listarmateriashomologadasdar(34504,112,1);
        
select * from nota where unicodigo = 16050 and id_plan_estudio = 111 and id_sede = 1;


select * from nivel;

select * from unicen.listarMateriasHomologadasDar(34504, 14, 1);

select * from unicen.plan_materia where id_plan_estudio = 14 AND id_sede = 1 order by id_nivel;

SELECT * FROM unicen.carrera where id_carrera = 111;


DROP FUNCTION IF EXISTS unicen.listarKardexPorPlanEstudioHom(INTEGER, INTEGER, INTEGER);
CREATE OR REPLACE FUNCTION unicen.listarKardexPorPlanEstudioHom(
    p_unicodigo INTEGER,
    p_id_plan_estudio INTEGER,
    p_id_sede INTEGER
)
RETURNS TABLE(
    gestion VARCHAR,
    cod_materia VARCHAR,
    creditos INTEGER,
    nombre_materia VARCHAR,
    grupo VARCHAR,
    primer_parcial DOUBLE PRECISION,
    segundo_parcial DOUBLE PRECISION,
    tercer_parcial DOUBLE PRECISION,
    asistencia DOUBLE PRECISION,
    examen_final DOUBLE PRECISION,
    segunda_instancia DOUBLE PRECISION,
    mesa DOUBLE PRECISION,
    gracia DOUBLE PRECISION,
    nota_final DOUBLE PRECISION,
    estado VARCHAR,
    observaciones VARCHAR,
    horas DOUBLE PRECISION,
    horas_teoria DOUBLE PRECISION,
    prerequisitos VARCHAR
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        ges.nombre AS gestion,
        mat.cod_materia,
        pm.creditos,
        mat.nombre AS nombre_materia,
        nt.paralelo as grupo,
        nt.pp AS primer_parcial,
        nt.sp AS segundo_parcial,
        nt.tp AS tercer_parcial,
        nt.ast AS asistencia,
        nt.ef AS examen_final,
        nt.si AS segunda_instancia,
        nt.ma AS mesa,
        nt.gr AS gracia,
        nt.nf AS nota_final,
        nt.estnota AS estado,
        nt.obs AS observaciones,
        pm.total_horas AS horas,
        pm.horas_teoria,
        STRING_AGG(mat_req.cod_materia, ', ' ORDER BY mat_req.cod_materia):: VARCHAR AS prerequisitos
        
    FROM (SELECT * FROM unicen.notahom WHERE unicodigo = p_unicodigo AND id_plan_estudio = p_id_plan_estudio AND id_sede = p_id_sede) nt
    JOIN unicen.materia mat ON nt.id_materia = mat.id_materia AND nt.id_sede = mat.id_sede
    JOIN unicen.plan_materia pm ON nt.id_materia = pm.id_materia AND nt.id_plan_estudio = pm.id_plan_estudio AND nt.id_sede = pm.id_sede
    JOIN unicen.gestion ges ON nt.id_gestion = ges.id_gestion
    LEFT JOIN unicen.pre_requisito pr ON nt.id_materia = pr.id_materia AND pr.id_plan_estudio = p_id_plan_estudio AND pr.id_sede = p_id_sede
    LEFT JOIN unicen.materia mat_req ON pr.id_materia_requisito = mat_req.id_materia AND mat_req.id_sede = p_id_sede
    
    WHERE nt.unicodigo = p_unicodigo 
      AND nt.id_plan_estudio = p_id_plan_estudio 
      AND nt.id_sede = p_id_sede
    GROUP BY ges.fecha_inicio,pm.horas_teoria, ges.nombre, mat.cod_materia, pm.creditos, mat.nombre, nt.paralelo, nt.pp, nt.sp, nt.tp, nt.ast, nt.ef, nt.si, nt.ma, nt.gr, nt.nf, nt.estnota, nt.obs, pm.total_horas
    ORDER BY ges.fecha_inicio, mat.nombre;
END;
$$ LANGUAGE plpgsql;

select * from unicen.nota where unicodigo = 16050;


SELECT * FROM unicen.nota WHERE unicodigo = 10151;

SELECT * FROM unicen.listarKardexPorPlanEstudioHom(10151, 14, 1);

select * from unicen.sheiko_listarkardex66(16050, 111, 1);

select * from unicen.sheiko_listarkardex66(34504, 14, 1);

-- CREATE OR REPLACE FUNCTION UNICEN

SELECT * FROM sheiko_listarkardexhistorialacademico(34504,112,1);


select * from unicen.estudiantecareco WHERE unicodigo = 10151;

SELECT * FROM unicen.gestion;

    UPDATE unicen.estudiante SET tipo_estudiante = 2 WHERE unicodigo = 10151 AND id_sede = 1;


INSERT INTO unicen.hom_estudiante (unicodigo, id_carrera, id_plan_estudio_antigua, id_plan_estudio_nueva, estado, id_gestion, id_sede) VALUES (10151, 79, 14, 112, 'HOMOLOGADO', 83, 1);




INSERT INTO unicen.notahom 
    SELECT *
    FROM unicen.nota
    WHERE unicodigo = 10151 AND id_plan_estudio = 14 AND id_sede = 1;



SELECT id_plan_estudio,paralelo,obs FROM unicen.nota WHERE unicodigo = 10151;

SELECT * FROM unicen.est_listarplanesestudioantiguo(10151,1);

SELECT * FROM unicen.estudiantecarecohom;


INSERT INTO unicen.estudiantecarecohom 
    SELECT *
    FROM unicen.estudiantecareco
    WHERE unicodigo = 10151 AND id_carrera = 79 AND id_plan_estudio = 112 AND id_sede = 1;

UPDATE unicen.nota SET obs = 'Homol. RR 056-B/2018 ITH No. 033-II/2018' WHERE unicodigo = 10151 AND paralelo = 'HM-C';

-- MARIA BASCOPE ARIAS

SELECT paralelo,obs FROM unicen.nota where unicodigo = 9269 and id_sede = 1;

UPDATE unicen.nota SET obs = 'Homol. RR 052-A/2023 ITH No. 003-I/2023' WHERE unicodigo = 9269 AND paralelo = 'HM-C' AND id_plan_estudio = 106 AND id_sede = 1;

SELECT * FROM unicen.estudiantecareco where unicodigo = 9269 and id_sede = 1;

SELECT * FROM unicen.gestion;

INSERT INTO unicen.hom_estudiante (unicodigo, id_carrera, id_plan_estudio_antigua, id_plan_estudio_nueva, estado, id_gestion, id_sede) VALUES (9269, 77, 41, 106, 'HOMOLOGADO', 97, 1);



UPDATE unicen.estudiante SET tipo_estudiante = 2 WHERE unicodigo = 9269 AND id_sede = 1;

INSERT INTO unicen.notahom 
    SELECT *
    FROM unicen.nota
    WHERE unicodigo = 9269 AND id_plan_estudio = 41 AND id_sede = 1;

    INSERT INTO unicen.estudiantecarecohom 
    SELECT *
    FROM unicen.estudiantecareco
    WHERE unicodigo = 9269 AND id_carrera = 77 AND id_plan_estudio = 106 AND id_sede = 1;


SELECT * FROM unicen.conva_estudiante where unicodigo = 9321;


SELECT * from unicen.conva_estudiante WHERE unicodigo = 10151;


select * from unicen.nota where paralelo = 'HM-C' and unicodigo IN(
select unicodigo from unicen.estudiante where tipo_estudiante = 2
);

UPDATE unicen.nota SET paralelo = 'HOMOLOGADO' WHERE paralelo = 'HM-C' AND unicodigo = 9269 and id_sede = 1;