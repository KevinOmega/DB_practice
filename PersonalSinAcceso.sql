select * from unicen.rol where nombre = 'DOCENTE';

SELECT unicodigo from unicen.personal where id_sede = 2 and activo = 'ACTIVO' and unicodigo NOT IN (
    SELECT unicodigo from unicen.usuario where id_sede = 2 and id_rol = 34
)

SELECT * FROM unicen.usuario where unicodigo = 4261;

SELECT id_personal from unicen.personal where unicodigo = 4261;
SELECT setval(

pg_get_serial_sequence('unicen.usuario', 'id_usuario'),
  COALESCE((SELECT MAX(id_usuario) FROM unicen.usuario), 0),
  TRUE
);

INSERT INTO unicen.usuario(id_personal, unicodigo,id_rol, id_sede, activo) VALUES (201603526 ,4261, 34, 2, 'ACTIVO');