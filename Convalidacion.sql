select * from unicen.sheiko_listarmateriaspreconvalidadas(17051,79,1,112);

select * from unicen.sheiko_listarmatprecon(19008,1,112);

select * from unicen.nota where unicodigo = 163000;

select * from unicen.nota WHERE unicodigo =  17051;


-- FUNCTION: unicen.sheiko_listarmatprecon(integer, integer, integer)

-- DROP FUNCTION unicen.sheiko_listarmatprecon(integer, integer, integer);

CREATE OR REPLACE FUNCTION unicen.sheiko_listarmatprecon(
	unicod integer,
	idsed integer,
	idplan integer)
    RETURNS TABLE(col bigint, idequi integer, nonmatext character varying, idmatext integer, codmatext character varying, ch integer, nommatloc character varying, idmatloc integer, codmatloc character varying, idplanes integer) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
begin
   return query
				
SELECT distinct ROW_NUMBER() OVER (ORDER BY  equimat.id_equivalencia_materias) as numer, equimat.id_equivalencia_materias,equimat.materia_externa,
 						equimat.id_materia_externa,
 						equimat.cod_mat_externo,equimat.carga_horaria,equimat.materia_local,
						mat.id_materia,
						equimat.cod_mat_local, equimat.id_plan_estudio
				FROM unicen.equivalencia_materias equimat
				inner join unicen.nota nt on equimat.id_materia = nt.id_materia and nt.id_sede=idsed
				inner join unicen.materia mat on nt.id_materia = mat.id_materia and mat.id_sede=idsed
				
				inner join unicen.plan_materia pm on nt.id_materia= pm.id_materia and pm.id_sede=idsed
				inner join unicen.gestion ges on nt.id_gestion = ges.id_gestion
				inner join unicen.plan_estudio pl on nt.id_plan_estudio = pl.id_plan_estudio and pl.id_sede=idsed
				
				INNER JOIN unicen.universidad_externa uniext ON uniext.id_universidad_externa = equimat.id_universidad_externa
				WHERE equimat.id_plan_estudio=idplan and uniext.unicodigo=unicod and (nt.paralelo = 'PRECONVALIDADO' OR nt.paralelo = 'CONVALIDADO' OR nt.paralelo = 'HOM/CONV') and pm.id_plan_estudio=idplan and nt.unicodigo=unicod;
end;
$BODY$;

-- Ver estudiantes convalidados

SELECT unicodigo, estado FROM  unicen.conva_estudiante WHERE estado != 'TERMINADO' LIMIT 20;



select * from unicen.sheiko_listarkardex66(18250,1,304);


CREATE OR REPLACE FUNCTION unicen.seg_materiasaprobadasxsemestre(plaest integer, idsed integer, unicod integer)
 RETURNS TABLE(idmat integer, ntf integer, obser text, ord integer, gest character varying)
 LANGUAGE plpgsql
AS $function$
begin
   return query
		
		
		select nt.id_materia,nt.nf::int, CASE 
        WHEN nt.paralelo = 'CONVALIDADO' OR nt.paralelo = 'HM-C'
            THEN COALESCE(conv.rr_rv || conv.resolucion, 'CONV-RR-' || split_part(regexp_replace(nt.obs, '^RR',''), '-', 1))
        ELSE COALESCE(nt.obs, 'N')
   		END::text AS obser1,ges.ord,ges.nombre
		from unicen.nota nt 
		inner join unicen.gestion ges on nt.id_gestion = ges.id_gestion 
		left join unicen.conva_estudiante conv on nt.unicodigo=conv.unicodigo and conv.id_sede=1 and conv.gestion=nt.id_gestion
		where nt.unicodigo = unicod
		and nt.id_sede = idsed
		and nt.id_plan_estudio = plaest
		and nt.est ='ACTIVO'
		and nt.estnota = 'APROBADO'
		order by ges.ord;
		end;
		
$function$

DROP FUNCTION IF EXISTS unicen.sheiko_listarkardex66(integer, integer, integer);

CREATE OR REPLACE FUNCTION unicen.sheiko_listarkardex66(unicod integer, idcarr integer, idsed integer)
 RETURNS TABLE(col bigint, idnot integer, plan integer, mate character varying, gest character varying, idges integer, p1 double precision, p2 double precision, p3 double precision, exfin double precision, asis double precision, seginst double precision, mesa double precision, graci double precision, notafin double precision, estado character varying, observac text, nivel integer, tgrupo character varying, idgru integer, paralel character varying, totalh double precision, codmater character varying, cred integer, ht double precision, hp double precision, orden integer)
 LANGUAGE plpgsql
