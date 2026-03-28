-- NOTA ID ROL 5 CBBA, 17 SCZ, 18 LPZ

-- QuERY PARA OBTENER LOS ESTUDIANTES QUE NO TIENEN USUARIOS 
 SELECT unicodigo, activo, num_documento, paterno, materno, nombres FROM unicen.estudiante WHERE unicodigo NOT IN (
    SELECT unicodigo FROM unicen.usuarioest WHERE id_sede = 1
) and unicodigo IN (
    SELECT unicodigo from unicen.estudiantecareco where activo = 'ACTIVO' AND id_sede = 1
) and activo = 'ACTIVO' and id_sede = 1;

-- INSERTAR LOS ESTUDIANTES QUE NO TIENEN USUARIOS EN LA TABLA DE USUARIOS
INSERT INTO usuarioest(unicodigo, id_rol, id_sede, activo )
SELECT unicodigo, 5, 1, 'ACTIVO' FROM unicen.estudiante WHERE id_sede = 1 AND unicodigo NOT IN (
    SELECT unicodigo FROM unicen.usuarioest WHERE id_sede = 1
) and unicodigo IN (
    SELECT unicodigo from unicen.estudiantecareco where activo = 'ACTIVO' AND id_sede = 1
) and activo = 'ACTIVO'  AND id_sede = 1;

-- Query para obtener los estudiantes que tienen mal definida su contraseña, es decir, que su contraseña no es el md5 de su numero de documento
SELECT unicodigo, num_documento, pass, paterno, materno, nombres FROM unicen.estudiante WHERE unicodigo IN (
    SELECT unicodigo FROM unicen.usuarioest WHERE id_sede = 1 and id_rol = 5
) and pass <> md5(num_documento) and id_sede = 1;

-- Actualizar la contraseña de los estudiantes que tienen mal definida su contraseña, es decir, que su contraseña no es el md5 de su numero de documento
UPDATE unicen.estudiante SET pass = md5(num_documento) WHERE unicodigo IN (
    SELECT unicodigo FROM unicen.usuarioest WHERE id_sede = 1 and id_rol = 5
) and pass <> md5(num_documento) and id_sede = 1;

SELECT setval(
  pg_get_serial_sequence('unicen.usuarioest', 'id_usuarioest'),
  COALESCE((SELECT MAX(id_usuarioest) FROM unicen.usuarioest), 0),
  TRUE
);
SELECT unicodigo, num_documento,nombres, paterno, materno from unicen.estudiante where materno = 'LORES';
SELECT * FROM  unicen.usuarioest where unicodigo = 35978;
select unicen.aut

SELECT * FROM unicen.rol where nombre = 'ESTUDIANTE';

