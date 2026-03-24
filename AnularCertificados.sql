SELECT * FROM unicen.estudiante_certificado where numero_certificado IN (
    168583, 168584, 168585, 168586, 168587, 168588, 168589, 168590, 168591, 168592
) and id_sede = 1;


SELECT paterno,materno, nombres FROM unicen.estudiante WHERE unicodigo = 18333; 

BEGIN;

DELETE FROM unicen.estudiante_certificado where numero_certificado IN (
    168583, 168584, 168585, 168586, 168587, 168588, 168589, 168590, 168591, 168592
) and id_sede = 1 and unicodigo = 18333;

commit;