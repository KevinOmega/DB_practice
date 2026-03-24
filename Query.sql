select * from unicen.reportes_estudiantes_notas_deudas66(106,112,1)

select * from unicen.reportes_estudiantes_notas_deudas(106,83,1)

EXPLAIN ANALYZE

select * from unicen.reportes_estudiantes_notas_deudas(106,112,1);


CREATE OR REPLACE FUNCTION unicen.reportes_estudiantes_notas_deudas(idge integer, idplan integer, idsd integer)
 RETURNS TABLE(car character varying, unic integer, pat character varying, matern character varying, nom character varying, sem integer, codmat character varying, mat character varying, pp double precision, sp double precision, ef double precision, nfr double precision, si double precision, ma double precision, nf double precision, est character varying, matri character varying, adm1 double precision, pacon1 double precision, reint1 double precision, matr1 double precision, c1 double precision, c2 double precision, c3 double precision, c4 double precision, c5 double precision, recur5 double precision, turn character varying, pleco1 character varying, can text)
 LANGUAGE plpgsql
AS $function$
declare	
idord integer;
BEGIN

SELECT ord INTO idord
    FROM unicen.gestion
    WHERE id_gestion = idge;
	RAISE NOTICE 'El valor de idord es: %', idord;

RETURN QUERY

WITH estudiantes_activos AS (
    SELECT nt.unicodigo, nt.id_plan_estudio, nt.id_materia, nt.pp, nt.sp, nt.ef, nt.nfr, nt.si, nt.ma, nt.nf, nt.estnota,
           nt.id_turno, nt.id_gestion
    FROM unicen.nota nt
    WHERE nt.id_sede = idsd AND nt.id_gestion = idge AND nt.id_plan_estudio = idplan AND nt.est = 'ACTIVO'
),
clasificacion_ingreso AS (
    SELECT 
        nt2.unicodigo,
        nt2.id_plan_estudio,
        CASE
            WHEN COUNT(DISTINCT nt2.id_gestion) = 1 THEN 'NUEVO'
            WHEN COUNT(DISTINCT nt2.id_gestion) > 1 THEN 'ANTIGUO'
            ELSE 'SIN DATOS'
        END AS nueant
    FROM unicen.nota nt2
    INNER JOIN unicen.gestion gs2 ON nt2.id_gestion = gs2.id_gestion
    WHERE nt2.id_sede = idsd AND gs2.ord <= idord AND nt2.id_plan_estudio = idplan AND nt2.est = 'ACTIVO'
    GROUP BY nt2.unicodigo, nt2.id_plan_estudio
),
deudas_agrupadas AS (
    SELECT unicodigo,
           MAX(CASE WHEN id_item_seguimiento = 52 THEN monto_deuda END) AS adm1,
           MAX(CASE WHEN id_item_seguimiento = 53 THEN monto_deuda END) AS pacon1,
           MAX(CASE WHEN id_item_seguimiento = 54 THEN monto_deuda END) AS reint1,
           MAX(CASE WHEN id_item_seguimiento = 13 THEN monto_deuda END) AS matr1,
           MAX(CASE WHEN id_item_seguimiento = 1 THEN monto_deuda END) AS c1,
           MAX(CASE WHEN id_item_seguimiento = 2 THEN monto_deuda END) AS c2,
           MAX(CASE WHEN id_item_seguimiento = 3 THEN monto_deuda END) AS c3,
           MAX(CASE WHEN id_item_seguimiento = 4 THEN monto_deuda END) AS c4,
           MAX(CASE WHEN id_item_seguimiento = 5 THEN monto_deuda END) AS c5,
           MAX(CASE WHEN id_item_seguimiento = 16 THEN monto_deuda END) AS recur5
    FROM unicen.deudas_contable
    WHERE id_sede = idsd AND id_gestion = idge
    GROUP BY unicodigo
),
est AS (
	select est.unicodigo, est.paterno, est.materno, est.nombres, est.matricula,est.id_sede FROM unicen.estudiante est
),
careco AS (
	select careco.unicodigo, careco.id_plan_estudio, careco.id_plan_economico from unicen.estudiantecareco careco
),
pest AS (
	select pest.id_plan_estudio, pest.id_sede, pest.id_carrera from unicen.plan_estudio pest
)

