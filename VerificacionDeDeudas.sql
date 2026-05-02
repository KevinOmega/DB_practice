DO $$
DECLARE
    unicodigos INT[] := ARRAY[
        34356, 34269, 34433, 34613, 34279, 34279, 34356, 35996, 35780,
        35326, 35326, 34429, 35996, 34293, 34429, 34715, 35280, 35280,
        35647, 35713, 35772, 34293
    ];
    num_facturas VARCHAR(15)[] := ARRAY[
        '27997', '28905', '30245', '31139', '31258', '31259', '31318',
        '31403', '31484', '31754', '31755', '32210', '33387', '49216',
        '49891', '50840', '51382', '51383', '52083', '52302', '52383',
        '53168'
    ];
    i INT; -- Variable para el índice del bucle
BEGIN
    -- Iteramos desde el primer índice (1) hasta la longitud total del arreglo
    FOR i IN array_lower(unicodigos, 1) .. array_upper(unicodigos, 1)
    LOOP
        select unicodigo,numero_factura,monto_cubierto,fecha_factura FROM unicen.factura where unicodigo = unicodigos[i] and numero_factura = num_facturas[i];
         -- Aquí puedes realizar cualquier operación que necesites con el valor actual del arreglo

    END LOOP;
END;
$$ LANGUAGE plpgsql;


DO $$
    DECLARE
        num_facturas VARCHAR(15)[] := ARRAY['123', '28774', '28857', '28896', '28913', '28961', '28990', '31010', '31068', '31396', '31436', '32861', '33190', '48967',
        '49020', '49050', '49053', '49054', '49503', '49542', '50318', '50597', '50608', '50702', '50797', '50844', '51070'];
    BEGIN
        -- Iteramos desde el primer índice (1) hasta la longitud total del arreglo
        SELECT est.unicodigo, est.paterno,est.materno, est.nombres, it.id_item_seguimiento,it.descripcion, fac.numero_factura, fac.fecha_factura, fac.monto_cubierto
        FROM unicen.factura fac
        JOIN unicen.estudiante est ON fac.unicodigo = est.unicodigo
        JOIN unicen.item_seguimiento it ON fac.id_item_seguimiento = it.id_item_seguimiento
        WHERE fac.numero_factura IN (SELECT unnest(num_facturas)) and est.id_sede = 3 ORDER BY est.paterno, est.materno, est.nombres;
    END;
$$;


(SELECT
    est.unicodigo,
    est.paterno,
    est.materno,
    est.nombres,
    it.descripcion,
    fac.numero_factura,
    fac.fecha,
    fac.monto_cubierto,
    'DELTA' as tipo
FROM unicen.factura_historial fac
JOIN unicen.estudiante est ON fac.unicodigo = est.unicodigo
JOIN unicen.item_seguimiento it ON fac.id_item_seguimiento = it.id_item_seguimiento
WHERE fac.numero_factura = ANY (
    ARRAY[
        '123', '28774', '28857', '28896', '28913', '28961', '28990', '31010', '31068',
        '31396', '31436', '32861', '33190', '48967', '49020', '49050', '49053', '49054',
        '49503', '49542', '50318', '50597', '50608', '50702', '50797', '50844', '51070'
    ]::VARCHAR(15)[]
)
AND est.id_sede = 3 AND fac.id_item_seguimiento = 52)
UNION
(SELECT
    est.unicodigo,
    est.paterno,
    est.materno,
    est.nombres,
    it.descripcion,
    fac.numero_factura,
    fac.fecha_hora as fecha,
    fac.monto_cubierto,
    'DAR' as tipo
FROM unicen.factura fac
JOIN unicen.estudiante est ON fac.unicodigo = est.unicodigo
JOIN unicen.item_seguimiento it ON fac.id_item_seguimiento = it.id_item_seguimiento
WHERE fac.numero_factura = ANY (
    ARRAY[
        '123', '28774', '28857', '28896', '28913', '28961', '28990', '31010', '31068',
        '31396', '31436', '32861', '33190', '48967', '49020', '49050', '49053', '49054',
        '49503', '49542', '50318', '50597', '50608', '50702', '50797', '50844', '51070'
    ]::VARCHAR(15)[]
)
AND est.id_sede = 3 AND fac.id_item_seguimiento = 52);

