select * from unicen.ciudad ;

-- cusco_id = 41

select * from unicen.provincia;


SELECT * FROM unicen.pais;

select * from unicen.ciudad where nombre = 'PUNO';


SELECT * FROM unicen.ciudad where UPPER(nombre) IN ('AMAZONAS', 'ANCASH', 'APURÍMAC', 'AREQUIPA', 'AYACUCHO', 'CAJAMARCA', 'CALLAO', 'CUSCO', 'HUANCAVELICA', 'HUÁNUCO', 'ICA', 'JUNÍN', 'LA LIBERTAD', 'LAMBAYEQUE', 'LIMA', 'LORETO', 'MADRE DE DIOS', 'MOQUEGUA', 'PASCO', 'PIURA', 'SAN MARTÍN', 'TACNA', 'TUMBES', 'UCAYALI');

-- Inserta ciudades peruanas con abreviación departamental si no existen
WITH new_cities(nombre, id_pais, alpha3, estado) AS (
    VALUES
        ('Amazonas', 4, 'AMA', NULL),
        ('Ancash', 4, 'ANC', NULL),
        ('Apurímac', 4, 'APU', NULL),
        ('Arequipa', 4, 'ARE', NULL),
        ('Ayacucho', 4, 'AYA', NULL),
        ('Cajamarca', 4, 'CAJ', NULL),
        ('Callao', 4, 'CAL', NULL),
        ('Cusco', 4, 'CUS', NULL),
        ('Huancavelica', 4, 'HUV', NULL),
        ('Huánuco', 4, 'HUC', NULL),
        ('Ica', 4, 'ICA', NULL),
        ('Junín', 4, 'JUN', NULL),
        ('La Libertad', 4, 'LAL', NULL),
        ('Lambayeque', 4, 'LAM', NULL),
        ('Lima', 4, 'LIM', NULL),
        ('Loreto', 4, 'LOR', NULL),
        ('Madre de Dios', 4, 'MDD', NULL),
        ('Moquegua', 4, 'MOQ', NULL),
        ('Pasco', 4, 'PAS', NULL),
        ('Piura', 4, 'PIU', NULL),
        ('San Martín', 4, 'SAM', NULL),
        ('Tacna', 4, 'TAC', NULL),
        ('Tumbes', 4, 'TUM', NULL),
        ('Ucayali', 4, 'UCA', NULL)
)
INSERT INTO unicen.ciudad (nombre, id_pais, alpha3, estado)
SELECT n.nombre, n.id_pais, n.alpha3, n.estado
FROM new_cities n
WHERE NOT EXISTS (
    SELECT 1
    FROM unicen.ciudad c
    WHERE UPPER(c.nombre) = UPPER(n.nombre)
      AND c.id_pais = n.id_pais
);

INSERT INTO unicen.ciudad (nombre, id_pais, alpha3, estado) VALUES ('PUNO', 4, 'PUN', 'ACTIVO');

-- Verificación
SELECT c.id_ciudad, c.nombre, c.id_pais, c.alpha3, c.estado
FROM unicen.ciudad c
WHERE UPPER(c.nombre) IN (
    'AMAZONAS','ANCASH','APURÍMAC','AREQUIPA','AYACUCHO','CAJAMARCA','CALLAO',
    'CUSCO','HUANCAVELICA','HUÁNUCO','ICA','JUNÍN','LA LIBERTAD','LAMBAYEQUE',
    'LIMA','LORETO','MADRE DE DIOS','MOQUEGUA','PASCO','PIURA','SAN MARTÍN',
    'TACNA','TUMBES','UCAYALI'
);

UPDATE unicen.ciudad
SET estado = 'ACTIVO'
WHERE id_pais = 4
  AND UPPER(nombre) IN (
    'AMAZONAS','ANCASH','APURÍMAC','AREQUIPA','AYACUCHO','CAJAMARCA','CALLAO',
    'CUSCO','HUANCAVELICA','HUÁNUCO','ICA','JUNÍN','LA LIBERTAD','LAMBAYEQUE',
    'LIMA','LORETO','MADRE DE DIOS','MOQUEGUA','PASCO','PIURA','SAN MARTÍN',
    'TACNA','TUMBES','UCAYALI'
);

select * from unicen.ciudad where id_pais = 4;


