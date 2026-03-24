SELECT * FROM unicen.usuario where unicodigo = 4137;

-- SALAZAR CHUI NELSON ELCIER
-- --------------------------------------
-- DERECHO COMERCIAL II
-- ARGUMENTACIÓN JURIDICA Y TÉCNICAS DE LITIGACIÓN
-- DERECHO DE LOS RECURSOS NATURALES NO RENOVABLES 
-- METODOLOGIA DE LA INVESTIGACIÓN CIENTÍFICA

SELECT * FROM unicen.nota where unicodigo = 34501;

SELECT * FROM unicen.materia where nombre IN (
    'DERECHO COMERCIAL II',
    'ARGUMENTACION JURIDICA Y TECNICAS DE LITIGACION',
    'DERECHO DE LOS RECURSOS NATURALES NO RENOVABLES',
    'METODOLOGIA DE LA INVESTIGACION CIENTIFICA'
) and id_sede = 3;

SELECT * from unicen.plan_materia
WHERE  id_materia IN (
    SELECT id_materia FROM unicen.materia where nombre IN (
        'DERECHO COMERCIAL II',
        'ARGUMENTACION JURIDICA Y TECNICAS DE LITIGACION',
        'DERECHO DE LOS RECURSOS NATURALES NO RENOVABLES',
        'METODOLOGIA DE LA INVESTIGACION CIENTIFICA'
    ) and id_sede = 3
) and id_plan_estudio = 133;

SELECT DISTINCT id_materia, paralelo,id_turno, id_grupo FROM unicen.nota where 
id_materia IN (
    SELECT id_materia from unicen.plan_materia
WHERE  id_materia IN (
    SELECT id_materia FROM unicen.materia where nombre IN (
        'DERECHO COMERCIAL II',
        'ARGUMENTACION JURIDICA Y TECNICAS DE LITIGACION',
        'DERECHO DE LOS RECURSOS NATURALES NO RENOVABLES',
        'METODOLOGIA DE LA INVESTIGACION CIENTIFICA'
    ) and id_sede = 3
) and id_plan_estudio = 133
) and id_gestion = 105 and id_sede = 3 and id_plan_estudio = 133;

SELECT DISTINCT id_materia, unicodigo, paralelo,id_turno, id_grupo, estnota, est, estinsc, tipo_ins, recursada FROM unicen.nota where 
id_materia IN (
    SELECT id_materia from unicen.plan_materia
WHERE  id_materia IN (
    SELECT id_materia FROM unicen.materia where nombre IN (
        'DERECHO COMERCIAL II',
        'ARGUMENTACION JURIDICA Y TECNICAS DE LITIGACION',
        'DERECHO DE LOS RECURSOS NATURALES NO RENOVABLES',
        'METODOLOGIA DE LA INVESTIGACION CIENTIFICA'
    ) and id_sede = 3
) and id_plan_estudio = 133
) and id_gestion = 105 and id_sede = 3 and id_plan_estudio = 133;

SELECT * FROM unicen.grupo where id_grupo = 87189;

SELECT * FROM unicen.nota where unicodigo = 34501 and id_plan_estudio = 133 and id_sede = 3;

ROLLBACK;


SELECT 1 FROM unicen.inscripcion 
        WHERE unicodigo = 23008 
        AND id_gestion = 105
        AND id_sede = 3;

CREATE OR REPLACE PROCEDURE unicen.pr_aux_add_nota_estudiante(
    p_unicodigo integer,
    p_id_estudiante integer,
    p_materias_array varchar[],
    p_id_plan_estudio integer,
    p_id_sede integer,
    p_id_gestion integer,
    p_paralelo varchar,
    p_turno integer
)
AS $$
DECLARE
    v_id_materia integer;
    v_id_materias integer[] = ARRAY(
        SELECT id_materia from unicen.plan_materia
        WHERE  id_materia IN (
            SELECT id_materia FROM unicen.materia where nombre IN (SELECT unnest(p_materias_array)) and id_sede = p_id_sede
        ) and id_plan_estudio = p_id_plan_estudio and id_sede = p_id_sede );
    v_id_grupo integer;
    v_id_carrera integer;
    v_id_plan_economico integer;
BEGIN

    SELECT id_carrera, id_plan_economico INTO v_id_carrera, v_id_plan_economico
    FROM unicen.estudiantecareco
    WHERE unicodigo = p_unicodigo and id_sede = p_id_sede;

    FOREACH v_id_materia IN ARRAY v_id_materias
    LOOP
        SELECT id_grupo INTO v_id_grupo 
        FROM unicen.grupo 
        WHERE id_plan_estudio = p_id_plan_estudio 
        and id_turno = p_turno 
        and paralelo = p_paralelo 
        and id_sede = p_id_sede 
        and id_gestion = p_id_gestion
        and id_materia = v_id_materia;    
        RAISE NOTICE 'Materia: %, Grupo: %', v_id_materia, v_id_grupo;
        IF v_id_grupo IS NULL THEN
            RAISE EXCEPTION 'No se encontró un grupo para la materia % con el plan de estudio %, turno %, paralelo % en la sede % y gestión %', v_id_materia, p_id_plan_estudio, p_turno, p_paralelo, p_id_sede, p_id_gestion;
        END IF;

        IF NOT EXISTS (
            SELECT 1 FROM unicen.nota 
            WHERE unicodigo = p_unicodigo 
            AND id_materia = v_id_materia 
            AND id_plan_estudio = p_id_plan_estudio 
            AND id_sede = p_id_sede
        ) THEN
            RAISE NOTICE 'Insertando nota para materia %', v_id_materia;
            INSERT INTO unicen.nota (
                unicodigo,
                id_estudiante,
                id_plan_estudio,
                id_materia,
                id_sede,id_gestion,
                paralelo,
                pp,sp,tp,ef,ast,si,ma,gr,nf,
                estnota,
                est,
                id_turno,
                id_grupo,
                estinsc,
                tipo_ins,
                recursada,
                freg
            ) VALUES (
                p_unicodigo,
                p_id_estudiante,
                p_id_plan_estudio,
                v_id_materia,
                p_id_sede,
                p_id_gestion,
                p_paralelo,
                0,0,0,0,0,0,0,0,0,
                'REPROBADO',
                'ACTIVO',
                p_turno,
                v_id_grupo,
                'PREINSCRITO',
                'WEBADM',
                'N',
                CURRENT_DATE
            );
        END IF;
    END LOOP;

    IF NOT EXISTS (
        SELECT 1 FROM unicen.inscripcion 
        WHERE unicodigo = p_unicodigo 
        AND id_sede = p_id_sede
    ) THEN

        INSERT INTO unicen.inscripcion(
                id_estudiante,
                id_sede,
                f_registro,
                id_turno,
                id_carrera,
                id_gestion,
                estado,
                id_plan_economico,
                tpins,
                estinsc,
                unicodigo,
                id_plan_estudio,estinsceco,
                festinsceco
            )   VALUES (
                p_id_estudiante,
                p_id_sede,
                CURRENT_DATE,
                p_turno,
                v_id_carrera,
                p_id_gestion,
                1,
                v_id_plan_economico,
                'A',
                'PREINSCRITO',
                p_unicodigo,
                p_id_plan_estudio,'INSCRITO',CURRENT_DATE
        );
    END IF;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM unicen.estudiantecareco where unicodigo = 34501 and id_sede = 3;


SELECT * FROM unicen.inscripcion where unicodigo = 34501 and id_sede = 3;

