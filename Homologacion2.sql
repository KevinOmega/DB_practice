select * from unicen.estudiantecareco where unicodigo = 19667;


SELECT * FROM unicen.carrera where id_sede = 3;


select * from unicen.carrera where nombre like '%DERECHO Y CIENCIAS%'


SELECT * FROM unicen.plan_estudio where id_carrera = 79 and id_sede = 1;

select * from unicen.nota where unicodigo = 


SELECT * FROM unicen.plan_estudio where id_carrera = 74 and id_sede = 3;

select * from unicen.nota where id_plan_estudio in (
    select id_plan_estudio from unicen.plan_estudio where id_carrera in (
        select id_carrera from unicen.carrera where id_sede = 3 and id_carrera = 10
    )
) and id_estudiante = 9836;

select * from unicen.materia where cod_materia = 'DCJ462' and id_sede = 3;

select * from unicen.nota where id_estudiante = 9836;

select * from unicen.plan_estudio where id_plan_estudio = 10;

select * from unicen.carrera where id_carrera = 10 and id_sede = 3;

select * from unicen.materia where id_materia IN (
    SELECT id_materia from unicen.plan_materia where id_plan_estudio = 10 and id_sede = 3
) and id_sede = 3;


SELECT ma.cod_materia, ma.nombre, pm.id_nivel FROM unicen.materia ma 
join (select * from unicen.plan_materia where id_plan_estudio = 10 and id_sede = 3) pm 
on ma.id_materia = pm.id_materia where ma.id_sede = 3 ORDER BY pm.id_nivel;

select m.cod_materia, m.nombre, nt.nf, g.nombre as gestion, nt.obs from unicen.plan_materia pm JOIN (select * from unicen.nota where id_estudiante = 9836 and id_plan_estudio = 10 and nf >= 51) nt ON pm.id_materia = nt.id_materia and pm.id_plan_estudio = nt.id_plan_estudio and pm.id_sede = nt.id_sede JOIN unicen.materia m ON pm.id_materia = m.id_materia JOIN unicen.gestion g ON nt.id_gestion = g.id_gestion WHERE pm.id_plan_estudio = 10 AND pm.id_sede = 3 ORDER BY nt.id_gestion, m.nombre;


select m.cod_materia, m.nombre, nt.nf, g.nombre as gestion, nt.obs from 
(select * from unicen.notahom where id_estudiante = 9836 and id_plan_estudio = 10 and nf >= 51) nt 
JOIN unicen.materia m ON nt.id_materia = m.id_materia and nt.id_sede = m.id_sede 
JOIN unicen.gestion g ON nt.id_gestion = g.id_gestion 
ORDER BY nt.id_gestion, m.nombre;

select * from unicen.notahom where id_estudiante = 9836;

SELECT * FROM unicen.estudiantecareco where id_estudiante = 9836;
-- 133 , 74


--OLD ONE 10


-- DANTE SAUL

SELECT * FROM unicen.nota where id_estudiante = 9836;

SELECT * FROM unicen.notahom where id_estudiante = 9836;

SELECT * from unicen.plan_estudio where id_carrera = 74 and id_sede = 3;

select  unicen.cancelarprocesodehomologacionestudiante(19667,74,10,133,3);

UPDATE unicen.nota 
SET id_plan_estudio = 179
WHERE unicodigo = 19667 AND id_sede = 3 AND id_plan_estudio = 10;

SELECT * FROM unicen.estudiantecareco where id_estudiante = 9836;
update unicen.estudiantecareco set id_plan_estudio = 10, id_carrera = 10 where id_estudiante = 9836 and id_sede = 3;

update unicen.estudiantecareco set id_plan_estudio = 179 where id_estudiante = 9836 and id_sede = 3;


select * from  unicen.nota where id_estudiante = 8120;

select * from unicen.nota where unicodigo = 34501;


select * from unicen.nota where unicodigo = 19492;


select * from unicen.estudiante where id_estudiante = 11121;


