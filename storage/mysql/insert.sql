-- Biblioteca Campus - datos de prueba y demostración
USE biblioteca_campus;

START TRANSACTION;

INSERT INTO libros
    (id_libro, titulo, genero, descripcion, idioma)
VALUES
    (1, 'Cien años de soledad', 'Novela', 'Saga de la familia Buendía en Macondo.', 'Español'),
    (2, 'Don Quijote de la Mancha', 'Novela', 'Aventuras del hidalgo Alonso Quijano.', 'Español'),
    (3, 'La casa de los espíritus', 'Realismo mágico', 'Historia familiar ambientada en un país latinoamericano.', 'Español'),
    (4, 'El principito', 'Literatura infantil', 'Relato filosófico sobre la amistad y la responsabilidad.', 'Español'),
    (5, 'Sapiens: De animales a dioses', 'Historia', 'Recorrido por la historia de la humanidad.', 'Español'),
    (6, 'Clean Code', 'Programación', 'Prácticas para escribir código legible y mantenible.', 'Inglés'),
    (7, 'Veinte poemas de amor y una canción desesperada', 'Poesía', 'Colección poética sobre el amor y la ausencia.', 'Español'),
    (8, 'El amor en los tiempos del cólera', 'Novela', 'Historia de un amor que espera durante décadas.', 'Español'),
    (9, 'Rayuela', 'Novela', 'Novela experimental ambientada entre París y Buenos Aires.', 'Español'),
    (10, 'Introducción a los algoritmos', 'Informática', 'Fundamentos de algoritmos y estructuras de datos.', 'Español');

INSERT INTO autores
    (id_autor, nombres, apellidos, fecha_nacimiento, nacionalidad)
VALUES
    (1, 'Gabriel García', 'Márquez', '1927-03-06', 'Colombiana'),
    (2, 'Miguel', 'de Cervantes Saavedra', '1547-09-29', 'Española'),
    (3, 'Isabel', 'Allende', '1942-08-02', 'Chilena'),
    (4, 'Antoine', 'de Saint-Exupéry', '1900-06-29', 'Francesa'),
    (5, 'Yuval Noah', 'Harari', '1976-02-24', 'Israelí'),
    (6, 'Robert C.', 'Martin', '1952-12-05', 'Estadounidense'),
    (7, 'Pablo', 'Neruda', '1904-07-12', 'Chilena'),
    (8, 'Julio', 'Cortázar', '1914-08-26', 'Argentina'),
    (9, 'Thomas H.', 'Cormen', '1956-06-22', 'Estadounidense'),
    (10, 'Charles E.', 'Leiserson', '1953-11-10', 'Estadounidense'),
    (11, 'Ronald L.', 'Rivest', '1947-05-06', 'Estadounidense'),
    (12, 'Clifford', 'Stein', '1965-12-28', 'Estadounidense');

INSERT INTO libro_autor
    (id_libro, id_autor, orden_autoria, rol_autoria)
VALUES
    (1, 1, 1, 'Autor'),
    (2, 2, 1, 'Autor'),
    (3, 3, 1, 'Autora'),
    (4, 4, 1, 'Autor'),
    (5, 5, 1, 'Autor'),
    (6, 6, 1, 'Autor'),
    (7, 7, 1, 'Autor'),
    (8, 1, 1, 'Autor'),
    (9, 8, 1, 'Autor'),
    (10, 9, 1, 'Autor'),
    (10, 10, 2, 'Coautor'),
    (10, 11, 3, 'Coautor'),
    (10, 12, 4, 'Coautor');

INSERT INTO ediciones
    (id_edicion, id_libro, isbn, numero_edicion, fecha_publicacion, editorial, paginas, formato, idioma, notas)