SELECT * FROM unicen.inscripcion where unicodigo = 19113 and id_sede = 3;


-- 
BEGIN;

SELECT * FROM unicen.estudiantecareco where unicodigo = 34501;

SELECT * FROM unicen.nota where unicodigo = 34501 and id_plan_estudio = 133 and id_sede = 3 ORDER BY freg ASC;

CALL unicen.pr_aux_add_nota_estudiante(
    34501,
    9836,
    ARRAY[
        'DERECHO COMERCIAL II',
        'ARGUMENTACION JURIDICA Y TECNICAS DE LITIGACION',
        'DERECHO DE LOS RECURSOS NATURALES NO RENOVABLES',
        'METODOLOGIA DE LA INVESTIGACION CIENTIFICA'
     ],
    133,
    3,
    105,
    'A'::VARCHAR,
    3
);

ROLLBACK;

87177,87179, 87189

select * from unicen.seiko_listarestudiantegrupo(87143,105,3) WHERE unic = 34501;
select * from unicen.seiko_listarestudiantegrupo(87177,105,3) WHERE unic = 34501;

select * from unicen.seiko_listarestudiantegrupo(87179,105,3) WHERE unic = 34501;
select * from unicen.seiko_listarestudiantegrupo(87189,105,3) WHERE unic = 34501;
-- --------------------------------------
-- NAVARRO RIVERA DANTE SAUL
-- --------------------------------------
-- DERECHO INFORMATICO
-- INTRODUCCIÓN A LA INVESTIGACIÓN CIENTIFICA 
-- ORATORIA JURÍDICA Y FORENSE
-- PRÁCTICA FORENSE CIVIL I
-- MEDIOS ALTERNOS DE SOLUCIÓN DE CONFLICTOS

SELECT * FROM unicen.materia where nombre IN (
    'DERECHO INFORMATICO',
    'INTRODUCCION A LA INVESTIGACION CIENTIFICA',
    'ORATORIA JURIDICA Y FORENSE',
    'PRACTICA FORENSE CIVIL I',
    'MEDIOS ALTERNOS DE SOLUCION DE CONFLICTOS'
) and id_sede = 3;

SELECT * from unicen.plan_materia
WHERE  id_materia IN (
    SELECT id_materia FROM unicen.materia where nombre IN (
        'DERECHO INFORMATICO',
        'INTRODUCCION A LA INVESTIGACION CIENTIFICA',
        'ORATORIA JURIDICA Y FORENSE',
        'PRACTICA FORENSE CIVIL I',
        'MEDIOS ALTERNOS DE SOLUCION DE CONFLICTOS'
    ) and id_sede = 3
) and id_plan_estudio = 133;

SELECT DISTINCT id_materia, paralelo,id_turno, id_grupo FROM unicen.nota where 
id_materia IN (
    SELECT id_materia from unicen.plan_materia
WHERE  id_materia IN (
    SELECT id_materia FROM unicen.materia where nombre IN (
        'DERECHO INFORMATICO',
        'INTRODUCCION A LA INVESTIGACION CIENTIFICA',
        'ORATORIA JURIDICA Y FORENSE',
        'PRACTICA FORENSE CIVIL I',
        'MEDIOS ALTERNOS DE SOLUCION DE CONFLICTOS'
    ) and id_sede = 3
) and id_plan_estudio = 133
) and id_gestion = 105 and id_sede = 3 and id_plan_estudio = 133;

SELECT DISTINCT id_materia, unicodigo, paralelo,id_turno, id_grupo, estnota, est, estinsc, tipo_ins, recursada FROM unicen.nota where 
id_materia IN (
    SELECT id_materia from unicen.plan_materia
WHERE  id_materia IN (
    SELECT id_materia FROM unicen.materia where nombre IN (
        'DERECHO INFORMATICO',
        'INTRODUCCION A LA INVESTIGACION CIENTIFICA',
        'ORATORIA JURIDICA Y FORENSE',
        'PRACTICA FORENSE CIVIL I',
        'MEDIOS ALTERNOS DE SOLUCION DE CONFLICTOS'
    ) and id_sede = 3
) and id_plan_estudio = 133
) and id_gestion = 105 and id_sede = 3 and id_plan_estudio = 133;


19667

BEGIN;

SELECT * FROM unicen.estudiantecareco where unicodigo = 19667 and id_sede = 3;


CALL unicen.pr_aux_add_nota_estudiante(
    19667,
    9836,
    ARRAY[
        'DERECHO INFORMATICO',
        'INTRODUCCION A LA INVESTIGACION CIENTIFICA',
        'ORATORIA JURIDICA Y FORENSE',
        'PRACTICA FORENSE CIVIL I',
        'MEDIOS ALTERNOS DE SOLUCION DE CONFLICTOS'
     ],
    133,
    3,
    105,
    'A',
    3
);

SELECT * FROM unicen.estudiantecareco where unicodigo = 19667 and id_sede = 3;

SELECT * FROM unicen.nota where unicodigo = 19667 and id_plan_estudio = 133 and id_sede = 3 ORDER BY freg ASC;

SELECT * FROM unicen.inscripcion where unicodigo = 19667 and id_gestion = 105 and id_sede = 3;

COMMIT;
ROLLBACK;


-- --------------------------------------
-- VEIZAGA CERRUTO JORGE
-- --------------------------------------
-- DERECHO COMERCIAL II
-- DERECHO INTERNACIONAL PÚBLICO
-- DERECHO PROCESAL PENAL
-- ORATORIA JURÍDICA Y FORENSE
-- --------------------------------------

SELECT * FROM unicen.materia where nombre IN (
    'DERECHO COMERCIAL II',
    'DERECHO INTERNACIONAL PUBLICO',
    'DERECHO PROCESAL PENAL',
    'ORATORIA JURIDICA Y FORENSE'
) and id_sede = 3;

SELECT * from unicen.plan_materia
WHERE  id_materia IN (
    SELECT id_materia FROM unicen.materia where nombre IN (
        'DERECHO COMERCIAL II',
        'DERECHO INTERNACIONAL PUBLICO',
        'DERECHO PROCESAL PENAL',
        'ORATORIA JURIDICA Y FORENSE'
        ) and id_sede = 3
) and id_plan_estudio = 133;

SELECT DISTINCT id_materia, paralelo,id_turno, id_grupo FROM unicen.nota where 
id_materia IN (
    SELECT id_materia from unicen.plan_materia
WHERE  id_materia IN (
    SELECT id_materia FROM unicen.materia where nombre IN (
        'DERECHO COMERCIAL II',
        'DERECHO INTERNACIONAL PUBLICO',
        'DERECHO PROCESAL PENAL',
        'ORATORIA JURIDICA Y FORENSE'
    ) and id_sede = 3
) and id_plan_estudio = 133
) and id_gestion = 105 and id_sede = 3 and id_plan_estudio = 133;

SELECT DISTINCT id_materia, unicodigo, paralelo,id_turno, id_grupo, estnota, est, estinsc, tipo_ins, recursada FROM unicen.nota where 
id_materia IN (
    SELECT id_materia from unicen.plan_materia
WHERE  id_materia IN (
    SELECT id_materia FROM unicen.materia where nombre IN (
        'DERECHO COMERCIAL II',
        'DERECHO INTERNACIONAL PUBLICO',
        'DERECHO PROCESAL PENAL',
        'ORATORIA JURIDICA Y FORENSE'
    ) and id_sede = 3
) and id_plan_estudio = 133
) and id_gestion = 105 and id_sede = 3 and id_plan_estudio = 133;


