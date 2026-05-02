-- 1. EXPORT DATA

-- COPY table_name TO "location\filename" DELIMITER ',' CSV HEADER;

-- CONSOLE

-- \copy table_name TO 'C:\Users\user\Desktop\filename.csv' DELIMITER ',' CSV HEADER;


\copy (select 113, ma.id_materia, te.nombre, te.titulo, te.contenido, 1 as id_sede, 'ACTIVO' as estado
FROM unicen.tema te
JOIN unicen.plan_materia pm ON te.id_plan_materia = pm.id_plan_materia
JOIN unicen.materia ma ON ma.id_materia = pm.id_materia
JOIN unicen.plan_estudio pe ON pm.id_plan_estudio = pe.id_plan_estudio
JOIN unicen.carrera car ON pe.id_carrera = car.id_carrera
WHERE ma.nombre = 'MERCADO DE VALORES' and pm.id_plan_estudio = 114
ORDER BY te.id_tema) TO '/home/kevin/Downloads/mercado2.csv' DELIMITER ',' CSV HEADER;


-- 2. IMPORT DATA

-- \COPY table_name(field1,field2, ...) FROM 'C:\Users\user\Desktop\filename.csv' DELIMITER ',' CSV HEADER;



SELECT * FROM unicen.tema_unicen WHERE id_plan_estudio = 41;

\copy unicen.tema_unicen (id_plan_estudio, id_materia, nombre, titulo, contenido, id_sede, estado)
FROM '/home/kevin/Downloads/mercado.csv' DELIMITER ',' CSV HEADER;
