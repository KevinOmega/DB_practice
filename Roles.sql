select * from unicen.rol where nombre = 'VRC';


select id_componente,estado from unicen.menu where id_rol = 29
EXCEPT
select id_componente,estado from  unicen.menu where id_rol = 31

select * from unicen.menu where id_rol = 29 ORDER BY id_componente;
select * from  unicen.menu where id_rol = 31 ORDER BY id_componente;


SELECT * FROM unicen.componente where id_componente = 109;


SELECT * FROM  unicen.usuario where unicodigo = 4137;

SELECT rol.id_rol, menu.id_menu, menu.id_componente, comp.path11 FROM unicen.rol rol
JOIN unicen.menu menu ON rol.id_rol = menu.id_rol and rol.id_sede = 3
JOIN unicen.componente comp ON menu.id_componente = comp.id_componente
where rol.nombre = 'COORDINADOR'

SELECT * FROM unicen.menu where id_rol = 26 and id_sede = 3;

BEGIN;

commit;
INSERT INTO unicen.menu(id_rol, id_componente, id_sede, estado)
VALUES (26, 55, 3, 'ACTIVO');



-- 140, 55
SELECT * from unicen.componente where path11 = '/personal' or path11= '/reprrhhlistadocentes';
SELECT * FROM unicen.componente where path11 LIKE '/rep%';
select *
from unicen.rol where id_rol = 68;

BEGIN;
update unicen.usuario SET id_sede = 2 where unicodigo = 4137;
commit ;
SELECT unicodigo, num_documento, paterno,materno , nombres from unicen.personal where nombres = 'LITCY ANDREA';

SELECT * FROM unicen.usuario where unicodigo = 4342;

SELECT * FROM unicen.rol where id_sede = 3;


SELECT * from unicen.rol where id_rol = 35;
SELECT * FROM unicen.estudiante where unicodigo = 4342;

SELECT * FROM unicen.usuario where unicodigo = 4137;


SELECT * FROM unicen.componente where path11 LIKE '%bac%';

SELECT * FROM  unicen.componente where path11 LIKE '%contrato%';


SELECT * FROM unicen.menu;


SELECT * FROM unicen.usuario where  unicodigo = 4137;