BEGIN;

select * from unicen.estudiantecareco where unicodigo = 19977 and id_sede = 3;

CALL unicen.pr_aux_add_nota_estudiante(
    19977,
    11930,
    ARRAY[
        'DERECHO COMERCIAL II',
        'DERECHO INTERNACIONAL PUBLICO',
        'DERECHO PROCESAL PENAL',
        'ORATORIA JURIDICA Y FORENSE'
     ],
    133,
    3,
    105,
    'A',
    3
);

SELECT * FROM unicen.nota where unicodigo = 19977 and id_plan_estudio = 133 and id_sede = 3 ORDER BY freg ASC;

SELECT * FROM unicen.inscripcion where unicodigo = 19977 and id_gestion = 105 and id_sede = 3;

COMMIT;

-- --------------------------------------
-- SARA IVANA AGUIRRE ALBAN
-- --------------------------------------
-- METODOLOGÍA DE LA INVESTIGACIÓN CIENTÍFICA (7° grupo B) 
-- PATOLOGÍA POR ESPECILIDADES (7° grupo B)
-- TERAPIA MANUAL I (7° grupo B)
-- KINESIOTERAPIA ESTETICA Y DERMATOFUNCIONAL (8 Grupo A)


SELECT * FROM unicen.materia where nombre LIKE '%ESPECIALIDADES%';

SELECT * FROM unicen.carrera where nombre like '%FISIOTERAPIA%' AND id_sede = 3;

SELECT * FROM unicen.plan_estudio where id_carrera = 6;



select * from unicen.estudiantecareco where unicodigo =23008;

SELECT * FROM unicen.materia where nombre IN (
    'METODOLOGIA DE LA INVESTIGACION CIENTIFICA',
    'PATOLOGIA POR ESPECIALIDADES',
    'TERAPIA MANUAL I',
    'KINESIOTERAPIA ESTETICA Y DERMATOFUNCIONAL'
) and id_sede = 3;


SELECT * from unicen.plan_materia
WHERE  id_materia IN (
    SELECT id_materia FROM unicen.materia where nombre IN (
        'METODOLOGIA DE LA INVESTIGACION CIENTIFICA',
        'PATOLOGIA POR ESPECIALIDADES',
        'TERAPIA MANUAL I',
        'KINESIOTERAPIA ESTETICA Y DERMATOFUNCIONAL'
        ) and id_sede = 3
) and id_plan_estudio = 134;

SELECT DISTINCT id_materia, paralelo,id_turno, id_grupo FROM unicen.nota where 
id_materia IN (
    SELECT id_materia from unicen.plan_materia
WHERE  id_materia IN (
    SELECT id_materia FROM unicen.materia where nombre IN (
        'METODOLOGIA DE LA INVESTIGACION CIENTIFICA',
        'PATOLOGIA POR ESPECIALIDADES',
        'TERAPIA MANUAL I',
        'KINESIOTERAPIA ESTETICA Y DERMATOFUNCIONAL'
    ) and id_sede = 3
) and id_plan_estudio = 134
) and id_gestion = 105 and id_sede = 3 and id_plan_estudio = 134;

SELECT * FROM unicen.inscripcion where unicodigo = 23008 and id_gestion = 105 and id_sede = 3;

SELECT DISTINCT id_materia, unicodigo, paralelo,id_turno, id_grupo, estnota, est, estinsc, tipo_ins, recursada FROM unicen.nota where 
id_materia IN (
    SELECT id_materia from unicen.plan_materia
WHERE  id_materia IN (
    SELECT id_materia FROM unicen.materia where nombre IN (
        'METODOLOGIA DE LA INVESTIGACION CIENTIFICA',
        'PATOLOGIA POR ESPECIALIDADES',
        'TERAPIA MANUAL I',
        'KINESIOTERAPIA ESTETICA Y DERMATOFUNCIONAL'
    ) and id_sede = 3
) and id_plan_estudio = 134
) and id_gestion = 105 and id_sede = 3 and id_plan_estudio = 134;

select * from unicen.estudiantecareco where unicodigo = 23008 and id_sede = 3;

BEGIN;

SELECT setval(
  pg_get_serial_sequence('unicen.inscripcion', 'id_inscripcion'),
  COALESCE((SELECT MAX(id_inscripcion) FROM unicen.inscripcion), 0),
  TRUE
);

CALL unicen.pr_aux_add_nota_estudiante(
    23008,
    6668,
    ARRAY[
        'KINESIOTERAPIA ESTETICA Y DERMATOFUNCIONAL'
     ],
    134,
    3,
    105,
    'A',
    2
);

CALL unicen.pr_aux_add_nota_estudiante(
    23008,
    6668,
    ARRAY[
        'METODOLOGIA DE LA INVESTIGACION CIENTIFICA',
        'PATOLOGIA POR ESPECIALIDADES',
        'TERAPIA MANUAL I'
     ],
    134,
    3,
    105,
    'B',
    2
);



select * from unicen.nota where unicodigo = 23008 and id_plan_estudio = 134 and id_sede = 3 ORDER BY freg ASC;

select * from unicen.estudiantecareco where unicodigo = 23008 and id_sede = 3;

SELECT * FROM unicen.inscripcion where unicodigo = 23008 and id_gestion = 105 and id_sede = 3;

SELECT * from unicen.usuario where unicodigo = 4137;

COMMIT;

ROLLBACK;

-- GUZMAN DONGO PEDRO SEGUNDO
-- --------------------------------------
-- DERECHO INTERNACIONAL PÚBLICO
-- INTRODUCCIÓN A LA INVESTIGACIÓN CIENTÍFICA 
-- ORATORIA JURÍDICA Y FORENSE
-- DERECHO AGRARIO
-- MEDIOS ALTERNOS DE SOLUCIÓN DE CONFLICTOS 
-- METODOLOGIA DE LA INVESTIGACION CIENTIFICA 
-- PRÁCTICA FORENSE CIVIL I

SELECT id_grupo, id_materia FROM unicen.nota where unicodigo = 19492 and id_plan_estudio = 133 and id_sede = 3 and  id_gestion = 105 and id_materia IN (
    1817,
    1823,
    1826    
); 


DELETE FROM unicen.nota where unicodigo = 19492 and id_plan_estudio = 133 and id_sede = 3 and  id_gestion = 105 and id_materia IN (
    1817,
    1823,
    1826    
);


BEGIN;

-- 221
-- 1823
-- 239
-- 1826
SELECT * FROM unicen.materia where nombre IN (
    'DERECHO INTERNACIONAL PUBLICO',
    'INTRODUCCION A LA INVESTIGACION CIENTIFICA',
    'ORATORIA JURIDICA Y FORENSE',
    'DERECHO AGRARIO',
    'MEDIOS ALTERNOS DE SOLUCION DE CONFLICTOS',
    'METODOLOGIA DE LA INVESTIGACION CIENTIFICA',
    'PRACTICA FORENSE CIVIL I'
) and id_sede = 3;

SELECT * from unicen.plan_materia
WHERE  id_materia IN (
    SELECT id_materia FROM unicen.materia where nombre IN (
        'DERECHO INTERNACIONAL PUBLICO',
        'INTRODUCCION A LA INVESTIGACION CIENTIFICA',
        'ORATORIA JURIDICA Y FORENSE',
        'DERECHO AGRARIO',
        'MEDIOS ALTERNOS DE SOLUCION DE CONFLICTOS',
        'METODOLOGIA DE LA INVESTIGACION CIENTIFICA',
        'PRACTICA FORENSE CIVIL I'
        ) and id_sede = 3
) and id_plan_estudio = 133;

