-- INSTANCE LEVEL OF SECURITY

-- LOGIN
-- SUPERUSER
-- CREATEROLE
-- CREATEDB
-- REPLICATION
-- 

-- DATABASE LEVEL
-- * CREATE
-- * TEMP/TEMPORARY
-- * CONNECT

-- SCHEMA
-- * CREATE
-- * USAGE

-- TABLE
-- *SELECT
-- * INSERT
-- * DELETE
-- * UPDATE
-- * TRUNCATE
-- * TRIGGER
-- * REFERENCE

-- COLUMN
-- * SELECT
-- * UPDATE
-- * INSERT
-- * REFERENCE

-- ROW LEVEL
-- POLICIES
-- ALTER TABLE tablename ENABLE ROW LEVEL SECURITY
-- After eneabling, default value is Deny All

CREATE POLICY policy_name ON table_name
FOR SELECT | INSERT | UPDATE | DELETE
TO role_name/username
USING (expression)



-- EXAMPLE --


CREATE USER mike  NOSUPERUSER NOCREATEDB NOCREATEROLE LOGIN PASSWORD 'mike_password';
CREATE USER jane  NOSUPERUSER NOCREATEDB NOCREATEROLE LOGIN PASSWORD 'jane_password';

CREATE ROLE hr NOSUPERUSER NOCREATEDB NOCREATEROLE LOGIN;
CREATE ROLE developer NOSUPERUSER NOCREATEDB NOCREATEROLE LOGIN;

GRANT hr TO mike;

GRANT developer TO jane;

ALTER ROLE developer WITH CREATEDB;
GRANT developer TO jane WITH ADMIN OPTION;
ALTER USER jane WITH CREATEDB;

ALTER USER mike NOCREATEDB;

REVOKE ALL ON DATABASE hr FROM public;


GRANT CONNECT on DATABASE hr TO developer;

GRANT CONNECT ON DATABASE hr TO hr;

GRANT CREATE ON DATABASE hr TO developer;

GRANT USAGE ON SCHEMA public TO hr;

GRANT SELECT ON TABLE public.dev_test TO hr;

GRANT INSERT ON TABLE public.dev_test TO hr;

REVOKE USAGE ON SCHEMA public FROM hr;



REVOKE SELECT ON TABLE public.dev_test FROM hr;

GRANT SELECT (country_name, country_id) ON TABLE countries TO hr;

GRANT SELECT on table jobs to hr;

ALTER TABLE jobs ENABLE ROW LEVEL SECURITY;

CREATE POLICY job_max_salary_policy_hr ON jobs
for SELECT
TO hr
USING (max_salary <= 10000);

CREATE POLICY p_job_min_salary_limit ON jobs
AS RESTRICTIVE
FOR SELECT
TO hr
using (min_salary > 4000);

DROP POLICY p_job_min_salary_limit ON jobs;

CREATE TABLE test_table (
    id SERIAL PRIMARY KEY,
    username VARCHAR(30),
    tag VARCHAR(30)
);


INSERT INTO test_table (username,tag) VALUES
('jane', 'tag12'),
('jane', 'tag8'),
('jane', 'tag9'),
('jane', 'tag10'),
('mike', 'tag1'),
('mike', 'tag2'),
('mike', 'tag3');

CREATE POLICY p_select_username ON test_table
for all to PUBLIC
using (username = CURRENT_USER);


CREATE POLICY p_select_rol ON test_table
FOR ALL TO public
using (username = current_setting('rls.username'));

ALTER TABLE test_table ENABLE ROW LEVEL SECURITY;
GRANT SELECT ON table test_table TO PUBLIC;


-- DELETE A POLICY 

DROP POLICY IF EXISTS 

