SELECT count(userna) FROM unicen.listarestudiantesmoodle(3,105);

SELECT userna, count(userna) as count FROM unicen.listarestudiantesmoodle(3,105) GROUP BY userna HAVING count(userna) > 1 ORDER BY count DESC;

SELECT count(uni) FROM (
	SELECT DISTINCT uni FROM unicen.listarantiguosxgestionsinobs(105, 3) 
	UNION ALL
	SELECT DISTINCT uni FROM unicen.listarnuevosxgestionsinobs(105, 3) 
) counts;

SELECT uni from unicen.listarantiguosxgestionsinobs(105, 3) where uni=28551;


select DISTINCT uni from unicen.listarantiguosxgestionsinobs(105, 3)
INTERSECT
SELECT DISTINCT uni from unicen.listarnuevosxgestionsinobs(105, 3);



SELECT * FROM unicen.nota where unicodigo = 28423;
select * from unicen.listarnuevosxgestion(105, 3) where uni = 20786;

SELECT uni, count(uni) as count FROM unicen.listarantiguosxgestion(105, 3) GROUP BY uni HAVING count(uni) > 1 ORDER BY count DESC;

SELECT uni, count(uni) as count FROM unicen.listarnuevosxgestion(105, 3) GROUP BY uni HAVING count(uni) > 1 ORDER BY count DESC ;

SELECT DISTINCT uni from unicen.listarantiguosxgestion(105, 3)
UNION all
SELECT DISTINCT uni from unicen.listarnuevosxgestion(105, 3)
EXCEPT
SELECT DISTINCT userna from unicen.listarestudiantesmoodle(3,105);


SELECT DISTINCT userna from unicen.listarestudiantesmoodle(3,105)
EXCEPT
(SELECT DISTINCT uni from unicen.listarantiguosxgestion(105, 3)
UNION all
SELECT DISTINCT uni from unicen.listarnuevosxgestion(105, 3));

(SELECT DISTINCT uni from unicen.listarantiguosxgestionsinobs(105, 3)
UNION all
SELECT DISTINCT uni from unicen.listarnuevosxgestionsinobs(105, 3))
EXCEPT
SELECT DISTINCT userna from unicen.listarestudiantesmoodle(3,105);


SELECT estudiantes_inscrito_reserva(23675,3,105);

select * from unicen.inscripcion where unicodigo = 20786 and id_gestion = 105;


SELECT id_materia from unicen.nota where unicodigo = 20786 and id_gestion = 105 and id_sede = 3 ;


SELECT * FROM inscripcion where unicodigo = 20786;

SELECT * FROM unicen.estudiantecareco where unicodigo = 20786;

SELECT * FROM plan_economico where id_plan_economico = 336;


SELECT nacionalidad FROM unicen.estudiante where unicodigo = 20786 and id_sede = 3;


SELECT * FROM unicen.nota where unicodigo = 28551;

SELECT * FROM unicen.baja_academica where unicodigo = 28551;

SELECT * FROM unicen.nota where unicodigo = 28423 ;

SELECT * from unicen.inscripcion where unicodigo = 35983 and id_gestion = 105 and id_sede = 3;


SELECT * FROM unicen.plan_estudio where id_plan_estudio IN (130,17) and id_sede = 3;


SELECT * FROM unicen.estudiante where unicodigo = 35983 and id_sede = 3;

SELECT * FROM unicen.estudiantecareco where unicodigo = 35983;

SELECT * FROM unicen.estudiante where unicodigo = 28423;

SELECT * FROM unicen.estudiantecareco where unicodigo = 28423;

SELECT * from unicen.nota where unicodigo = 34352;

SELECT * FROM unicen.inscripcion where unicodigo IN (
	34352,
35904,
34318,
35881,
34264,
28551
)
and id_gestion = 105 and id_sede = 3 ORDER BY unicodigo;