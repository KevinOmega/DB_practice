select * from carrera where nombre LIKE '%FINANCIERA%'

SELECT * FROM unicen.plan_estudio WHERE id_carrera = 19 and id_sede = 1;


select * from unicen.estudiantecareco where id_carrera = 11;

SHOW log_statement;

SELECT event_object_table, trigger_name
FROM information_schema.triggers
WHERE trigger_schema = 'public';

select * from unicen.plan_estudio where id_carrera = 19 AND id_sede = 1;

update unicen.plan_estudio set id_carrera = 81 where id_plan_estudio = 39 and id_carrera = 19 AND id_sede = 1;


select * from unicen.tipo_plan_estudio where id_sede = 1;
select * from unicen.plan_materia where id_plan_estudio = 39 AND id_sede = 1;




select * from unicen.estudiantecareco where id_plan_estudio = 7;

select * from materia join unicen.plan_materia pm on materia.id_materia = pm.id_materia
where pm.id_plan_estudio = 123 and materia.id_sede = 1 order by materia.nombre;

SELECT * FROM unicen.carrera WHERE nombre LIKE '%COMERCIAL%' AND id_sede = 1;


select * from unicen.carrera where id_carrera = 12 AND id_sede = 1;


select * from unicen.plan_estudio where id_carrera = 12 AND id_sede = 1;


UPDATE unicen.plan_estudio SET id_carrera = 80 where id_carrera = 12 AND id_sede = 1 and id_tipo_plan_estudio  = 5;