Amazonas	AMAZONAS
Ancash	ANCASH
Apurímac	Abancay
Apurímac	Andahuaylas
Apurímac	Antabamba
Apurímac	Aymaraes
Apurímac	Cotabambas
Apurímac	Chincheros
Apurímac	Grau
Arequipa	Arequipa
Arequipa	Camaná
Arequipa	Caravelí
Arequipa	Castilla
Arequipa	Caylloma
Arequipa	Condesuyos
Arequipa	Islay
Arequipa	La Unión
Ayacucho	Huamanga
Ayacucho	Cangallo
Ayacucho	Huanca Sancos
Ayacucho	Huanta
Ayacucho	La Mar
Ayacucho	Lucanas
Ayacucho	Parinacochas
Ayacucho	Paucar del Sara Sara
Ayacucho	Sucre
Ayacucho	Víctor Fajardo
Ayacucho	Vilcas Huamán
Cajamarca	Cajamarca
Cajamarca	Cajabamba
Cajamarca	Celendín
Cajamarca	Chota
Cajamarca	Contumazá
Cajamarca	Cutervo
Cajamarca	Hualgayoc
Cajamarca	Jaén
Cajamarca	San Ignacio
Cajamarca	San Marcos
Cajamarca	San Miguel
Cajamarca	San Pablo
Cajamarca	Santa Cruz
Callao	Callao
Cusco	Cusco
Cusco	Acomayo
Cusco	Anta
Cusco	Calca
Cusco	Canas
Cusco	Canchis
Cusco	Chumbivilcas
Cusco	Espinar
Cusco	La Convención
Cusco	Paruro
Cusco	Paucartambo
Cusco	Quispicanchi
Cusco	Urubamba
Huancavelica	Huancavelica
Huánuco	Huánuco
Ica	Ica
Ica	Chincha
Ica	Nasca
Ica	Palpa
Ica	Pisco
Junín	Junín
La Libertad	La Libertad
Lambayeque	Lambayeque
Lima	Lima
Lima	Barranca
Lima	Cajatambo
Lima	Canta
Lima	Cañete
Lima	Huaral
Lima	Huarochirí
Lima	Huaura
Lima	Oyón
Lima	Yauyos
Loreto	Loreto
Madre de Dios	Tambopata
Moquegua	Ilo
Pasco	Pasco
Pasco	Daniel Alcides Carrión
Pasco	Oxapampa
Piura	Piura
Puno	Puno
Puno	Azángaro
Puno	Carabaya
Puno	Chucuito
Puno	El Collao
Puno	Huancané
Puno	Lampa
Puno	Melgar
Puno	Moho
Puno	San Antonio de Putina
Puno	San Román
Puno	Sandia
Puno	Yunguyo
San Martín	San Martín
Tacna	Tacna
Tumbes	Tumbes
Ucayali	Ucayali


SELECT * FROM unicen.ciudad where id_pais = 4;


44	AMAZONAS	4	AMA	ACTIVO
45	ANCASH	4	ANC	ACTIVO
46	APURÍMAC	4	APU	ACTIVO
47	AREQUIPA	4	ARE	ACTIVO
48	AYACUCHO	4	AYA	ACTIVO
49	CAJAMARCA	4	CAJ	ACTIVO
50	CALLAO	4	CAL	ACTIVO
41	CUSCO	4	CUSCO	ACTIVO
51	HUANCAVELICA	4	HUV	ACTIVO
52	HUÁNUCO	4	HUC	ACTIVO
53	ICA	4	ICA	ACTIVO
67	JULIACA	4	JUL	ACTIVO
54	JUNÍN	4	JUN	ACTIVO
55	LA LIBERTAD	4	LAL	ACTIVO
56	LAMBAYEQUE	4	LAM	ACTIVO
57	LIMA	4	LIM	ACTIVO
58	LORETO	4	LOR	ACTIVO
59	MADRE DE DIOS	4	MDD	ACTIVO
60	MOQUEGUA	4	MOQ	ACTIVO
61	PASCO	4	PAS	ACTIVO
12	PERU	4	PER	ACTIVO
62	PIURA	4	PIU	ACTIVO
68	PUNO	4	PUN	ACTIVO
63	SAN MARTÍN	4	SAM	ACTIVO
64	TACNA	4	TAC	ACTIVO
65	TUMBES	4	TUM	ACTIVO
66	UCAYALI	4	UCA	ACTIVO