SELECT DISTINCT id_materia, paralelo,id_turno, id_grupo FROM unicen.nota where 
id_materia IN (
    SELECT id_materia from unicen.plan_materia
WHERE  id_materia IN (
    SELECT id_materia FROM unicen.materia where nombre IN (
        'DERECHO INTERNACIONAL PUBLICO',
        'INTRODUCCION A LA INVESTIGACION CIENTIFICA',
        'ORATORIA JURIDICA Y FORENSE',
        'DERECHO AGRARIO',
        'MEDIOS ALTERNOS DE SOLUCION DE CONFLICTOS',
        'METODOLOGIA DE LA INVESTIGACION CIENTIFICA',
        'PRACTICA FORENSE CIVIL I'
    ) and id_sede = 3
) and id_plan_estudio = 133
) and id_gestion = 105 and id_sede = 3 and id_plan_estudio = 133;


SELECT setval(
  pg_get_serial_sequence('unicen.inscripcion', 'id_inscripcion'),
  COALESCE((SELECT MAX(id_inscripcion) FROM unicen.inscripcion), 0),
  TRUE
);


select id_estudiante from unicen.estudiantecareco where unicodigo = 19492 and id_sede = 3;

SELECT * FROM unicen.estudiantecareco where unicodigo = 19492 and id_sede = 3;

SELECT * FROM unicen.nota where unicodigo = 19492 and id_plan_estudio = 133 and id_sede = 3 ORDER BY freg ASC;

SELECT * FROM unicen.inscripcion where unicodigo = 19492 and id_gestion = 105 and id_sede = 3;

CALL unicen.pr_aux_add_nota_estudiante(
    19492,
    14613,
    ARRAY[
        'DERECHO INTERNACIONAL PUBLICO',
        'INTRODUCCION A LA INVESTIGACION CIENTIFICA',
        'ORATORIA JURIDICA Y FORENSE',
        'DERECHO AGRARIO',
        'MEDIOS ALTERNOS DE SOLUCION DE CONFLICTOS',
        'METODOLOGIA DE LA INVESTIGACION CIENTIFICA',
        'PRACTICA FORENSE CIVIL I'
     ],
    133,
    3,
    105,
    'A',
    3
);

CALL unicen.pr_aux_add_nota_estudiante(
    19492,
    14613,
    ARRAY[
        'DERECHO AGRARIO',
        'MEDIOS ALTERNOS DE SOLUCION DE CONFLICTOS',
        'PRACTICA FORENSE CIVIL I'
     ],
    133,
    3,
    105,
    'A',
    1
);
COMMIT;

SELECT id_materia,paralelo,id_turno FROM unicen.nota where unicodigo = 19492 and id_gestion = 105;

SELECT * FROM unicen.inscripcion where unicodigo = 23008 and id_gestion = 105 and id_sede = 3;

SELECT DISTINCT id_materia, unicodigo, paralelo,id_turno, id_grupo, estnota, est, estinsc, tipo_ins, recursada FROM unicen.nota where 
id_materia IN (
    SELECT id_materia from unicen.plan_materia
WHERE  id_materia IN (
    SELECT id_materia FROM unicen.materia where nombre IN (
        'METODOLOGIA DE LA INVESTIGACION CIENTIFICA',
        'PATOLOGIA POR ESPECIALIDADES',
        'TERAPIA MANUAL I',
        'KINESIOTERAPIA ESTETICA Y DERMATOFUNCIONAL'
    ) and id_sede = 3
) and id_plan_estudio = 134
) and id_gestion = 105 and id_sede = 3 and id_plan_estudio = 134;

select * from unicen.inscripcion where unicodigo = 34501 and id_gestion = 105 and id_sede = 3;

    ) and id_sede = 3
) and id_plan_estudio = 133
) and id_gestion = 105 and id_sede = 3 and id_plan_estudio = 133;


SELECT * FROM unicen.nota where unicodigo = 34501 and id_plan_estudio = 133 and id_sede = 3 ORDER BY freg ASC;

COMMIT;
select * from unicen.inscripcion where unicodigo = 34501 and id_gestion = 105 and id_sede = 3;

SELECT * FROM unicen.estudiante where paterno = 'SALAZAR' and materno = 'CHUI';
SELECT * FROM unicen.estudiantecareco where unicodigo = 34501 and id_sede = 3;




SELECT * FROM unicen.usuario where unicodigo = 4137;



-- --------------------------------------
-- MAMANI CRUZ JARED BENJAMIN
-- --------------------------------------
-- ADMINISTRACION DE HOSPITALES (paralelo A)
-- DERMATOLOGIA (paralelo A)
-- GINECOLOGIA Y OBSTETRICIA IV (paralelo A)
-- MEDICINA INTERNA II - ENDOCRINOLOGIA (paralelo A)
-- MEDICINA INTERNA II - HEMATOLOGIA (paralelo A)
-- MEDICINA LEGAL (paralelo A)
-- PSIQUIATRIA (paralelo A)


SELECT * from unicen.materia where nombre LIKE '%DERMATOLOGIA%';

SELECT * FROM unicen.carrera where nombre like '%MEDICINA%' AND id_sede = 3;

SELECT * FROM unicen.plan_estudio where id_carrera = 54 and id_sede = 3;

SELECT * FROM unicen.materia where nombre IN (
    'ADMINISTRACION DE HOSPITALES',
    'DERMATOLOGIA',
    'GINECOLOGIA Y OBSTETRICIA IV',
    'MEDICINA INTERNA II - ENDOCRINOLOGIA',
    'MEDICINA INTERNA II - HEMATOLOGIA',
    'MEDICINA LEGAL',
    'PSIQUIATRIA'
) and id_sede = 3;

SELECT * from unicen.plan_materia
WHERE  id_materia IN (
    SELECT id_materia FROM unicen.materia where nombre IN (
        'ADMINISTRACION DE HOSPITALES',
        'DERMATOLOGIA',
        'GINECOLOGIA Y OBSTETRICIA IV',
        'MEDICINA INTERNA II - ENDOCRINOLOGIA',
        'MEDICINA INTERNA II - HEMATOLOGIA',
        'MEDICINA LEGAL',
        'PSIQUIATRIA'
        ) and id_sede = 3
) and id_plan_estudio = 105 and id_sede = 3;

SELECT DISTINCT id_materia, paralelo,id_turno, id_grupo FROM unicen.nota where 
id_materia IN (
    SELECT id_materia from unicen.plan_materia
WHERE  id_materia IN (
    SELECT id_materia FROM unicen.materia where nombre IN (
        'ADMINISTRACION DE HOSPITALES',
        'DERMATOLOGIA',
        'GINECOLOGIA Y OBSTETRICIA IV',
        'MEDICINA INTERNA II - ENDOCRINOLOGIA',
        'MEDICINA INTERNA II - HEMATOLOGIA',
        'MEDICINA LEGAL',
        'PSIQUIATRIA'
    ) and id_sede = 3
) and id_plan_estudio = 105 and id_sede = 3
) and id_gestion = 105 and id_sede = 3 and id_plan_estudio = 105;


SELECT setval(
  pg_get_serial_sequence('unicen.inscripcion', 'id_inscripcion'),
  COALESCE((SELECT MAX(id_inscripcion) FROM unicen.inscripcion), 0),
  TRUE
);

