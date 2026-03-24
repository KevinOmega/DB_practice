-- INDEXES
-- indexes are used to speed up the retrieval of data from a database table. They work by creating a data structure that allows for faster searching and sorting of the data. When a query is executed, the database engine can use the index to quickly locate the relevant rows in the table, rather than having to scan through the entire table.
-- In the context of a course, indexes can be used to optimize queries that involve searching for specific information, such as student records, course materials, or grades. For example, an index on the student ID column in a student records table can speed up queries that search for a specific student by their ID number. Similarly, an index on the course name column in a course materials table can speed up queries that search for materials related to a specific course.
-- However, it's important to note that while indexes can improve query performance, they can also slow down data modification operations (such as INSERT, UPDATE, DELETE) because the index needs to be updated whenever the underlying data changes. Therefore, it's important to carefully consider which columns to index based on the specific queries that will be run against the database.

-- TWO MAIN TYPES OF INDEXES
-- 1. INDEX               Create an index on one or more columns of a table.
-- 2. UNIQUE INDEX        Create a unique index on only UNIQUE values of a column or a set of columns.

CREATE INDEX index_name
ON table_name(col1, col2, .......);

CREATE UNIQUE INDEX index_name
ON table_name(col1, col2, .......);

CREATE INDEX index_name ON table_name [USING method]
(
    column_name [ASC | DESC] [NULLS {FIRST | LAST}],
    ...
)

-- Try to keep the naming convention of indexes unique and globally accesible e.g.


INDEX           CREATE INDEX idx_table_name_column_name_col2,
UNIQUE INDEX    CREATE UNIQUE INDEX idx_u_table_name_column_name_col2


-- Lets create some indexes

CREATE INDEX idx_order_order_id ON orders(order_id);

CREATE INDEX idx_orders_ship_city ON orders(ship_city);

CREATE INDEX idx_orders_customer_id_order_id ON orders(customer_id, order_id);

-- WHEN creating an index of two or more columns, the order of the columns in the index matters. The index will be most effective when the query filters on the leading column(s) of the index. For example, if you have an index on (customer_id, order_id), it will be most effective for queries that filter on customer_id, and less effective for queries that filter only on order_id.

-- This is because the database engine can use the index to quickly locate the relevant rows based on the leading column (customer_id), but if the query only filters on order_id, the engine may not be able to efficiently use the index, as it would have to scan through all entries for that order_id regardless of the customer_id. Therefore, it's important to consider the most common query patterns when creating indexes on multiple columns.


-- CREATE UNIQUE INDEX
-- A unique index ensures that the values in the indexed column(s) are unique across the table. This means that no two rows can have the same value in the indexed column(s). Unique indexes are often used to enforce data integrity and to ensure that certain columns (such as primary keys or email addresses) do not contain duplicate values.

CREATE UNIQUE INDEX idx_u_employees_home_phone ON employees(home_phone);


-- SELECTING INDEXES

SELECT * from pg_indexes;

SELECT * FROM pg_indexes where schemaname = 'public';

SELECT * FROM pg_indexes where schemaname = 'public' and tablename = 'orders';


SELECT
    schemaname,
    tablename,
    indexname,
    indexdef
FROM pg_indexes
WHERE schemaname NOT IN ('pg_catalog', 'information_schema')
ORDER BY schemaname, tablename, indexname;

-- SIZE OF INDEXES

SELECT pg_size_pretty(pg_indexes_size('public.orders'));


-- STATS ON INDEXES

SELECT * FROM pg_stat_all_indexes;


SELECT * FROM pg_stat_all_indexes where schemaname = 'public';

SELECT * FROM pg_stat_all_indexes where relname = 'orders';


-- STAGES OF QUERY EXECUTION
-- 1. Parsing: The database engine parses the SQL query to check for syntax errors and to create an internal representation of the query.
-- 2. Rewriting: The database engine may rewrite the query to optimize it, such as by simplifying expressions or by transforming subqueries into joins.
-- 3. Optimizer: The database engine generates multiple execution plans for the query and estimates the cost of each plan based on factors such as the size of the tables, the presence of indexes, and the selectivity of the filters. The optimizer then selects the most efficient execution plan.
-- 4. Execution: The database engine executes the selected execution plan, which may involve scanning tables, using indexes, performing joins, and applying filters to retrieve the desired results.

-- QUERY OPTIMIZER

-- Thread: Since Postgres >= 9.6, the query optimizer can use multiple CPU cores to execute a query in parallel, which can significantly improve performance for large queries.

-- Nodes: The query optimizer generates a query execution plan that consists of a series of nodes, each representing a specific operation (e.g., scan, join, aggregate). The optimizer estimates the cost of each node based on factors such as the number of rows processed and the presence of indexes.
-- Node eg:
-- SELECT * FROM orders ORDER BY order_date DESC;
-- The query optimizer might generate a plan that includes a "Seq Scan" node to scan the orders table, followed by a "Sort" node to sort the results by order_date in descending order.