-- 1) Datos base: CIUDAD (departamento) y DISTRITO, ambos en mayúsculas
WITH data(city_name, district) AS (
    VALUES
        ('AMAZONAS','AMAZONAS'),
        ('ANCASH','ANCASH'),
        ('APURÍMAC','ABANCAY'),
        ('APURÍMAC','ANDAHUAYLAS'),
        ('APURÍMAC','ANTABAMBA'),
        ('APURÍMAC','AYMARAES'),
        ('APURÍMAC','COTABAMBAS'),
        ('APURÍMAC','CHINCHEROS'),
        ('APURÍMAC','GRAU'),
        ('AREQUIPA','AREQUIPA'),
        ('AREQUIPA','CAMANÁ'),
        ('AREQUIPA','CARAVELÍ'),
        ('AREQUIPA','CASTILLA'),
        ('AREQUIPA','CAYLLOMA'),
        ('AREQUIPA','CONDESUYOS'),
        ('AREQUIPA','ISLAY'),
        ('AREQUIPA','LA UNIÓN'),
        ('AYACUCHO','HUAMANGA'),
        ('AYACUCHO','CANGALLO'),
        ('AYACUCHO','HUANCA SANCOS'),
        ('AYACUCHO','HUANTA'),
        ('AYACUCHO','LA MAR'),
        ('AYACUCHO','LUCANAS'),
        ('AYACUCHO','PARINACOCHAS'),
        ('AYACUCHO','PAUCAR DEL SARA SARA'),
        ('AYACUCHO','SUCRE'),
        ('AYACUCHO','VÍCTOR FAJARDO'),
        ('AYACUCHO','VILCAS HUAMÁN'),
        ('CAJAMARCA','CAJAMARCA'),
        ('CAJAMARCA','CAJABAMBA'),
        ('CAJAMARCA','CELENDÍN'),
        ('CAJAMARCA','CHOTA'),
        ('CAJAMARCA','CONTUMAZÁ'),
        ('CAJAMARCA','CUTERVO'),
        ('CAJAMARCA','HUALGAYOC'),
        ('CAJAMARCA','JAÉN'),
        ('CAJAMARCA','SAN IGNACIO'),
        ('CAJAMARCA','SAN MARCOS'),
        ('CAJAMARCA','SAN MIGUEL'),
        ('CAJAMARCA','SAN PABLO'),
        ('CAJAMARCA','SANTA CRUZ'),
        ('CALLAO','CALLAO'),
        ('CUSCO','CUSCO'),
        ('CUSCO','ACOMAYO'),
        ('CUSCO','ANTA'),
        ('CUSCO','CALCA'),
        ('CUSCO','CANAS'),
        ('CUSCO','CANCHIS'),
        ('CUSCO','CHUMBIVILCAS'),
        ('CUSCO','ESPINAR'),
        ('CUSCO','LA CONVENCIÓN'),
        ('CUSCO','PARURO'),
        ('CUSCO','PAUCARTAMBO'),
        ('CUSCO','QUISPICANCHI'),
        ('CUSCO','URUBAMBA'),
        ('HUANCAVELICA','HUANCAVELICA'),
        ('HUÁNUCO','HUÁNUCO'),
        ('ICA','ICA'),
        ('ICA','CHINCHA'),
        ('ICA','NASCA'),
        ('ICA','PALPA'),
        ('ICA','PISCO'),
        ('JUNÍN','JUNÍN'),
        ('LA LIBERTAD','LA LIBERTAD'),
        ('LAMBAYEQUE','LAMBAYEQUE'),
        ('LIMA','LIMA'),
        ('LIMA','BARRANCA'),
        ('LIMA','CAJATAMBO'),
        ('LIMA','CANTA'),
        ('LIMA','CAÑETE'),
        ('LIMA','HUARAL'),
        ('LIMA','HUAROCHIRÍ'),
        ('LIMA','HUAURA'),
        ('LIMA','OYÓN'),
        ('LIMA','YAUYOS'),
        ('LORETO','LORETO'),
        ('MADRE DE DIOS','TAMBOPATA'),
        ('MOQUEGUA','ILO'),
        ('PASCO','PASCO'),
        ('PASCO','DANIEL ALCIDES CARRIÓN'),
        ('PASCO','OXAPAMPA'),
        ('PIURA','PIURA'),
        ('PUNO','PUNO'),
        ('PUNO','AZÁNGARO'),
        ('PUNO','CARABAYA'),
        ('PUNO','CHUCUITO'),
        ('PUNO','EL COLLAO'),
        ('PUNO','HUANCANÉ'),
        ('PUNO','LAMPA'),
        ('PUNO','MELGAR'),
        ('PUNO','MOHO'),
        ('PUNO','SAN ANTONIO DE PUTINA'),
        ('PUNO','SAN ROMÁN'),
        ('PUNO','SANDIA'),
        ('PUNO','YUNGUYO'),
        ('SAN MARTÍN','SAN MARTÍN'),
        ('TACNA','TACNA'),
        ('TUMBES','TUMBES'),
        ('UCAYALI','UCAYALI')
)

-- 2) Ciudades faltantes (no están en unicen.ciudad con id_pais = 4)
, missing AS (
    SELECT DISTINCT d.city_name
    FROM data d
    LEFT JOIN unicen.ciudad c
      ON UPPER(c.nombre) = d.city_name
     AND c.id_pais = 4
    WHERE c.id_ciudad IS NULL
)
SELECT * FROM missing;

-- Si el SELECT anterior devuelve filas, crea primero esas ciudades (id_pais=4) antes de insertar distritos.
-- Si no hay faltantes, ejecuta el INSERT:

