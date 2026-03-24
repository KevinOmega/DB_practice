-- loop an array inside a procedure

CREATE OR REPLACE FUNCTION process_array(input_array integer[])
RETURNS void AS $$
DECLARE
    element integer;
BEGIN
    FOREACH element IN ARRAY input_array
    LOOP
        -- Process each element (for example, insert into a table)
        RAISE NOTICE 'Processing element: %', element;
        -- You can replace the above line with your actual processing logic
    END LOOP;
END;
$$ LANGUAGE plpgsql;


-- Example of calling the function with an array
SELECT process_array(ARRAY[1, 2, 3, 4, 5]);