WITH num_facturas AS(
    SELECT unnest(ARRAY[
        '27997', '28905', '30245', '31139', '31258', '31259', '31318',
        '31403', '31484', '31754', '31755', '32210', '33387', '49216',
        '49891', '50840', '51382', '51383', '52083', '52302', '52383',
        '53168'
        ]),
    unicodigos as(

    )
)

DO $plpgsql$
    declare
        numero_facturas VARCHAR(15)[] := ARRAY[
        '27997', '28905', '30245', '31139', '31258', '31259', '31318',
        '31403', '31484', '31754', '31755', '32210', '33387', '49216',
        '49891', '50840', '51382', '51383', '52083', '52302', '52383',
        '53168'
        ];
        unicodigos INT[] := ARRAY[34356, 34269, 34433, 34613, 34279, 34279, 34356, 35996, 35780,
            35326, 35326, 34429, 35996, 34293, 34429, 34715, 35280, 35280, 35647, 35713, 35772, 34293];
        v_unicodigo INT;
        v_numero_factura VARCHAR(15);
        v_monto_cubierto DECIMAL(10,2);
        v_fecha_factura DATE;
        i INT;
    BEGIN
        FOR i IN 1..array_length(numero_facturas, 1) LOOP
            SELECT unicodigo,numero_factura,monto_cubierto,fecha_hora
            INTO v_unicodigo,v_numero_factura,v_monto_cubierto,v_fecha_factura
            FROM unicen.factura fac where unicodigo = unicodigos[i] and numero_factura = numero_facturas[i] and id_sede = 3 and id_item_seguimiento = 52;
            IF(v_unicodigo IS NOT NULL and v_numero_factura IS not NULL) then
                RAISE NOTICE 'FACTURA INGRESADA DESDE DELTA PARA: unicodigo: %, numero_factura: %, monto_cubierto: %, fecha_factura: %', v_unicodigo, v_numero_factura, v_monto_cubierto, v_fecha_factura;
            END IF;
        END LOOP;
    end;
$plpgsql$;





select est.unicodigo, est.paterno,est.materno, est.nombres, it.id_item_seguimiento,it.descripcion, fac.numero_factura, fac.fecha_factura, fac.monto_cubierto
FROM unicen.factura fac
JOIN unicen.estudiante est ON fac.unicodigo = est.unicodigo
JOIN unicen.item_seguimiento it ON fac.id_item_seguimiento = it.id_item_seguimiento
WHERE fac.numero_factura = '123' and est.id_sede = 3
ORDER BY est.paterno, est.materno, est.nombres;

SELECT  unicodigo,paterno,materno,nombres FROM unicen.estudiante where paterno = 'BARRIGOLA' AND materno = 'CALLIZAYA';

SELECT  unicodigo,numero_factura,fecha, id_gestion,id_sede FROM unicen.factura_historial where numero_factura = '30245';

SELECT  unicodigo,numero_factura,fecha_factura, id_gestion,id_sede FROM unicen.factura where numero_factura = '123' and id_sede =3;


CREATE OR REPLACE FUNCTION unicen.fn_aux_verificar_facturas_detalle()
RETURNS TABLE (
    unicodigo       INT,
    paterno         VARCHAR,
    materno         VARCHAR,
    nombres         VARCHAR,
    descripcion     TEXT,
    numero_factura  VARCHAR(15),
    fecha           DATE,
    monto_cubierto  DECIMAL(10,2),
    tipo            VARCHAR(5)
)
LANGUAGE plpgsql
AS $$
DECLARE
    numero_facturas VARCHAR(15)[] := ARRAY[
        '27997', '28905', '30245', '31139', '31258', '31259', '31318',
        '31403', '31484', '31754', '31755', '32210', '33387', '49216',
        '49891', '50840', '51382', '51383', '52083', '52302', '52383',
        '53168'
    ];
    unicodigos INT[] := ARRAY[
        34356, 34269, 34433, 34613, 34279, 34279, 34356, 35996, 35780,
        35326, 35326, 34429, 35996, 34293, 34429, 34715, 35280, 35280,
        35647, 35713, 35772, 34293
    ];
    i INT;
