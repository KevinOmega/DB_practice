SELECT * FROM unicen.estudiante_certificado where numero_certificado IN (
    168583, 168584, 168585, 168586, 168587, 168588, 168589, 168590, 168591, 168592
) and id_sede = 1;


SELECT paterno,materno, nombres FROM unicen.estudiante WHERE unicodigo = 18333; 

BEGIN;

DELETE FROM unicen.estudiante_certificado where numero_certificado IN (
    168583, 168584, 168585, 168586, 168587, 168588, 168589, 168590, 168591, 168592
) and id_sede = 1 and unicodigo = 18333;


SELECT e.nombres, e.paterno, e.materno, ec.numero_certificado from unicen.estudiante_certificado ec
JOIN unicen.estudiante e on e.unicodigo = ec.unicodigo
WHERE numero_certificado = '173674';

SELECT  * FROM unicen.estudiante_certificado where numero_certificado = '173674';

BEGIN ;

UPDATE unicen.estudiante_certificado SET numero_certificado = '173674' WHERE numero_certificado = '1773674';

COMMIT ;


commit;