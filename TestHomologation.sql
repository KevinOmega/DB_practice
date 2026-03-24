UPDATE unicen.hom_estudiante
 SET estado = 'PREHOMOLOGADO',
     fecha_homologacion = null,
     resolucion = null,
     observacion = '',
     ith = null
 WHERE unicodigo = 34504;

 UPDATE unicen.nota set paralelo = 'PREHOMOLOGADO', obs = '' WHERE unicodigo = 34504 AND id_plan_estudio = 112 AND id_sede = 1 ;

 

 SELECT * FROM unicen.estudiante_tipo;