AS $function$
begin
   return query
				
				SELECT distinct  ROW_NUMBER() OVER (ORDER BY  aux.id_gestion asc) as numer, aux.id_nota,aux.id_plan_estudio,aux.materia,
				aux.gestion,aux.id_gestion,aux.pp,aux.sp,aux.tp,aux.ef,aux.ast,aux.si,aux.ma,aux.gr,aux.nf,
				aux.estnota,aux.obs,aux.id_nivel,aux.tpgrupo,aux.id_grupo,aux.paralelo,aux.total_horas,aux.cod_materia,aux.creditos,
				aux.horas_teoria,aux.horas_practica,aux.ord
				from (
	            select nt.id_nota,nt.id_plan_estudio,mat.nombre materia,
				ges.nombre gestion,nt.id_gestion,nt.pp,nt.sp,nt.tp,nt.ef,nt.ast,nt.si,nt.ma,nt.gr,nt.nf,
				nt.estnota,conv.rr_rv||conv.resolucion as obs,pm.id_nivel,''::character varying tpgrupo,0::integer id_grupo,nt.paralelo,pm.total_horas,mat.cod_materia,pm.creditos,
				pm.horas_teoria,pm.horas_practica,ges.ord
				
				from unicen.nota nt
				inner join unicen.materia mat on nt.id_materia = mat.id_materia and mat.id_sede=idsed
			    inner join unicen.plan_materia pm on nt.id_materia= pm.id_materia and pm.id_plan_estudio=idcarr and pm.id_sede=idsed
				inner join unicen.gestion ges on nt.id_gestion = ges.id_gestion
				inner join unicen.plan_estudio pl on nt.id_plan_estudio = pl.id_plan_estudio and pl.id_sede=idsed
				left join unicen.conva_estudiante conv on nt.unicodigo=conv.unicodigo and conv.id_sede=idsed and conv.gestion=nt.id_gestion 
					and nt.paralelo in ('HOM/CONV','PRECONVALIDADO', 'CONVALIDADO')--and nt.paralelo = 'HOM/CONV'
					
				where nt.unicodigo=unicod and nt.id_sede=idsed
				and nt.est = 'ACTIVO' 
				and nt.id_plan_estudio=idcarr
				and nt.id_grupo is null 
				
				union all 
				select nt.id_nota,nt.id_plan_estudio,mat.nombre,
				ges.nombre,nt.id_gestion,nt.pp,nt.sp,nt.tp,nt.ef,nt.ast,nt.si,nt.ma,nt.gr,nt.nf,
				nt.estnota,nt.obs,pm.id_nivel,gr.tpgrupo,nt.id_grupo,nt.paralelo,pm.total_horas,mat.cod_materia,pm.creditos,
				pm.horas_teoria,pm.horas_practica,ges.ord
				
				from unicen.nota nt
				inner join unicen.materia mat on nt.id_materia = mat.id_materia and mat.id_sede=idsed
			    inner join unicen.plan_materia pm on nt.id_materia= pm.id_materia and pm.id_plan_estudio=idcarr and pm.id_sede=idsed
				inner join unicen.gestion ges on nt.id_gestion = ges.id_gestion
				inner join unicen.plan_estudio pl on nt.id_plan_estudio = pl.id_plan_estudio and pl.id_sede=idsed
				inner join (select * from unicen.grupo where tpgrupo = 'TEORICO' and id_sede=idsed and id_plan_estudio=idcarr) gr on nt.id_grupo = gr.id_grupo 
				left join unicen.conva_estudiante conv on nt.unicodigo=conv.unicodigo and conv.id_sede=idsed and conv.gestion=nt.id_gestion 
					and nt.paralelo in ('HOM/CONV','PRECONVALIDADO', 'CONVALIDADO') --and nt.paralelo = 'HOM/CONV'
				
				where nt.unicodigo=unicod and nt.id_sede=idsed
				and nt.est = 'ACTIVO' 
				and nt.id_plan_estudio=idcarr)aux
					
				group by aux.id_nota,aux.id_plan_estudio,aux.materia,
				aux.gestion,aux.id_gestion,aux.pp,aux.sp,aux.tp,aux.ef,aux.ast,aux.si,aux.ma,aux.gr,aux.nf,
				aux.estnota,aux.obs,aux.id_nivel,aux.tpgrupo,aux.id_grupo,aux.paralelo,aux.total_horas,aux.cod_materia,aux.creditos,
				aux.horas_teoria,aux.horas_practica,aux.ord
				order by aux.ord ASC;
end;
$function$


CREATE OR REPLACE FUNCTION unicen.sheiko_listarkardex66(
	unicod integer,
	idcarr integer,
	idsed integer)
    RETURNS TABLE(col bigint, idnot integer, plan integer, mate character varying, gest character varying, idges integer, p1 double precision, p2 double precision, p3 double precision, exfin double precision, asis double precision, seginst double precision, mesa double precision, graci double precision, notafin double precision, estado character varying, observac text, nivel integer, tgrupo character varying, idgru integer, paralel character varying, totalh double precision, codmater character varying, cred integer, ht double precision, hp double precision, orden integer, idmate integer) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
