
-- ============================================================
-- PROPAGACIÓN DE CONTENIDOS ANALÍTICOS ENTRE SEDES EQUIVALENTES
-- ============================================================
-- Objetivo: cuando se inserta, modifica o elimina un tema en
-- una materia origen (según unicen.equivalencia_materia_unicen),
-- replicar automáticamente esa acción en todas las materias
-- destino equivalentes.
--
-- Pasos:
--   1. Agregar columna id_tema_unicen_origen a tema_unicen
--   2. Backfill de registros destino ya existentes
--   3. Actualizar procedure agregar_temas_unicen
--   4. Actualizar procedure pr_agregar_tema_unicen_de_materia
--   5. Crear trigger function trg_fn_propagar_tema_unicen
--   6. Crear trigger trg_propagar_tema_unicen en tema_unicen
-- ============================================================


-- ============================================================
-- 1. NUEVA COLUMNA
-- ============================================================
-- Vincula cada fila destino con el id del tema origen del que
-- fue copiada. Nula en filas origen (no son copia de nadie).
ALTER TABLE unicen.tema_unicen
ADD COLUMN IF NOT EXISTS id_tema_unicen_origen INTEGER;


-- ============================================================
-- 2. BACKFILL PARA DATOS EXISTENTES
-- ============================================================
-- Pobla id_tema_unicen_origen en las filas destino que ya
-- existen antes de este script, haciendo match por nombre
-- dentro del par (materia_origen, materia_destino) definido
-- en equivalencia_materia_unicen.
UPDATE unicen.tema_unicen t_dest
SET    id_tema_unicen_origen = t_orig.id_tema_unicen
FROM   unicen.tema_unicen t_orig
JOIN   unicen.equivalencia_materia_unicen emu
       ON  emu.id_plan_estudio_origen = t_orig.id_plan_estudio
       AND emu.id_materia_origen      = t_orig.id_materia
       AND emu.id_sede_origen         = t_orig.id_sede
WHERE  t_dest.id_plan_estudio        = emu.id_plan_estudio_destino
  AND  t_dest.id_materia             = emu.id_materia_destino
  AND  t_dest.id_sede                = emu.id_sede_destino
  AND  t_dest.nombre                 = t_orig.nombre
  AND  t_dest.id_tema_unicen_origen  IS NULL;


-- ============================================================
-- 3. PROCEDURE: agregar_temas_unicen (actualizado)
-- ============================================================
-- Cambios respecto a la versión anterior:
--   - Especifica id_tema_unicen con MAX(id)+ROW_NUMBER para
--     evitar depender de la secuencia dañada.
--   - Rellena id_tema_unicen_origen con el id del tema origen.
DROP PROCEDURE IF EXISTS unicen.agregar_temas_unicen(integer, integer, integer, integer);

CREATE OR REPLACE PROCEDURE unicen.agregar_temas_unicen(
    p_id_plan_estudio_origen  integer,
    p_id_sede_origen          integer,
    p_id_plan_estudio_destino integer,
    p_id_sede_destino         integer
) AS $$
BEGIN
    INSERT INTO unicen.tema_unicen (
        id_tema_unicen,
        id_plan_estudio,
        id_materia,
        nombre,
        titulo,
        contenido,
        id_sede,
        estado,
        id_tema_unicen_origen
    )
    WITH max_id AS (
        SELECT COALESCE(MAX(id_tema_unicen), 0) AS val
        FROM   unicen.tema_unicen
    ),
    source AS (
        SELECT
            emu.id_plan_estudio_destino,
            emu.id_materia_destino,
            t.nombre,
            t.titulo,
            t.contenido,
            t.id_tema_unicen        AS origen_id,
            ROW_NUMBER() OVER ()    AS rn
        FROM unicen.tema_unicen t
        JOIN (
            SELECT *
            FROM   unicen.equivalencia_materia_unicen
            WHERE  id_sede_origen          = p_id_sede_origen
              AND  id_plan_estudio_origen  = p_id_plan_estudio_origen
              AND  id_sede_destino         = p_id_sede_destino
              AND  id_plan_estudio_destino = p_id_plan_estudio_destino
        ) emu
          ON  t.id_materia      = emu.id_materia_origen
          AND t.id_plan_estudio = emu.id_plan_estudio_origen
          AND t.id_sede         = emu.id_sede_origen
    )
    SELECT
        m.val + s.rn,
        s.id_plan_estudio_destino,
        s.id_materia_destino,
        s.nombre,
        s.titulo,
        s.contenido,
        p_id_sede_destino,
        'ACTIVO',
        s.origen_id
    FROM source s, max_id m;
END;
$$ LANGUAGE plpgsql;


-- ============================================================
-- 4. PROCEDURE: pr_agregar_tema_unicen_de_materia (actualizado)
-- ============================================================
-- Mismos cambios que el anterior pero para una sola materia.
DROP PROCEDURE IF EXISTS unicen.pr_agregar_tema_unicen_de_materia(integer, integer, integer, integer, integer, integer);