SELECT 
    car.nombre AS car,
    est.unicodigo AS unic,
    est.paterno AS pat,
    est.materno AS matern,
    est.nombres AS nom,
    pl.id_nivel AS sem,
    mat.cod_materia AS codmat,
    mat.nombre AS mat,
    ea.pp, ea.sp, ea.ef, ea.nfr, ea.si, ea.ma, ea.nf, ea.estnota AS est,
    est.matricula AS matri,
    da.adm1, da.pacon1, da.reint1, da.matr1,
    da.c1, da.c2, da.c3, da.c4, da.c5, da.recur5,
    tur.nombre AS turn,
    pleco.nombre AS pleco1,
    ci.nueant AS can
FROM estudiantes_activos ea
INNER JOIN est ON est.unicodigo = ea.unicodigo AND est.id_sede = idsd
INNER JOIN careco ON careco.unicodigo = est.unicodigo AND careco.id_plan_estudio = ea.id_plan_estudio
INNER JOIN clasificacion_ingreso ci ON ci.unicodigo = ea.unicodigo AND ci.id_plan_estudio = ea.id_plan_estudio
INNER JOIN unicen.plan_economico pleco ON careco.id_plan_economico = pleco.id_plan_economico AND pleco.id_sede = idsd
INNER JOIN unicen.plan_estudio pest ON ea.id_plan_estudio = pest.id_plan_estudio AND pest.id_sede = idsd
INNER JOIN unicen.plan_materia pl ON pest.id_plan_estudio = pl.id_plan_estudio AND ea.id_materia = pl.id_materia AND pl.id_sede = idsd
INNER JOIN unicen.materia mat ON ea.id_materia = mat.id_materia AND mat.id_sede = idsd
INNER JOIN unicen.carrera car ON pest.id_carrera = car.id_carrera AND car.id_sede = idsd
INNER JOIN unicen.turno tur ON ea.id_turno = tur.id_turno
LEFT JOIN deudas_agrupadas da ON ea.unicodigo = da.unicodigo
-- WHERE ea.id_turno IN (SELECT tur.id_turno, tur.nombre from unicen.turno WHERE tur.id_turno == ea.id_turno)
ORDER BY car.nombre, est.paterno, est.materno;

END;
$function$




CREATE OR REPLACE FUNCTION unicen.reportes_estudiantes_notas_deudas(
    idge integer,
    idplan integer,
    idsd integer
)
RETURNS TABLE(
    car varchar,
    unic integer,
    pat varchar,
    matern varchar,
    nom varchar,
    sem integer,
    codmat varchar,
    mat varchar,
    pp double precision,
    sp double precision,
    ef double precision,
    nfr double precision,
    si double precision,
    ma double precision,
    nf double precision,
    est varchar,
    matri varchar,
    adm1 double precision,
    pacon1 double precision,
    reint1 double precision,
    matr1 double precision,
    c1 double precision,
    c2 double precision,
    c3 double precision,
    c4 double precision,
    c5 double precision,
    recur5 double precision,
    turn varchar,
    pleco1 varchar,
    can text
)
LANGUAGE plpgsql
AS $$
DECLARE
    idord integer;
