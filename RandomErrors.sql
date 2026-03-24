select * from (select * from unicen.nota where unicodigo = 17529 and id_gestion = 106) nt JOIN unicen.inscripcion ins ON nt.unicodigo = ins.unicodigo;



SELECT * FROM unicen.usuarioest where unicodigo = 34793;


SELECT * FROM unicen.rol where id_sede = 1;

SELECT * FROM unicen.usuarioest where id_sede = 1;

INSERT INTO unicen.usuarioest (id_usuarioest,unicodigo, id_sede, id_rol, activo) VALUES ((SELECT max(id_usuarioest) FROM unicen.usuarioest) + 1,34793, 1, 5,'ACTIVO');

-- ROCHA CUENTAS BELINDA RAQUEL
-- ZULETA CHOQUE SIOMARA YESENIA 
-- BELÉN DEL CARMEN RADA GUTIERREZ
-- EDSON DIEGO CONDORI ENRIQUEZ
-- RENY DANIEL TICLLA ARIAS
-- MARIA SEFORA ARO DIAZ

SELECT * from unicen.estudiante where paterno = 'RADA'

SELECT * FROM unicen.estudiante where paterno = 'ROCHA' and materno = 'CUENTAS' and nombres = 'BELINDA RAQUEL';
SELECT * FROM unicen.estudiante where paterno = 'ZULETA' and materno = 'CHOQUE' and nombres = 'SIOMARA YESENIA';

SELECT * from unicen.estudiante where paterno = 'BELÉN' and materno = 'DEL CARMEN';

SELECT * FROM unicen.estudiante where  nombres = 'EDSON DIEGO';

SELECT * FROM unicen.estudiante where paterno = 'TICLLA' and materno = 'ARIAS' and nombres = 'RENY DANIEL';

SELECT * FROM unicen.estudiante where paterno = 'ARO' and materno = 'DIAZ' and nombres = 'MARIA SEFORA';


SELECT unicen.estudiantes_inscrito_reserva(11695, 1, 105);

SELECT unicen.estudiantes_inscrito_reserva(11975, 1, 105);

SELECT unicen.estudiantes_inscrito_reserva(11163, 1, 105);


SELECT unicodigo,estinsc,estinsceco from unicen.inscripcion where unicodigo = 35742 and id_gestion = 105 and id_sede = 1;

SELECT unicodigo,estinsc,estinsceco from unicen.inscripcion where unicodigo = 11975 and id_gestion = 105 and id_sede = 1;

SELECT unicodigo,estinsc,estinsceco from unicen.inscripcion where unicodigo = 11163 and id_gestion = 105 and id_sede = 1;



SELECT unicodigo from unicen.inscripcion where estinsceco is null and id_gestion = 105 and id_sede = 3;

CREATE OR REPLACE FUNCTION unicen.fn_aux_inscribir_estudiante_reserva_por_unicodigo(p_unicodigos integer[], p_id_sede INTEGER, p_id_gestion INTEGER)
 RETURNS TABLE(unicodigo integer, estinsceco character varying)
 LANGUAGE plpgsql
 AS $$
    DECLARE
        v_unicodigo integer;

    BEGIN
        FOREACH v_unicodigo IN ARRAY p_unicodigos
        LOOP
            IF (SELECT 1 from unicen.inscripcion where unicodigo = v_unicodigo and id_sede = p_id_sede and id_gestion = p_id_gestion and estinsceco = 'INSCRITO') THEN
                RAISE NOTICE 'El unicodigo % ya tiene una inscripción para la sede % y gestión %', v_unicodigo, p_id_sede, p_id_gestion;
                CONTINUE;
            END IF;

            PERFORM unicen.estudiantes_inscrito_reserva(v_unicodigo, p_id_sede, p_id_gestion);
        END LOOP;

        RETURN QUERY 
        SELECT ins.unicodigo, ins.estinsceco FROM unicen.inscripcion ins WHERE ins.unicodigo IN(
            SELECT unnest(p_unicodigos)
        ) AND ins.id_sede = p_id_sede AND ins.id_gestion = p_id_gestion;
    END;
 $$;


