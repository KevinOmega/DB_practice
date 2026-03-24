-- GENERAR DEUDA ESTUDIANTES ANTIGUOS
			      PERFORM   unicen.deudas_cargar_antiguos(unicod,idges,idsed,idplanest,idplaneco);
				 -- GENERAR DEUDA ESTUDIANTES PLAN REGULAR 
				  PERFORM   unicen.deudas_cargar_antiguos_plan_regular(unicod,idges,idsed,idplanest,idplaneco);
				 -- GENERAR DEUDA RECURSADA
				  PERFORM   unicen.deudas_cargar_antiguos_recursadas(unicod,idges,idsed,idplanest,idplaneco);
				 -- SIMULADOR - ADT
				  PERFORM  unicen.deudas_cargar_antiguos_simuladoradt(unicod,idges,idsed,idplanest,idplaneco);	
				 -- PRACTICAS HOSPITALARIAS - MEDICINA de 1 a 2 500 BS MAYORES A 3 1000 BS 
				  PERFORM  unicen.deudas_cargar_antiguos_practicashospitalarias5a6(unicod,idges,idsed,idplanest,idplaneco);


CREATE TABLE unicen.general_audit (
    id_audit SERIAL PRIMARY KEY,
    pg_user TEXT,
    usuario INTEGER,
    table_schema TEXT NOT NULL,
    table_name TEXT NOT NULL,
    operation TEXT NOT NULL,
    old_data JSONB,
    new_data JSONB,
    changed_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE OR REPLACE FUNCTION unicen.fn_tfr_audit()
    RETURNS TRIGGER 
    LANGUAGE PLPGSQL
AS $$
DECLARE
    v_old_record JSON = NULL;
    v_new_record JSON = NULL;
BEGIN
    IF (TG_OP = 'INSERT' OR TG_OP = 'UPDATE') THEN
        v_new_record = row_to_json(NEW);
    END IF;

    IF(TG_OP = 'DELETE' OR TG_OP = 'UPDATE') THEN
        v_old_record = row_to_json(OLD);
    END IF;

    INSERT INTO  unicen.general_audit (pg_user, usuario, table_schema, table_name, operation, old_data, new_data)
    VALUES (
        SESSION_USER,
        COALESCE(
            (v_new_record->>'id_usuario')::INTEGER,
            (v_old_record->>'id_usuario')::INTEGER
        ),
        TG_TABLE_SCHEMA, TG_TABLE_NAME, TG_OP, v_old_record, v_new_record
    );

    RETURN NULL; -- AFTER trigger: el valor de retorno es ignorado por PostgreSQL
END;
$$;

DROP TRIGGER IF EXISTS trg_audit_general ON unicen.notassss;

CREATE OR REPLACE TRIGGER trg_audit_general
AFTER INSERT OR UPDATE OR DELETE ON unicen.deudas_contable
FOR EACH ROW EXECUTE FUNCTION unicen.fn_tfr_audit();

CREATE OR REPLACE TRIGGER trg_audit_general
AFTER INSERT OR UPDATE OR DELETE ON unicen.inscripcion
FOR EACH ROW EXECUTE FUNCTION unicen.fn_tfr_audit();
SELECT * FROM unicen.notassss;
INSERT INTO unicen.notassss (unicodigo, id_sede, id_plan_estudio, id_gestion, id_materia, paralelo, obs)
VALUES (19008, 1, 112, 106, 1776, 'HOMOLOGADO', 'Observación de prueba para auditoría');

SELECT * FROM unicen.general_audit WHERE table_name = 'deudas_contable' ORDER BY changed_at DESC;

SELECT old_data, new_data, changed_at FROM unicen.general_audit 
WHERE table_name = 'inscripcion' and operation='UPDATE' and new_data->>'estinsceco' IS null and old_data->>'estinsceco' = 'INSCRITO'; 
SELECT old_data, new_data, changed_at FROM unicen.general_audit 
WHERE table_name = 'inscripcion' and operation='UPDATE' and new_data->>'estinsceco'= 'INSCRITO' and old_data->>'estinsceco' IS NULL; 

SELECT operation,old_data, new_data, changed_at FROM unicen.general_audit 
WHERE table_name = 'inscripcion' and operation = 'DELETE' and old_data->>'estinsceco' = 'INSCRITO' and old_data->>'id_gestion'='105'; 

SELECT operation,old_data, new_data, changed_at FROM unicen.general_audit 
WHERE table_name = 'inscripcion' and (old_data->>'unicodigo' = '25642' or new_data->>'unicodigo'='25642'); 



SELECT operation,old_data, new_data, changed_at FROM unicen.general_audit 
WHERE table_name = 'deudas_contable' and (old_data->>'unicodigo'='33934' OR new_data->>'unicodigo'='33934');
SELECT operation,old_data, new_data, changed_at FROM unicen.general_audit 
WHERE table_name = 'inscripcion'; 
select * from  unicen.estudiante_certificado WHERE unicodigo = 16050;

select * from personal where nombres = 'JOSUE DAVID';

SELECT * FROM unicen.usuario where unicodigo = 4137;


SELECT id_plan_estudio, id_materia FROM unicen.nota where unicodigo = 35741 GROUP BY id_plan_estudio,id_materia;

SELECT * FROM unicen.estudiante where unicodigo = 35741;

DELETE FROM unicen.estudiante where unicodigo = 35741;

SELECT id_plan_estudio, id_materia FROM unicen.nota where unicodigo = 35053 GROUP BY id_plan_estudio,id_materia;


SELECT unicodigo,estinsceco FROM unicen.inscripcion where unicodigo IN (
    16649
,16650
,12679
,17518
) and id_gestion = 105;