BEGIN
    SELECT ord INTO idord
    FROM unicen.gestion
    WHERE id_gestion = idge;
    RAISE NOTICE 'El valor de idord es: %', idord;

    RETURN QUERY
    SELECT
        car.nombre,
        est.unicodigo,
        est.paterno,
        est.materno,
        est.nombres,
        pl.id_nivel,
        mat.cod_materia,
        mat.nombre,
        nt.pp, nt.sp, nt.ef, nt.nfr, nt.si, nt.ma, nt.nf,
        nt.estnota,
        est.matricula,

        MAX(CASE WHEN id_item_seguimiento = 52 THEN monto_deuda END) AS adm1,
        MAX(CASE WHEN id_item_seguimiento = 53 THEN monto_deuda END) AS pacon1,
        MAX(CASE WHEN id_item_seguimiento = 54 THEN monto_deuda END) AS reint1,
        MAX(CASE WHEN id_item_seguimiento = 13 THEN monto_deuda END) AS matr1,
        MAX(CASE WHEN id_item_seguimiento = 1 THEN monto_deuda END) AS c1,
        MAX(CASE WHEN id_item_seguimiento = 2 THEN monto_deuda END) AS c2,
        MAX(CASE WHEN id_item_seguimiento = 3 THEN monto_deuda END) AS c3,
        MAX(CASE WHEN id_item_seguimiento = 4 THEN monto_deuda END) AS c4,
        MAX(CASE WHEN id_item_seguimiento = 5 THEN monto_deuda END) AS c5,
        MAX(CASE WHEN id_item_seguimiento = 16 THEN monto_deuda END) AS recur5,

        tur.nombre,
        pleco.nombre,

        CASE
            WHEN COUNT(DISTINCT nt2.id_gestion) = 1 THEN 'NUEVO'
            ELSE 'ANTIGUO'
        END
    FROM unicen.nota nt
    INNER JOIN unicen.estudiante est
        ON est.unicodigo = nt.unicodigo AND est.id_sede = idsd
    INNER JOIN unicen.estudiantecareco careco
        ON careco.unicodigo = nt.unicodigo
        AND careco.id_plan_estudio = nt.id_plan_estudio
    INNER JOIN unicen.plan_economico pleco
        ON pleco.id_plan_economico = careco.id_plan_economico
        AND pleco.id_sede = idsd
    INNER JOIN unicen.plan_estudio pest
        ON pest.id_plan_estudio = nt.id_plan_estudio
        AND pest.id_sede = idsd
    INNER JOIN unicen.plan_materia pl
        ON pl.id_plan_estudio = pest.id_plan_estudio
        AND pl.id_materia = nt.id_materia
        AND pl.id_sede = idsd
    INNER JOIN unicen.materia mat
        ON mat.id_materia = nt.id_materia
        AND mat.id_sede = idsd
    INNER JOIN unicen.carrera car
        ON car.id_carrera = pest.id_carrera
        AND car.id_sede = idsd
    INNER JOIN unicen.turno tur
        ON tur.id_turno = nt.id_turno
    LEFT JOIN unicen.deudas_contable dc
        ON dc.unicodigo = nt.unicodigo
        AND dc.id_sede = idsd
        AND dc.id_gestion = idge
    LEFT JOIN unicen.nota nt2
        ON nt2.unicodigo = nt.unicodigo
        AND nt2.id_plan_estudio = nt.id_plan_estudio
        AND nt2.id_sede = idsd
        AND nt2.est = 'ACTIVO'
        AND nt2.id_gestion <= idge
    WHERE nt.id_sede = idsd
      AND nt.id_gestion = idge
      AND nt.id_plan_estudio = idplan
      AND nt.est = 'ACTIVO'
    GROUP BY
        car.nombre, est.unicodigo, est.paterno, est.materno, est.nombres,
        pl.id_nivel, mat.cod_materia, mat.nombre,
        nt.pp, nt.sp, nt.ef, nt.nfr, nt.si, nt.ma, nt.nf, nt.estnota,
        est.matricula, tur.nombre, pleco.nombre
    ORDER BY car.nombre, est.paterno, est.materno;

END;
$$;


-- OLD QUERY
-- QUERY PLAN	Function Scan on reportes_estudiantes_notas_deudas (cost=0.25..10.25 rows=1000 width=496) (actual time=47978.739..47978.794 rows=1481 loops=1)
-- QUERY PLAN	Planning Time: 0.034 ms
-- QUERY PLAN	Execution Time: 47978.868 ms



