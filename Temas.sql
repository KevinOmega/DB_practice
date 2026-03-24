select * from unicen.tema where id_sede = 1;

select * from unicen.usuario where unicodigo = 4137;

select * from unicen.carrera where nombre like '%FINANCIERA%';

-- SEDE 1 : ID CARRERA = 81
-- SEDE 3 : ID CARRERA = 20

SELECT *
FROM unicen.plan_estudio pe
where
    pe.id_carrera = 81
    and pe.id_sede = 1
    and pe.activo = 'ACTIVO';

SELECT * FROM unicen.tema_unicen where id_plan_estudio = 113;

select * from unicen.tema where id_sede = 3 and id_plan_estudio = 136;
select * from unicen.tipo_plan_estudio;

SELECT *
FROM unicen.tema
where
    id_plan_estudio = (
        SELECT pe.id_plan_estudio
        FROM unicen.plan_estudio pe
        where
            pe.id_carrera = 81
            and pe.id_sede = 1
            and pe.activo = 'ACTIVO'
    )
    and id_sede = 1;

select *
from unicen.materia ma
where
    ma.id_materia IN (
        select id_materia
        from unicen.plan_materia
        where
            id_plan_estudio = (
                SELECT pe.id_plan_estudio
                FROM unicen.plan_estudio pe
                where
                    pe.id_carrera = 81
                    and pe.id_sede = 3
                    and pe.activo = 'ACTIVO'
            )
            
    );

UPDATE unicen.materia SET nombre = 'ÁLGEBRA' where id_materia = 1580 and id_sede = 3;

UPDATE unicen.materia SET nombre = 'CÁLCULO I' where id_materia = 1584 and id_sede = 3;



CREATE OR REPLACE FUNCTION

select * from unicen.materia where id_materia IN (1580, 1584);
(select nombre
from unicen.materia ma
where
    ma.id_materia IN (
        select id_materia
        from unicen.plan_materia
        where
            id_plan_estudio = (
                SELECT pe.id_plan_estudio
                FROM unicen.plan_estudio pe
                where
                    pe.id_carrera = 20
                    and pe.id_sede = 3
                    and pe.activo = 'ACTIVO'
            )
            and ma.id_sede = 3
    ))
EXCEPT

(select nombre
from unicen.materia ma
where
    ma.id_materia IN (
        select id_materia
        from unicen.plan_materia
        where
            id_plan_estudio = (
                SELECT pe.id_plan_estudio
                FROM unicen.plan_estudio pe
                where
                    pe.id_carrera = 81
                    and pe.id_sede = 1
                    and pe.activo = 'ACTIVO'
            )
            and ma.id_sede = 1
    ));


select nombre
from unicen.materia ma
where
    ma.id_materia IN (
        select id_materia
        from unicen.plan_materia
        where
            id_plan_estudio = (
                SELECT pe.id_plan_estudio
                FROM unicen.plan_estudio pe
                where
                    pe.id_carrera = 20
                    and pe.id_sede = 3
                    and pe.activo = 'ACTIVO'
            )
            and ma.id_sede = 3
    );

select nombre
from unicen.materia ma
where
    ma.id_materia IN (
        select id_materia
        from unicen.plan_materia
        where
            id_plan_estudio = (
                SELECT pe.id_plan_estudio
                FROM unicen.plan_estudio pe
                where
                    pe.id_carrera = 81
                    and pe.id_sede = 1
                    and pe.activo = 'ACTIVO'
            )
            and ma.id_sede = 1
    );




select *
from unicen.materia ma
where
    ma.id_materia IN (
        select id_materia
        from unicen.plan_materia
        where
            id_plan_estudio = (
                SELECT pe.id_plan_estudio
                FROM unicen.plan_estudio pe
                where
                    pe.id_carrera = 20
                    and pe.id_sede = 3
                    and pe.activo = 'ACTIVO'
            )
            and ma.id_sede = 3
            and nombre LIKE ANY (
                select ma.nombre
                from unicen.materia ma
                where
                    ma.id_materia IN (
                        select id_materia
                        from unicen.plan_materia
                        where
                            id_plan_estudio = (
                                SELECT pe.id_plan_estudio
                                FROM unicen.plan_estudio pe
                                where
                                    pe.id_carrera = 81
                                    and pe.id_sede = 1
                                    and pe.activo = 'ACTIVO'
                            )
                            and ma.id_sede = 1
                    )
            )
    )

