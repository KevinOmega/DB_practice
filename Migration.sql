SELECT * FROM unicen.plan_materia where id_plan_estudio = 10 and id_sede = 3;

SELECT * FROM unicen.materia;


select * from unicen.plan_estudio;

INSERT INTO unicen.materia (cod_materia, nombre, id_carrera, activo, id_sede)
VALUES
('DCE483','DERECHO REGULATORIO',10,'ACTIVO',3),
('DCE484','LEGISLACION ADUANERA',10,'ACTIVO',3),
('DCE485','PRACTICA FORENSE JURIDICO EMPRESARIAL',10,'ACTIVO',3),
('DAC11','COMPUTACION I',10,'ACTIVO',3),
('DCJ95','PROCEDIMIENTOS ESPECIALES',10,'ACTIVO',3),
('DCJ12','DERECHO I',10,'ACTIVO',3),
('AUD11','ECONOMIA GENERAL',10,'ACTIVO',3),
('DAC12','INGLES I',10,'ACTIVO',3),
('DCJ21','DERECHO CIVIL I (PERSONAS)',10,'ACTIVO',3),
('DCJ22','DERECHO CONSTITUCIONAL I',10,'ACTIVO',3),
('DCJ23','DERECHO PENAL I (GENERAL)',10,'ACTIVO',3),
('DAC22','INGLES II',10,'ACTIVO',3),
('DCJ31','DERECHO CIVIL II (REALES)',10,'ACTIVO',3),
('DCJ32','DERECHO CONSTITUCIONAL II',10,'ACTIVO',3),
('DCJ33','DERECHO PENAL II (ESPECIAL)',10,'ACTIVO',3),
('OPT','OPTATIVA',10,'ACTIVO',3),
('DCJ41','DERECHO ADMINISTRATIVO I',10,'ACTIVO',3),
('DCJ42','DERECHO AGRARIO',10,'ACTIVO',3),
('DCJ44','DERECHO COMERCIAL I (COMERCIANTES)',10,'ACTIVO',3),
('DCJ45','DERECHO FINANCIERO',10,'ACTIVO',3),
('DCJ51','DERECHO ADMINISTRATIVO II',10,'ACTIVO',3),
('DCJ11','CRIMINOLOGIA',10,'ACTIVO',3),
('ADM11','ADMINISTRACION I',10,'ACTIVO',3),
('DCJ43','DERECHO CIVIL III (OBLIGACIONES)',10,'ACTIVO',3),
('DCJ52','DERECHO CIVIL IV (CONTRATOS)',10,'ACTIVO',3),
('DCJ54','DERECHO COMERCIAL II (BIENES Y VALORES)',10,'ACTIVO',3),
('DCJ56','DERECHO TRIBUTARIO',10,'ACTIVO',3),
('DCJ58','PSICOLOGIA JURIDICA',10,'ACTIVO',3),
('DCJ59','SOCIOLOGIA JURIDICA',10,'ACTIVO',3),
('DCJ61','DERECHO CIVIL V (SUCESIONES)',10,'ACTIVO',3),
('DCJ62','DERECHO COMERCIAL III (CONTRATOS)',10,'ACTIVO',3),
('DCJ63','DERECHO DEL TRABAJO',10,'ACTIVO',3),
('DCJ64','DERECHO MINERO',10,'ACTIVO',3),
('DCJ65','DERECHO PROCESAL CIVIL Y LEY DE ORGANIZACION JUDICIAL',10,'ACTIVO',3),
('DCJ66','MEDICINA LEGAL',10,'ACTIVO',3),
('DCJ71','DERECHO COMERCIAL IV (PROCEDIMIENTOS ESPECIALES)',10,'ACTIVO',3),
('DCJ72','DERECHO INTERNACIONAL PUBLICO',10,'ACTIVO',3),
('DCJ73','DERECHO PETROLERO E HIDROCARBUROS',10,'ACTIVO',3),
('DCJ74','DERECHO PROCESAL Y PROCEDIMIENTO PENAL',10,'ACTIVO',3),
('DCJ75','INTRODUCCION A LAS NEGOCIACIONES',10,'ACTIVO',3),
('PPM71','ORATORIA Y PERSUASION',10,'ACTIVO',3),
('DCJ76','PROCEDIMIENTO CIVIL',10,'ACTIVO',3),
('DCJ81','DERECHO BANCARIO Y SEGUROS',10,'ACTIVO',3),
('DCJ82','DERECHO DE FAMILIA',10,'ACTIVO',3),
('DCJ83','DERECHO INTERNACIONAL PRIVADO I',10,'ACTIVO',3),
('DCJ85','PRACTICA FORENSE CIVIL I',10,'ACTIVO',3),
('DCJ86','PRACTICA FORENSE PENAL I',10,'ACTIVO',3),
('DCJ87','SEGURIDAD SOCIAL',10,'ACTIVO',3),
('AUD64','INTERPRETACION DE ESTADOS FINANCIEROS',10,'ACTIVO',3),
('DAC91','METODOS DE INVESTIGACION CIENTIFICA',10,'ACTIVO',3),
('DCJ93','PRACTICA FORENSE CIVIL II',10,'ACTIVO',3),
('DCJ94','PRACTICA FORENSE PENAL II',10,'ACTIVO',3),
('DCJ96','PROTECCION JURIDICA DEL CONSUMIDOR',10,'ACTIVO',3),
('DCJ101','* AREA 1 PENAL',10,'ACTIVO',3),
('DCJ107','* AREA 1 TEORICO DOCTRINAL',10,'ACTIVO',3),
('DCJ112','* AREA 1 TEORICO - PARTE GENERAL',10,'ACTIVO',3),
('DCJ105','* AREA 2 CIVIL, COMERCIAL Y OTROS',10,'ACTIVO',3),
('DCJ108','* AREA 2 DERECHO POSITIVO',10,'ACTIVO',3),
('DCJ106','* AREA 3 MENCION DERECHO EMPRESARIAL',10,'ACTIVO',3),
('DCJ110','* MODALIDAD EXCELENCIA ACADEMICA',10,'ACTIVO',3),
('DCJ84','NEGOCIACIONES I',10,'ACTIVO',3);