17450
17184
16666
12753
12721
12879
12784
12598
12605
12612
17279
17403
34178
12899
33869
16666
17184
12881
17450
3599
34162
34835
4036
3955
18492
34956
33884
15991
12638
12753
35817


select unicodigo, estinsceco from unicen.inscripcion where unicodigo IN (17450, 17184, 16666, 12753, 12721, 12879, 12784, 12598, 12605, 12612, 17279, 17403, 34178, 12899, 33869, 16666, 17184, 12881, 17450, 3599, 34162, 34835, 4036, 3955, 18492, 34956, 33884, 15991, 12638, 12753, 35817) and id_sede =2 and id_gestion =105;


SELECT * FROM unicen.fn_aux_inscribir_estudiante_reserva_por_unicodigo(ARRAY[17450, 17184, 16666, 12753, 12721, 12879, 12784, 12598, 12605, 12612, 17279, 17403, 34178, 12899, 33869, 16666, 17184, 12881, 17450, 3599, 34162, 34835, 4036, 3955, 18492, 34956, 33884, 15991, 12638, 12753, 35817],2,105);

SELECT ARRAY(SELECT unicodigo FROM unicen.inscripcion where estinsceco is null and id_gestion = 105 and id_sede = 3
) AS unicodigos;


select unicen.fn_aux_inscribir_estudiante_reserva_por_unicodigo(ARRAY(SELECT unicodigo FROM unicen.inscripcion where estinsceco is null and id_gestion = 105 and id_sede = 3), 3, 105);

select unicen.fn_aux_inscribir_estudiante_reserva_por_unicodigo(ARRAY(SELECT unicodigo FROM unicen.inscripcion where estinsceco is null and id_gestion = 105 and id_sede = 1), 1, 105);
begin;
select unicen.fn_aux_inscribir_estudiante_reserva_por_unicodigo(
    (SELECT ARRAY(SELECT unicodigo FROM unicen.inscripcion where id_gestion = 105 and id_sede = 3 and estinsceco is null)), 3, 105);
ROLLBACK;



select operation,old_data,new_data, changed_at from unicen.general_audit where table_name = 'inscripcion' ORDER BY changed_at;

SELECT * from unicen.estudiantecareco where unicodigo = 17580;

select * from unicen.inscripcion where unicodigo = 17580 and id_gestion = 105 and id_sede = 2;

SELECT unicodigo,estinsceco from unicen.inscripcion where unicodigo IN (
    SELECT unicodigo from unicen.estudiante where paterno like 'VILLCA%' and materno like 'TUNARI' and nombres like '%'
);

SELECT * FROM unicen.inscripcion where unicodigo = 34361;


BEGIN;
3599
17580
15991
12616
12638
35650
35612
35513
33803
35513
17518
16336
12679
3599
3955
18492
34956
33884
15991
12712
16650
16648
16648
12638
35817

begin;
-- Unsolved
-- 35513
-- 17518
-- 16648
-- 12638
-- 34063
-- 12679


-- SOLVED
-- 18492
-- 12712
-- 12616
-- 33803
-- 15991
-- 17580
-- 33884
-- 34956
-- 16336
-- 35650
-- 35612
-- 35817
-- 16650

SELECT * FROM unicen.usuario where  unicodigo = 4137;


SELECT * FROM unicen.fn_aux_inscribir_estudiante_reserva_por_unicodigo(ARRAY[32021,34465,32395,32550,30759,22511,32722,32756,29395],3,105);

SELECT * FROM unicen.estudiantecareco where unicodigo = 26119;

SELECT * FROM unicen.estudiante where unicodigo = 26119;



select * from unicen.gestion;
ROLLBACK;
BEGIN;

