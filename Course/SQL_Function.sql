CREATE OR REPLACE FUNCTION function_name()
RETURNS void AS 
'
    --- SQL COMMAND
'
LANGUAGE sql;


CREATE OR REPLACE FUNCTION fn_mysum(int,int)
RETURNS int AS 
'
    SELECT $1 + $2;
'
LANGUAGE sql;

SELECT * from fn_mysum(10,20);

CREATE OR REPLACE FUNCTION fn_mysum(int,int)
RETURNS int AS 
$$
    SELECT $1 + $2;
$$
LANGUAGE sql;