WITH estudiantes_activos AS (
    SELECT nt.unicodigo, nt.id_plan_estudio, nt.id_materia, nt.pp, nt.sp, nt.ef, nt.nfr, nt.si, nt.ma, nt.nf, nt.estnota,
           nt.id_turno, nt.id_gestion
    FROM unicen.nota nt
    WHERE nt.id_sede = idsd AND nt.id_gestion = idge AND nt.id_plan_estudio = idplan AND nt.est = 'ACTIVO'
),
clasificacion_ingreso AS (
    SELECT 
        nt2.unicodigo,
        nt2.id_plan_estudio,
        CASE
            WHEN COUNT(DISTINCT nt2.id_gestion) = 1 THEN 'NUEVO'
            WHEN COUNT(DISTINCT nt2.id_gestion) > 1 THEN 'ANTIGUO'
            ELSE 'SIN DATOS'
        END AS nueant
    FROM unicen.nota nt2
    INNER JOIN unicen.gestion gs2 ON nt2.id_gestion = gs2.id_gestion
    WHERE nt2.id_sede = idsd AND gs2.ord <= idord AND nt2.id_plan_estudio = idplan AND nt2.est = 'ACTIVO'
    GROUP BY nt2.unicodigo, nt2.id_plan_estudio
),
deudas_agrupadas AS (
    SELECT unicodigo,
           MAX(CASE WHEN id_item_seguimiento = 52 THEN monto_deuda END) AS adm1,
           MAX(CASE WHEN id_item_seguimiento = 53 THEN monto_deuda END) AS pacon1,
           MAX(CASE WHEN id_item_seguimiento = 54 THEN monto_deuda END) AS reint1,
           MAX(CASE WHEN id_item_seguimiento = 13 THEN monto_deuda END) AS matr1,
           MAX(CASE WHEN id_item_seguimiento = 1 THEN monto_deuda END) AS c1,
           MAX(CASE WHEN id_item_seguimiento = 2 THEN monto_deuda END) AS c2,
           MAX(CASE WHEN id_item_seguimiento = 3 THEN monto_deuda END) AS c3,
           MAX(CASE WHEN id_item_seguimiento = 4 THEN monto_deuda END) AS c4,
           MAX(CASE WHEN id_item_seguimiento = 5 THEN monto_deuda END) AS c5,
           MAX(CASE WHEN id_item_seguimiento = 16 THEN monto_deuda END) AS recur5
    FROM unicen.deudas_contable
    WHERE id_sede = idsd AND id_gestion = idge
    GROUP BY unicodigo
),
est AS (
	select est.unicodigo, est.paterno, est.materno, est.nombres, est.matricula,est.id_sede FROM unicen.estudiante est
),
careco AS (
	select careco.unicodigo, careco.id_plan_estudio, careco.id_plan_economico from unicen.estudiantecareco careco
),
pest AS (
	select pest.id_plan_estudio, pest.id_sede, pest.id_carrera from unicen.plan_estudio pest
)

SELECT 
    car.nombre AS car,
    est.unicodigo AS unic,
    est.paterno AS pat,
    est.materno AS matern,
    est.nombres AS nom,
    pl.id_nivel AS sem,
    mat.cod_materia AS codmat,
    mat.nombre AS mat,
    ea.pp, ea.sp, ea.ef, ea.nfr, ea.si, ea.ma, ea.nf, ea.estnota AS est,
    est.matricula AS matri,
    da.adm1, da.pacon1, da.reint1, da.matr1,
    da.c1, da.c2, da.c3, da.c4, da.c5, da.recur5,
    tur.nombre AS turn,
    pleco.nombre AS pleco1,
    ci.nueant AS can
FROM estudiantes_activos ea
INNER JOIN est ON est.unicodigo = ea.unicodigo AND est.id_sede = idsd
INNER JOIN careco ON careco.unicodigo = est.unicodigo AND careco.id_plan_estudio = ea.id_plan_estudio
INNER JOIN clasificacion_ingreso ci ON ci.unicodigo = ea.unicodigo AND ci.id_plan_estudio = ea.id_plan_estudio
INNER JOIN unicen.plan_economico pleco ON careco.id_plan_economico = pleco.id_plan_economico AND pleco.id_sede = idsd
INNER JOIN unicen.plan_estudio pest ON ea.id_plan_estudio = pest.id_plan_estudio AND pest.id_sede = idsd
INNER JOIN unicen.plan_materia pl ON pest.id_plan_estudio = pl.id_plan_estudio AND ea.id_materia = pl.id_materia AND pl.id_sede = idsd
INNER JOIN unicen.materia mat ON ea.id_materia = mat.id_materia AND mat.id_sede = idsd
INNER JOIN unicen.carrera car ON pest.id_carrera = car.id_carrera AND car.id_sede = idsd
INNER JOIN unicen.turno tur ON ea.id_turno = tur.id_turno
LEFT JOIN deudas_agrupadas da ON ea.unicodigo = da.unicodigo
-- WHERE ea.id_turno IN (SELECT tur.id_turno, tur.nombre from unicen.turno WHERE tur.id_turno == ea.id_turno)
ORDER BY car.nombre, est.paterno, est.materno;




