SELECT * FROM unicen.carrera where nombre like '%INGENIERIA COMERCIAL%' and id_sede = 3;


select * from unicen.plan_estudio where id_carrera = 13 and id_sede = 3;
select * from unicen.tipo_plan_estudio;

SELECT * FROM unicen.plan_estudio pe JOIN unicen.tipo_plan_estudio tpe ON pe.id_tipo_plan_estudio = tpe.id_tipo_plan_estudio AND pe.id_sede = tpe.id_sede WHERE pe.id_carrera = 13 and pe.id_sede = 3 ;



select * from unicen.plan_materia where id_plan_estudio = 17 AND id_sede = 3;



select * from unicen.estudiante where unicodigo = 33765;

select max(unicodigo) from unicen.estudiante;

SELECT pg_get_serial_sequence('unicen.estudiante', 'unicodigo');

SELECT setval('unicen.estudiante_unicodigo_seq',
              (SELECT COALESCE(MAX(unicodigo), 0) + 1 FROM unicen.estudiante),
              false);


select * from unicen.estudiante where unicodigo = 35543;

select * from unicen.estudiantecareco where unicodigo = 35543;

INSERT INTO unicen.estudiantecareco (unicodigo, id_carrera, id_sede, id_plan_estudio, estado) VALUES (35543, 13, 3, 17, 'ACTIVO');

select * from unicen.ciudad;

-- Reiniciar el incremento automático de la primary key


select * from unicen.plan_economico where id_sede = 3 and activoinsnue = 'ACTIVO';