WITH data(city_name, district) AS (
    VALUES
        ('AMAZONAS','AMAZONAS'),
        ('ANCASH','ANCASH'),
        ('APURÍMAC','ABANCAY'),
        ('APURÍMAC','ANDAHUAYLAS'),
        ('APURÍMAC','ANTABAMBA'),
        ('APURÍMAC','AYMARAES'),
        ('APURÍMAC','COTABAMBAS'),
        ('APURÍMAC','CHINCHEROS'),
        ('APURÍMAC','GRAU'),
        ('AREQUIPA','AREQUIPA'),
        ('AREQUIPA','CAMANÁ'),
        ('AREQUIPA','CARAVELÍ'),
        ('AREQUIPA','CASTILLA'),
        ('AREQUIPA','CAYLLOMA'),
        ('AREQUIPA','CONDESUYOS'),
        ('AREQUIPA','ISLAY'),
        ('AREQUIPA','LA UNIÓN'),
        ('AYACUCHO','HUAMANGA'),
        ('AYACUCHO','CANGALLO'),
        ('AYACUCHO','HUANCA SANCOS'),
        ('AYACUCHO','HUANTA'),
        ('AYACUCHO','LA MAR'),
        ('AYACUCHO','LUCANAS'),
        ('AYACUCHO','PARINACOCHAS'),
        ('AYACUCHO','PAUCAR DEL SARA SARA'),
        ('AYACUCHO','SUCRE'),
        ('AYACUCHO','VÍCTOR FAJARDO'),
        ('AYACUCHO','VILCAS HUAMÁN'),
        ('CAJAMARCA','CAJAMARCA'),
        ('CAJAMARCA','CAJABAMBA'),
        ('CAJAMARCA','CELENDÍN'),
        ('CAJAMARCA','CHOTA'),
        ('CAJAMARCA','CONTUMAZÁ'),
        ('CAJAMARCA','CUTERVO'),
        ('CAJAMARCA','HUALGAYOC'),
        ('CAJAMARCA','JAÉN'),
        ('CAJAMARCA','SAN IGNACIO'),
        ('CAJAMARCA','SAN MARCOS'),
        ('CAJAMARCA','SAN MIGUEL'),
        ('CAJAMARCA','SAN PABLO'),
        ('CAJAMARCA','SANTA CRUZ'),
        ('CALLAO','CALLAO'),
        ('CUSCO','CUSCO'),
        ('CUSCO','ACOMAYO'),
        ('CUSCO','ANTA'),
        ('CUSCO','CALCA'),
        ('CUSCO','CANAS'),
        ('CUSCO','CANCHIS'),
        ('CUSCO','CHUMBIVILCAS'),
        ('CUSCO','ESPINAR'),
        ('CUSCO','LA CONVENCIÓN'),
        ('CUSCO','PARURO'),
        ('CUSCO','PAUCARTAMBO'),
        ('CUSCO','QUISPICANCHI'),
        ('CUSCO','URUBAMBA'),
        ('HUANCAVELICA','HUANCAVELICA'),
        ('HUÁNUCO','HUÁNUCO'),
        ('ICA','ICA'),
        ('ICA','CHINCHA'),
        ('ICA','NASCA'),
        ('ICA','PALPA'),
        ('ICA','PISCO'),
        ('JUNÍN','JUNÍN'),
        ('LA LIBERTAD','LA LIBERTAD'),
        ('LAMBAYEQUE','LAMBAYEQUE'),
        ('LIMA','LIMA'),
        ('LIMA','BARRANCA'),
        ('LIMA','CAJATAMBO'),
        ('LIMA','CANTA'),
        ('LIMA','CAÑETE'),
        ('LIMA','HUARAL'),
        ('LIMA','HUAROCHIRÍ'),
        ('LIMA','HUAURA'),
        ('LIMA','OYÓN'),
        ('LIMA','YAUYOS'),
        ('LORETO','LORETO'),
        ('MADRE DE DIOS','TAMBOPATA'),
        ('MOQUEGUA','ILO'),
        ('PASCO','PASCO'),
        ('PASCO','DANIEL ALCIDES CARRIÓN'),
        ('PASCO','OXAPAMPA'),
        ('PIURA','PIURA'),
        ('PUNO','PUNO'),
        ('PUNO','AZÁNGARO'),
        ('PUNO','CARABAYA'),
        ('PUNO','CHUCUITO'),
        ('PUNO','EL COLLAO'),
        ('PUNO','HUANCANÉ'),
        ('PUNO','LAMPA'),
        ('PUNO','MELGAR'),
        ('PUNO','MOHO'),
        ('PUNO','SAN ANTONIO DE PUTINA'),
        ('PUNO','SAN ROMÁN'),
        ('PUNO','SANDIA'),
        ('PUNO','YUNGUYO'),
        ('SAN MARTÍN','SAN MARTÍN'),
        ('TACNA','TACNA'),
        ('TUMBES','TUMBES'),
        ('UCAYALI','UCAYALI')
)
INSERT INTO unicen.distrito (id_sede, distrito, estado, id_ciudad)
SELECT 2, d.district, 'ACTIVO', c.id_ciudad
FROM data d
JOIN unicen.ciudad c
  ON UPPER(c.nombre) = d.city_name
 AND c.id_pais = 4
