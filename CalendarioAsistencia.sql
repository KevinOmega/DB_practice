SELECT pers.unicodigo, pers.nombres, pers.paterno, pers.materno,pers.id_profesion, pers.num_documento, pers.activo, u.activo FROM unicen.personal pers JOIN unicen.usuario u ON pers.unicodigo = u.unicodigo where u.id_rol = 33 and pers.activo = 'ACTIVO' and pers.id_sede = 1 ;


UPDATE unicen.usuario SET activo = 'ACTIVO' where unicodigo IN (
SELECT unicodigo FROM unicen.personal where id_sede = 1 and id_docente_categoria = 1 
) and id_rol = 33;

select * from unicen.usuario where unicodigo = 4102;

SELECT unicodigo, num_documento FROM unicen.personal where id_sede = 1 and id_docente_categoria = 1;


SELECT * FROM unicen.docente_categoria;


select * from unicen.docen

select * from unicen.rol;


select num_documento from unicen.personal where unicodigo = 3908;


select * from unicen.seiko_listarestudiantegrupoasistenciageneral(89369,105,1);


ALTER TABLE unicen.asistencia DROP COLUMN IF EXISTS fecha_registro;
ALTER TABLE unicen.asistencia ADD COLUMN fecha_registro timestamp without time zone;


select * from unicen.asistencia where fecha_registro is NULL;

UPDATE unicen.asistencia SET fecha_registro = null;


SELECT * FROM unicen.personal where paterno = 'MONTES' and materno = 'GARCIA';


SELECT unicodigo, num_documento FROM unicen.personal where nombres LIKE '%REYNALDO%' and paterno LIKE '%VILA%'; 

SELECT unicodigo, num_documento FROM unicen.personal where unicodigo = 3599;


SELECT * FROM unicen.personal  where  paterno LIKE '%DOCENTE%'; 


SELECT DISTINCT(fecha) FROM asistencia where id_grupo = 86299 ORDER BY fecha;

SELECT * FROM unicen.nota where id_grupo = 86019 and id_sede = 2 and id_gestion = 105;

SELECT * FROM unicen.inscripcion where unicodigo = 34018;