No Cr. Cod. Materia 1º 2º 3º EF AS M G Nota 2Ins Estado Observación
1 4 ICO411 ALGEBRA 19 12 22 53 Aprobada
2 4 ICO412 CALCULO I 18 18 15 51 Aprobada
3 3 DAC411 COMPUTACION I 34 16 20 70 Aprobada
4 3 DAC412 DERECHO COMERCIAL 32 31 20 83 Aprobada
5 4 CPA412 ECONOMIA GENERAL Y POLITICA 30 30 16 76 Aprobada
6 3 DAC413 INGLES I 31 29 30 90 Aprobada
7 4 ICO413 MARKETING I 27 35 30 92 Aprobada
Promedio Ponderado Semestral: 74 Nota Aprobación: 51
1/2012
No Cr. Cod. Materia 1º 2º 3º EF AS M G Nota 2Ins Estado Observación
8 4 ICO425 ADMINISTRACION I 29 24 19 72 Aprobada
9 4 ICO421 CALCULO II 21 24 15 60 Aprobada
10 3 DAC421 COMPUTACION II 8 2 20 30 Reprobada
11 4 CPA422 ECONOMIA DE EMPRESAS 24 16 14 54 Aprobada
12 4 ICO422 ESTADISTICA I 9 5 26 40 30 Reprobada
13 3 DAC422 INGLES II 0 0 0 86 Aprobada
14 4 ICO423 MARKETING II 13 22 25 60 Aprobada
Promedio Ponderado Semestral: 66 Nota Aprobación: 51
2/2012
2/2012
No Cr. Cod. Materia 1º 2º 3º EF AS M G Nota 2Ins Estado Observación
15 4 ICO431 ADMINISTRACION II 30 21 25 76 Aprobada
16 3 DAC421 COMPUTACION II 8 1 10 19 Reprobada
17 4 CPA411 CONTABILIDAD COMERCIAL 15 16 11 42 51 Aprobada
18 4 ICO422 ESTADISTICA I 13 4 30 47 51 Aprobada
19 3 DAC431 INGLES III 21 21 23 65 Aprobada
20 4 ICO434 MACROECONOMIA 22 26 4 52 Aprobada
21 4 PPM423 PUBLICIDAD I 26 24 13 63 Aprobada
Promedio Ponderado Semestral: 60 Nota Aprobación: 51
1/2013
No Cr. Cod. Materia 1º 2º 3º EF AS M G Nota 2Ins Estado Observación
22 3 DAC421 COMPUTACION II 18 25 27 70 Aprobada
23 4 CPA421 CONTABILIDAD INDUSTRIAL 22 25 22 69 Aprobada
24 4 ICO432 ESTADISTICA II 4 12 0 16 Reprobada
25 3 DAC441 INGLES IV 19 19 26 64 Aprobada
26 4 ICO433 INVESTIGACION DE MERCADOS I 19 19 22 60 Aprobada
27 3 DCJ446 ORATORIA Y LIDERAZGO 30 29 16 75 Aprobada
28 3 ICO444 SISTEMAS ADMINISTRATIVOS 23 17 40 51 Aprobada
Promedio Ponderado Semestral: 65 Nota Aprobación: 51
2/2013
No Cr. Cod. Materia 1º 2º 3º EF AS M G Nota 2Ins Estado Observación
29 3 ICO441 COMPORTAMIENTO DEL CONSUMIDOR I 13 20 18 51 Aprobada
30 4 ICO432 ESTADISTICA II 14 18 30 62 Aprobada
31 4 ICO442 ESTRATEGIAS PROMOCIONALES 21 30 29 80 Aprobada
32 4 ICO443 INVESTIGACION DE MERCADOS II 12 18 21 51 Aprobada
33 4 ICO452 INVESTIGACION DE OPERACIONES I 20 15 16 51 Aprobada
34 3 ICO454 SISTEMAS DE INFORMACION 12 23 5 40 51 Aprobada
Promedio Ponderado Semestral: 58 Nota Aprobación: 51
1/2014
No Cr. Cod. Materia 1º 2º 3º EF AS M G Nota 2Ins Estado Observación
35 3 ICO461 CANALES DE DISTRIBUCION 33 32 5 70 Aprobada
36 3 ICO451 COMPORTAMIENTO DEL CONSUMIDOR II 20 15 30 65 Aprobada
37 3 CPA443 COSTOS PARA DECISIONES 24 17 13 54 Aprobada
38 3 PPM462 GESTION DE VENTAS 23 24 24 71 Aprobada
39 4 CPA423 MATEMATICA FINANCIERA 20 11 15 46 40 Reprobada
40 3 ICO453 MERCHANDISING 24 28 18 70 Aprobada
Promedio Ponderado Semestral: 66 Nota Aprobación: 51
Pagina 2/2
24-02-2026
KARDEX
Nombre: MICHELLE ALEJANDRA VERA RUBIN DE CELIS
Carrera: INGENIERIA COMERCIAL
Matrícula: 3140V364
2/2014
No Cr. Cod. Materia 1º 2º 3º EF AS M G Nota 2Ins Estado Observación
41 4 DCJ443 DERECHO DEL TRABAJO Y SEGURIDAD SOCIAL 35 26 30 91 Aprobada
42 4 ICO462 DESARROLLO DE PRODUCTOS Y MARCAS 26 25 0 51 Aprobada
43 4 CPA423 MATEMATICA FINANCIERA 7 5 5 17 Reprobada
44 3 CPA444 PRESUPUESTOS 23 17 20 60 Aprobada
45 3 ICO464 SEMINARIO DE ACTUALIZACION I 26 27 27 80 Aprobada
Promedio Ponderado Semestral: 71 Nota Aprobación: 51
1/2015
No Cr. Cod. Materia 1º 2º 3º EF AS M G Nota 2Ins Estado Observación
46 4 CPA 451 ADMINISTRACION DE RECURSOS HUMANOS 17 8 25 Reprobada
47 4 ICO471 COMERCIO INTERNACIONAL I 18 10 0 28 Reprobada
48 4 ICO463 INVESTIGACION DE OPERACIONES II 24 19 43 Reprobada
49 4 CPA423 MATEMATICA FINANCIERA 0 0 0 0 Reprobada
50 3 ICO473 POLITICA DE PRECIOS 20 22 0 42 Reprobada
51 3 ICO475 SEMINARIO DE ACTUALIZACION II 20 20 20 60 Aprobada
Promedio Ponderado Semestral: 60 Nota Aprobación: 51
2/2016
No Cr. Cod. Materia 1º 2º 3º EF AS M G Nota 2Ins Estado Observación
52 4 CPA 451 ADMINISTRACION DE RECURSOS HUMANOS 21 20 18 59 Aprobada
53 4 ICO471 COMERCIO INTERNACIONAL I 20 12 12 44 51 Aprobada
54 4 CPA423 MATEMATICA FINANCIERA 10 2 0 12 Reprobada
55 3 ICO473 POLITICA DE PRECIOS 17 29 10 56 Aprobada
Promedio Ponderado Semestral: 55 Nota Aprobación: 51
1/2019
No Cr. Cod. Materia 1º 2º 3º EF AS M G Nota 2Ins Estado Observación
56 4 ICO481 COMERCIO INTERNACIONAL II 32 27 11 70 Aprobada
57 4 ICO485 NEGOCIACIONES 22 20 23 65 Aprobada
58 3 ICO486 SEMINARIO DE ACTUALIZACION III 30 30 23 83 Aprobada
Promedio Ponderado Semestral: 73 Nota Aprobación: 51
2/2019
No Cr. Cod. Materia 1º 2º 3º EF AS M G Nota 2Ins Estado Observación
59 4 ICO463 INVESTIGACION DE OPERACIONES II 25 21 7 53 Aprobada
60 4 ICO484 MARKETING INTERNACIONAL 20 18 20 58 Aprobada
61 4 CPA423 MATEMATICA FINANCIERA 25 32 0 57 Aprobada
Promedio Ponderado Semestral: 56 Nota Aprobación: 51