VALUES
    (1, 1, '9780307474728', 1, '1967-05-30', 'Editorial Sudamericana', 496, 'FISICO', 'Español', 'Primera edición de referencia'),
    (2, 1, '9788439722322', 2, '2007-03-01', 'Random House', 496, 'FISICO', 'Español', 'Edición conmemorativa'),
    (3, 2, '9788420412146', 1, '2004-01-15', 'Alfaguara', 1344, 'FISICO', 'Español', NULL),
    (4, 3, '9788401352836', 1, '2001-06-20', 'Plaza & Janés', 448, 'FISICO', 'Español', NULL),
    (5, 4, '9780156012195', 1, '2000-05-01', 'Harcourt', 96, 'FISICO', 'Español', 'Edición ilustrada'),
    (6, 5, '9780062316097', 1, '2015-02-10', 'Harper', 464, 'FISICO', 'Español', NULL),
    (7, 6, '9780132350884', 1, '2008-08-11', 'Prentice Hall', 464, 'FISICO', 'Inglés', NULL),
    (8, 6, '9780134494166', 2, '2018-09-12', 'Pearson', 464, 'DIGITAL', 'Inglés', 'Edición revisada'),
    (9, 7, '9788437609439', 1, '2005-04-18', 'Cátedra', 128, 'FISICO', 'Español', NULL),
    (10, 8, '9780307389732', 1, '2007-10-01', 'Vintage Español', 368, 'FISICO', 'Español', NULL),
    (11, 9, '9788437602348', 1, '2011-02-14', 'Cátedra', 736, 'FISICO', 'Español', NULL),
    (12, 10, '9780262033848', 1, '2009-07-31', 'MIT Press', 1312, 'FISICO', 'Inglés', NULL),
    (13, 10, '9780262533058', 2, '2022-04-05', 'MIT Press', 1312, 'DIGITAL', 'Inglés', 'Edición actualizada'),
    (14, 1, '9786073135295', 3, '2014-11-01', 'Diana', 496, 'DIGITAL', 'Español', 'Edición digital'),
    (15, 5, '9780062464316', 2, '2018-09-04', 'Harper Perennial', 528, 'DIGITAL', 'Español', 'Edición ampliada');

INSERT INTO ejemplares
    (id_ejemplar, id_edicion, codigo_inventario, ubicacion, estado, fecha_alta)
VALUES
    (1, 1, 'BC-0001', 'Sala A / Estante 01', 'DISPONIBLE', '2024-01-10'),
    (2, 1, 'BC-0002', 'Sala A / Estante 01', 'DISPONIBLE', '2024-01-10'),
    (3, 2, 'BC-0003', 'Sala A / Estante 01', 'DISPONIBLE', '2024-01-10'),
    (4, 3, 'BC-0004', 'Sala A / Estante 02', 'DISPONIBLE', '2024-01-10'),
    (5, 3, 'BC-0005', 'Sala A / Estante 02', 'DISPONIBLE', '2024-01-10'),
    (6, 4, 'BC-0006', 'Sala A / Estante 03', 'DISPONIBLE', '2024-01-10'),
    (7, 5, 'BC-0007', 'Sala B / Estante 01', 'DISPONIBLE', '2024-01-10'),
    (8, 6, 'BC-0008', 'Sala B / Estante 02', 'DISPONIBLE', '2024-01-10'),
    (9, 7, 'BC-0009', 'Sala C / Estante 01', 'DISPONIBLE', '2024-01-10'),
    (10, 7, 'BC-0010', 'Sala C / Estante 01', 'DISPONIBLE', '2024-01-10'),
    (11, 8, 'BC-0011', 'Sala B / Estante 02', 'DISPONIBLE', '2024-01-10'),
    (12, 9, 'BC-0012', 'Sala C / Estante 02', 'DISPONIBLE', '2024-01-10'),
    (13, 10, 'BC-0013', 'Sala A / Estante 03', 'DISPONIBLE', '2024-01-10'),
    (14, 10, 'BC-0014', 'Sala A / Estante 03', 'DISPONIBLE', '2024-01-10'),
    (15, 11, 'BC-0015', 'Sala C / Estante 02', 'DISPONIBLE', '2024-01-10'),
    (16, 12, 'BC-0016', 'Sala D / Estante 01', 'DISPONIBLE', '2024-01-10'),
    (17, 13, 'BC-0017', 'Sala D / Estante 01', 'DISPONIBLE', '2024-01-10'),
    (18, 14, 'BC-0018', 'Sala A / Estante 01', 'DISPONIBLE', '2024-01-10'),
    (19, 15, 'BC-0019', 'Sala B / Estante 01', 'DISPONIBLE', '2024-01-10'),
    (20, 15, 'BC-0020', 'Sala B / Estante 01', 'DISPONIBLE', '2024-01-10');

