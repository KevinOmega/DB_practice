select * from unicen.rol where nombre = 'VRC';


select id_componente,estado from unicen.menu where id_rol = 29
EXCEPT
select id_componente,estado from  unicen.menu where id_rol = 31

select * from unicen.menu where id_rol = 29 ORDER BY id_componente;
select * from  unicen.menu where id_rol = 31 ORDER BY id_componente;


SELECT * FROM unicen.componente where id_componente = 109;