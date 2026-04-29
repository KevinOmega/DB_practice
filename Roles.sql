select * from unicen.rol where nombre = 'VRC';


select id_componente,estado from unicen.menu where id_rol = 29
EXCEPT
select id_componente,estado from  unicen.menu where id_rol = 31

select * from unicen.menu where id_rol = 29 ORDER BY id_componente;
select * from  unicen.menu where id_rol = 31 ORDER BY id_componente;


SELECT * FROM unicen.componente where id_componente = 109;

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