SELECT * FROM unicen.estudiantecareco where unicodigo = 19492 and id_sede = 3;

SELECT * FROM unicen.nota where unicodigo = 19492 and id_plan_estudio = 105 and id_sede = 3 ORDER BY freg ASC;

SELECT * FROM unicen.inscripcion where unicodigo = 19492 and id_gestion = 105 and id_sede = 3;

SELECT * FROM unicen.estudiantecareco where unicodigo = 28157 and id_sede = 3;

BEGIN;

CALL unicen.pr_aux_add_nota_estudiante(
    28157,
    24801,
    ARRAY[
        'ADMINISTRACION DE HOSPITALES',
        'DERMATOLOGIA',
        'GINECOLOGIA Y OBSTETRICIA IV',
        'MEDICINA INTERNA II - ENDOCRINOLOGIA',
        'MEDICINA INTERNA II - HEMATOLOGIA',
        'MEDICINA LEGAL',
        'PSIQUIATRIA'
     ],
    105,
    3,
    105,
    'A',
    2
);

SELECT * FROM unicen.nota where unicodigo = 28157 and id_plan_estudio = 105 and id_sede = 3 ORDER BY freg ASC;

SELECT * FROM unicen.estudiantecareco where unicodigo = 28157 and id_sede = 3;

SELECT * FROM unicen.inscripcion where unicodigo = 28157 and id_gestion = 105 and id_sede = 3;

COMMIT;


        'METODOLOGIA DE LA INVESTIGACION CIENTIFICA',
        'PRACTICA FORENSE CIVIL I'
     ],
    133,
    3,
    105,
    'A',
    3
);

