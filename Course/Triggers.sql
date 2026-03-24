-- Active: 1771870897885@@127.0.0.1@5432@learning
select * from public.accounts;

select * from accounts;

-- CREATE A TRIGGER SINTAX
CREATE OR REPLACE FUNCTION trigger_function()
    RETURNS TRIGGER 
    LANGUAGE PLPPGSQL
AS $$
BEGIN
    --- Trigger logic goes here
END;
$$;


CREATE TRIGGER trigger_name
    { BEFORE | AFTER | INSTEAD OF } { event [ OR ... ] }  BEFORE [INSERT | DELETE | TRUNCATE] / BEFORE UPDATE / AFTER INSERT
    ON table_name
    [ FOR [ EACH ] { ROW | STATEMENT } ]
    EXECUTE FUNCTION trigger_function();



--- DATA AUDITING WITH TRIGGERS 

CREATE TABLE players (
    player_id SERIAL PRIMARY KEY,
    name VARCHAR(100)
);


CREATE TABLE players_audit (
    player_audit_id SERIAL PRIMARY KEY,
    player_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    edit_table TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE OR REPLACE FUNCTION fn_audit_players()
RETURNS TRIGGER 
LANGUAGE PLPGSQL
AS $$
BEGIN
    IF OLD.name <> NEW.name THEN
        INSERT INTO players_audit (player_id, name)
        VALUES (OLD.player_id, OLD.name);
    END IF;
    RETURN NEW;
END;

$$;

CREATE TRIGGER trg_audit_players
BEFORE UPDATE ON players
FOR EACH ROW
EXECUTE PROCEDURE fn_audit_players();


INSERT INTO players (name) VALUES ('John Doe'), ('Kevin'); 

UPDATE players SET name = 'KevinOmega1234' where player_id = 2;


select * from public.players;

select * from public.players_audit;

-- GENERIC BLOCK WITH TRIGGER

CREATE OR REPLACE FUNCTION fn_generic_action_blocker()
RETURNS TRIGGER
LANGUAGE PLPGSQL
AS $$
    BEGIN
        IF TG_WHEN = 'AFTER' THEN
            RAISE EXCEPTION 'You can not % ON %.%.', TG_OP, TG_TABLE_SCHEMA, TG_TABLE_NAME;
        END IF;
    END;
$$;


-- TRIGGER VARIABLES


-- TG_OP: Operation type (INSERT, UPDATE, DELETE)
-- TG_TABLE_NAME: Name of the table that fired the trigger
-- TG_RELNAME: Name of the relation (table) that fired the trigger
-- TG_TABLE_SCHEMA: Schema of the table that fired the trigger
-- TG_WHEN: Timing of the trigger (BEFORE, AFTER, INSTEAD OF
-- TG_LEVEL: Level of the trigger (ROW, STATEMENT)
-- TG_NARGS: Number of arguments passed to the trigger function
-- TG_ARGV: Array of arguments passed to the trigger function (TG_ARGV[0], TG_ARGV[1], etc.)


-- AUDIT TRIGGER
DROP TABLE audit_log;
CREATE TABLE audit_log (
    log_id SERIAL PRIMARY KEY,
    username TEXT,
    operation VARCHAR(10),
    table_name VARCHAR(50),
    old_data JSONB,
    new_data JSONB,
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE OR REPLACE FUNCTION fn_audit_changes()
    RETURNS TRIGGER
    LANGUAGE PLPGSQL
AS $$
    DECLARE
        old_value JSON = NULL;
        new_value JSON = NULL;
    BEGIN
        -- DELETE / UPDATE 
        IF TG_OP IN ('DELETE', 'UPDATE') THEN
            old_value = row_to_json(OLD);
        END IF;
        -- INSERT / UPDATE
        IF TG_OP IN ('INSERT', 'UPDATE') THEN
            new_value = row_to_json(NEW);
        END IF;
        -- INSERT INTO AUDIT
        INSERT INTO public.audit_log (
            username,
            operation,
            table_name,
            old_data,
            new_data,
            changed_at
        ) VALUES (
            SESSION_USER,
            TG_OP,
            TG_TABLE_SCHEMA || '.' || TG_TABLE_NAME,
            old_value,
            new_value,
            NOW()
        );
        RETURN NEW;
    END;
$$;

CREATE TRIGGER trg_audit_trigger
AFTER INSERT OR UPDATE OR DELETE
ON products
FOR EACH ROW
EXECUTE PROCEDURE fn_audit_changes();


insert into public.products (product_id,product_name, unit_price)
VALUES (10,'Manzana', 20)

insert into public.products (product_id,product_name, unit_price)
VALUES (11,'Pera', 10)

update public.products SET product_name = 'Naranja' where product_name = 'Manzana';

select * from public.audit_log;


delete from public.products where product_id = 11;


-- CONDITIONAL TRIGGER

CREATE OR REPLACE FUNCTION fn_conditional()
RETURNS TRIGGER
LANGUAGE PLPGSQL
AS $$
    BEGIN
        RAISE EXCEPTION '%', TG_ARGV[0];
        RETURN NULL;
    END;
$$;

CREATE TABLE task(
    task_id SERIAL PRIMARY KEY,
    task VARCHAR
);


CREATE TRIGGER trg_conditional
BEFORE UPDATE OR DELETE OR INSERT OR TRUNCATE
ON task
FOR EACH STATEMENT
WHEN (
    EXTRACT('DOW' FROM CURRENT_TIMESTAMP) = 3 AND 
    current_time > '12:00'
)
EXECUTE PROCEDURE fn_conditional('NO SE PUEDE AGREGAR CAMBIOS LOS DIAS MIERCOLES POR LA MANIANA');

DROP TRIGGER trg_conditional ON  task;


select * from EXTRACT('DOW' FROM CURRENT_TIMESTAMP);
select * from CURRENT_TIME;


INSERT INTO task (task) VALUES ('SUCCESS');

SELECT * FROM public.task;

DELETE FROM public.task;


-- DISABLE TO MAKE CHANGES ON SPECIFIC COLS

CREATE TRIGGER trg_disable_update_pk
AFTER UPDATE OF task_id
on public.task 
EXECUTE PROCEDURE public.fn_generic_action_blocker();

select * from public.task;