EXPLAIN ANALYZE
SELECT 
        nt2.unicodigo,
        nt2.id_plan_estudio,
        CASE
            WHEN COUNT(DISTINCT nt2.id_gestion) = 1 THEN 'NUEVO'
            WHEN COUNT(DISTINCT nt2.id_gestion) > 1 THEN 'ANTIGUO'
            ELSE 'SIN DATOS'
        END AS nueant
    FROM unicen.nota nt2
    INNER JOIN unicen.gestion gs2 ON nt2.id_gestion = gs2.id_gestion
    WHERE nt2.id_sede = 1 AND gs2.ord <= 106 AND nt2.id_plan_estudio = 112 AND nt2.est = 'ACTIVO'
    GROUP BY nt2.unicodigo, nt2.id_plan_estudio

CREATE OR REPLACE FUNCTION unicen.reportes_estudiantes_notas_deudas(
    idge integer,
    idplan integer,
    idsd integer
)
RETURNS TABLE(
    car varchar,
    unic integer,
    pat varchar,
    matern varchar,
    nom varchar,
    sem integer,
    codmat varchar,
    mat varchar,
    pp double precision,
    sp double precision,
    ef double precision,
    nfr double precision,
    si double precision,
    ma double precision,
    nf double precision,
    est varchar,
    matri varchar,
    adm1 double precision,
    pacon1 double precision,
    reint1 double precision,
    matr1 double precision,
    c1 double precision,
    c2 double precision,
    c3 double precision,
    c4 double precision,
    c5 double precision,
    recur5 double precision,
    turn varchar,
    pleco1 varchar,
    can text
)
LANGUAGE plpgsql
AS $$
DECLARE
    idord integer;