select * from unicen.tema where id_materia = 1347 and id_sede = 1 and id_plan_estudio = (
    SELECT pe.id_plan_estudio
    FROM unicen.plan_estudio pe
    where
        pe.id_carrera = 81
        and pe.id_sede = 1
        and pe.activo = 'ACTIVO'
)

select * from unicen.tema where id_materia = 1584 and id_sede = 3 and id_plan_estudio = (
    SELECT pe.id_plan_estudio
    FROM unicen.plan_estudio pe
    where
        pe.id_carrera = 20
        and pe.id_sede = 3
        and pe.activo = 'ACTIVO'
)

SELECT pe.id_plan_estudio
    FROM unicen.plan_estudio pe
    where
        pe.id_carrera = 20
        and pe.id_sede = 3
        and pe.activo = 'ACTIVO';


SELECT * FROM unicen.plan_materia where id_plan_estudio = 136 and id_sede = 3 and id_materia = 1584;
-- 5242
INSERT INTO unicen.tema (
    id_tema,
    id_plan_materia,
    id_plan_estudio,
    id_materia,
    titulo,
    contenido,
    id_sede,
    estado
)VALUES(
    1000,
    5242,
    136,
    1584,
    'GEOMETRÍA ANALÍTICA PLANA',
    '',
    3,
    'ACTIVO'
);


select *
from unicen.materia ma join unicen.materia ma2 on ma.nombre = ma2.nombre 
where
    ma.id_materia IN (
        select id_materia
        from unicen.plan_materia
        where
            id_plan_estudio = (
                SELECT pe.id_plan_estudio
                FROM unicen.plan_estudio pe
                where
                    pe.id_carrera = 20
                    and pe.id_sede = 3
                    and pe.activo = 'ACTIVO'
            )
            and ma.id_sede = 3
            and ma2.id_sede = 1
    ) and ma2.id_materia IN (
        select id_materia
        from unicen.plan_materia
        where
            id_plan_estudio = (
                SELECT pe.id_plan_estudio
                FROM unicen.plan_estudio pe
                where
                    pe.id_carrera = 81
                    and pe.id_sede = 1
                    and pe.activo = 'ACTIVO'
            )
            and ma2.id_sede = 1
    );

SELECT * from unicen.tema_unicen where id_plan_estudio = 113 and id_sede = 1;


SELECT setval(
  pg_get_serial_sequence('unicen.tema_unicen', 'id_tema_unicen'),
  COALESCE((SELECT MAX(id_tema_unicen) FROM unicen.tema_unicen), 0),
  TRUE
);

    INSERT INTO unicen.tema_unicen (
    id_plan_estudio,
    id_materia,
    nombre,
    titulo,
    contenido,
    id_sede,
    estado
)
SELECT
    pe3.id_plan_estudio,
    ma3.id_materia,
    t.nombre,
    t.titulo,
    t.contenido,
    3 AS id_sede,
    t.estado
FROM unicen.tema_unicen t
JOIN unicen.materia ma1
    ON ma1.id_materia = t.id_materia
    AND ma1.id_sede = 1
JOIN unicen.materia ma3
    ON ma3.nombre = ma1.nombre
    AND ma3.id_sede = 3
JOIN unicen.plan_estudio pe1
    ON pe1.id_carrera = 81
    AND pe1.id_sede = 1
    AND pe1.activo = 'ACTIVO'
JOIN unicen.plan_estudio pe3
    ON pe3.id_carrera = 20
    AND pe3.id_sede = 3
    AND pe3.activo = 'ACTIVO'
JOIN unicen.plan_materia pm1
    ON pm1.id_plan_estudio = pe1.id_plan_estudio
    AND pm1.id_materia = ma1.id_materia
JOIN unicen.plan_materia pm3
    ON pm3.id_plan_estudio = pe3.id_plan_estudio
    AND pm3.id_materia = ma3.id_materia;



