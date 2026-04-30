-- Active: 1773947064130@@162.216.115.118@5432@uniproduccion
-- ============================================================
-- TEST: Inserción de temas para materia 1401, plan 113, sede 1
-- Envuelto en transacción con ROLLBACK para no persistir datos.
-- Permite verificar el trigger trg_propagar_tema_unicen.
-- ============================================================

BEGIN;
INSERT INTO unicen.tema_unicen (id_plan_estudio, id_materia, nombre, titulo, contenido, id_sede, estado)
VALUES 
(113, 1401, 'EL SISTEMA FINANCIERO', 'TEMA 1', '1.1 LAS FINANZAS – CONCEPTO
1.2 FUNCIONES Y CAMPO DE ACCIÓN DE LAS FINANZAS
1.3 FINANZAS, ECONOMÍA Y CONTABILIDAD
1.4 MERCADOS E INSTITUCIONES FINANCIERAS
1.5 INSTRUMENTOS O ACTIVOS FINANCIEROS', 1, 'ACTIVO'),
(113, 1401, 'PLANEACIÓN FINANCIERA', 'TEMA 2', '2.1 TIPOS DE PLANES
2.2 ETAPAS DE LA PLANEACIÓN
2.3 MODELO PLANEACIÓN ESTRATÉGICA
2.4 CONTROL FINANCIERO
2.5 PLAN OPERATIVO
2.6 PLAN TÁCTICO
2.7 CRONOGRAMA DE OPERACIONES
2.8 PRESUPUESTO
2.9 CONTROL DE EJECUCIÓN PRESUPUESTARIA', 1, 'ACTIVO'),
(113, 1401, 'ESTADOS FINANCIEROS', 'TEMA 3', '3.1 CONCEPTO
3.2 OBJETO DE LOS ESTADOS FINANCIEROS
3.3 ESTADO DEL COSTO
3.3 ESTADO DE RESULTADOS
3.4 BALANCE DE SITUACIÓN FINANCIERA
3.5 EVOLUCIÓN PATRIMONIAL
3.6 FLUJO DE EFECTIVO
3.5 RATIOS DE MEDICIÓN DE RESULTADOS
3.6 EQUILIBRIO Y SOLIDEZ DE LA ESTRUCTURA PATRIMONIAL', 1, 'ACTIVO'),
(113, 1401, 'APALANCAMIENTO OPERATIVO Y FINANCIERO', 'TEMA 4', '4.1 ANÁLISIS DEL PUNTO DE EQUILIBRIO
4.2 ANÁLISIS DEL PUNTO DE EQUILIBRIO EN EFECTIVO
4.3 APALANCAMIENTO OPERATIVO
4.4 APALANCAMIENTO FINANCIERO
4.5 COSTO DEL APALANCAMIENTO', 1, 'ACTIVO'),
(113, 1401, 'ANALISIS DE ESTADOS FINANCIEROS', 'TEMA 5', '5.1 ANÁLISIS FINANCIERO
5.2 ANÁLISIS VERTICAL
5.3 ANÁLISIS HORIZONTAL
5.4 RAZONES DE LIQUIDEZ
5.5 RAZONES DE APALANCAMIENTO
5.6 RAZONES DE RENTABILIDAD
5.7 RAZONES DE DESEMPEÑO
5.8 PROYECCIONES FINANCIERAS', 1, 'ACTIVO'),
(113, 1401, 'ADMINISTRACIÓN DEL CAPITAL DE OPERACIONES', 'TEMA 6', '6.1 CONCEPTO DE CAPITAL DE TRABAJO
6.2 ADMINISTRACIÓN DEL EFECTIVO
6.3 ADMINISTRACIÓN DEL EXIGIBLE
6.4 ADMINISTRACIÓN DE INVENTARIOS', 1, 'ACTIVO'),
(113, 1401, 'ADMINISTRACIÓN DEL ACTIVO FIJO', 'TEMA 7', 'ADMINISTRACIÓN DEL ACTIVO FIJO', 1, 'ACTIVO'),
(113, 1401, 'ADMINISTRACIÓN DEL FINANCIAMIENTO', 'TEMA 8', 'ADMINISTRACIÓN DEL FINANCIAMIENTO', 1, 'ACTIVO'),
(113, 1401, 'ADMINISTRACIÓN DEL PATRIMONIO', 'TEMA 9', '9.1 ADMINISTRACIÓN DEL PATRIMONIO', 1, 'ACTIVO'),
(113, 1401, 'PRESUPUESTO DE CAPITAL', 'TEMA 10', '10.1 SIGNIFICADO DEL PRESUPUESTO DE CAPITAL
10.2 CAPITAL DE INVERSIÓN
10.3 CAPITAL DE OPERACIÓN
10.4 TASA DE DEVALUACIÓN
10.5 VALOR PRESENTE NETO VAN
10.6 TASA INTERNA DE RETORNO O RENDIMIENTO TIR', 1, 'ACTIVO'),
(113, 1401, 'COSTO DE CAPITAL', 'TEMA 11', '11.1. COSTO DE CAPITAL', 1, 'ACTIVO'),
(113, 1401, 'POLÍTICAS FINANCIERAS', 'TEMA 12', '12.1 ADMINISTRACIÓN DEL EFECTIVO.
12.2 ADMINISTRACIÓN Y POLÍTICAS DE CRÉDITO
12.3 ADMINISTRACIÓN DE LOS INVENTARIOS.
12.4 ADMINISTRACIÓN DE ACTIVOS FIJOS
12.5 ADMINISTRACIÓN DE OBLIGACIONES
12.6 POLÍTICA DE VENTAS, ADQUISICIONES, ALMACENAJE, PRODUCCIÓN, DISTRIBUCIÓN, ETC.', 1, 'ACTIVO');

-- ============================================================
-- TEST: Inserción de temas para materia 1348 (Gestión de
--       Emprendimientos), plan 113, sede 1
-- ============================================================

SELECT(
    setval('unicen.tema_unicen_id_tema_unicen_seq', (SELECT MAX(id_tema_unicen) FROM unicen.tema_unicen) + 1)
)

begin;

INSERT INTO unicen.tema_unicen (id_plan_estudio, id_materia, nombre, titulo, contenido, id_sede, estado)
VALUES
(113, 1348, 'TERMINOLOGÍA Y CARACTERÍSTICAS RELACIONADAS CON EL EMPRENDIMIENTO', 'TEMA 1',
'1.1 ESPÍRITU EMPRENDEDOR
1.2 CREATIVIDAD
1.3 TRABAJO EN EQUIPO
1.4 PROPUESTA DE VALOR
1.5 MODELO DE NEGOCIO',
1, 'ACTIVO'),
(113, 1348, 'OPORTUNIDADES DE NEGOCIO', 'TEMA 2',
'2.1 ANÁLISIS DE LA INDUSTRIA
2.2 CLIMA ECONÓMICO
2.3 EL PAPEL DE LA TECNOLOGÍA
2.4 ESTRATEGIA DE SALIDA
2.5 REGULACIONES GUBERNAMENTALES
2.6 TENDENCIAS DEMOGRÁFICAS
2.7 ANÁLISIS DEL MERCADO
2.8 ANÁLISIS DE LA COMPETENCIA
2.9 SEGMENTOS DE MERCADO E INNOVACIÓN
2.10 TAMAÑO Y PARTICIPACIÓN DEL MERCADO',
1, 'ACTIVO'),
(113, 1348, 'PROCESO DE CREACIÓN DE UN NEGOCIO PROPIO', 'TEMA 3',
'3.1 NATURALEZA DEL PROYECTO
3.2 EL MERCADO (PLAN DE MARKETING)
3.3 PRODUCCIÓN (PLAN DE PRODUCCIÓN)
3.4 ORGANIZACIÓN (PLAN ORGANIZATIVO)
3.5 FINANZAS (PLAN FINANCIERO)
3.6 PLAN DE TRABAJO',
1, 'ACTIVO');

-- ============================================================
-- Verificación: temas origen insertados (1401 - Ing. Financiera)
-- ============================================================
SELECT id_tema_unicen, id_plan_estudio, id_materia, id_sede,
       titulo, nombre, id_tema_unicen_origen
FROM   unicen.tema_unicen
WHERE  id_materia = 1401 AND id_plan_estudio = 113 AND id_sede = 1
ORDER  BY titulo;

-- ============================================================
-- Verificación: temas propagados por el trigger (1401)
-- ============================================================
SELECT t.id_tema_unicen, t.id_plan_estudio, t.id_materia, t.id_sede,
       t.titulo, t.nombre, t.id_tema_unicen_origen
FROM   unicen.tema_unicen t
WHERE  t.id_tema_unicen_origen IN (
    SELECT id_tema_unicen
    FROM   unicen.tema_unicen
    WHERE  id_materia = 1401 AND id_plan_estudio = 113 AND id_sede = 1
)
ORDER  BY t.id_tema_unicen_origen, t.id_sede;

-- ============================================================
-- Verificación: temas origen insertados (1348 - Gest. Emprendimientos)
-- ============================================================
SELECT id_tema_unicen, id_plan_estudio, id_materia, id_sede,
       titulo, nombre, id_tema_unicen_origen
FROM   unicen.tema_unicen
WHERE  id_materia = 1348 AND id_plan_estudio = 113 AND id_sede = 1
ORDER  BY titulo;

-- ============================================================
-- Verificación: temas propagados por el trigger (1348)
-- ============================================================
SELECT t.id_tema_unicen, t.id_plan_estudio, t.id_materia, t.id_sede,
       t.titulo, t.nombre, t.id_tema_unicen_origen
FROM   unicen.tema_unicen t
WHERE  t.id_tema_unicen_origen IN (
    SELECT id_tema_unicen
    FROM   unicen.tema_unicen
    WHERE  id_materia = 1418 AND id_plan_estudio = 113 AND id_sede = 1
)
ORDER  BY t.id_tema_unicen_origen, t.id_sede;


ROLLBACK;

COMMIT;


-- GESTION DE EMPRENDIMIENTOS

-- DAC581

SELECT * FROM unicen.materia where cod_materia = 'DAC581';
-- 1348 CBBA
-- 1746 LPZ
-- 1658 STZ

SELECT  * FROM unicen.carrera where nombre  = 'INGENIERÍA FINANCIERA';

SELECT  * FROM unicen.plan_estudio where id_carrera = 20 and id_sede = 3;

-- 113 CBBA
-- 136 LPZ


SELECT * FROM unicen.materia where cod_materia = 'IFI561';


-- 1754 LPZ
-- 1690 STZ
-- 1401 CBBA


-- LPZ
SELECT * FROM unicen.tema_unicen where id_materia = 1754 and id_plan_estudio = 136;


SELECT * FROM unicen.equivalencia_materia_unicen WHERE id_plan_estudio_origen = 113 and id_sede_origen = 1 and id_materia_origen = 1401;
-- CBBA

SELECT  * FROM unicen.tema_unicen where id_materia = 1401 and id_plan_estudio = 113;


SELECT * FROM unicen.materia where cod_materia = 'CPA552';


SELECT * FROM unicen.tema_unicen where id_materia = 1386 and id_plan_estudio = 113;


BEGIN;

UPDATE unicen.tema_unicen 
SET contenido = '1.1.	CONCEPTOS 
1.2.	DEFINICIONES 
1.3.	ESTRUCTURA DEL SISTEMA FINANCIERO
1.3.1. CONSEJO DE ESTABILIDAD FINANCIERA 
1.3.2. BANCO CENTRAL DE BOLIVIA
1.3.3. AUTORIDAD DE SUPERVISIÓN DEL SISTEMA FINANCIERO
1.4	ENTIDADES FINANCIERAS
    1.4.1. DEL ESTADO
    1.4.2. PRIVADAS
' WHERE id_tema_unicen = 2757;