select * from unicen.ciudad WHERE id_pais = 20;

SELECT * FROM unicen.ciudad WHERE id_ciudad > 33;

DELETE FROM unicen.ciudad WHERE id_ciudad = 100;


SELECT * FROM unicen.provincia;

CREATE OR REPLACE FUNCTION unicen.addCiudad(nombre_ciudad CHARACTER VARYING, id_pais INTEGER, alpha3 CHARACTER VARYING)
 RETURNS void
AS $$
BEGIN
   insert into unicen.ciudad(nombre, id_pais, alpha3, estado) values (nombre_ciudad, id_pais, alpha3, 'ACTIVO');
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION unicen.addDistrito(distrito CHARACTER VARYING, id_ciudad INTEGER, id_sede INTEGER)
 RETURNS void
AS $$
BEGIN
   insert into unicen.distrito(distrito, id_ciudad, id_sede, estado) values (distrito, id_ciudad, id_sede, 'ACTIVO');
END;
$$ LANGUAGE plpgsql;

select * from unicen.distrito;

SELECT pg_get_serial_sequence('unicen.distrito', 'id_distrito');

SELECT setval('unicen.distrito_id_distrito_seq',
              (SELECT COALESCE(MAX(id_distrito), 0) + 1 FROM unicen.distrito),
              false);

select unicen.addDistrito('Congo', 40,1);

SELECT unicen.addCiudad('La Plata', 100, 'ARG');

SELECT * FROM unicen.colegio;

SELECT * FROM unicen.distrito LIMIT 50;

select * from materia where nombre LIKE '%CALCULO I%'

select * from  unicen.estudiantecareco WHERE unicodigo = 9475;

select * from unicen.nota where unicodigo = 9475 and si = 51;

select * from unicen.nota where unicodigo = 9475 and id_materia = 1584 and id_sede = 1;

select * from unicen.materia where id_materia = 1584;

select * from unicen.estudiantecareco WHERE unicodigo = 9475;

select * from unicen.materia where cod_materia = 'ICO512' and id_sede = 1;

select nt.id_nota,mat.nombre, nt.paralelo, nt.id_gestion, nt.nf, nt.id_materia from  unicen.nota nt  JOIN materia mat ON nt.id_materia = mat.id_materia and nt.id_sede = mat.id_sede WHERE nt.unicodigo = 9475;

select nt.id_nota,mat.nombre, nt.paralelo, id_gestion ,nt.nf, nt.id_materia from  unicen.nota nt  JOIN materia mat ON nt.id_materia = mat.id_materia and nt.id_sede = mat.id_sede WHERE nt.unicodigo = 9475 and nt.id_materia = 1584 and nt.id_sede = 1;


select * from unicen.nota where unicodigo = 9475 and id_materia = 1584 and id_sede = 1;

select * from unicen.nota where id_materia = 1331 and unicodigo = 9475 and id_sede = 1;


select * from unicen.nota where id_materia = 1357 and id_gestion = 91;


INSERT INTO unicen.nota (unicodigo, id_estudiante,id_plan_estudio,id_materia, id_sede, id_gestion, paralelo, pp,sp,tp,ef,ast,si,ma,gr,nf,estnota,est,id_turno,nfr) VALUES (9475,21595, 113, 1347, 1, 91, 3, 0 , 20, 0, 24, 0, 51,0,0, 44, 'APROBADO', 'ACTIVO',1,51  );

UPDATE unicen.nota SET nf = 51, estnota = 'APROBADO' WHERE unicodigo = 9475 AND id_materia = 1347 AND id_sede = 1;


WITH plan_materia_nivel_1 AS (
    SELECT id_materia, id_plan_estudio
    FROM unicen.plan_materia
WHERE id_plan_estudio IN (
    SELECT id_plan_estudio FROM unicen.plan_estudio where id_sede = 3 and activo = 'ACTIVO'
) and id_nivel = 1
)
SELECT DISTINCT e.*
FROM unicen.estudiante e
WHERE unicodigo IN (
    SELECT unicodigo from unicen.nota n 
    join plan_materia_nivel_1 p on n.id_materia = p.id_materia and n.id_plan_estudio = p.id_plan_estudio
    where n.id_gestion = 105 and n.id_sede = 3 AND n.nf = 0
) GROUP BY unicodigo ORDER BY paterno, materno, nombres;


SELECT * FROM unicen.rol where id_sede = 3;

(SELECT id_componente FROM unicen.menu where id_rol = 3 and estado = 'ACTIVO' ORDER BY id_componente)
EXCEPT
(SELECT id_componente FROM unicen.menu where id_rol = 25 ORDER BY id_componente);


SELECT id_componente FROM unicen.menu where id_rol = 3 and estado = 'ACTIVO' ORDER BY id_componente;

SELECT id_componente FROM unicen.menu where id_rol = 25 and estado = 'ACTIVO' ORDER BY id_componente; 


SELECT id_componente FROM unicen.menu where id_rol = 4 and estado = 'ACTIVO' ORDER BY id_componente;
SELECT id_componente FROM unicen.menu where id_rol = 26 and estado = 'ACTIVO' ORDER BY id_componente; 


(SELECT id_componente FROM unicen.menu where id_rol = 4 and estado = 'ACTIVO' ORDER BY id_componente)
EXCEPT
(SELECT id_componente FROM unicen.menu where id_rol = 26 ORDER BY id_componente);

select * from unicen.componente where id_componente IN (
(SELECT id_componente FROM unicen.menu where id_rol = 29 and estado = 'ACTIVO' ORDER BY id_componente)
EXCEPT
(SELECT id_componente FROM unicen.menu where id_rol = 31 ORDER BY id_componente)
);

SELECT * FROM unicen.menu where id_rol = 29 ORDER BY id_componente


SELECT * FROM unicen.usuario where id_rol = (
   SELECT id_rol FROM unicen.rol where id_sede = 1 and id_rol = 29
); 


SELECT * from unicen.usuario where id_rol = (
   SELECT id_rol FROM unicen.rol where id_sede = 1 and id_rol = 26
);

select * from unicen.personal;


select * from unicen.usuario where unicodigo = 3682;


select * from unicen.personal where unicodigo = 3682;

select * from unicen.listarnuevosxgestion(105,3) where carr = 'MEDICINA';


select * from unicen.componente where path11 = '/repinscripcion';

select * from unicen.usuario where unicodigo = 4137;