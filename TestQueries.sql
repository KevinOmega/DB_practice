EXPLAIN SELECT unicodigo, paterno, materno, nombres FROM unicen.estudiante WHERE unicodigo IN (
    SELECT unicodigo FROM unicen.inscripcion WHERE id_gestion = 105 AND id_sede = 3 AND id_carrera = 54 AND estinsceco = 'INSCRITO'
)


EXPLAIN SELECT est.unicodigo, est.paterno, est.materno, est.nombres FROM unicen.estudiante est
join inscripcion ins ON est.unicodigo = ins.unicodigo
WHERE ins.id_gestion = 105 AND ins.id_sede = 3 AND ins.id_carrera = 54 AND ins.estinsceco = 'INSCRITO'


SELECT relname, relkind, reltuples, relpages
FROM pg_class
WHERE relname LIKE '%homologacion%';