BEGIN
    SELECT ord
    INTO idord
    FROM unicen.gestion
    WHERE id_gestion = idge;

    RETURN QUERY
    WITH estudiantes_activos AS NOT MATERIALIZED (
        SELECT
            nt.unicodigo,
            nt.id_plan_estudio,
            nt.id_materia,
            nt.pp, nt.sp, nt.ef, nt.nfr, nt.si, nt.ma, nt.nf,
            nt.estnota,
            nt.id_turno
        FROM unicen.nota nt
        WHERE nt.id_sede = idsd
          AND nt.id_gestion = idge
          AND nt.id_plan_estudio = idplan
          AND nt.est = 'ACTIVO'
    ),
    clasificacion_ingreso AS MATERIALIZED (
        SELECT 
            nt2.unicodigo,
            nt2.id_plan_estudio,
            CASE
                WHEN COUNT(DISTINCT nt2.id_gestion) = 1 THEN 'NUEVO'
                WHEN COUNT(DISTINCT nt2.id_gestion) > 1 THEN 'ANTIGUO'
                ELSE 'SIN DATOS'
            END AS nueant
        FROM unicen.nota nt2
        INNER JOIN unicen.gestion gs2
            ON gs2.id_gestion = nt2.id_gestion
        WHERE nt2.id_sede = idsd
          AND gs2.ord <= idord
          AND nt2.id_plan_estudio = idplan
          AND nt2.est = 'ACTIVO'
        GROUP BY nt2.unicodigo, nt2.id_plan_estudio
    ),
    deudas_agrupadas AS MATERIALIZED (
        SELECT
            unicodigo,
            MAX(monto_deuda) FILTER (WHERE id_item_seguimiento = 52) AS adm1,
            MAX(monto_deuda) FILTER (WHERE id_item_seguimiento = 53) AS pacon1,
            MAX(monto_deuda) FILTER (WHERE id_item_seguimiento = 54) AS reint1,
            MAX(monto_deuda) FILTER (WHERE id_item_seguimiento = 13) AS matr1,
            MAX(monto_deuda) FILTER (WHERE id_item_seguimiento = 1) AS c1,
            MAX(monto_deuda) FILTER (WHERE id_item_seguimiento = 2) AS c2,
            MAX(monto_deuda) FILTER (WHERE id_item_seguimiento = 3) AS c3,
            MAX(monto_deuda) FILTER (WHERE id_item_seguimiento = 4) AS c4,
            MAX(monto_deuda) FILTER (WHERE id_item_seguimiento = 5) AS c5,
            MAX(monto_deuda) FILTER (WHERE id_item_seguimiento = 16) AS recur5
        FROM unicen.deudas_contable
        WHERE id_sede = idsd
          AND id_gestion = idge
        GROUP BY unicodigo
    )
    SELECT
        car.nombre,
        est.unicodigo,
        est.paterno,
        est.materno,
        est.nombres,
        pl.id_nivel,
        mat.cod_materia,
        mat.nombre,
        ea.pp, ea.sp, ea.ef, ea.nfr, ea.si, ea.ma, ea.nf,
        ea.estnota,
        est.matricula,
        da.adm1, da.pacon1, da.reint1, da.matr1,
        da.c1, da.c2, da.c3, da.c4, da.c5, da.recur5,
        tur.nombre,
        pleco.nombre,
        ci.nueant
    FROM estudiantes_activos ea
    INNER JOIN unicen.estudiante est
        ON est.unicodigo = ea.unicodigo
       AND est.id_sede = idsd
    INNER JOIN unicen.estudiantecareco careco
        ON careco.unicodigo = est.unicodigo
       AND careco.id_plan_estudio = ea.id_plan_estudio
    INNER JOIN clasificacion_ingreso ci
        ON ci.unicodigo = ea.unicodigo
       AND ci.id_plan_estudio = ea.id_plan_estudio
    INNER JOIN unicen.plan_economico pleco
        ON pleco.id_plan_economico = careco.id_plan_economico
       AND pleco.id_sede = idsd
    INNER JOIN unicen.plan_estudio pest
        ON pest.id_plan_estudio = ea.id_plan_estudio
       AND pest.id_sede = idsd
    INNER JOIN unicen.plan_materia pl
        ON pl.id_plan_estudio = pest.id_plan_estudio
       AND pl.id_materia = ea.id_materia
       AND pl.id_sede = idsd
    INNER JOIN unicen.materia mat
        ON mat.id_materia = ea.id_materia
       AND mat.id_sede = idsd
    INNER JOIN unicen.carrera car
        ON car.id_carrera = pest.id_carrera
       AND car.id_sede = idsd
    INNER JOIN unicen.turno tur
        ON tur.id_turno = ea.id_turno
    LEFT JOIN deudas_agrupadas da
        ON da.unicodigo = ea.unicodigo
    ORDER BY car.nombre, est.paterno, est.materno;
END;
$$;

CREATE OR REPLACE FUNCTION unicen.reportes_estudiantes_notas_deudas_old(idge integer, idplan integer, idsd integer)
 RETURNS TABLE(car character varying, unic integer, pat character varying, matern character varying, nom character varying, sem integer, codmat character varying, mat character varying, pp double precision, sp double precision, ef double precision, nfr double precision, si double precision, ma double precision, nf double precision, est character varying, matri character varying, adm1 double precision, pacon1 double precision, reint1 double precision, matr1 double precision, c1 double precision, c2 double precision, c3 double precision, c4 double precision, c5 double precision, recur5 double precision, turn character varying, pleco1 character varying, can text)
 LANGUAGE plpgsql
AS $function$
declare	
idord integer;
BEGIN

SELECT ord INTO idord
    FROM unicen.gestion
    WHERE id_gestion = idge;
	RAISE NOTICE 'El valor de idord es: %', idord;

RETURN QUERY

