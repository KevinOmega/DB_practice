DECLARE get_all_movies CURSOR FOR 
SELECT movie_name, movie_length, release_date FROM movies;


DECLARE cur_all_movies_by_year CURSOR FOR (p_year integer)
SELECT  movie_name, movie_length, release_date FROM movies
WHERE extract('year' FROM release_date) = p_year;



-- OPEN A CURSOR


-- Unbound cursor

OPEN cur_all_directors 
FOR
    SELECT first_name, last_name, date_of_birth FROM directors
    WHERE nationality = 'American';

-- Opening with a dinamyc query

my_query := 'SELECT DISTINCT(nationality) FROM directors ORDER BY $1';


OPEN cur_directors_nationality
FOR EXECUTE
    my_query USING sort_field

-- Opening a bound query

OPEN cur_all_movies


OPEN cur_all_movies_by_year ( custom_year := 2010);


-- USING A CURSOR

-- FETCH | MOVE | UPDATE | DELETE

FETCH [ DIRECTION { FROM | IN } ] cursor_name INTO target_variable;

fetch cur_all_movies into row_movie;

-- DIRECTION: NEXT | PRIOR | FIRST | LAST | ABSOLUTE count | RELATIVE count

-- IF YOU ENABLE SCROLL

-- FORWARD | BACKWARD 

-- MOVE is the same as FETCH but without target variable, it just moves the cursor position

MOVE [ DIRECTION { FROM | IN } ] cursor_name;

MOVE cur_all_moviees;

MOVE LAST FROM cur_all_movies;

MOVE relative -1 FROM cur_all_movies;

move forward 4 from cur_all_movies;


-- Update / DELETE

-- UPDATE WHERE CURRENTE  OF or 
-- UPDATE WHERE CURRENT OF 


UPDATE movies
SET YEAR  (release_date) = custom_year
WHERE CURRENT OF cur_all_movies_by_year;



-- CLOSING A CURSOR
-- #############################

CLOSE cursor_variable

-- CLOSE statement releases rosources or frees up cursor variable to allow i to be opened again using open statement

CLOSE cur_all_movies;

OPEN cur_all_movies;


select * from movies order by movie_name;


DO $$
    DECLARE
        output_text text DEFAULT '';

        current_record text := '';

        cur_all_movies CURSOR FOR
        SELECT movie_name, movie_length from movies;
    BEGIN

        OPEN cur_all_movies;

        LOOP
            FETCH cur_all_movies INTO current_record;
            EXIT WHEN NOT FOUND;

            output_text := output_text || ' | ' || current_record;
        END LOOP;
        raise NOTICE 'ALL MOVIES NAMES %', output_text;
    END;
$$;