-- INSERTAR PLAN DE ESTUDIO
-- id_plan_estudio	10
-- id_tipo_plan_estudio	5
-- id_carrera	10
-- resolucion	
-- fecha_creacion	2005-03-01
-- activo	1
-- semanas_periodo	19
-- total_horas_acad	0

INSERT INTO unicen.plan_estudio (id_tipo_plan_estudio,id_carrera, resolucion,fecha_res, activo,id_sede,choraria)
VALUES(
    5,74, '', '2005-03-01', 'ACTIVO', 3, 0
);


SELECT nombre FROM unicen.materia where id_materia IN (
    SELECT id_materia from unicen.plan_materia where id_plan_estudio = 10 and id_sede = 3
) and id_sede = 3
EXCEPT
SELECT nombre FROM unicen.materia where id_carrera = 10 and id_sede = 3;


SELECT nombre FROM unicen.materia where id_carrera = 10 and id_sede = 3
EXCEPT
SELECT nombre FROM unicen.materia where id_materia IN (
    SELECT id_materia from unicen.plan_materia where id_plan_estudio = 10 and id_sede = 3
) and id_sede = 3;

SELECT nombre FROM unicen.materia where id_carrera = 10 and id_sede = 3;
SELECT nombre FROM unicen.materia where id_materia IN (
    SELECT id_materia from unicen.plan_materia where id_plan_estudio = 10 and id_sede = 3
) and id_sede = 3;

SELECT * FROM unicen.plan_estudio where id_plan_estudio = 179 and id_carrera = 10 and id_sede = 3;



-- AGREGAR NUEVO PLAN DE ESTUDIOS
BEGIN;

-- UPDATE unicen.plan_estudio SET id_carrera = 10 where id_plan_estudio = 10 and id_sede = 3 and id_carrera = 74;
select max(id_plan_estudio) FROM unicen.plan_estudio;

INSERT INTO unicen.plan_estudio 
SELECT 179, id_tipo_plan_estudio, id_carrera, resolucion, fecha_res, activo, id_sede, choraria
FROM unicen.plan_estudio where id_plan_estudio = 10 and id_sede = 3 and id_carrera = 10;

UPDATE unicen.plan_estudio SET id_carrera = 74 where id_plan_estudio = 179 and id_carrera = 10 and id_sede = 3;

SELECT * FROM unicen.carrera where id_carrera = 74 and id_sede = 3;

commit;

ROLLBACK;


-- DUPLICAR MATERIAS


select  * from unicen.plan_materia where id_plan_estudio = 10 and id_sede = 3;

BEGIN;

SELECT setval(
  pg_get_serial_sequence('unicen.plan_materia', 'id_plan_materia'),
  COALESCE((SELECT MAX(id_plan_materia) FROM unicen.plan_materia), 0),
  TRUE
);

INSERT INTO unicen.plan_materia(
    id_materia,
    id_materia_tipo,
    id_plan_estudio,
    id_nivel,
    creditos,
    horas_teoria,
    horas_practica,
    cod_materia,
    practica_hospitalaria,
    total_horas,
    estado,
    id_sede,
    pay
)
SELECT 
    id_materia,
    id_materia_tipo,
    179,
    id_nivel,
    creditos,
    horas_teoria,
    horas_practica,
    cod_materia,
    practica_hospitalaria,
    total_horas,
    estado,
    id_sede,
    pay
FROM unicen.plan_materia
WHERE id_plan_estudio = 10 and id_sede = 3;


SELECT * FROM unicen.plan_materia where id_plan_estudio = 179 and id_sede = 3;

ROLLBACK;

COMMIT;




-- MODIFICAR CARECO DE ESTUDIANTE
select * from unicen.estudiante where id_estudiante = 9836;

select * from unicen.plan_estudio where id_carrera = 74 and id_sede = 3;


select * from unicen.estudiantecareco where id_estudiante = 9836;


SELECT * FROM unicen.usuario where unicodigo = 4137;

SELECT * FROM unicen.hom_estudiante where unicodigo = 23008 and id_sede = 3;
SELECT unicen.cancelarprocesodehomologacionestudiante(23008,6,4,134,3);

select * from unicen.nota where id_estudiante = 8120;
select * from unicen.nota where unicodigo = 34501;
BEGIN;
UPDATE unicen.nota SET unicodigo = 34501 
where id_estudiante = 8120 and id_sede = 3 and unicodigo IS NULL and id_plan_estudio = 10;




commit;


ROLLBACK;


SELECT * FROM unicen.usuario where unicodigo = 4137;