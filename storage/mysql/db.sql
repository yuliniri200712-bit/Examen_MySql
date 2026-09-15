-- Biblioteca Campus - estructura de la base de datos
-- Motor: MySQL 8.0+ / InnoDB

CREATE DATABASE IF NOT EXISTS biblioteca_campus
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_0900_ai_ci;

USE biblioteca_campus;

CREATE TABLE IF NOT EXISTS libros (
    id_libro INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(200) NOT NULL,
    genero VARCHAR(80) NOT NULL,
    descripcion TEXT NULL,
    idioma VARCHAR(50) NOT NULL DEFAULT 'Español',
    fecha_registro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT uk_libro_titulo UNIQUE (titulo)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS autores (
    id_autor INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    fecha_nacimiento DATE NULL,
    nacionalidad VARCHAR(80) NULL,
    CONSTRAINT uk_autor_nombre UNIQUE (nombres, apellidos)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS libro_autor (
    id_libro INT UNSIGNED NOT NULL,
    id_autor INT UNSIGNED NOT NULL,
    orden_autoria TINYINT UNSIGNED NOT NULL DEFAULT 1,
    rol_autoria VARCHAR(60) NOT NULL DEFAULT 'Autor',
    PRIMARY KEY (id_libro, id_autor),
    CONSTRAINT fk_libro_autor_libro
        FOREIGN KEY (id_libro) REFERENCES libros (id_libro)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_libro_autor_autor
        FOREIGN KEY (id_autor) REFERENCES autores (id_autor)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS ediciones (
    id_edicion INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_libro INT UNSIGNED NOT NULL,
    isbn CHAR(17) NOT NULL,
    numero_edicion SMALLINT UNSIGNED NOT NULL,
    fecha_publicacion DATE NOT NULL,
    editorial VARCHAR(150) NOT NULL,
    paginas SMALLINT UNSIGNED NULL,
    formato ENUM('FISICO', 'DIGITAL', 'AUDIO') NOT NULL DEFAULT 'FISICO',
    idioma VARCHAR(50) NOT NULL DEFAULT 'Español',
    notas VARCHAR(255) NULL,
    CONSTRAINT uk_edicion_isbn UNIQUE (isbn),
    CONSTRAINT uk_edicion_numero UNIQUE (id_libro, numero_edicion),
    CONSTRAINT fk_edicion_libro
        FOREIGN KEY (id_libro) REFERENCES libros (id_libro)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS ejemplares (
    id_ejemplar INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_edicion INT UNSIGNED NOT NULL,
    codigo_inventario VARCHAR(30) NOT NULL,
    ubicacion VARCHAR(100) NOT NULL,
    estado ENUM('DISPONIBLE', 'PRESTADO', 'MANTENIMIENTO', 'BAJA')
        NOT NULL DEFAULT 'DISPONIBLE',
    fecha_alta DATE NOT NULL,
    CONSTRAINT uk_ejemplar_inventario UNIQUE (codigo_inventario),
    CONSTRAINT fk_ejemplar_edicion
        FOREIGN KEY (id_edicion) REFERENCES ediciones (id_edicion)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS miembros (
    id_miembro INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    documento VARCHAR(30) NOT NULL,
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    correo VARCHAR(150) NOT NULL,
    telefono VARCHAR(30) NULL,
    direccion VARCHAR(200) NULL,
    fecha_registro DATE NOT NULL,
    estado ENUM('ACTIVO', 'SUSPENDIDO', 'INACTIVO') NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT uk_miembro_documento UNIQUE (documento),
    CONSTRAINT uk_miembro_correo UNIQUE (correo)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS prestamos (
    id_prestamo INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_ejemplar INT UNSIGNED NOT NULL,
    id_miembro INT UNSIGNED NOT NULL,
    fecha_prestamo DATE NOT NULL,
    fecha_vencimiento DATE NOT NULL,
    fecha_devolucion DATE NULL,
    estado ENUM('PRESTADO', 'DEVUELTO', 'ATRASADO', 'PERDIDO') NOT NULL,
    observaciones VARCHAR(255) NULL,
    CONSTRAINT fk_prestamo_ejemplar
        FOREIGN KEY (id_ejemplar) REFERENCES ejemplares (id_ejemplar)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_prestamo_miembro
        FOREIGN KEY (id_miembro) REFERENCES miembros (id_miembro)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT chk_prestamo_fechas CHECK (fecha_vencimiento >= fecha_prestamo),
    CONSTRAINT chk_prestamo_estado CHECK (
        (fecha_devolucion IS NULL AND estado IN ('PRESTADO', 'ATRASADO', 'PERDIDO'))
        OR (fecha_devolucion IS NOT NULL AND estado = 'DEVUELTO')
    )
) ENGINE = InnoDB;

CREATE INDEX idx_libro_genero ON libros (genero);
CREATE INDEX idx_autor_apellidos ON autores (apellidos, nombres);
CREATE INDEX idx_edicion_libro_fecha ON ediciones (id_libro, fecha_publicacion);
CREATE INDEX idx_ejemplar_estado ON ejemplares (estado);
CREATE INDEX idx_miembro_nombre ON miembros (apellidos, nombres);
CREATE INDEX idx_prestamo_miembro ON prestamos (id_miembro, fecha_prestamo);
CREATE INDEX idx_prestamo_ejemplar_estado ON prestamos (id_ejemplar, estado);

DROP VIEW IF EXISTS vw_libros_disponibilidad;
CREATE VIEW vw_libros_disponibilidad AS
SELECT
    l.id_libro,
    l.titulo,
    l.genero,
    COUNT(ej.id_ejemplar) AS ejemplares_totales,
    COALESCE(SUM(ej.estado = 'DISPONIBLE'), 0) AS ejemplares_disponibles,
    CASE
        WHEN COALESCE(SUM(ej.estado = 'DISPONIBLE'), 0) > 0 THEN 'DISPONIBLE'
        ELSE 'NO DISPONIBLE'
    END AS disponibilidad
FROM libros AS l
LEFT JOIN ediciones AS e ON e.id_libro = l.id_libro
LEFT JOIN ejemplares AS ej ON ej.id_edicion = e.id_edicion
WHERE l.activo = TRUE
GROUP BY l.id_libro, l.titulo, l.genero;

DROP TRIGGER IF EXISTS trg_prestamos_before_insert;
DROP TRIGGER IF EXISTS trg_prestamos_after_insert;
DROP TRIGGER IF EXISTS trg_prestamos_after_update;

DELIMITER $$

CREATE TRIGGER trg_prestamos_before_insert
BEFORE INSERT ON prestamos
FOR EACH ROW
BEGIN
    DECLARE v_estado VARCHAR(20);

    IF NEW.fecha_devolucion IS NULL
       AND NEW.estado IN ('PRESTADO', 'ATRASADO', 'PERDIDO') THEN
        SELECT estado
          INTO v_estado
          FROM ejemplares
         WHERE id_ejemplar = NEW.id_ejemplar
         FOR UPDATE;

        IF v_estado <> 'DISPONIBLE' THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'El ejemplar seleccionado no está disponible';
        END IF;
    END IF;
END$$

CREATE TRIGGER trg_prestamos_after_insert
AFTER INSERT ON prestamos
FOR EACH ROW
BEGIN
    IF NEW.fecha_devolucion IS NULL
       AND NEW.estado IN ('PRESTADO', 'ATRASADO', 'PERDIDO') THEN
        UPDATE ejemplares
           SET estado = CASE
               WHEN NEW.estado = 'PERDIDO' THEN 'BAJA'
               ELSE 'PRESTADO'
           END
         WHERE id_ejemplar = NEW.id_ejemplar;
    END IF;
END$$

CREATE TRIGGER trg_prestamos_after_update
AFTER UPDATE ON prestamos
FOR EACH ROW
BEGIN
    IF OLD.fecha_devolucion IS NULL AND NEW.fecha_devolucion IS NOT NULL THEN
        UPDATE ejemplares
           SET estado = 'DISPONIBLE'
         WHERE id_ejemplar = NEW.id_ejemplar;
    END IF;
END$$

DELIMITER ;