CREATE OR REPLACE PROCEDURE unicen.pr_agregar_tema_unicen_de_materia(
    p_id_plan_estudio_origen  integer,
    p_id_materia_origen       integer,
    p_id_sede_origen          integer,
    p_id_plan_estudio_destino integer,
    p_id_materia_destino      integer,
    p_id_sede_destino         integer
) AS $$
BEGIN
    INSERT INTO unicen.tema_unicen (
        id_tema_unicen,
        id_plan_estudio,
        id_materia,
        nombre,
        titulo,
        contenido,
        id_sede,
        estado,
        id_tema_unicen_origen
    )
    WITH max_id AS (
        SELECT COALESCE(MAX(id_tema_unicen), 0) AS val
        FROM   unicen.tema_unicen
    ),
    source AS (
        SELECT
            emu.id_plan_estudio_destino,
            emu.id_materia_destino,
            t.nombre,
            t.titulo,
            t.contenido,
            t.id_tema_unicen        AS origen_id,
            ROW_NUMBER() OVER ()    AS rn
        FROM unicen.tema_unicen t
        JOIN (
            SELECT *
            FROM   unicen.equivalencia_materia_unicen
            WHERE  id_sede_origen          = p_id_sede_origen
              AND  id_plan_estudio_origen  = p_id_plan_estudio_origen
              AND  id_materia_origen       = p_id_materia_origen
              AND  id_sede_destino         = p_id_sede_destino
              AND  id_plan_estudio_destino = p_id_plan_estudio_destino
              AND  id_materia_destino      = p_id_materia_destino
        ) emu
          ON  t.id_materia      = emu.id_materia_origen
          AND t.id_plan_estudio = emu.id_plan_estudio_origen
          AND t.id_sede         = emu.id_sede_origen
    )
    SELECT
        m.val + s.rn,
        s.id_plan_estudio_destino,
        s.id_materia_destino,
        s.nombre,
        s.titulo,
        s.contenido,
        p_id_sede_destino,
        'ACTIVO',
        s.origen_id
    FROM source s, max_id m;
END;
$$ LANGUAGE plpgsql;


-- ============================================================
-- 5. TRIGGER FUNCTION: trg_fn_propagar_tema_unicen
-- ============================================================
-- Lógica por operación:
--
--   INSERT: busca todas las equivalencias donde la materia
--     recién insertada sea origen y crea una copia del tema
--     en cada materia destino, apuntando a NEW.id_tema_unicen.
--
--   UPDATE: actualiza nombre/titulo/contenido/estado en todos
--     los temas destino que referencian a OLD.id_tema_unicen.
--     No toca los campos estructurales (plan, materia, sede).
--
--   DELETE: elimina todos los temas destino que referencian
--     a OLD.id_tema_unicen antes de que el origen desaparezca.
--
-- Guarda anti-recursión: si el trigger fue invocado desde otro
-- trigger (pg_trigger_depth > 1) sale sin hacer nada, evitando
-- bucles en caso de equivalencias encadenadas o circulares.
-- ============================================================
CREATE OR REPLACE FUNCTION unicen.trg_fn_propagar_tema_unicen()
RETURNS trigger LANGUAGE plpgsql AS $$
DECLARE
    equiv  RECORD;
    new_id INTEGER;
BEGIN
    -- Evitar cascada infinita: solo actuar en el primer nivel
    IF pg_trigger_depth() > 1 THEN
        RETURN COALESCE(NEW, OLD);
    END IF;

    -- --------------------------------------------------------
    -- INSERT: replicar el nuevo tema en cada materia destino
    -- --------------------------------------------------------
    IF TG_OP = 'INSERT' THEN

        FOR equiv IN
            SELECT *
            FROM   unicen.equivalencia_materia_unicen
            WHERE  id_plan_estudio_origen = NEW.id_plan_estudio
              AND  id_materia_origen      = NEW.id_materia
              AND  id_sede_origen         = NEW.id_sede
              AND  estado                 = 'ACTIVO'
        LOOP
            SELECT COALESCE(MAX(id_tema_unicen), 0) + 1
            INTO   new_id
            FROM   unicen.tema_unicen;

            INSERT INTO unicen.tema_unicen (
                id_tema_unicen,
                id_plan_estudio,
                id_materia,
                nombre,
                titulo,
                contenido,
                id_sede,
                estado,
                id_tema_unicen_origen
            ) VALUES (
                new_id,
                equiv.id_plan_estudio_destino,
                equiv.id_materia_destino,
                NEW.nombre,
                NEW.titulo,
                NEW.contenido,
                equiv.id_sede_destino,
                NEW.estado,
                NEW.id_tema_unicen
            );
        END LOOP;

        RETURN NEW;

    -- --------------------------------------------------------
    -- UPDATE: propagar cambios de contenido a los destinos
    -- --------------------------------------------------------
    ELSIF TG_OP = 'UPDATE' THEN

        UPDATE unicen.tema_unicen
        SET    nombre    = NEW.nombre,
               titulo    = NEW.titulo,
               contenido = NEW.contenido,
               estado    = NEW.estado
        WHERE  id_tema_unicen_origen = OLD.id_tema_unicen;

        RETURN NEW;

    -- --------------------------------------------------------
    -- DELETE: eliminar las copias destino antes que el origen
    -- --------------------------------------------------------
    ELSIF TG_OP = 'DELETE' THEN

        DELETE FROM unicen.tema_unicen
        WHERE  id_tema_unicen_origen = OLD.id_tema_unicen;

        RETURN OLD;

    END IF;

    RETURN COALESCE(NEW, OLD);
END;
$$;


-- ============================================================
-- 6. TRIGGER en unicen.tema_unicen
-- ============================================================
DROP TRIGGER IF EXISTS trg_propagar_tema_unicen ON unicen.tema_unicen;

CREATE TRIGGER trg_propagar_tema_unicen
AFTER INSERT OR UPDATE OR DELETE ON unicen.tema_unicen
FOR EACH ROW
EXECUTE FUNCTION unicen.trg_fn_propagar_tema_unicen();