WHERE NOT EXISTS (
    SELECT 1
    FROM unicen.distrito di
    WHERE di.distrito = d.district
      AND di.id_ciudad = c.id_ciudad
);

-- 3) Verificar lo insertado / existente
SELECT di.id_distrito, di.distrito, di.id_ciudad, di.id_sede, di.estado, c.nombre AS ciudad
FROM unicen.distrito di
JOIN unicen.ciudad c ON di.id_ciudad = c.id_ciudad
WHERE UPPER(c.nombre) IN (
    'AMAZONAS','ANCASH','APURÍMAC','AREQUIPA','AYACUCHO','CAJAMARCA','CALLAO',
    'CUSCO','HUANCAVELICA','HUÁNUCO','ICA','JUNÍN','LA LIBERTAD','LAMBAYEQUE',
    'LIMA','LORETO','MADRE DE DIOS','MOQUEGUA','PASCO','PIURA','PUNO',
    'SAN MARTÍN','TACNA','TUMBES','UCAYALI'
)
ORDER BY c.nombre, di.distrito;


-- 1) Checa si faltan ciudades (debe existir id_pais = 4)
WITH data(city_name, district) AS (
    VALUES
        ('AMAZONAS','AMAZONAS'),
        ('ANCASH','ANCASH'),
        ('APURÍMAC','ABANCAY'),
        ('APURÍMAC','ANDAHUAYLAS'),
        ('APURÍMAC','ANTABAMBA'),
        ('APURÍMAC','AYMARAES'),
        ('APURÍMAC','COTABAMBAS'),
        ('APURÍMAC','CHINCHEROS'),
        ('APURÍMAC','GRAU'),
        ('AREQUIPA','AREQUIPA'),
        ('AREQUIPA','CAMANÁ'),
        ('AREQUIPA','CARAVELÍ'),
        ('AREQUIPA','CASTILLA'),
        ('AREQUIPA','CAYLLOMA'),
        ('AREQUIPA','CONDESUYOS'),
        ('AREQUIPA','ISLAY'),
        ('AREQUIPA','LA UNIÓN'),
        ('AYACUCHO','HUAMANGA'),
        ('AYACUCHO','CANGALLO'),
        ('AYACUCHO','HUANCA SANCOS'),
        ('AYACUCHO','HUANTA'),
        ('AYACUCHO','LA MAR'),
        ('AYACUCHO','LUCANAS'),
        ('AYACUCHO','PARINACOCHAS'),
        ('AYACUCHO','PAUCAR DEL SARA SARA'),
        ('AYACUCHO','SUCRE'),
        ('AYACUCHO','VÍCTOR FAJARDO'),
        ('AYACUCHO','VILCAS HUAMÁN'),
        ('CAJAMARCA','CAJAMARCA'),
        ('CAJAMARCA','CAJABAMBA'),
        ('CAJAMARCA','CELENDÍN'),
        ('CAJAMARCA','CHOTA'),
        ('CAJAMARCA','CONTUMAZÁ'),
        ('CAJAMARCA','CUTERVO'),
        ('CAJAMARCA','HUALGAYOC'),
        ('CAJAMARCA','JAÉN'),
        ('CAJAMARCA','SAN IGNACIO'),
        ('CAJAMARCA','SAN MARCOS'),
        ('CAJAMARCA','SAN MIGUEL'),
        ('CAJAMARCA','SAN PABLO'),
        ('CAJAMARCA','SANTA CRUZ'),
        ('CALLAO','CALLAO'),
        ('CUSCO','CUSCO'),
        ('CUSCO','ACOMAYO'),
        ('CUSCO','ANTA'),
        ('CUSCO','CALCA'),
        ('CUSCO','CANAS'),
        ('CUSCO','CANCHIS'),
        ('CUSCO','CHUMBIVILCAS'),
        ('CUSCO','ESPINAR'),
        ('CUSCO','LA CONVENCIÓN'),
        ('CUSCO','PARURO'),
        ('CUSCO','PAUCARTAMBO'),
        ('CUSCO','QUISPICANCHI'),
        ('CUSCO','URUBAMBA'),
        ('HUANCAVELICA','HUANCAVELICA'),
        ('HUÁNUCO','HUÁNUCO'),
        ('ICA','ICA'),
        ('ICA','CHINCHA'),
        ('ICA','NASCA'),
        ('ICA','PALPA'),
        ('ICA','PISCO'),
        ('JUNÍN','JUNÍN'),
        ('LA LIBERTAD','LA LIBERTAD'),
        ('LAMBAYEQUE','LAMBAYEQUE'),
        ('LIMA','LIMA'),
        ('LIMA','BARRANCA'),
        ('LIMA','CAJATAMBO'),
        ('LIMA','CANTA'),
        ('LIMA','CAÑETE'),
        ('LIMA','HUARAL'),
        ('LIMA','HUAROCHIRÍ'),
        ('LIMA','HUAURA'),
        ('LIMA','OYÓN'),
        ('LIMA','YAUYOS'),
        ('LORETO','LORETO'),
        ('MADRE DE DIOS','TAMBOPATA'),
        ('MOQUEGUA','ILO'),
        ('PASCO','PASCO'),
        ('PASCO','DANIEL ALCIDES CARRIÓN'),
        ('PASCO','OXAPAMPA'),
        ('PIURA','PIURA'),
        ('PUNO','PUNO'),
        ('PUNO','AZÁNGARO'),
        ('PUNO','CARABAYA'),
        ('PUNO','CHUCUITO'),
        ('PUNO','EL COLLAO'),
        ('PUNO','HUANCANÉ'),
        ('PUNO','LAMPA'),
        ('PUNO','MELGAR'),
        ('PUNO','MOHO'),
        ('PUNO','SAN ANTONIO DE PUTINA'),
        ('PUNO','SAN ROMÁN'),
        ('PUNO','SANDIA'),
        ('PUNO','YUNGUYO'),
        ('SAN MARTÍN','SAN MARTÍN'),
        ('TACNA','TACNA'),
        ('TUMBES','TUMBES'),
        ('UCAYALI','UCAYALI')
)
, missing AS (
    SELECT DISTINCT d.city_name
    FROM data d
    LEFT JOIN unicen.ciudad c
      ON UPPER(c.nombre) = d.city_name
     AND c.id_pais = 4
    WHERE c.id_ciudad IS NULL
)
SELECT * FROM missing;
-- Si esto devuelve filas, crea primero esas ciudades (id_pais=4).

