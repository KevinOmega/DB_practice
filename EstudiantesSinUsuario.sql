 SELECT unicodigo, activo, num_documento FROM unicen.estudiante WHERE unicodigo NOT IN (
    SELECT unicodigo FROM unicen.usuarioest WHERE id_sede = 2
) and unicodigo IN (
    SELECT unicodigo from unicen.estudiantecareco where activo = 'ACTIVO' AND id_sede = 2
) and activo = 'ACTIVO' AND pass = md5(num_documento) and id_sede = 2;

BEGIN;

SELECT setval(
  pg_get_serial_sequence('unicen.usuarioest', 'id_usuarioest'),
  COALESCE((SELECT MAX(id_usuarioest) FROM unicen.usuarioest), 0),
  TRUE
);

UPDATE unicen.usuarioest SET id_rol = 5 where id_rol = 2;


SELECT * from unicen.rol where nombre = 'ESTUDIANTE';
-- 5 CBBA, 17 SCZ, 18 LPZ

-- CAMBIAR CONTRASEÑA A MD5 DEL NUMERO DE DOCUMENTO DE LOS ESTUDIANTES QUE VARIA SU USUARIO DE SU DOCUMENTO

SELECT * FROM unicen.estudiante where paterno = 'DORADO' and materno = 'SILVA';

SELECT num_documento, md5(num_documento), pass from unicen.estudiante where unicodigo IN (
    SELECT unicodigo FROM unicen.usuarioest WHERE id_sede = 2 and id_rol = 17
) and pass <> md5(num_documento) and id_sede = 2;

UPDATE unicen.estudiante SET pass = md5(num_documento) where unicodigo IN (
    SELECT unicodigo FROM unicen.usuarioest WHERE id_sede = 3 and id_rol = 18
) and pass <> md5(num_documento) and id_sede = 3;

BEGIN;

INSERT INTO usuarioest(unicodigo, id_rol, id_sede, activo )
SELECT unicodigo, 17, 2, 'ACTIVO' FROM unicen.estudiante WHERE id_sede = 2 AND unicodigo NOT IN (
    SELECT unicodigo FROM unicen.usuarioest WHERE id_sede = 2
) and unicodigo IN (
    SELECT unicodigo from unicen.estudiantecareco where activo = 'ACTIVO' AND id_sede = 2
) and activo = 'ACTIVO' AND pass = md5(num_documento) AND id_sede = 2;

COMMIT;

SELECT * FROM unicen.usuarioest where unicodigo = 16050;

ROLLBACK;

SELECT unicodigo, num_documento from unicen.estudiante where unicodigo = 19059;

UPDATE unicen.estudiante SET pass = md5(num_documento) where unicodigo = 19059;

select * from unicen.usuarioest where unicodigo = 19059;


select * from unicen.usuarioest where unicodigo IN (
    18492,
35948,
33761,
36005,
12712,
16644
)


SELECT id_sede,num_documento,nombres from unicen.estudiante where unicodigo = 23855;


SELECT * FROM unicen.usuarioest where id_sede = 1 and unicodigo IN (
    SELECT unicodigo FROM unicen.estudiante where id_sede <> 1
)

DELETE FROM unicen.usuarioest where id_sede = 1 and unicodigo IN (
    SELECT unicodigo FROM unicen.estudiante where id_sede <> 1
);

