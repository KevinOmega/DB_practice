

SELECT '{
    "key": "value",
    "key1": "value"
}' :: JSON

CREATE TABLE books(
    book_id SERIAL PRIMARY KEY,
    book JSONB
)


"36026"

INSERT INTO books (
    book
)
VALUES(
    '{
        "title" : "Book title",
        "author": "author1"   
    }'
);
INSERT INTO books (
    book
)
VALUES(
    '{
        "title" : "JANGO",
        "author": "author1"   
    }'
),
(
    '{
        "title" : "LORD OF THE RINGS",
        "author": "author1"   
    }'
),(
    '{
        "title" : "STAR WARS",
        "author": "author3"   
    }'
);
SELECT * FROM books;


-- SELECTING DATA FROM JSON
-- WITH -> for getting with quotes
SELECT book->'author' from books;

-- with ->> for getting as a text without quotes
SELECT book->>'title' from books;

-- FILTERING DATAj

SELECT * from books where book->>'title' = 'JANGO';




SELECT  ROW_NUMBER () OVER (ORDER BY car.nombre,est.paterno, est.materno, est.nombres), est.unicodigo,careco.id_plan_economico, est.matricula, est.num_documento,ci.nombre,  est.paterno, est.materno, est.nombres, est.sexo, pai.nombre , car.nombre, pleco.nombre, baca.categoria, baca.resolucion, baca.fechareg, baca.observacion, 'NUEVO' :: text, 0  FROM (
         select  * from unicen.estudiante where id_sede = 1 and unicodigo in (
                        SELECT ins.unicodigo
                        from unicen.inscripcion ins
                           JOIN (
                              SELECT nt.unicodigo, min(ge.fecha_fin)
                              from unicen.nota nt
                                    JOIN unicen.gestion ge ON nt.id_gestion = ge.id_gestion
                              where nt.id_sede = idsed
                              group by unicodigo
                              having min(ge.fecha_fin) = (
                                       SELECT fecha_fin from unicen.gestion
                                       where id_gestion = idges
                                    )
                           ) est_nuevos ON ins.unicodigo = est_nuevos.unicodigo
                        WHERE
                           ins.id_gestion = idges and ins.estinsceco = 'INSCRITO' and ins.id_sede = idsed
         )
      ) est INNER JOIN unicen.estudiantecareco careco ON est.unicodigo = careco.unicodigo
      INNER JOIN unicen.plan_economico pleco ON careco.id_plan_economico = pleco.id_plan_economico and careco.id_sede = pleco.id_sede
      LEFT JOIN unicen.baja_academica baca ON est.unicodigo = baca.unicodigo and baca.id_plan_estudio = careco.id_plan_estudio
      INNER JOIN unicen.carrera car ON careco.id_carrera = car.id_carrera and careco.id_sede = car.id_sede
      INNER JOIN unicen.ciudad ci ON est.ext_documento = ci.id_ciudad
      INNER JOIN unicen.pais pai ON est.nacionalidad = pai.id_pais
      ORDER BY car.nombre, est.paterno, est.materno, est.nombres;