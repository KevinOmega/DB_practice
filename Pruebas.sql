SELECT car.nombre as carrera,ma.nombre as materia, ges.nombre as gestion, gr.id_grupo, gr.paralelo, tur.nombre as turno FROM unicen.materia ma
JOIN unicen.grupo gr ON  ma.id_materia = gr.id_materia and gr.id_gestion = 105 and gr.id_sede = 1
JOIN unicen.gestion ges ON gr.id_gestion = ges.id_gestion
JOIN unicen.turno tur ON  gr.id_turno = tur.id_turno
JOIN unicen.plan_estudio pe ON gr.id_plan_estudio = pe.id_plan_estudio and pe.id_plan_estudio = 113 and pe.id_sede = 1
JOIN unicen.carrera car ON pe.id_carrera = car.id_carrera AND car.id_sede = 1
WHERE gr.id_materia = 1582 and ma.id_sede = 1;



SELECT est.paterno, est.materno, est.nombres, ma.nombre as materia, nt.id_grupo, nt.paralelo, tur.nombre AS turno FROM unicen.nota nt
JOIN unicen.estudiante est ON nt.unicodigo = est.unicodigo
JOIN unicen.materia ma on nt.id_materia = ma.id_materia and ma.id_sede = 1
JOIN unicen.gestion ges ON nt.id_gestion = ges.id_gestion
JOIN unicen.turno tur ON nt.id_turno = tur.id_turno
WHERE nt.unicodigo = 34868 and nt.id_sede = 1;

SELECT * FROM unicen.usuario where unicodigo = 4137;

select unicen.estudiantes_inscrito_reserva(9230,1,105);