-- Node types

-- 1. Seq Scan:
--  A sequential scan of a table, which reads all rows in the table, this type of scan is used when no index is available or when the query does not filter on indexed columns.
    -- Example: SELECT * FROM orders;

SELECT * FROM public.orders;

    EXPLAIN SELECT * FROM public.orders where ship_city <> 'Reims';
     EXPLAIN SELECT * FROM public.orders;

-- 2. Index NODE:
--  A scan of a table using an index, which can be much faster than a sequential scan when the query filters on indexed columns.
    -- TYPES
    -- 2.1. Index Scan: A scan of a table using an index, which can be much faster than a sequential scan when the query filters on indexed columns.
        -- Example: SELECT * FROM orders WHERE customer_id = 123;
    -- 2.2. Index Only Scan: A scan of a table using an index that can return all the required data without having to access the underlying table, this is possible when the index contains all the columns needed for the query.
        -- Example: SELECT customer_id FROM orders WHERE order_id = 123; (assuming customer_id is included in the index)
    -- 2.3. Bitmap Index Scan: A scan of a table using a bitmap index, which can be more efficient than a regular index scan when the query filters on multiple indexed columns.
        -- Example: SELECT * FROM orders WHERE customer_id = 123 AND order_date > '2023-01-01'; (assuming there are indexes on both customer_id and order_date)




EXPLAIN SELECT * FROM public.orders where order_id = 123;

EXPLAIN SELECT order_id FROM public.orders where order_id = 123;

-- 3. Join Nodes:
--  A join operation that combines rows from two or more tables based on a related column between them. The query optimizer can choose from different join algorithms (e.g., nested loop, hash join, merge join) based on the size of the tables and the presence of indexes.
    -- HASH JOIN
    -- inner join  Builds a hash table on the smaller table and then probes the hash table for each row in the larger table.
    -- outer join  Then checks the outer table for any unmatched rows and includes them in the result set.
    
EXPLAIN SELECT * FROM orders o JOIN customers c ON o.customer_id = c.customer_id;


-- HASH JOIN
-- The query optimizer might choose a hash join if the orders table is small and the customers table is large, and there is an index on the customer_id column in the customers table. The optimizer would build a hash table on the orders table and then probe the hash table for each row in the customers table to find matching rows based on the customer_id column.

EXPLAIN SELECT * FROM public.orders ord where customer_id IN (SELECT customer_id FROM public.customers)

EXPLAIN (FORMAT JSON) SELECT * FROM public.orders where order_id = 1;


EXPLAIN ANALYZE SELECT * FROM public.orders where order_id = 1;
-- 

-- QUERY COST MODEL

CREATE TABLE big_table (
    id SERIAL PRIMARY KEY,
    data TEXT
);

INSERT INTO big_table (data)
SELECT 'Sample data ' || generate_series(1, 1000000);

INSERT INTO big_table (data)
SELECT 'ADAM' || generate_series(1, 1000000);




EXPLAIN SELECT * FROM big_table where id = '2000';

show max_parallel_workers_per_gather;

set max_parallel_workers_per_gather = 2;

-- RELATION SIZE
-- The size of a relation (table) can impact the query cost, as larger tables may require more time to scan and retrieve data. The query optimizer takes into account the size of the relation when estimating the cost of different execution plans.

SELECT pg_relation_size('public.big_table') / 8192.0;
-- 11775

-- SEQUENTIAL PAGE COST
-- The sequential page cost is a parameter that represents the cost of reading a page of data from disk. The default value is typically set to 1.0, but it can be adjusted based on the performance characteristics of the storage system. A higher sequential page cost can make the optimizer more likely to choose index scans over sequential scans.

SHOW seq_page_cost;
-- 1.0

-- CPU TUPLE COST
-- The CPU tuple cost is a parameter that represents the cost of processing a single row of data in memory. The default value is typically set to 0.01, but it can be adjusted based on the performance characteristics of the CPU. A higher CPU tuple cost can make the optimizer more likely to choose plans that minimize the number of rows processed.
SHOW cpu_tuple_cost;
-- 0.01

-- CPU OPERATOR COST
-- The CPU operator cost is a parameter that represents the cost of executing an operator (e.g., a join or a filter) in memory. The default value is typically set to 0.0025, but it can be adjusted based on the performance characteristics of the CPU. A higher CPU operator cost can make the optimizer more likely to choose plans that minimize the number of operators executed.
SHOW cpu_operator_cost;
-- 0.0025

SELECT COUNT(*) FROM big_table;

-- COST FORMULA
pg_relation_size * seq_page_cost + total_number_of_table_rows * cpu_tuple_cost
+ total_number_of_table_rows * cpu_operator_cost

SELECT 11775 * 1.0 + 2000000 * 0.01 + 2000000 * 0.0025;
-- 36775.0000

EXPLAIN (FORMAT JSON) SELECT * FROM big_table ;


CREATE INDEX idx_big_table_id ON big_table(id);