CREATE TABLE T1(
    id SERIAL PRIMARY KEY,
    a INTEGER,
    b VARCHAR(32)
)

INSERT INTO T1 (a,b)
SELECT (random()*100) :: INT, 'test1' from generate_series(1,1000000);


EXPLAIN ANALYZE select * from t1 where a = 50;

select * from t1 where a = 50;

SELECT ctid, * from t1 where a = 50 LIMIT 2;