SELECT unicen.insertarnotasprehomologadasdar(35543, 17, id_materia, id_gestion, nota, 3, 1)



begin;

ROLLBACK;
-- Notas del año 2013
SELECT unicen.insertarnotasprehomologadasdar(35543, 17, (SELECT id_materia FROM unicen.materia WHERE cod_materia = 'DAC421' and id_sede = 3), (SELECT id_gestion FROM unicen.gestion WHERE nombre='1/2013'), 70, 3, 1);
SELECT unicen.insertarnotasprehomologadasdar(35543, 17, (SELECT id_materia FROM unicen.materia WHERE cod_materia = 'CPA421' and id_sede = 3), (SELECT id_gestion FROM unicen.gestion WHERE nombre='1/2013'), 69, 3, 1);
SELECT unicen.insertarnotasprehomologadasdar(35543, 17, (SELECT id_materia FROM unicen.materia WHERE cod_materia = 'ICO432' and id_sede = 3), (SELECT id_gestion FROM unicen.gestion WHERE nombre='1/2013'), 16, 3, 1);
SELECT unicen.insertarnotasprehomologadasdar(35543, 17, (SELECT id_materia FROM unicen.materia WHERE cod_materia = 'DAC441' and id_sede = 3), (SELECT id_gestion FROM unicen.gestion WHERE nombre='1/2013'), 64, 3, 1);
SELECT unicen.insertarnotasprehomologadasdar(35543, 17, (SELECT id_materia FROM unicen.materia WHERE cod_materia = 'ICO433' and id_sede = 3), (SELECT id_gestion FROM unicen.gestion WHERE nombre='1/2013'), 60, 3, 1);
SELECT unicen.insertarnotasprehomologadasdar(35543, 17, (SELECT id_materia FROM unicen.materia WHERE cod_materia = 'DCJ446' and id_sede = 3), (SELECT id_gestion FROM unicen.gestion WHERE nombre='1/2013'), 75, 3, 1);
SELECT unicen.insertarnotasprehomologadasdar(35543, 17, (SELECT id_materia FROM unicen.materia WHERE cod_materia = 'ICO444' and id_sede = 3), (SELECT id_gestion FROM unicen.gestion WHERE nombre='1/2013'), 51, 3, 1);

