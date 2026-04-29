SELECT * from unicen.materia where cod_materia = 'CPA552';

-- 1655
SELECT  * FROM unicen.carrera where codigo = 'IFI' and id_sede = 3;

-- 20

SELECT * FROM unicen.plan_estudio WHERE id_carrera = 20 AND id_sede =3;

-- 136

select * from unicen.tema_unicen where id_plan_estudio = 136 and id_materia = 1655;

BEGIN ;

UPDATE unicen.tema_unicen
SET TITULO = 'OPERACIONES DE LAS ENTIDADES FINANCIERAS',
    CONTENIDO =
'4.1.	OPERACIONES ACTIVAS
4.1.1.	CLASIFICACIÓN POR TIPO DE OPERACIÓN
4.1.2.	CLASIFICACIÓN POR EL PLAZO
4.2.	OPERACIONES PASIVAS
4.2.1.  CLASIFICACIÓN POR TIPO DE OPERACIÓN
4.2.1.  CLASIFICACIÓN POR EL PLAZO
4.3. 	OPERACIONES CONTINGENTES
4.4. 	OPERACIONES DE SERVICIOS
'
WHERE id_tema_unicen = 6940;

UPDATE unicen.tema_unicen
SET titulo = 'PRÁCTICA CONTABLE Y ESTADOS FINANCIEROS ',
    contenido =
'5.1.	OPERACIONES DE CARTERA
5.1.1.	MARCO NORMATIVO
5.1.2.	EJEMPLO PRESTAMOS A PLAZO FIJO EN MN Y ME
5.1.3.	EJEMPLO PRESTAMOS AMORTIZABLES EN MN Y ME
5.1.4.	RESOLUCIONES PRÁCTICAS
5.2.	OBLIGACIONES CON EL PÚBLICO
5.2.1.	MARCO NORMATIVO
5.2.2.	EJEMPLO DE CUENTAS DE AHORRO MN Y ME
5.2.3.	EJEMPLO DE CUENTAS A PLAZO MN Y ME
5.2.4.	RESOLUCIONES PRÁCTICAS
5.3.	OTRAS OPERACIONES ACTIVAS, PASIVAS Y DE SERVICIOS
5.4.	ESTADOS FINANCIEROS
5.4.1.	MARCO NORMATIVO
5.4.2.	ESTADOS DE PRESENTACIÓN
5.4.3.	ESTADOS DE PUBLICACIÓN
'
WHERE id_tema_unicen = 6942;

commit ;

SELECT * FROM unicen.materia where cod_materia = 'PSI546' and id_sede = 1;
-- 1413

SELECT * FROM unicen.tema_unicen where id_plan_estudio = 111 and id_materia = 1342;

SELECT id_plan_estudio
    FROM unicen.plan_materia where id_materia = 1413 and id_sede = 1

SELECT * FROM unicen.carrera where id_sede = 1 and id_carrera_tipo = 4;


SELECT nombres ,paterno, materno from unicen.estudiante where unicodigo = 11442;
SELECT  * FROM unicen.carrera_tipo;

SELECT * FROM unicen.estudiante_certificado where numero_certificado = '173999';