-- 2) Inserta para id_sede 2 y 3, evitando duplicados por sede/ciudad/distrito
WITH data(city_name, district) AS (
    VALUES
        ('AMAZONAS','AMAZONAS'),
        ('ANCASH','ANCASH'),
        ('APURÍMAC','ABANCAY'),
        ('APURÍMAC','ANDAHUAYLAS'),
        ('APURÍMAC','ANTABAMBA'),
        ('APURÍMAC','AYMARAES'),
        ('APURÍMAC','COTABAMBAS'),
        ('APURÍMAC','CHINCHEROS'),
        ('APURÍMAC','GRAU'),
        ('AREQUIPA','AREQUIPA'),
        ('AREQUIPA','CAMANÁ'),
        ('AREQUIPA','CARAVELÍ'),
        ('AREQUIPA','CASTILLA'),
        ('AREQUIPA','CAYLLOMA'),
        ('AREQUIPA','CONDESUYOS'),
        ('AREQUIPA','ISLAY'),
        ('AREQUIPA','LA UNIÓN'),
        ('AYACUCHO','HUAMANGA'),
        ('AYACUCHO','CANGALLO'),
        ('AYACUCHO','HUANCA SANCOS'),
        ('AYACUCHO','HUANTA'),
        ('AYACUCHO','LA MAR'),
        ('AYACUCHO','LUCANAS'),
        ('AYACUCHO','PARINACOCHAS'),
        ('AYACUCHO','PAUCAR DEL SARA SARA'),
        ('AYACUCHO','SUCRE'),
        ('AYACUCHO','VÍCTOR FAJARDO'),
        ('AYACUCHO','VILCAS HUAMÁN'),
        ('CAJAMARCA','CAJAMARCA'),
        ('CAJAMARCA','CAJABAMBA'),
        ('CAJAMARCA','CELENDÍN'),
        ('CAJAMARCA','CHOTA'),
        ('CAJAMARCA','CONTUMAZÁ'),
        ('CAJAMARCA','CUTERVO'),
        ('CAJAMARCA','HUALGAYOC'),
        ('CAJAMARCA','JAÉN'),
        ('CAJAMARCA','SAN IGNACIO'),
        ('CAJAMARCA','SAN MARCOS'),
        ('CAJAMARCA','SAN MIGUEL'),
        ('CAJAMARCA','SAN PABLO'),
        ('CAJAMARCA','SANTA CRUZ'),
        ('CALLAO','CALLAO'),
        ('CUSCO','CUSCO'),
        ('CUSCO','ACOMAYO'),
        ('CUSCO','ANTA'),
        ('CUSCO','CALCA'),
        ('CUSCO','CANAS'),
        ('CUSCO','CANCHIS'),
        ('CUSCO','CHUMBIVILCAS'),
        ('CUSCO','ESPINAR'),
        ('CUSCO','LA CONVENCIÓN'),
        ('CUSCO','PARURO'),
        ('CUSCO','PAUCARTAMBO'),
        ('CUSCO','QUISPICANCHI'),
        ('CUSCO','URUBAMBA'),
        ('HUANCAVELICA','HUANCAVELICA'),
        ('HUÁNUCO','HUÁNUCO'),
        ('ICA','ICA'),
        ('ICA','CHINCHA'),
        ('ICA','NASCA'),
        ('ICA','PALPA'),
        ('ICA','PISCO'),
        ('JUNÍN','JUNÍN'),
        ('LA LIBERTAD','LA LIBERTAD'),
        ('LAMBAYEQUE','LAMBAYEQUE'),
        ('LIMA','LIMA'),
        ('LIMA','BARRANCA'),
        ('LIMA','CAJATAMBO'),
        ('LIMA','CANTA'),
        ('LIMA','CAÑETE'),
        ('LIMA','HUARAL'),
        ('LIMA','HUAROCHIRÍ'),
        ('LIMA','HUAURA'),
        ('LIMA','OYÓN'),
        ('LIMA','YAUYOS'),
        ('LORETO','LORETO'),
        ('MADRE DE DIOS','TAMBOPATA'),
        ('MOQUEGUA','ILO'),
        ('PASCO','PASCO'),
        ('PASCO','DANIEL ALCIDES CARRIÓN'),
        ('PASCO','OXAPAMPA'),
        ('PIURA','PIURA'),
        ('PUNO','PUNO'),
        ('PUNO','AZÁNGARO'),
        ('PUNO','CARABAYA'),
        ('PUNO','CHUCUITO'),
        ('PUNO','EL COLLAO'),
        ('PUNO','HUANCANÉ'),
        ('PUNO','LAMPA'),
        ('PUNO','MELGAR'),
        ('PUNO','MOHO'),
        ('PUNO','SAN ANTONIO DE PUTINA'),
        ('PUNO','SAN ROMÁN'),
        ('PUNO','SANDIA'),
        ('PUNO','YUNGUYO'),
        ('SAN MARTÍN','SAN MARTÍN'),
        ('TACNA','TACNA'),
        ('TUMBES','TUMBES'),
        ('UCAYALI','UCAYALI')
)
, target_sedes AS (
    SELECT unnest(ARRAY[2,3]) AS id_sede
)
INSERT INTO unicen.distrito (id_sede, distrito, estado, id_ciudad)
SELECT s.id_sede, d.district, 'ACTIVO', c.id_ciudad
FROM data d
JOIN unicen.ciudad c
  ON UPPER(c.nombre) = d.city_name
 AND c.id_pais = 4