WITH estudiantes_activos AS (
    SELECT nt.unicodigo, nt.id_plan_estudio, nt.id_materia, nt.pp, nt.sp, nt.ef, nt.nfr, nt.si, nt.ma, nt.nf, nt.estnota,
           nt.id_turno, nt.id_gestion
    FROM unicen.nota nt
    WHERE nt.id_sede = idsd AND nt.id_gestion = idge AND nt.id_plan_estudio = idplan AND nt.est = 'ACTIVO'
),
clasificacion_ingreso AS (
    SELECT 
        nt2.unicodigo,
        nt2.id_plan_estudio,
        CASE
            WHEN COUNT(DISTINCT nt2.id_gestion) = 1 THEN 'NUEVO'
            WHEN COUNT(DISTINCT nt2.id_gestion) > 1 THEN 'ANTIGUO'
            ELSE 'SIN DATOS'
        END AS nueant
    FROM unicen.nota nt2
    INNER JOIN unicen.gestion gs2 ON nt2.id_gestion = gs2.id_gestion
    WHERE nt2.id_sede = idsd AND gs2.ord <= idord AND nt2.id_plan_estudio = idplan AND nt2.est = 'ACTIVO'
    GROUP BY nt2.unicodigo, nt2.id_plan_estudio
),
deudas_agrupadas AS (
    SELECT unicodigo,
           MAX(CASE WHEN id_item_seguimiento = 52 THEN monto_deuda END) AS adm1,
           MAX(CASE WHEN id_item_seguimiento = 53 THEN monto_deuda END) AS pacon1,
           MAX(CASE WHEN id_item_seguimiento = 54 THEN monto_deuda END) AS reint1,
           MAX(CASE WHEN id_item_seguimiento = 13 THEN monto_deuda END) AS matr1,
           MAX(CASE WHEN id_item_seguimiento = 1 THEN monto_deuda END) AS c1,
           MAX(CASE WHEN id_item_seguimiento = 2 THEN monto_deuda END) AS c2,
           MAX(CASE WHEN id_item_seguimiento = 3 THEN monto_deuda END) AS c3,
           MAX(CASE WHEN id_item_seguimiento = 4 THEN monto_deuda END) AS c4,
           MAX(CASE WHEN id_item_seguimiento = 5 THEN monto_deuda END) AS c5,
           MAX(CASE WHEN id_item_seguimiento = 16 THEN monto_deuda END) AS recur5
    FROM unicen.deudas_contable
    WHERE id_sede = idsd AND id_gestion = idge
    GROUP BY unicodigo
)

SELECT 
    car.nombre AS car,
    est.unicodigo AS unic,
    est.paterno AS pat,
    est.materno AS matern,
    est.nombres AS nom,
    pl.id_nivel AS sem,
    mat.cod_materia AS codmat,
    mat.nombre AS mat,
    ea.pp, ea.sp, ea.ef, ea.nfr, ea.si, ea.ma, ea.nf, ea.estnota AS est,
    est.matricula AS matri,
    da.adm1, da.pacon1, da.reint1, da.matr1,
    da.c1, da.c2, da.c3, da.c4, da.c5, da.recur5,
    tur.nombre AS turn,
    pleco.nombre AS pleco1,
    ci.nueant AS can
FROM estudiantes_activos ea
INNER JOIN unicen.estudiante est ON est.unicodigo = ea.unicodigo AND est.id_sede = idsd
INNER JOIN unicen.estudiantecareco careco ON careco.unicodigo = est.unicodigo AND careco.id_plan_estudio = ea.id_plan_estudio
INNER JOIN clasificacion_ingreso ci ON ci.unicodigo = ea.unicodigo AND ci.id_plan_estudio = ea.id_plan_estudio
INNER JOIN unicen.plan_economico pleco ON careco.id_plan_economico = pleco.id_plan_economico AND pleco.id_sede = idsd
INNER JOIN unicen.plan_estudio pest ON ea.id_plan_estudio = pest.id_plan_estudio AND pest.id_sede = idsd
INNER JOIN unicen.plan_materia pl ON pest.id_plan_estudio = pl.id_plan_estudio AND ea.id_materia = pl.id_materia AND pl.id_sede = idsd
INNER JOIN unicen.materia mat ON ea.id_materia = mat.id_materia AND mat.id_sede = idsd
INNER JOIN unicen.carrera car ON pest.id_carrera = car.id_carrera AND car.id_sede = idsd
INNER JOIN unicen.turno tur ON ea.id_turno = tur.id_turno
LEFT JOIN deudas_agrupadas da ON ea.unicodigo = da.unicodigo
ORDER BY car.nombre, est.paterno, est.materno;

END;
$function$


SELECT * FROM unicen.reportes_estudiantes_notas_deudas(106,112,1)
EXCEPT
SELECT * FROM unicen.reportes_estudiantes_notas_deudas_old(106,112,1);

SELECT * FROM unicen.reportes_estudiantes_notas_deudas(106,123,1);
83