-- VIEWS
-- Views are virtual tables that are defined by a SQL query. They do not store data themselves but provide a way to simplify complex queries and present data in a specific format.

-- USE CASES
-- 1. Simplifying Complex Queries
-- 2. Restricting Access to Specific Data
-- 3. Presenting Data in a Different Format

CREATE OR REPLACE VIEW v_movie_quick AS
SELECT movie_name, movie_length, release_date FROM movies;


SELECT * FROM v_movie_quick;


ALTER VIEW v_movie_quick2 RENAME to v_movie_quick;



SELECT * FROM directors;


-- UPDATABLE VIEWS
-- An updatable view allows you to perform INSERT, UPDATE, and DELETE operations on the view, which will affect the underlying base tables. However, not all views are updatable. For a view to be updatable, it must meet certain criteria, such as having a one-to-one relationship with the underlying table and not containing any aggregate functions or GROUP BY clauses.

DROP VIEW vu_american_directors;



CREATE OR REPLACE VIEW vu_american_directors AS
SELECT first_name,last_name,date_of_birth,nationality from directors
where nationality = 'American'
WITH CHECK OPTION;


INSERT INTO vu_american_directors (first_name, last_name, date_of_birth,nationality) VALUES ('Quentin', 'Tarantino', '1963-03-27','American');