update unicen.nota SET id_gestion = 101 WHERE unicodigo = 26119 and id_gestion = 105 and paralelo = 'PRECONVALIDADO';


SELECT * FROM unicen.nota where unicodigo = 26119 and paralelo = 'PRECONVALIDADO';


COMMIT;


SELECT * FROM unicen.tipo_plan_economico;

select num_documento from unicen.personal where unicodigo = 3599;

select num_documento from unicen.personal where unicodigo = 3941;

select num_documento from unicen.personal where unicodigo = 3955;


SELECT * FROM unicen.usuario where unicodigo = 4137;

SELECT * FROM unicen.estudiantecareco where unicodigo = 19008;


SELECT * FROM unicen.nota where unicodigo = 19008;

SELECT unicodigo, num_documento from unicen.personal where nombres = 'JOSUE DAVID';

SELECT * FROM unicen.factura_historial where unicodigo = 34845;

SELECT unicodigo,estado,numero_factura,monto_cubierto,codigo_control FROM unicen.factura where unicodigo = 34845;  
SELECT * FROM unicen.estudiantecareco where unicodigo = 34845;


SELECT * FROM unicen.estudiante where unicodigo = 34845;

SELECT * FROM unicen.estudiante where id_estudiante = 12727;

SELECT * FROM unicen.estudiantecareco where id_estudiante = 12727;

SELECT * FROM unicen.nota where id_estudiante = 12727;



SELECT * FROM unicen.materia where nombre LIKE '%TECNOLO%ALIMENTOS%';


select * from unicen.materia where nombre = 'TECNOLOGIA DE ALIMENTOS III' and id_sede = 3;


SELECT * FROM unicen.plan_materia where id_materia IN (
    select id_materia from unicen.materia where nombre = 'TECNOLOGIA DE ALIMENTOS III' and id_sede = 3
) and id_sede = 3;

SELECT * FROM unicen.grupo where id_materia IN (
    select id_materia from unicen.materia where nombre = 'TECNOLOGIA DE ALIMENTOS III' and id_sede = 3
) and id_sede = 3 and id_gestion = 105;


SELECT * FROM unicen.grupo_docente where id_grupo = 87122;


SELECT num_documento, unicodigo from unicen.personal where unicodigo = 4201;


SELECT * FROM unicen.materia where cod_materia = 'ADT534';

SELECT * FROM unicen.grupo where id_materia = 1635;


SELECT unicodigo,num_documento from unicen.personal where unicodigo IN (
    SELECT unicodigo FROM unicen.grupo_docente where id_grupo IN (
        SELECT id_grupo from unicen.grupo where id_materia = 1635 and id_gestion = 105
    )
);

SELECT * FROM unicen.usuario where unicodigo = 4137;


SELECT * FROM unicen.inscripcion where unicodigo = 12679 and id_gestion = 105 and id_sede = 2;


select unicen.estudiantes_inscrito_reserva(17518, 2, 105);


SELECT paterno,materno, nombres, num_documento FROM unicen.estudiante where unicodigo = 18323;

cbd10afac3b1c29fedc234b057cec962

8de692469abd4600c6a931f002d37f36

SELECT * FROM unicen.usuarioest where unicodigo = 18323;


select * from unicen.rol where nombre = 'ESTUDIANTE';

INSERT INTO unicen.usuarioest (id_usuarioest,unicodigo, id_sede, id_rol, activo) VALUES ((SELECT max(id_usuarioest) FROM unicen.usuarioest) + 1,18323, 2, 17,'ACTIVO');


CREATE OR REPLACE PROCEDURE unicen.pr_aux_add_estudiante_a_usuarioest(p_unicodigos integer[], p_id_sede integer)
AS $$
DECLARE
    v_unicodigo integer;
