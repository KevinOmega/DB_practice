-- SCHEMAS

-- logical views

-- organize tables into logical groups

-- Allow multiple users to use the same table names without conflict

-- SCHEMA CREATION

-- CREATE SCHEMA schema_name;

CREATE SCHEMA sales;

CREATE SCHEMA hr;


-- RENAME A CEHCMA


ALTER SCHEMA sales RENAME TO programming;

-- DROP A SCHEMA
-- Be careful when dropping a schema, as it will also drop all the objects contained within it, such as tables, views, and functions. Make sure to back up any important data before dropping a schema.
DROP SCHEMA programming;

-- MOVE A TABLE TO ANOTHER SCHEMA
-- To move a table from one schema to another, you can use the ALTER TABLE statement with


SELECT * FROM public.employees; -- to check if the table is in the public schema

INSERT INTO public.employees (firstname, lastname) VALUES ('John', 'Doe'); -- to insert data into the table in the public schema

ALTER TABLE hr.employees SET SCHEMA public;

-- SEARCH PATH

SELECT current_schema(); -- to check the current schema

SHOW search_path; -- to check the search path

SET search_path TO '$user',hr, public; -- to set the search path to include both schemas


SELECT * FROM employees; -- to check if the table is accessible without schema qualification



-- ALTER SCHEMA OWNERSHIP


ALTER SCHEMA hr OWNER TO new_owner; -- to change the ownership of the hr schema to a new owner, can be a user or a role



-- DUPLICATE A SCHEMA

-- Make a dump using a pg dump command with the --schema option to specify the schema you want to duplicate. For example, to dump the hr schema, you can use the following command:

-- pg_dump -d database_name -h localhost -U postgres -n hr > dump.sql

-- rename the original shcema to something else, for example hr_old

ALTER SCHEMA hr RENAME TO hr_old;


-- import back the dump file to create a new schema with the original name hr

-- psql -h localhost -U postgres -d test_schema -f dump.sql



-- PG_CATALOG
-- The pg_catalog schema is a system schema that contains the metadata and system tables for the PostgreSQL database. It is automatically created when a new database is initialized and cannot be dropped or renamed. The pg_catalog schema is used by the PostgreSQL system to store information about the database, such as table definitions, user accounts, and other system-level information. It is important to note that the pg_catalog schema should not be modified directly by users, as it can lead to unexpected behavior and potential data loss.


-- pg_catalog is always first in the search path.


SELECT * FROM information_schema.schemata; -- to list all the schemas in the database


-- COMPARE TABLES AND COLUMNS IN TWO SCHEMAS




-- SCHEMAS AND PRIVILEGES

-- Two scehma access levels rghts
--  * USATE: To access schema
--  * CREATE: To create objects in the schema


-- GRANT USAGE ON SCHEMA hr TO user_name; -- to grant usage privilege on the hr schema to a specific user
-- GRANT CREATE ON SCHEMA hr TO user_name; -- to grant create privilege on the hr schema to a specific user