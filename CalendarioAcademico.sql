select * from unicen.gestion where id_gestion = 105;

select * from unicen.calendario_academico where id_evento_academico = 3 and id_gestion = 105;

select * from unicen.calendario_academico;

select * from unicen.evento_academico;


ALTER TABLE unicen.calendario_academico ADD COLUMN id_sede integer;

BEGIN;

INSERT INTO unicen.calendario_academico (id_evento_academico, id_gestion, fecha_inicio, fecha_fin, estado, id_sede) 
SELECT id_evento_academico, id_gestion, fecha_inicio, fecha_fin, estado, 3 FROM unicen.calendario_academico 
WHERE id_gestion = 105 AND id_evento_academico IN (3,4,5,6,7,12,13) and id_sede IS NULL;

ROLLBACK;



SELECT a.attname 
FROM pg_index i
JOIN pg_attribute a ON a.attrelid = i.indrelid AND a.attnum = ANY(i.indkey)
WHERE i.indrelname = 'calendario_academico_pkey';

'\d unicen.calendario_academico'

SELECT * FROM unicen.estudiante where paterno LIKE  'DE %' and id_sede = 3;

SELECT * FROM unicen.estudiante WHERE nombres LIKE '%MICHELLE ALEJANDRA%';


SELECT unicodigo,num_documento FROM unicen.personal where paterno = 'AGUILERA';



SELECT * FROM unicen.materia where cod_materia = 'CPA582' and id_sede = 1;


SELECT * FROM unicen.grupo where id_materia = 1417  and id_gestion = 105 and id_sede = 1;


SELECT unicodigo, nf, est  from unicen.nota where id_grupo = 89649;


SELECT unicodigo,estinsceco FROM unicen.inscripcion where unicodigo IN (
    SELECT unicodigo FROM unicen.nota where id_grupo = 89649 and id_gestion = 105
) and id_gestion = 105 and id_sede = 1;


SELECT  old_data from unicen.general_audit where table_name = 'inscripcion' and operation = 'UPDATE' 
and old_data->>'unicodigo' IN (
    SELECT unicodigo::text FROM unicen.nota where id_grupo = 89648 and id_gestion = 105
);

begin;

select * from  unicen.fn_aux_inscribir_estudiante_reserva_por_unicodigo(
    (SELECT ARRAY(SELECT unicodigo from nota where id_grupo = 89648 and id_gestion = 105)),1,105)


SELECT * FROM unicen.fn_aux_inscribir_estudiante_reserva_por_unicodigo(
    (SELECT ARRAY(
        SELECT DISTINCT unicodigo from unicen.nota where nf = 0 and id_gestion = 105 and id_sede = 2 and unicodigo NOT IN (
            SELECT unicodigo from unicen.inscripcion where id_gestion = 105 and id_sede = 2 and estinsceco = 'INSCRITO'
        )
    )), 2, 105
);

SELECT * FROM unicen.nota where unicodigo = 16650 and id_gestion = 105;

SELECT * FROM unicen.inscripcion where unicodigo = 16650 and id_gestion = 105;;


SELECT * FROM unicen.usuario where unicodigo = 4137;

SELECT unicen.fn_aux_inscribir_estudiante_reserva_por_unicodigo(ARRAY[27922,27317,28889],3,105);


SELECT unicodigo,estinsceco from unicen.inscripcion where unicodigo IN (
    select unicodigo from unicen.estudiante where paterno IN ('DENCELL', 'ALARU', 'CALLE', 'AGUIRRE', 'ILAQUITA', 'VILCA') and id_sede = 3 and materno IN ('LINO', 'ARGANI', 'CHOQUE', 'ARIAS', 'MAMANI', 'SARMIENTO') and nombres IN ('FROILAN', 'BRANDON LUIS', 'NELSON', 'KATHERINE GRACIELA', 'LEYDI YASEL', 'FABRIZIO JAIR')

)

select unicodigo,estinsceco from unicen.inscripcion where unicodigo IN(
 28889,
27925,
27082,
27091,
27922,
27317  
) and id_gestion = 105 and id_sede = 3;


select id_grupo from unicen.nota where unicodigo = 27925 and id_gestion = 105;


SELECT * FROM unicen.seiko_listarestudiantegrupo(87078,105,3) where unic = 27925;


28889
27925
27082
27091
27922
27317

SELECT * FROM unicen.usuario where unicodigo = 4137;
-- IDME LINO DENCELL FROILAN
-- ALARU ARGANI BRANDON LUIS
-- CALLE CHOQUE NELSON 
-- AGUIRRE ARIAS KATHERINE GRACIELA 
-- ILAQUITA MAMANI LEYDI YASEL
-- VILCA SARMIENTO FABRIZIO JAIR 

-- 27922 IDME LINO DENCELL FROILAN, NO TIENE REGISTRO DE PAGOS EN LA PRESENTE GESTION, PERO TIENE DEUDA 0
-- 27317 CALLE CHOQUE NELSON, TIENE REINTEGROS ACADEMICOS Y PERTENECE AL PLAN REGULAR
-- 28889 VILCA SARMIENTO FABRIZIO JAIR, TIENE REINTEGROS ACADEMICOS Y PERTENECE AL PLAN REGULAR

-- 


SELECT unicodigo from unicen.estudiantecareco where id_sede = 3 and estado = 'ACTIVO' and unicodigo NOT IN (
            SELECT unicodigo from unicen.inscripcion where id_gestion = 105 and id_sede = 3 and estinsceco = 'INSCRITO'
        );


SELECT DISTINCT unicodigo from unicen.nota where nf = 0 and id_gestion = 105 and id_sede = 3 and unicodigo NOT IN (
    SELECT unicodigo from unicen.inscripcion where id_gestion = 105 and id_sede = 3 and estinsceco = 'INSCRITO'
);

rollback;

select * from unicen.general_audit where changed_at = '2026-03-17' AND table_name ='inscripcion' ORDER BY changed_at DESC;