BEGIN
    FOREACH v_unicodigo IN ARRAY p_unicodigos
    LOOP
        IF (SELECT 1 FROM unicen.usuarioest WHERE unicodigo = v_unicodigo AND id_sede = p_id_sede) THEN
            RAISE NOTICE 'El unicodigo % ya existe en usuarioest para la sede %', v_unicodigo, p_id_sede;
            CONTINUE;
        END IF;

        INSERT INTO unicen.usuarioest (id_usuarioest, unicodigo, id_sede, id_rol, activo)
        VALUES ((SELECT max(id_usuarioest) FROM unicen.usuarioest) + 1, v_unicodigo, p_id_sede, 5, 'ACTIVO');

        RAISE NOTICE 'Se ha insertado el unicodigo % en usuarioest para la sede %', v_unicodigo, p_id_sede;
    END LOOP;
END;

$$ LANGUAGE plpgsql;


CALL unicen.pr_aux_add_estudiante_a_usuarioest(ARRAY[35742], 1);

SELECT num_documento FROM unicen.estudiante where unicodigo = 35742;

SELECT md5('17862287');

SELECT unicodigo, num_documento FROM unicen.estudiante where unicodigo IN (17214);


SELECT unicodigo, num_documento, paterno, materno,nombres FROM unicen.personal where paterno = 'ALMENDRAS';

SELECT unicodigo, num_documento, paterno, materno, nombres FROM unicen.personal where paterno = 'TORREZ' AND materno like '%EYZAGUIRRE%';


SELECT * FROM unicen.usuario where unicodigo = 4137;

SELECT * from unicen.equivalencia_homologacion where id_plan_estudio_antigua = 14;


SELECT unicodigo,num_documento, paterno, materno, nombres FROM unicen.personal where paterno = 'TRUJILLO';


UPDATE unicen.equivalencia_homologacion SET estado = 'EMPAREJADA' where id_plan_estudio_antigua = 14 and id_plan_estudio_nueva = 112 and id_sede = 1;


SELECT * FROM unicen.seiko_listahorariodocentegrupo(3734,105,86299);


select * from unicen.factura_historial where numero_factura = '62876' and monto_cubierto  = 840 and fecha= '2026/02/19';


select * from unicen.inscripcion where unicodigo = 17450 and id_sede =2 and id_gestion = 105;;



SELECT * FROM unicen.materia where id_materia = 664;

-- 

SELECT * FROM unicen.nota where unicodigo = 16334 and pp = 23;

SELECT * FROM unicen.rol where id_sede = 2;

SELECT md5('5220626');

SELECT * FROM unicen.personal where nombres = 'JOSUE DAVID';

BEGIN;

ROLLBACK;

INSERT INTO unicen.usuario (
    id_usuario,unicodigo, id_rol, id_sede, activo
)VALUES(
    (SELECT max(id_usuario) + 1 FROM unicen.usuario),4294, 34, 2, 'ACTIVO'
)

SELECT * FROM unicen.usuario where unicodigo = 4294;


select * FROM seiko_aut(4294, '5220626');

COMMIT;


select * from unicen.personal where unicodigo = 3955;


SELECT * FROM unicen.estudiantecareco where unicodigo IN (

    SELECT unicodigo FROM unicen.estudiante where paterno = 'ROCHA' and materno = 'RAMIREZ'
)


select * from unicen.plan_economico where id_plan_economico IN (314,336) and id_sede = 1;
BEGIN;

DELETE FROM unicen.estudiante where unicodigo = 35726;

DELETE from  unicen.estudiantecareco where unicodigo = 35726;

DELETE FROM unicen.nota where unicodigo =35726

ROLLBACK;
select id_gestion, nf from unicen.nota where unicodigo = 35726;

select id_gestion, nf from unicen.nota where unicodigo = 9998;



select * from unicen.estudiante where paterno = 'LOPEZ' and materno = 'QUINTANILLA';

SELECT * FROM unicen.estudiante where paterno = 'MICHEL' AND materno = 'HOLGUIN';
select * from  unicen.estudiantecareco where unicodigo IN (
    SELECT unicodigo FROM unicen.estudiante where paterno = 'LOPEZ' AND materno = 'QUINTANILLA'
)

