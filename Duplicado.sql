select * from unicen.estudiantecareco where unicodigo = 35054;



select * from unicen.estudiante where unicodigo = 35054;

select * from unicen.estudiante where paterno like '%MOYA%' and materno like 'LOPEZ';


select * from unicen.personal where id_personal = 1;

UPDATE unicen.estudiante SET activo = 'INACTIVO' WHERE unicodigo = 35054;

SELECT unicodigo, COUNT(*) as cantidad
FROM unicen.estudiante
GROUP BY unicodigo
HAVING COUNT(*) > 1
ORDER BY cantidad DESC;

SELECT nombres, paterno, materno, COUNT(*) as cantidad
FROM unicen.estudiante
GROUP BY nombres, paterno, materno
HAVING COUNT(*) > 1
ORDER BY cantidad DESC;

