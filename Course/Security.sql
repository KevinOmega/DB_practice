-- POSTGRES SECURITY
-- Roles are everyghing

-- 6 levels of security in PostgreSQL

-- 1 INSTANCE
-- 2 DATABASE
-- 3 SCHEMA
-- 4 TABLE
-- 5 COLUMN
-- 6 ROW


-- INSTANCE LEVEL SECURITY
-- At the instance level, security is managed through roles and permissions. Roles can be assigned to users and groups, and permissions can be granted or revoked on various database objects. This allows for fine-grained control over who can access what within the PostgreSQL instance.


-- CAN BE ASSIGN WITH
    -- SUPERUSER: This role has all privileges and can perform any action on the database. It is typically reserved for database administrators.
    -- CREATEDB: This role allows the user to create new databases within the PostgreSQL instance.
    -- CREATEROLE: This role allows the user to create, alter, and drop roles within the PostgreSQL instance.
    -- REPLICATION: This role allows the user to initiate streaming replication and manage replication slots.
    -- BYPASSRLS: This role allows the user to bypass row-level security policies, giving them access to all rows in a table regardless of any RLS policies that may be in place.
    -- LOGIN: This role allows the user to log in to the PostgreSQL instance. Without this role, a user cannot connect to the database.

-- NOTE: Using NO means no access i.e. 'NOSUPERUSER'

CREATE ROLE hr NOSUPERUSER NOCREATEDB NOCREATEROLE NOREPLICATION NOLOGIN;


CREATE ROLE developer NOSUPERUSER NOCREATEDB NOCREATEROLE NOREPLICATION NOLOGIN;

CREATE ROLE sales NOSUPERUSER NOCREATEDB NOCREATEROLE NOREPLICATION LOGIN;
CREATE ROLE mike NOSUPERUSER NOCREATEDB NOCREATEROLE NOREPLICATION LOGIN; 

CREATE USER mike NOSUPERUSER NOCREATEDB NOCREATEROLE NOREPLICATION LOGIN PASSWORD 'mike_password';
CREATE USER jane NOSUPERUSER NOCREATEDB NOCREATEROLE NOREPLICATION LOGIN PASSWORD 'jane_password';

--  BY DEFAULT ALL USERS CAN ENTER TO ANY DATABASE IN THE INSTANCE, Because public schema by default has USAGE and CREATE privileges for all users, which allows them to access and create objects in the public schema of any database. To restrict access to specific databases, you can revoke the CONNECT privilege on those databases from the public role or specific users.
-- To avoid this, you can revoke the CONNECT privilege on the database from the public role or specific users. For example, to revoke CONNECT privilege on a database named 'my_database' from the public role, you can use the following command:

REVOKE ALL ON DATABASE learning_db FROM public;

-- ADD USERS TO ROLES

GRANT hr TO mike;
GRANT developer TO jane;


-- DATABASE LEVEL SECURITY
-- At the database level, security is managed through database-level permissions. Users can be granted or revoked permissions to connect to a database, create objects within the database, and perform various actions on the database. This allows for control over who can access and modify the database and its objects.

-- Can be assigned with
    -- CONNECT: This permission allows a user to connect to a specific database. Without this permission, a user cannot access the database.
    -- CREATE: This permission allows a user to create new objects (such as schemas, tables, views, etc.) within the database.
    -- TEMPORARY: This permission allows a user to create temporary tables within the database.
    -- ALL: This permission grants all available permissions on the database to the user.

GRANT CONNECT ON DATABASE learning_db TO hr;
GRANT CONNECT ON DATABASE learning_db TO developer;


GRANT CREATE ON DATABASE learning_db TO developer;


-- SCHEMA LEVEL SECURITY
-- At the schema level, security is managed through schema-level permissions. Users can be granted or revoked permissions to access and create objects within a specific schema. This allows for control over who can access and modify the objects within a particular schema.


/*
    CREATE      : Allows a user to create new objects (such as tables, views, functions, etc.) within the schema.
    USAGE       : Allows a user to access objects within the schema, but does not allow them to create new objects. This permission is necessary for a user to be able to use any objects
*/

-- By default all users have USAGE and CREATE privileges on the public schema

REVOKE ALL ON SCHEMA public FROM public; -- to revoke all privileges on the public schema from all users


GRANT USAGE ON SCHEMA public TO hr; -- to grant usage privilege on the hr schema to the hr role


GRANT USAGE ON SCHEMA public TO developer; -- to grant usage privilege on the hr schema to the developer role


GRANT CREATE ON SCHEMA public TO developer;


-- TABLE LEVEL SECURITY
-- At the table level, security is managed through table-level permissions. Users can be granted or revoked permissions to access and modify specific tables within a schema. This allows for control over who can read, write, and modify data in specific tables.


/*

    SELECT      : Allows a user to read data from a table.
    INSERT      : Allows a user to insert new rows into a table.
    UPDATE      : Allows a user to modify existing rows in a table.
    DELETE      : Allows a user to delete rows from a table.
    TRUNCATE     : Allows a user to truncate a table, which removes all rows from the table without logging individual row deletions.
    REFERENCES   : Allows a user to create foreign key constraints that reference the table.
    TRIGGER      : Allows a user to create triggers on the table.
    ALL          : This permission grants all available permissions on the table to the user.

*/


GRANT ALL ON ALL TABLES IN SCHEMA public TO developer; -- to grant all privileges on all tables in the public schema to the developer role


GRANT SELECT ON employees TO hr;

GRANT INSERT on employees TO hr;

REVOKE insert ON employees FROM hr; -- to revoke all privileges on the employees table from the hr role


-- COLUMN LEVEL SECURITY
-- At the column level, security is managed through column-level permissions. Users can be granted or revoked permissions to access and modify specific columns within a table. This allows for control over who can read, write, and modify data in specific columns of a table.


/*

    SELECT      : Allows a user to read data from a specific column in a table.
    INSERT      : Allows a user to insert new values into a specific column when inserting new rows into the table.
    UPDATE      : Allows a user to modify existing values in a specific column when updating rows in the table.
    ALL          : This permission grants all available permissions on the specified column to the user.

*/


-- GRANT permision_name (col1, col2,...) ON table_name TO role_name; -- to grant specific permissions on specific columns of a table to a role

REVOKE SELECT ON ALL TABLES IN SCHEMA public FROM hr; -- to revoke all privileges on all tables in the public schema from the hr role

GRANT SELECT (firstname) ON employees TO hr; -- to grant select privilege on the firstname column of the employees table to the hr role