-- seleccionar a todos los estudiantes de n sede que no salen en listas

SELECT DISTINCT unicodigo FROM unicen.nota WHERE id_gestion = 105 and id_sede = 1 and nf = 0 and unicodigo NOT IN (
    SELECT unicodigo from unicen.inscripcion where id_gestion = 105 and id_sede = 1 and estinsceco = 'INSCRITO'
);

-- Correr funcion para inscribir a estudiantes que cumplen la condicion necesaria
SELECT * FROM unicen.fn_aux_inscribir_estudiante_reserva_por_unicodigo(
    (SELECT ARRAY(SELECT DISTINCT unicodigo FROM unicen.nota where id_gestion = 105 and id_sede = 1 and nf = 0 and unicodigo NOT IN (
    SELECT unicodigo from unicen.inscripcion where id_gestion = 105 and id_sede = 1 and estinsceco = 'INSCRITO'
))), 1, 105);


SELECT unicodigo,paterno,materno, nombres from unicen.estudiante where paterno = 'ARROYO' and materno LIKE 'GUZM%' and nombres LIKE 'MA%'

select * from unicen.usuario where unicodigo = 4137;

SELECT * FROM unicen.usuario where unicodigo = 4137;

select * from unicen.estudiante where unicodigo IN (
    select unicodigo from unicen.inscripcion where id_gestion = 105 and id_sede = 3 and id_carrera = 54
)



select * from unicen.inscripcion where id_gestion = 105 and id_sede = 3 and id_carrera = 54 AND estinsceco = 'INSCRITO';


SELECT DISTINCT unicodigo FROM unicen.nota where id_gestion = 105 and id_sede = 2 and nf = 0 and unicodigo NOT IN (
    SELECT unicodigo from unicen.inscripcion where id_gestion = 105 and id_sede = 2 and estinsceco = 'INSCRITO'
);

SELECT * FROM unicen.inscripcion where unicodigo = 16649;

select * from unicen.tema where id_sede = 3 and id_plan_estudio = 


select * from unicen.estudiante where unicodigo = 25614;



SELECT estinsceco FROM unicen.inscripcion where id_sede = 2 and estinsceco <> 'INSCRITO' and unicodigo IN (
    SELECT DISTINCT unicodigo FROM unicen.nota where id_gestion = 105 and id_sede = 2 and nf = 0
);

SELECT num_documento from unicen.estudiante where unicodigo = 35940;
SELECT * FROM unicen.inscripcion where unicodigo = 35940 and id_gestion = 105;

SELECT * FROM unicen.fn_aux_inscribir_estudiante_reserva_por_unicodigo(
    (SELECT ARRAY(SELECT DISTINCT unicodigo FROM unicen.nota where id_gestion = 105 and id_sede = 2 and nf = 0 and unicodigo NOT IN (
    SELECT unicodigo from unicen.inscripcion where id_gestion = 105 and id_sede = 2 and estinsceco = 'INSCRITO'
))), 2, 105);

SELECT * FROM unicen.fn_aux_inscribir_estudiante_reserva_por_unicodigo(ARRAY[11082], 1, 105);

select estinsceco from unicen.inscripcion where unicodigo = 36034 and id_gestion = 105;

SELECT DISTINCT unicodigo FROM unicen.nota where id_gestion = 105 and id_sede = 2 and nf = 0 and unicodigo NOT IN (
    SELECT unicodigo from unicen.inscripcion where id_gestion = 105 and id_sede = 2 and estinsceco = 'INSCRITO'
);

SELECT unicodigo, estinsceco FROM  inscripcion where id_gestion = 105 and unicodigo IN (
    16649,
16650,
12679,
17518
)

SELECT * FROM unicen.usuario where unicodigo = 4137;


SELECT num_documento FROM unicen.personal where unicodigo = 3599;


SELECT id_inscripcion, estinsceco FROM unicen.inscripcion where unicodigo = 36034;


SELECT * FROM unicen.estudiantes_inscrito_reserva(36034, 1, 105);


select * from unicen.certificado_valido;


SELECT * from unicen.nota where unicodigo = 19846 and id_gestion = 103 and paralelo ='HOM/CONV';

SELECT * FROM unicen.notahom where unicodigo = 19846;

SELECT paterno, materno, nombres FROM unicen.estudiante WHERE unicodigo = 19846;;

SELECT * FROM unicen.usuario where unicodigo = 4137;

BEGIN;

INSERT INTO unicen.nota 
(unicodigo, id_estudiante, id_plan_estudio, id_materia, id_sede, id_gestion, paralelo, pp, sp, tp, ef, ast, si, ma, gr, nf, estnota, est, id_turno, id_grupo) 
VALUES (19846, 10577, 133, 1779, 3, 103, 'A', 0, 0, 0, 0, 0, 0, 0, 0,91, 'APROBADO', 'ACTIVO', 1,0);

COMMIT;

SELECT id_materia from unicen.materia where nombre = 'COMPUTACION I' and id_sede = 3;

SELECT id_materia,id_nivel FROM unicen.plan_materia where id_plan_estudio = 133 and id_materia IN (157,1779);

SELECT * FROM unicen.estudiantecareco where unicodigo = 36011;


SELECT ma.nombre, ma.cod_materia, nt.paralelo, nt.id_turno
    FROM unicen.nota nt
    JOIN unicen.materia ma ON nt.id_materia = ma.id_materia and ma.id_sede = 1
WHERE nt.unicodigo = 36034 and id_gestion = 105;