CROSS JOIN target_sedes s
WHERE NOT EXISTS (
    SELECT 1
    FROM unicen.distrito di
    WHERE di.id_sede = s.id_sede
      AND di.id_ciudad = c.id_ciudad
      AND di.distrito = d.district
);

-- 3) Revisión
SELECT di.id_sede, di.distrito, c.nombre AS ciudad
FROM unicen.distrito di
JOIN unicen.ciudad c ON di.id_ciudad = c.id_ciudad
WHERE di.id_sede IN (2,3) and c.id_pais = 4
ORDER BY di.id_sede, c.nombre, di.distrito;


WITH provincias(nombre) AS (
    VALUES
        ('AMAZONAS'),
        ('ANCASH'),
        ('ABANCAY'),
        ('ANDAHUAYLAS'),
        ('ANTABAMBA'),
        ('AYMARAES'),
        ('COTABAMBAS'),
        ('CHINCHEROS'),
        ('GRAU'),
        ('AREQUIPA'),
        ('CAMANÁ'),
        ('CARAVELÍ'),
        ('CASTILLA'),
        ('CAYLLOMA'),
        ('CONDESUYOS'),
        ('ISLAY'),
        ('LA UNIÓN'),
        ('HUAMANGA'),
        ('CANGALLO'),
        ('HUANCA SANCOS'),
        ('HUANTA'),
        ('LA MAR'),
        ('LUCANAS'),
        ('PARINACOCHAS'),
        ('PAUCAR DEL SARA SARA'),
        ('SUCRE'),
        ('VÍCTOR FAJARDO'),
        ('VILCAS HUAMÁN'),
        ('CAJAMARCA'),
        ('CAJABAMBA'),
        ('CELENDÍN'),
        ('CHOTA'),
        ('CONTUMAZÁ'),
        ('CUTERVO'),
        ('HUALGAYOC'),
        ('JAÉN'),
        ('SAN IGNACIO'),
        ('SAN MARCOS'),
        ('SAN MIGUEL'),
        ('SAN PABLO'),
        ('SANTA CRUZ'),
        ('CALLAO'),
        ('CUSCO'),
        ('ACOMAYO'),
        ('ANTA'),
        ('CALCA'),
        ('CANAS'),
        ('CANCHIS'),
        ('CHUMBIVILCAS'),
        ('ESPINAR'),
        ('LA CONVENCIÓN'),
        ('PARURO'),
        ('PAUCARTAMBO'),
        ('QUISPICANCHI'),
        ('URUBAMBA'),
        ('HUANCAVELICA'),
        ('HUÁNUCO'),
        ('ICA'),
        ('CHINCHA'),
        ('NASCA'),
        ('PALPA'),
        ('PISCO'),
        ('JUNÍN'),
        ('LA LIBERTAD'),
        ('LAMBAYEQUE'),
        ('LIMA'),
        ('BARRANCA'),
        ('CAJATAMBO'),
        ('CANTA'),
        ('CAÑETE'),
        ('HUARAL'),
        ('HUAROCHIRÍ'),
        ('HUAURA'),
        ('OYÓN'),
        ('YAUYOS'),
        ('LORETO'),
        ('TAMBOPATA'),
        ('ILO'),
        ('PASCO'),
        ('DANIEL ALCIDES CARRIÓN'),
        ('OXAPAMPA'),
        ('PIURA'),
        ('PUNO'),
        ('AZÁNGARO'),
        ('CARABAYA'),
        ('CHUCUITO'),
        ('EL COLLAO'),
        ('HUANCANÉ'),
        ('LAMPA'),
        ('MELGAR'),
        ('MOHO'),
        ('SAN ANTONIO DE PUTINA'),
        ('SAN ROMÁN'),
        ('SANDIA'),
        ('YUNGUYO'),
        ('SAN MARTÍN'),
        ('TACNA'),
        ('TUMBES'),
        ('UCAYALI')
),
target_sedes AS (
    SELECT unnest(ARRAY[1,2,3]) AS id_sede
)
INSERT INTO unicen.provincia (nombre, id_sede)
SELECT p.nombre, s.id_sede
FROM provincias p
CROSS JOIN target_sedes s
WHERE NOT EXISTS (
    SELECT 1
    FROM unicen.provincia pr
    WHERE pr.id_sede = s.id_sede
      AND UPPER(pr.nombre) = p.nombre
);


