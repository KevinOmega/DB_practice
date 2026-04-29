SELECT *, CASE WHEN notas.nf >= 51 THEN 'APROBADO' ELSE 'REPROBADO' END estnota FROM (
    SELECT
        19977 as unicodigo,
        nt.id_estudiante,
        179 as id_plan_externo,
        pm.id_materia,
        3 as id_sede,
        pmgd.id_gestion,
        MAX(CASE WHEN nt.id_tipo_nota = 1 THEN nt.nota  END) pp,
        MAX(CASE WHEN nt.id_tipo_nota = 2 THEN nt.nota END) sp,
        MAX(CASE WHEN nt.id_tipo_nota = 3 THEN nt.nota END) tp,
        MAX(CASE WHEN nt.id_tipo_nota = 4 THEN nt.nota END) ast,
        MAX(CASE WHEN nt.id_tipo_nota = 5 THEN nt.nota END) ef,
        MAX(CASE WHEN nt.id_tipo_nota = 6 THEN nt.nota END) nfr,
        MAX(CASE WHEN nt.id_tipo_nota = 7 THEN nt.nota END) si,
        MAX(CASE WHEN nt.id_tipo_nota = 8 THEN nt.nota END) ma,
        MAX(CASE WHEN nt.id_tipo_nota = 9 THEN nt.nota  END) gr,
        GREATEST(
            MAX(CASE WHEN nt.id_tipo_nota = 6 THEN nt.nota END),
            MAX(CASE WHEN nt.id_tipo_nota = 7 THEN nt.nota END),
            MAX(CASE WHEN nt.id_tipo_nota = 8 THEN nt.nota END),
            MAX(CASE WHEN nt.id_tipo_nota = 9 THEN nt.nota END)
        ) nf,
        'ACTIVO' as est,
        pmgd.grupo,
        pmgd.id_turno,
        'PREINSCRITO' AS estinsc,
        'WEBADM' AS tipo_ins,
        'N' AS recursada
    FROM unicen.nota nt
    JOIN unicen.plan_materia_gestion_docente pmgd ON nt.id_plan_materia_gestion_docente = pmgd.id_plan_materia_gestion_docente
    JOIN unicen.plan_materia pm ON pmgd.id_plan_materia = pm.id_plan_materia
    WHERE nt.id_estudiante = 11930
    GROUP BY nt.id_estudiante,pm.id_materia, pmgd.id_gestion, pmgd.grupo,pmgd.id_turno
) notas;