-- Notas del año 2014
SELECT unicen.insertarnotasprehomologadasdar(35543, 17, (SELECT id_materia FROM unicen.materia WHERE cod_materia = 'ICO461' and id_sede = 3), (SELECT id_gestion FROM unicen.gestion WHERE nombre='1/2014'), 70, 3, 1);
SELECT unicen.insertarnotasprehomologadasdar(35543, 17, (SELECT id_materia FROM unicen.materia WHERE cod_materia = 'ICO451' and id_sede = 3), (SELECT id_gestion FROM unicen.gestion WHERE nombre='1/2014'), 65, 3, 1);
SELECT unicen.insertarnotasprehomologadasdar(35543, 17, (SELECT id_materia FROM unicen.materia WHERE cod_materia = 'CPA443' and id_sede = 3), (SELECT id_gestion FROM unicen.gestion WHERE nombre='1/2014'), 54, 3, 1);
SELECT unicen.insertarnotasprehomologadasdar(35543, 17, (SELECT id_materia FROM unicen.materia WHERE cod_materia = 'PPM462' and id_sede = 3), (SELECT id_gestion FROM unicen.gestion WHERE nombre='1/2014'), 71, 3, 1);
SELECT unicen.insertarnotasprehomologadasdar(35543, 17, (SELECT id_materia FROM unicen.materia WHERE cod_materia = 'CPA423' and id_sede = 3), (SELECT id_gestion FROM unicen.gestion WHERE nombre='1/2014'), 46, 3, 1);
SELECT unicen.insertarnotasprehomologadasdar(35543, 17, (SELECT id_materia FROM unicen.materia WHERE cod_materia = 'ICO453' and id_sede = 3), (SELECT id_gestion FROM unicen.gestion WHERE nombre='1/2014'), 70, 3, 1);
-- Notas del año 2012
SELECT unicen.insertarnotasprehomologadasdar(35543, 17, (SELECT id_materia FROM unicen.materia WHERE cod_materia = 'ICO431' and id_sede = 3), (SELECT id_gestion FROM unicen.gestion WHERE nombre='2/2012'), 76, 3, 1);
SELECT unicen.insertarnotasprehomologadasdar(35543, 17, (SELECT id_materia FROM unicen.materia WHERE cod_materia = 'DAC421' and id_sede = 3), (SELECT id_gestion FROM unicen.gestion WHERE nombre='2/2012'), 19, 3, 1); 
SELECT unicen.insertarnotasprehomologadasdar(35543, 17, (SELECT id_materia FROM unicen.materia WHERE cod_materia = 'CPA411' and id_sede = 3), (SELECT id_gestion FROM unicen.gestion WHERE nombre='2/2012'), 42, 3, 1);
SELECT unicen.insertarnotasprehomologadasdar(35543, 17, (SELECT id_materia FROM unicen.materia WHERE cod_materia = 'ICO422' and id_sede = 3), (SELECT id_gestion FROM unicen.gestion WHERE nombre='2/2012'), 47, 3, 1);
SELECT unicen.insertarnotasprehomologadasdar(35543, 17, (SELECT id_materia FROM unicen.materia WHERE cod_materia = 'DAC431' and id_sede = 3), (SELECT id_gestion FROM unicen.gestion WHERE nombre='2/2012'), 65, 3, 1);
SELECT unicen.insertarnotasprehomologadasdar(35543, 17, (SELECT id_materia FROM unicen.materia WHERE cod_materia = 'ICO434' and id_sede = 3), (SELECT id_gestion FROM unicen.gestion WHERE nombre='2/2012'), 52, 3, 1);
SELECT unicen.insertarnotasprehomologadasdar(35543, 17, (SELECT id_materia FROM unicen.materia WHERE cod_materia = 'PPM423' and id_sede = 3), (SELECT id_gestion FROM unicen.gestion WHERE nombre='2/2012'), 63, 3, 1);

