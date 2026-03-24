-- CREATE AN EVENT TRIGGER

-- FUNCTION RETURNING TRIGGER EVENT



/*
EVENT TRIGGER VARIABLES 
-------------------------------

ddl_command_start               this event occurs just before a CREATE, ALTER OR DROP DDL command is executed.

ddl_command_end                 this event occurs just after a CREATE, ALTER OR DROP DDL command is executed.

sql_drop                        this event occurs just before the ddl_command_end event for the commands that drop database objects (e.g., DROP TABLE, DROP FUNCTION, etc.)

EVENT TRIGGER VARIABLES
-------------------------------

TG_TAG this variable contains 'TAG' or command for which the trigger is executed, this variable does not containes the full command string, but just a tag such as CREATE TABLE, DROP TABLE, ALTER TABLE, AND SO ON.

TG_EVENT this variable contains the name of the event that fired the trigger, such as ddl_command_start, ddl_command_end, sql_drop, etc.

*/


CREATE TABLE ddl_audit(
    id_ddl_audit SERIAL PRIMARY KEY,
    username VARCHAR(32),
    ddl_event VARCHAR(32),
    ddl_operation VARCHAR(32),
    ddl_timestampt TIMESTAMP
)

CREATE FUNCTION fn_ddl_audit()
RETURNS EVENT_TRIGGER
LANGUAGE PLPGSQL
SECURITY DEFINER
AS $$
    BEGIN
        -- INSERT DATA
        INSERT INTO public.ddl_audit(
            username,
            ddl_event,
            ddl_operation,
            ddl_timestampt
        ) VALUES (
            SESSION_USER,
            TG_EVENT,
            TG_TAG,
            NOW()
        );

        -- RAISE NOTICE

        RAISE NOTICE 'DDL activity added';
    END;
$$;


CREATE EVENT TRIGGER trg_ddl_audit
ON ddl_command_start
WHEN TAG IN ('CREATE TABLE')
EXECUTE PROCEDURE fn_ddl_audit();

DROP EVENT TRIGGER trg_ddl_audit;

CREATE TABLE task2(
    task2_id SERIAL PRIMARY KEY,
    task TEXT
);


select * from public.ddl_audit;


CREATE OR REPLACE FUNCTION fn_event_abort_create_table()
RETURNS EVENT_TRIGGER
LANGUAGE PLPGSQL
SECURITY DEFINER
AS $$
    DECLARE
        current_hour INT := extract('hour' FROM now());

    BEGIN
        IF current_hour BETWEEN 15 AND 18 THEN
            RAISE EXCEPTION 'CHANGES ARE NOT ALLOWED BETWEEN 15:00 AND 18:00';
        END IF;
    END;
$$;


CREATE EVENT TRIGGER trg_event_abort_create_table
ON ddl_command_start
WHEN TAG IN ('CREATE TABLE')
EXECUTE PROCEDURE fn_event_abort_create_table();

CREATE TABLE t3(
    id_t3 SERIAL PRIMARY KEY
);


SELECT * FROM unicen.materia where nombre LIKE '%ALIMENTOS%' and id_sede = 1;

select * from unicen.plan_materia where id_materia = 3088 and id_sede = 1;


select * from unicen.estudiante where unicodigo IN (
    SELECT unicodigo from unicen.nota WHERE id_plan_estudio = 178 and id_materia <> 3088
);

SELECT * from unicen.estudiantecareco WHERE id_carrera = 209 and extract(year from f_registro) = 2025 and id_sede = 1;

SELECT * FROM unicen.carrera where id_carrera IN (
    select id_carrera from unicen.plan_estudio where id_plan_estudio = 178 and id_sede = 1
);

SELECT * FROM unicen.materia where cod_materia = 'GAS 2311'

SELECT * FROM unicen.carrera where id_carrera = 65;


