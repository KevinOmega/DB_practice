SELECT est.paterno, est.materno, est.nombres, ma.nombre as materia, nt.id_grupo, nt.paralelo, tur.nombre AS turno FROM unicen.nota nt
JOIN unicen.estudiante est ON nt.unicodigo = est.unicodigo
JOIN unicen.materia ma on nt.id_materia = ma.id_materia and ma.id_sede = 1
JOIN unicen.gestion ges ON nt.id_gestion = ges.id_gestion
JOIN unicen.turno tur ON nt.id_turno = tur.id_turno
WHERE nt.unicodigo = 34868 and nt.id_sede = 1;