
SELECT * FROM unicen.carrera where codigo = 'ADT';

SELECT * FROM unicen.plan_estudio where id_carrera = 76;


SELECT * FROM unicen.nota where id_plan_estudio = 105 and id_gestion = 105 and id_sede = 3;

SELECT est.unicodigo,est.num_documento, nt.id_materia FROM unicen.nota nt JOIN unicen.estudiante est 
ON nt.unicodigo = est.unicodigo
where nt.id_materia IN(
    select id_materia from unicen.materia where cod_materia IN (
        'ADM511',
        'CPA532',
        'ADT532',
    )
) and nt.id_gestion = 105 and nt.id_plan_estudio = 105;


SELECT est.unicodigo,est.num_documento FROM unicen.estudiante est where unicodigo IN (
    SELECT unicodigo FROM unicen.nota where id_materia IN(
        select id_materia from unicen.materia where cod_materia IN (
            'ADM511',
            'CPA532',
            'ADT532'
        )
    ) and id_gestion = 178 and id_plan_estudio = 178 and id_sede = 1
) and unicodigo NOT IN(
    SELECT unicodigo FROM unicen.nota where id_materia IN(
        select id_materia from unicen.materia where cod_materia IN (
                'GA 2311',
                'GA 2312'
        )
    ) and id_gestion = 178 and id_plan_estudio = 178 and id_sede = 1
)


SELECT * FROM  unicen.pre_requisito;


SELECT * FROM unicen.materia where cod_materia IN (
    'GAS 2311',
    'GAS 2312'
) and id_sede = 1;

SELECT * FROM unicen.materia where nombre LIKE '%(OPT%' AND id_sede = 1;

SELECT * FROM unicen.plan_materia where id_sede = 1 and id_materia IN (
    3088,3089
);

SELECT * FROM unicen.plan_estudio where id_plan_estudio = 178;


SELECT * FROM unicen.estudiantecareco where id_plan_estudio = 178 and unicodigo NOT IN (
    SELECT unicodigo FROM unicen.nota where id_plan_estudio = 178 and id_gestion = 105 and id_sede = 1 and id_materia IN (
        select id_materia from unicen.materia where cod_materia IN (
            'GAS 2312'
        ) and id_sede = 1
    )and id_sede = 1 and  nf >= 51
) and id_sede = 1;


SELECT * FROM unicen.carrera where id_carrera = 209;
SELECT * FROM unicen.pre_requisito where id_materia in(
    3088,3089
);


SELECT * FROM unicen.nota where unicodigo = 33811 and id_gestion = 105 ;

SELECT unicodigo, num_documento FROM unicen.personal where paterno = 'URIARTE' AND materno = 'GARCIA';