begin
   return query
				
				SELECT distinct  ROW_NUMBER() OVER (ORDER BY  aux.id_gestion asc) as numer, aux.id_nota,aux.id_plan_estudio,aux.materia,
				aux.gestion,aux.id_gestion,aux.pp,aux.sp,aux.tp,aux.ef,aux.ast,aux.si,aux.ma,aux.gr,aux.nf,
				aux.estnota,aux.obs,aux.id_nivel,aux.tpgrupo,aux.id_grupo,aux.paralelo,aux.total_horas,aux.cod_materia,aux.creditos,
				aux.horas_teoria,aux.horas_practica,aux.ord,aux.id_materia
				from (
	            select nt.id_nota,nt.id_plan_estudio,mat.nombre materia,
				ges.nombre gestion,nt.id_gestion,nt.pp,nt.sp,nt.tp,nt.ef,nt.ast,nt.si,nt.ma,nt.gr,nt.nf,
				nt.estnota, CASE WHEN nt.paralelo = 'CONVALIDADO' THEN conv.rr_rv || conv.resolucion ELSE nt.obs END::text as obs,pm.id_nivel,''::character varying tpgrupo,0::integer id_grupo,nt.paralelo,pm.total_horas,mat.cod_materia,pm.creditos,
				pm.horas_teoria,pm.horas_practica,ges.ord,mat.id_materia
				
				from unicen.nota nt
				inner join unicen.materia mat on nt.id_materia = mat.id_materia and mat.id_sede=idsed
			    inner join unicen.plan_materia pm on nt.id_materia= pm.id_materia and pm.id_plan_estudio=idcarr and pm.id_sede=idsed
				inner join unicen.gestion ges on nt.id_gestion = ges.id_gestion
				inner join unicen.plan_estudio pl on nt.id_plan_estudio = pl.id_plan_estudio and pl.id_sede=idsed
				left join unicen.conva_estudiante conv on nt.unicodigo=conv.unicodigo and conv.id_sede=idsed and conv.gestion=nt.id_gestion 
					and nt.paralelo in ('HOM/CONV','PRECONVALIDADO', 'CONVALIDADO')--and nt.paralelo = 'HOM/CONV'
					
				where nt.unicodigo=unicod and nt.id_sede=idsed
				and nt.est = 'ACTIVO' 
				and nt.id_plan_estudio=idcarr
				and nt.id_grupo is null 
				
				union all 
				select nt.id_nota,nt.id_plan_estudio,mat.nombre,
				ges.nombre,nt.id_gestion,nt.pp,nt.sp,nt.tp,nt.ef,nt.ast,nt.si,nt.ma,nt.gr,nt.nf,
				nt.estnota,nt.obs,pm.id_nivel,gr.tpgrupo,nt.id_grupo,nt.paralelo,pm.total_horas,mat.cod_materia,pm.creditos,
				pm.horas_teoria,pm.horas_practica,ges.ord,mat.id_materia
				
				from unicen.nota nt
				inner join unicen.materia mat on nt.id_materia = mat.id_materia and mat.id_sede=idsed
			    inner join unicen.plan_materia pm on nt.id_materia= pm.id_materia and pm.id_plan_estudio=idcarr and pm.id_sede=idsed
				inner join unicen.gestion ges on nt.id_gestion = ges.id_gestion
				inner join unicen.plan_estudio pl on nt.id_plan_estudio = pl.id_plan_estudio and pl.id_sede=idsed
				inner join (select * from unicen.grupo where tpgrupo = 'TEORICO' and id_sede=idsed and id_plan_estudio=idcarr) gr on nt.id_grupo = gr.id_grupo 
				left join unicen.conva_estudiante conv on nt.unicodigo=conv.unicodigo and conv.id_sede=idsed and conv.gestion=nt.id_gestion 
					and nt.paralelo in ('HOM/CONV','PRECONVALIDADO', 'CONVALIDADO') --and nt.paralelo = 'HOM/CONV'
				
				where nt.unicodigo=unicod and nt.id_sede=idsed
				and nt.est = 'ACTIVO' 
				and nt.id_plan_estudio=idcarr)aux
					
				group by aux.id_nota,aux.id_plan_estudio,aux.materia,
				aux.gestion,aux.id_gestion,aux.pp,aux.sp,aux.tp,aux.ef,aux.ast,aux.si,aux.ma,aux.gr,aux.nf,
				aux.estnota,aux.obs,aux.id_nivel,aux.tpgrupo,aux.id_grupo,aux.paralelo,aux.total_horas,aux.cod_materia,aux.creditos,
				aux.horas_teoria,aux.horas_practica,aux.ord,aux.id_materia
				order by aux.ord ASC;
end;
$BODY$;