-- --------------------------------------
-- TORREZ SARMIENTO NELGIO YUBER
-- --------------------------------------
-- DIRECCION EJECUTIVA
-- GESTION DE EMPRENDIMIENTOS
-- MARKETING DIGITAL
-- NEGOCIACIONES
-- PRACTICA PRE-PROFESIONAL (ADM
-- ADMINISTRACION FINANCIERA


SELECT * from unicen.materia where nombre LIKE '%E%';

SELECT * FROM unicen.carrera where nombre LIKE 'ADMI%' AND id_sede = 3;

SELECT * FROM unicen.nota where unicodigo = 21819 and id_plan_estudio = 135 and id_sede = 3 and id_materia = 1769;

SELECT * FROM unicen.plan_estudio where id_carrera = 17 and id_sede = 3;

SELECT * FROM unicen.materia where nombre LIKE '%TALLER INTEGRAL%'

SELECT * FROM unicen.materia where nombre IN (
    'DIRECCION EJECUTIVA',
    'GESTION DE EMPRENDIMIENTOS',
    'MARKETING DIGITAL',
    'NEGOCIACIONES',
    'PRACTICA PRE-PROFESIONAL (ADM)',
    'ADMINISTRACION FINANCIERA'
) and id_sede = 3;

SELECT * from unicen.plan_materia
WHERE  id_materia IN (
    SELECT id_materia FROM unicen.materia where nombre IN (
        'DIRECCION EJECUTIVA',
        'GESTION DE EMPRENDIMIENTOS',
        'MARKETING DIGITAL',
        'NEGOCIACIONES',
        'PRACTICA PRE-PROFESIONAL (ADM)',
        'ADMINISTRACION FINANCIERA'
        ) and id_sede = 3
) and id_plan_estudio = 135 and id_sede = 3;

SELECT DISTINCT id_materia, paralelo,id_turno, id_grupo FROM unicen.nota where 
id_materia IN (
    SELECT id_materia from unicen.plan_materia
WHERE  id_materia IN (
    SELECT id_materia FROM unicen.materia where nombre IN (
        'DIRECCION EJECUTIVA',
        'GESTION DE EMPRENDIMIENTOS',
        'MARKETING DIGITAL',
        'NEGOCIACIONES',
        'PRACTICA PRE-PROFESIONAL (ADM)',
        'ADMINISTRACION FINANCIERA'
    ) and id_sede = 3
) and id_plan_estudio = 135 and id_sede = 3
) and id_gestion = 105 and id_sede = 3 and id_plan_estudio = 135;

SELECT * from unicen.estudiantecareco where unicodigo = 21819 and id_sede = 3;

BEGIN;
ROLLBACK;

CALL unicen.pr_aux_add_nota_estudiante(
    21819,
    12066,
    ARRAY[
        'DIRECCION EJECUTIVA',
        'GESTION DE EMPRENDIMIENTOS',
        'MARKETING DIGITAL',
        'NEGOCIACIONES',
        'PRACTICA PRE-PROFESIONAL (ADM)',
        'ADMINISTRACION FINANCIERA'
     ],
    135,
    3,
    105,
    'A',
    3
);


CALL unicen.pr_aux_add_nota_estudiante(
    21819,
    12066,
    ARRAY[
        'TALLER INTEGRAL DE NEGOCIOS'
     ],
    135,
    3,
    105,
    'A',
    3
);

SELECT * FROM unicen.nota where unicodigo  = 21819 and id_sede = 3 and id_plan_estudio = 135 ORDER BY freg ASC;

COMMIT;
SELECT setval(
  pg_get_serial_sequence('unicen.inscripcion', 'id_inscripcion'),
  COALESCE((SELECT MAX(id_inscripcion) FROM unicen.inscripcion), 0),
  TRUE
);

select * from unicen.inscripcion where unicodigo = 21819 and id_gestion = 105 and id_sede = 3;

SELECT * FROM unicen.estudiantecareco where unicodigo = 19492 and id_sede = 3;

SELECT * FROM unicen.nota where unicodigo = 19492 and id_plan_estudio = 105 and id_sede = 3 ORDER BY freg ASC;

SELECT * FROM unicen.inscripcion where unicodigo = 19492 and id_gestion = 105 and id_sede = 3;

SELECT * FROM unicen.estudiantecareco where unicodigo = 28157 and id_sede = 3;

BEGIN;

CALL unicen.pr_aux_add_nota_estudiante(
    28157,
    24801,
    ARRAY[
        'ADMINISTRACION DE HOSPITALES',
        'DERMATOLOGIA',
        'GINECOLOGIA Y OBSTETRICIA IV',
        'MEDICINA INTERNA II - ENDOCRINOLOGIA',
        'MEDICINA INTERNA II - HEMATOLOGIA',
        'MEDICINA LEGAL',
        'PSIQUIATRIA'
     ],
    105,
    3,
    105,
    'A',
    2
);

SELECT * FROM unicen.estudiante where materno = 'RUBIN DE CELIS';

SELECT * FROM unicen.estudiante where materno = 'VERA';



-- --------------------------------------
-- VERA RUBIN DE CELIS MICHELLE
-- --------------------------------------

-- INTRODUCCION A LA INGENIERIA COMERCIAL

SELECT * from unicen.materia where nombre LIKE '%E%';

SELECT * FROM unicen.carrera where nombre = 'INGENIERIA COMERCIAL' AND id_sede = 3;

SELECT * FROM unicen.plan_estudio where id_carrera = 13 and id_sede = 3;

SELECT * FROM unicen.estudiante where num_documento = '8365046';



SELECT  * FROM unicen.estudiantecareco where unicodigo = 35983;

SELECT * FROM unicen.nota where unicodigo = 35983 and id_sede = 3;

SELECT * FROM unicen.materia where nombre IN (
    'INTRODUCCION A LA INGENIERIA COMERCIAL'
) and id_sede = 3;

SELECT * from unicen.plan_materia
WHERE  id_materia IN (
    SELECT id_materia FROM unicen.materia where nombre IN (
        'INTRODUCCION A LA INGENIERIA COMERCIAL'
    ) and id_sede = 3
) and id_plan_estudio = 130 and id_sede = 3;

SELECT DISTINCT id_materia, paralelo,id_turno, id_grupo, id_plan_estudio FROM unicen.nota where 
id_materia IN (
    SELECT id_materia from unicen.plan_materia
WHERE  id_materia IN (
    SELECT id_materia FROM unicen.materia where nombre IN (
        'INTRODUCCION A LA INGENIERIA COMERCIAL'
    ) and id_sede = 3
) and id_plan_estudio = 130 and id_sede = 3
) and id_gestion = 105 and id_sede = 3 and id_plan_estudio = 130;

SELECT DISTINCT id_materia, paralelo,id_turno, id_grupo, id_plan_estudio FROM unicen.nota where 
id_materia IN (
    SELECT id_materia from unicen.plan_materia
WHERE  id_materia IN (
    SELECT id_materia FROM unicen.materia where nombre IN (
        'DIRECCION EJECUTIVA',
        'GESTION DE EMPRENDIMIENTOS',
        'MARKETING DIGITAL',
        'NEGOCIACIONES',
        'PRACTICA PRE-PROFESIONAL (ADM)',
        'ADMINISTRACION FINANCIERA'
    ) and id_sede = 3
) and id_plan_estudio = 135 and id_sede = 3
) and id_gestion = 105 and id_sede = 3 and id_plan_estudio = 135;

select * from unicen.carrera where id_carrera = (
    SELECT id_carrera FROM unicen.plan_estudio where id_plan_estudio = 137 and id_sede = 3
) and id_sede = 3;


select * from unicen.grupo where  id_gestion = 105 and id_sede = 3 and id_plan_estudio = 130 and 
id_materia IN(
    SELECT id_materia from unicen.plan_materia
WHERE  id_materia IN (
    SELECT id_materia FROM unicen.materia where nombre IN (
                'INTRODUCCION A LA INGENIERIA COMERCIAL'
        ) and id_sede = 3
) and id_plan_estudio = 130 and id_sede = 3
);



SELECT * FROM unicen.nota where id_plan_estudio = 135 and id_sede = 3 and id_gestion = 105 and id_materia = 1827;


SELECT * FROM unicen.materia where id_materia = 1742 and id_sede = 3;

SELECT setval(
  pg_get_serial_sequence('unicen.inscripcion', 'id_inscripcion'),
  COALESCE((SELECT MAX(id_inscripcion) FROM unicen.inscripcion), 0),
  TRUE
);

SELECT * from unicen.estudiantecareco where unicodigo = 35983 and id_sede = 3;
ROLLBACK;

SELECT * FROM unicen.nota where unicodigo = 35983 and id_plan_estudio = 130 and id_sede = 3 ORDER BY freg ASC;
BEGIN;
CALL unicen.pr_aux_add_nota_estudiante(
    35983,
    7366,
    ARRAY[
        'INTRODUCCION A LA INGENIERIA COMERCIAL'
     ],
    130,
    3,
    105,
    'A',
    3
);

select * from unicen.nota where unicodigo = 35983 and id_plan_estudio = 130 and id_sede = 3 ORDER BY freg ASC;

COMMIT;


SELECT nt.id_grupo,nt.unicodigo,'AUSENTE','2026-03-04'::TIMESTAMP WITHOUT TIME ZONE
    FROM (SELECT id_grupo,unicodigo FROM unicen.nota where id_grupo=86309 and id_gestion=105 GROUP BY unicodigo,id_grupo) nt JOIN 
	(select distinct unicodigo FROM unicen.inscripcion where id_gestion = 105 and estinsceco = 'INSCRITO') inscr on nt.unicodigo = inscr.unicodigo;


SELECT nt.id_grupo,nt.unicodigo,'AUSENTE','2026-03-04'::TIMESTAMP WITHOUT TIME ZONE
    FROM (SELECT id_grupo,unicodigo FROM unicen.nota where id_grupo=86309 and id_gestion=105 GROUP BY unicodigo,id_grupo) nt JOIN 
	(select distinct unicodigo FROM unicen.inscripcion where id_gestion = 105 and estinsceco = 'INSCRITO' 
		and unicodigo NOT IN (
			SELECT unicodigo_est from unicen.asistencia where id_grupo = 86309 and (TO_CHAR(fecha, 'YYYY-MM-DD') = '2026-03-04')
	)) inscr on nt.unicodigo = inscr.unicodigo;


    SELECT unicodigo_est from unicen.asistencia where id_grupo = 86309 and (TO_CHAR(fecha, 'YYYY-MM-DD') = '2026-03-04');

SELECT * FROM unicen.usuario where unicodigo = 4137;


-- VERANO 2026
-- SALAZAR CHUI NELSON ELCIER
-- --------------------------------------

-- DERECHO PROCESAL CIVIL
-- ORGANIZACION JUDICIAL


select * from unicen.carrera where nombre like '%DERECHO%' and id_sede = 3;

select * from unicen.materia where nombre like '%JUDICIAL%' and id_sede = 3;

SELECT * FROM unicen.materia where nombre IN (
    'DERECHO PROCESAL CIVIL Y ORGANIZACION JUDICIAL'
) and id_sede = 3;

SELECT * FROM unicen.materia where nombre = 'DERECHO PROCESAL Y PROCEDIMIENTO CIVIL' and id_sede = 3;

SELECT * from unicen.plan_materia
WHERE  id_materia IN (
    SELECT id_materia FROM unicen.materia where nombre IN (
        'DERECHO PROCESAL Y PROCEDIMIENTO CIVIL'
    ) and id_sede = 3
) and id_plan_estudio = 133 and id_sede = 3;


SELECT * FROM unicen.grupo where id_materia = 1806 and id_sede = 3 and id_gestion = 112;

SELECT * from unicen.plan_materia
WHERE  id_materia IN (
    SELECT id_materia FROM unicen.materia where nombre IN (
        'DERECHO PROCESAL CIVIL Y ORGANIZACION JUDICIAL'
    ) and id_sede = 3
) and id_plan_estudio = 133 and id_sede = 3;

select * from unicen.grupo where  id_gestion = 112 and id_sede = 3 and id_plan_estudio = 133 and 
id_materia IN(
    SELECT id_materia from unicen.plan_materia
WHERE  id_materia IN (
    SELECT id_materia FROM unicen.materia where nombre IN (
                'DERECHO PROCESAL Y PROCEDIMIENTO CIVIL'
        ) and id_sede = 3
) and id_plan_estudio = 133 and id_sede = 3
);

SELECT * FROM unicen.gestion;


BEGIN;

SELECT * FROM unicen.estudiantecareco where unicodigo = 34501;

SELECT * FROM unicen.nota where unicodigo = 34501 and id_plan_estudio = 133 and id_sede = 3 ORDER BY freg ASC;


CALL unicen.pr_aux_add_nota_estudiante(
    34501,
    8120,
    ARRAY[
        'DERECHO PROCESAL Y PROCEDIMIENTO CIVIL'
     ],
    133,
    3,
    112,
    'A',
    1
);


BEGIN;

DELETE FROM unicen.nota where unicodigo = 34501 and id_plan_estudio = 133 and id_sede = 3 and id_gestion = 112 and id_materia = 1755;

COMMIT;

SELECT * FROM unicen.gestion where id_gestion = 112;
select * from unicen.inscripcion where  unicodigo = 11082;


ROLLBACK;



-- VERANO 2026
-- NAVARRO RIVERA DANTE SAUL
-- --------------------------------------

-- FILOSOFIA JURIDICA Y ETICA PROFESIONAL


SELECT * FROM unicen.materia where nombre IN (
    'FILOSOFIA JURIDICA Y ETICA PROFESIONAL'
) and id_sede = 3;


SELECT * from unicen.plan_materia
WHERE  id_materia IN (
    SELECT id_materia FROM unicen.materia where nombre IN (
        'FILOSOFIA JURIDICA Y ETICA PROFESIONAL'
    ) and id_sede = 3
) and id_plan_estudio = 133 and id_sede = 3;


select * from unicen.grupo where  id_gestion = 112 and id_sede = 3 and id_plan_estudio = 133 AND id_materia IN(
    SELECT id_materia from unicen.plan_materia
WHERE  id_materia IN (
    SELECT id_materia FROM unicen.materia where nombre IN (
        'FILOSOFIA JURIDICA Y ETICA PROFESIONAL'
    ) and id_sede = 3
) and id_plan_estudio = 133 and id_sede = 3
);


SELECT * FROM unicen.estudiantecareco where unicodigo = 19667;


CALL unicen.pr_aux_add_nota_estudiante(
    19667,
    9836,
    ARRAY[
        'FILOSOFIA JURIDICA Y ETICA PROFESIONAL'
     ],
    133,
    3,
    112,
    'A',
    1
);



SELECT ctid,* FROM unicen.nota where unicodigo = 19667 and id_plan_estudio = 133 and id_sede = 3 ORDER BY freg ASC;

SELECT * FROM unicen.inscripcion where unicodigo = 19667 and id_sede = 3;

ROLLBACK;

SELECT * FROM unicen.usuario where unicodigo = 4137;

SELECT pers.nombres, pers.unicodigo, pers.num_documento, m.nombre, g.id_grupo, g.id_materia, n.id_gestion, n.id_sede
from unicen.personal pers JOIN unicen.grupo_docente gd ON pers.unicodigo = gd.unicodigo
JOIN unicen.grupo g ON gd.id_grupo = g.id_grupo 
JOIN materia m ON g.id_materia = m.id_materia
JOIN nota n ON n.id_grupo = g.id_grupo and n.id_gestion = g.id_gestion and n.id_sede = g.id_sede
WHERE g.id_gestion = 105 and g.id_sede = 1 and m.nombre IN (
    'PEDIATRÍA II',
    'CIRUGÍA II',
    'EPIDEMIOLOGÍA',
    'GINECOLOGÍA Y OBSTETRICIA II'

)and n.id_gestion = 105 and n.unicodigo = 10935 and g.id_sede = 1;

SELECT * FROM unicen.inscripcion where unicodigo = 10935 and id_gestion = 105 and id_sede = 1;


SELECT * FROM unicen.personal pers JOIN unicen.grupo_docente gd ON pers.unicodigo = gd.unicodigo;


select * from unicen.materia m JOIN unicen.grupo g ON m.id_materia = g.id_materia
WHERE m.nombre IN (
    'PEDIATRÍA II',
    'CIRUGÍA II',
    'EPIDEMIOLOGÍA',
    'GINECOLOGÍA Y OBSTETRICIA II'
) and m.id_sede = 1 and g.id_gestion = 105 and g.id_sede = 1;

select * from unicen.usuario where unicodigo = 4137;

select * from unicen.inscripcion where unicodigo =11352 and id_sede = 1 and id_gestion = 105;

SELECT * FROM unicen.inscripcion where unicodigo = 11361 and id_sede = 1 and id_gestion = 105;


SELECT * FROM unicen.inscripcion where unicodigo = 10935 and id_sede = 1 and id_gestion = 105;

SELECT * FROM unicen.inscripcion where unicodigo = 11007 and id_sede = 1 and id_gestion = 105;

SELECT * FROM unicen.inscripcion where unicodigo = 11622 and id_sede = 1 and id_gestion = 105;

SELECT * FROM unicen.inscripcion where unicodigo = 11323 and id_sede = 1 and id_gestion = 105;

SELECT * FROM unicen.inscripcion where unicodigo = 11087 and id_sede = 1 and id_gestion = 105;

SELECT * FROM unicen.inscripcion where unicodigo = 11021 and id_sede = 1 and id_gestion = 105;

SELECT * FROM unicen.inscripcion where unicodigo = 11312 and id_sede = 1 and id_gestion = 105;

SELECT * FROM unicen.inscripcion where unicodigo = 34680 and id_sede = 1 and id_gestion = 105;

SELECT * FROM unicen.inscripcion where unicodigo = 33811 and id_sede = 1 and id_gestion = 105;

SELECT * FROM unicen.inscripcion where unicodigo = 16650 and id_sede = 2 and id_gestion = 105;

SELECT * FROM unicen.inscripcion where unicodigo = 35612 and id_sede = 2 and id_gestion = 105;
SELECT unicen.estudiantes_inscrito_reserva(34790, 3, 105)

SELECT id_gestion, id_grupo,nt.paralelo, m.nombre FROM unicen.nota nt JOIN materia m ON nt.id_materia = m.id_materia WHERE nt.unicodigo = 35612 and nt.id_sede = 2 and nt.id_gestion = 105 ORDER BY nt.id_gestion DESC;

select * from unicen.seiko_listarestudiantegrupo(85960,105,2) where unic = 35612;

SELECT * FROM unicen.estudiantecareco where unicodigo = 85961;

select * from unicen.plan_economico where id_plan_economico = 56;


-- GERARDO AMUSQUIVAR JEMIO




-- JOEL MAURICIO QUISBERT QUISBERT
-- VELIA  QUISPE  MAMANI

-- JOSE MARIA BLANCO TICONA

-- JHEFERSON FERNANDO  LAURA  QUENTA 

-- MARCELO NICOLAS GUTIERREZ MOLLO

-- GABRIELA NOEMI CATACORA CEREZO

-- 34182

-- ALISON ANDREA CHIPANA BALLEJOS - observacion

-- 34248

-- 34248

-- CRUZ CHURA REYNALDO

SELECT * FROM unicen.estudiante where unicodigo = 35728

SELECT * FROM unicen.usuario where unicodigo = 4137;

BEGIN;
DELETE FROM unicen.estudiante where unicodigo = 35728;

COMMIT;

select * from unicen.usuario WHERE unicodigo = 4137;

select * from plan_economico where id_plan_economico = 336;


SELECT * FROM unicen.plan_economico where id_plan_economico = 310;


SELECT unicen.estudiantes_inscrito_reserva(35268, 3, 105)

SELECT unicen.estudiantes_inscrito_reserva(11361, 1, 105)

SELECT unicen.estudiantes_inscrito_reserva(10935, 1, 105)

SELECT unicen.estudiantes_inscrito_reserva(11007, 1, 105)

SELECT unicen.estudiantes_inscrito_reserva(11622, 1, 105)

SELECT unicen.estudiantes_inscrito_reserva(11323, 1, 105)

SELECT unicen.estudiantes_inscrito_reserva(11087, 1, 105)

SELECT unicen.estudiantes_inscrito_reserva(11021, 1, 105)

SELECT unicen.estudiantes_inscrito_reserva(11312, 1, 105)

SELECT unicen.estudiantes_inscrito_reserva(11312, 1, 105)

SELECT unicen.estudiantes_inscrito_reserva(9357, 1, 105)



BEGIN;

SELECT unicen.estudiantes_inscrito_reserva(34680, 1, 105)

SELECT unicen.estudiantes_inscrito_reserva(35618, 1, 105);


COMMIT;

ROLLBACK;



SELECT id_gestion, id_grupo FROM unicen.nota where unicodigo = 34185 and id_sede = 3 ORDER BY id_gestion DESC;

SELECT id_gestion, id_grupo FROM unicen.nota where unicodigo = 11352 and id_sede = 1 ORDER BY id_gestion DESC;

SELECT id_gestion, id_grupo FROM unicen.nota where unicodigo = 11361 and id_sede = 1 ORDER BY id_gestion DESC;

SELECT id_gestion, id_grupo FROM unicen.nota where unicodigo = 11007 and id_sede = 1 ORDER BY id_gestion DESC;

SELECT id_gestion, id_grupo FROM unicen.nota where unicodigo = 11622 and id_sede = 1 ORDER BY id_gestion DESC;

SELECT id_gestion, id_grupo FROM unicen.nota where unicodigo = 33811 and id_sede = 1 ORDER BY id_gestion DESC;

SELECT id_gestion, id_grupo FROM unicen.nota where unicodigo = 10120 and id_sede = 1 and id_gestion = 105 ORDER BY id_gestion DESC;

SELECT id_gestion, id_grupo FROM unicen.nota where unicodigo = 35618 and id_sede = 1 and id_gestion = 105 ORDER BY id_gestion DESC;


SELECT * FROM unicen.nota where unicodigo = 34185 and id_sede = 1 and id_gestion = 105 and id_grupo IS NOT NULL;


SELECT * FROM unicen.nota

select * from unicen.seiko_listarestudiantegrupo(86092,105,1) where unic = 34185;



SELECT * FROM unicen.estudiantecareco where unicodigo = 33811 and id_sede = 1;

SELECT * FROM unicen.estudiantecareco where unicodigo = 11352 and id_sede = 1;

SELECT * FROM unicen.carrera where nombre LIKE '%MEDICINA%' and id_sede = 1;

select * from unicen.plan_economico where id_sede = 1;

SELECT * FROM unicen.nota where unicodigo = 35618;

SELECT * from unicen.estudiantecareco where unicodigo = 35618;


SELECT numero_factura,monto_cubierto FROM unicen.factura_historial where numero_factura = '810' and fecha_factura = '2026-01-08' and unicodigo = 34606 and monto_cubierto = 50678;

BEGIN ;

-- UPDATE unicen.factura_historial set monto_cubierto = 810, numero_factura = '50678' where numero_factura = '810' and fecha_factura = '2026-01-08' and unicodigo = 34606 and monto_cubierto = 50678;
-- UPDATE unicen.factura_historial set monto_cubierto = 240, numero_factura = '50678' where numero_factura = '240' and fecha_factura = '2026-01-08' and unicodigo = 34606 and monto_cubierto = 50678;

SELECT * FROM unicen.factura_historial where numero_factura = '51355';

COMMIT;
ROLLBACK;

SELECT * FROM unicen.usuario where unicodigo = 4137;

SELECT * FROM unicen.factura where numero_factura = '810'


SELECT * FROM unicen.personal where paterno = 'BACARREZA';

-- MAGIA

SELECT * FROM unicen.usuario where unicodigo = 4137;

SELECT estinsceco FROM unicen.inscripcion where unicodigo = 19044 and id_sede = 1 and id_gestion = 105;
SELECT unicen.estudiantes_inscrito_reserva(19044, 1, 105)

select * from unicen.estudiantecareco where unicodigo = 12638 and id_sede = 2;

SELECT * FROM unicen.materia where id_materia = 1675;

SELECT * FROM unicen.grupo where id_materia = 1069 and id_gestion = 105;

SELECT m.id_materia,m.nombre,nt.paralelo, nt.id_turno, nt.id_grupo as grupo_inscrito, g.id_grupo as grupo_real, i.estinsceco FROM unicen.nota nt 
JOIN unicen.plan_materia pm ON nt.id_materia = pm.id_materia and nt.id_plan_estudio = pm.id_plan_estudio and nt.id_sede = pm.id_sede
JOIN unicen.grupo g ON pm.id_materia = g.id_materia and pm.id_plan_estudio = g.id_plan_estudio and pm.id_sede = g.id_sede and g.id_gestion = nt.id_gestion and g.paralelo = nt.paralelo and nt.id_turno = g.id_turno    
JOIN unicen.materia m ON m.id_materia = pm.id_materia and m.id_sede = pm.id_sede
left join unicen.inscripcion i ON i.unicodigo = nt.unicodigo and i.id_sede = nt.id_sede and i.id_gestion = nt.id_gestion
WHERE nt.unicodigo =  12753 and nt.id_sede = 2 and nt.id_gestion = 105

SELECT * FROM unicen.inscripcion where unicodigo = 35817;

SELECT * FROM unicen.nota where unicodigo = 35817;


select * from unicen.seiko_listarestudiantegrupo(86010,105,2) where unic = 33884;


SELECT * FROM unicen.grupo where id_materia = 1776 and id_gestion = 105 and id_plan_estudio = 98;

UPDATE unicen.nota SET id_grupo = 89333 where unicodigo = 17273 and id_sede = 2 and id_gestion = 105 and id_grupo = 87566 and id_materia = 1815;

SELECT id_nota, id_grupo, id_materia from unicen.nota where unicodigo = 17580 and id_sede = 2 and id_gestion = 105 and id_grupo IS NOT NULL;

CREATE OR REPLACE PROCEDURE unicen.pr_aux_

SELECT * FROM unicen.estudiantecareco where unicodigo = 85961;

select * from unicen.plan_economico where id_plan_economico = 56;



SELECT * FROM unicen.grupo where id_grupo = 85961 and id_gestion = 105;

SELECT * FROM unicen.nota where unicodigo = 15991 and id_sede = 2 and id_gestion = 105;


SELECT * FROM unicen.nota where unicodigo = 12062 and id_sede = 2;
SELECT * FROM unicen.estudiantecareco where unicodigo = 15991 and id_sede = 2;

SELECT * FROM unicen.grupo where id_materia = 1675 and id_gestion = 105 and id_sede = 2 and id_plan_estudio = 95;

SELECT * FROM unicen.inscripcion where unicodigo = 15991 and id_sede = 2 and id_gestion = 105;


SELECT m.nombre, nt.id_grupo, g.id_grupo  FROM unicen.nota nt 
JOIN unicen.plan_materia pm ON nt.id_materia = pm.id_materia and nt.id_plan_estudio = pm.id_plan_estudio and nt.id_sede = pm.id_sede
JOIN unicen.grupo g ON pm.id_materia = g.id_materia and pm.id_plan_estudio = g.id_plan_estudio and pm.id_sede = g.id_sede and g.id_gestion = nt.id_gestion
JOIN unicen.materia m ON m.id_materia = pm.id_materia and m.id_sede = pm.id_sede
WHERE nt.unicodigo = 12062 and nt.id_sede = 2 and nt.id_gestion = 105


select * from unicen.seiko_listarestudiantegrupo(86019 ,105,2);


select * from unicen.usuario where unicodigo = 4137;


SELECT * FROM unicen.estudiante where unicodigo = 34504;

SELECT * FROM unicen.gestion where nombre = 'V/2026';

SELECT * FROM unicen.inscripcion where unicodigo = 34465;