INSERT INTO miembros
    (id_miembro, documento, nombres, apellidos, correo, telefono, direccion, fecha_registro, estado)
VALUES
    (1, 'CC-1001', 'Laura', 'Gómez Rojas', 'laura.gomez@campus.edu', '3005551001', 'Carrera 10 # 20-30', '2024-01-15', 'ACTIVO'),
    (2, 'CC-1002', 'Andrés', 'Pérez Díaz', 'andres.perez@campus.edu', '3005551002', 'Calle 12 # 8-15', '2024-01-18', 'ACTIVO'),
    (3, 'CC-1003', 'Camila', 'Torres Mejía', 'camila.torres@campus.edu', '3005551003', 'Carrera 7 # 44-12', '2024-02-02', 'ACTIVO'),
    (4, 'CC-1004', 'Santiago', 'Ruiz Castro', 'santiago.ruiz@campus.edu', '3005551004', 'Calle 80 # 14-22', '2024-02-16', 'ACTIVO'),
    (5, 'CC-1005', 'Valentina', 'Moreno León', 'valentina.moreno@campus.edu', '3005551005', 'Carrera 19 # 63-18', '2024-03-01', 'ACTIVO'),
    (6, 'CC-1006', 'Daniel', 'Vargas Silva', 'daniel.vargas@campus.edu', '3005551006', 'Calle 53 # 21-09', '2024-03-08', 'SUSPENDIDO'),
    (7, 'CC-1007', 'Mariana', 'Castillo Niño', 'mariana.castillo@campus.edu', '3005551007', 'Carrera 5 # 91-11', '2024-03-14', 'ACTIVO'),
    (8, 'CC-1008', 'Felipe', 'Navarro Gil', 'felipe.navarro@campus.edu', '3005551008', 'Calle 100 # 9-04', '2024-04-05', 'ACTIVO');

-- Los préstamos devueltos alimentan el historial; los tres últimos siguen activos.
INSERT INTO prestamos
    (id_prestamo, id_ejemplar, id_miembro, fecha_prestamo, fecha_vencimiento, fecha_devolucion, estado, observaciones)
VALUES
    (1, 1, 1, '2024-02-01', '2024-02-15', '2024-02-12', 'DEVUELTO', NULL),
    (2, 3, 1, '2024-02-20', '2024-03-05', '2024-03-04', 'DEVUELTO', NULL),
    (3, 6, 2, '2024-03-10', '2024-03-24', '2024-03-22', 'DEVUELTO', NULL),
    (4, 3, 2, '2026-09-01', '2026-09-15', NULL, 'PRESTADO', NULL),
    (5, 8, 3, '2026-09-04', '2026-09-18', NULL, 'PRESTADO', NULL),
    (6, 14, 1, '2026-08-20', '2026-09-03', NULL, 'ATRASADO', 'Notificar al miembro'),
    (7, 4, 4, '2024-04-01', '2024-04-15', '2024-04-14', 'DEVUELTO', NULL),
    (8, 1, 5, '2024-04-10', '2024-04-24', '2024-04-23', 'DEVUELTO', NULL),
    (9, 12, 6, '2024-05-02', '2024-05-16', '2024-05-15', 'DEVUELTO', NULL);

COMMIT;