BEGIN
    FOR i IN 1..array_length(numero_facturas, 1) LOOP

        -- unicen.factura (view) → DELTA
        RETURN QUERY
        SELECT
            est.unicodigo,
            est.paterno,
            est.materno,
            est.nombres,
            it.descripcion::TEXT,
            fac.numero_factura,
            fac.fecha_hora::DATE         AS fecha,
            fac.monto_cubierto,
            'DELTA'::VARCHAR(5)          AS tipo
        FROM unicen.factura fac
        JOIN unicen.estudiante est        ON fac.unicodigo           = est.unicodigo
        JOIN unicen.item_seguimiento it   ON fac.id_item_seguimiento = it.id_item_seguimiento
        WHERE fac.unicodigo           = unicodigos[i]
          AND fac.numero_factura      = numero_facturas[i]
          AND est.id_sede             = 3
          AND fac.id_item_seguimiento = 52;

        -- unicen.factura_historial → DAR
        RETURN QUERY
        SELECT
            est.unicodigo,
            est.paterno,
            est.materno,
            est.nombres,
            it.descripcion::TEXT,
            fac.numero_factura,
            fac.fecha                    AS fecha,
            fac.monto_cubierto,
            'DAR'::VARCHAR(5)            AS tipo
        FROM unicen.factura_historial fac
        JOIN unicen.estudiante est        ON fac.unicodigo           = est.unicodigo
        JOIN unicen.item_seguimiento it   ON fac.id_item_seguimiento = it.id_item_seguimiento
        WHERE fac.unicodigo           = unicodigos[i]
          AND fac.numero_factura      = numero_facturas[i]
          AND est.id_sede             = 3
          AND fac.id_item_seguimiento = 52;

    END LOOP;
END;
$$;

DROP FUNCTION IF EXISTS unicen.fn_aux_verificar_facturas_detalle();

CREATE OR REPLACE FUNCTION unicen.fn_aux_verificar_facturas_detalle(
    unicodigos INT[],
    numero_facturas VARCHAR(15)[]
)
    RETURNS TABLE
            (
                unicodigo      INT,
                paterno        VARCHAR,
                materno        VARCHAR,
                nombres        VARCHAR,
                descripcion    TEXT,
                numero_factura VARCHAR(15),
                fecha          DATE,
                monto_cubierto NUMERIC,
                tipo           VARCHAR(5)
            )
    LANGUAGE plpgsql
AS
$$
DECLARE
    i               INT;
BEGIN
    FOR i IN 1..array_length(numero_facturas, 1)
        LOOP

            -- unicen.factura (view) → DELTA
            RETURN QUERY
                SELECT est.unicodigo,
                       est.paterno,
                       est.materno,
                       est.nombres,
                       it.descripcion::TEXT,
                       fac.numero_factura,
                       fac.fecha_hora::DATE AS fecha,
                       fac.monto_cubierto::NUMERIC,
                       'DELTA'::VARCHAR(5)  AS tipo
                FROM unicen.factura fac
                         JOIN unicen.estudiante est ON fac.unicodigo = est.unicodigo
                         JOIN unicen.item_seguimiento it ON fac.id_item_seguimiento = it.id_item_seguimiento
                WHERE fac.unicodigo = unicodigos[i]
                  AND fac.numero_factura = numero_facturas[i]
                  AND est.id_sede = 3
                  AND fac.id_item_seguimiento = 52;

            -- unicen.factura_historial → DAR
            RETURN QUERY
                SELECT est.unicodigo,
                       est.paterno,
                       est.materno,
                       est.nombres,
                       it.descripcion::TEXT,
                       fac.numero_factura,
                       fac.fecha         AS fecha,
                       fac.monto_cubierto::NUMERIC,
                       'DAR'::VARCHAR(5) AS tipo
                FROM unicen.factura_historial fac
                         JOIN unicen.estudiante est ON fac.unicodigo = est.unicodigo
                         JOIN unicen.item_seguimiento it ON fac.id_item_seguimiento = it.id_item_seguimiento
                WHERE fac.unicodigo = unicodigos[i]
                  AND fac.numero_factura = numero_facturas[i]
                  AND est.id_sede = 3
                  AND fac.id_item_seguimiento = 52;

        END LOOP;
END;
$$;

SELECT *
FROM unicen.fn_aux_verificar_facturas_detalle(
     ARRAY [
        34356, 34269, 34433, 34613, 34279, 34279, 34356, 35996, 35780,
        35326, 35326, 34429, 35996, 34293, 34429, 34715, 35280, 35280,
        35647, 35713, 35772, 34293
        ],
     ARRAY [
        '27997', '28905', '30245', '31139', '31258', '31259', '31318',
        '31403', '31484', '31754', '31755', '32210', '33387', '49216',
        '49891', '50840', '51382', '51383', '52083', '52302', '52383',
        '53168'
        ]
     );