-- 1) Identifica la secuencia real
SELECT pg_get_serial_sequence('unicen.provincia', 'id_provincia');

-- 2) Ajusta la secuencia al valor máximo actual
SELECT setval(
  pg_get_serial_sequence('unicen.provincia', 'id_provincia'),
  COALESCE((SELECT MAX(id_provincia) FROM unicen.provincia), 0),
  TRUE
);



 -- 3) Verifica que el próximo valor sea correcto
SELECT nextval(pg_get_serial_sequence('unicen.provincia', 'id_provincia'));



-- Verificación rápida
SELECT id_provincia, nombre, id_sede
FROM unicen.provincia
WHERE id_sede IN (1,2,3)
  AND UPPER(nombre) IN (
        'AMAZONAS','ANCASH','ABANCAY','ANDAHUAYLAS','ANTABAMBA','AYMARAES','COTABAMBAS',
        'CHINCHEROS','GRAU','AREQUIPA','CAMANÁ','CARAVELÍ','CASTILLA','CAYLLOMA','CONDESUYOS',
        'ISLAY','LA UNIÓN','HUAMANGA','CANGALLO','HUANCA SANCOS','HUANTA','LA MAR','LUCANAS',
        'PARINACOCHAS','PAUCAR DEL SARA SARA','SUCRE','VÍCTOR FAJARDO','VILCAS HUAMÁN',
        'CAJAMARCA','CAJABAMBA','CELENDÍN','CHOTA','CONTUMAZÁ','CUTERVO','HUALGAYOC','JAÉN',
        'SAN IGNACIO','SAN MARCOS','SAN MIGUEL','SAN PABLO','SANTA CRUZ','CALLAO','CUSCO',
        'ACOMAYO','ANTA','CALCA','CANAS','CANCHIS','CHUMBIVILCAS','ESPINAR','LA CONVENCIÓN',
        'PARURO','PAUCARTAMBO','QUISPICANCHI','URUBAMBA','HUANCAVELICA','HUÁNUCO','ICA',
        'CHINCHA','NASCA','PALPA','PISCO','JUNÍN','LA LIBERTAD','LAMBAYEQUE','LIMA','BARRANCA',
        'CAJATAMBO','CANTA','CAÑETE','HUARAL','HUAROCHIRÍ','HUAURA','OYÓN','YAUYOS','LORETO',
        'TAMBOPATA','ILO','PASCO','DANIEL ALCIDES CARRIÓN','OXAPAMPA','PIURA','PUNO','AZÁNGARO',
        'CARABAYA','CHUCUITO','EL COLLAO','HUANCANÉ','LAMPA','MELGAR','MOHO','SAN ANTONIO DE PUTINA',
        'SAN ROMÁN','SANDIA','YUNGUYO','SAN MARTÍN','TACNA','TUMBES','UCAYALI'
  )
ORDER BY id_sede, nombre;