SELECT * FROM unicen.plan_economico where id_plan_economico IN (322,339) and id_sede = 1;

BEGIN;

DELETE FROM unicen.nota where unicodigo = 36011 and paralelo = 'A';

ROLLBACK;


COMMIT;


EXPLAIN SELECT * FROM unicen.general_audit;


select * from unicen.gestion where nombre = '1/2020'


SELECT id_nota from unicen.nota where unicodigo= 9647 and id_gestion = 88;


DELETE FROM unicen.nota where unicodigo= 9647 and id_gestion = 88;

INSERT INTO nota_eliminada ( unicodigo, id_estudiante, id_plan_estudio, id_materia, id_gestion, id_sede, paralelo, id_turno, pp, sp, tp, ast, ef, nfr, si, ma, gr,nf,estnota,est)
SELECT unicodigo, id_estudiante, id_plan_estudio, id_materia, id_gestion, id_sede, paralelo, id_turno, pp, sp, tp, ast, ef, nfr, si, ma, gr,nf,estnota,est FROM unicen.nota where unicodigo= 9647 and id_gestion = 88;


select * from unicen.estudiantecareco where unicodigo = 36026;

SELECT * FROM unicen.plan_estudio where id_plan_estudio IN (85,104);

SELECT * FROM unicen.usuario where unicodigo = 4137;

SELECT fh.unicodigo ,g.nombre as gestion, monto_cubierto, numero_factura, fecha FROM unicen.factura_historial fh 
join unicen.gestion g on fh.id_gestion = g.id_gestion where unicodigo = 27603  and id_item_seguimiento = 55 ORDER BY fecha_factura DESC;
SELECT id_gestion,monto_cubierto, numero_factura, fecha FROM unicen.factura_historial where unicodigo = 22213 AND id_item_seguimiento = (
    SELECT id_item_seguimiento from unicen.item_seguimiento where descripcion = 'PRACTICAS HOSPITALARIAS'
)

SELECT * FROM unicen.gestion where id_gestion = 106;

select id_item_seguimiento from unicen.item_seguimiento where descripcion = 'PRACTICAS HOSPITALARIAS';

SELECT * FROM unicen.factura where unicodigo = 22213;

SELECT id_gestion,monto_cubierto, numero_factura FROM unicen.factura where unicodigo = 22213;
select * from unicen.gestion where id_gestion = 103;

SELECT * FROM unicen.usuario where unicodigo = 4137;


SELECT * from unicen.item_seguimiento;


SELECT * from unicen.dia;

SELECT unicodigo, estinsceco FROM unicen.inscripcion where unicodigo IN (
    5644,35940,33884
) and id_gestion = 105;

SELECT unicodigo,num_documento, paterno, materno FROM unicen.estudiante where nombres = 'CLAUDIA MARIA';

SELECT unicodigo,num_documento FROM unicen.personal where paterno = 'LEDEZMA' and materno = 'GUZMAN';


SELECT * FROM  unicen.asistencia where id_grupo = 85979 and fecha = '2026-03-04';


SELECT  hr.id_grupo FROM unicen.horario hr join unicen.grupo g 
ON hr.id_grupo = g.id_grupo
where hr.id_dia = 7 and id_gestion = 105;

SELECT unicodigo,num_documento from unicen.personal where unicodigo IN (
    SELECT unicodigo FROM unicen.grupo_docente where id_grupo = 86154
)

SELECT * FROM unicen.usuario where unicodigo = 4137;


SELECT * FROM unicen.usuarioest where unicodigo = 34331;

SELECT num_documento from unicen.estudiante where unicodigo = 34331;

UPDATE unicen.estudiante SET pass = md5(num_documento) where unicodigo = 34331;


SELECT * FROM unicen.estudiante where unicodigo IN (
    SELECT unicodigo FROM unicen.usuarioest where id_rol = 17 and id_sede = 2
)