# Consultas

## Listar todos los libros disponibles

```sql
SELECT
    l.id_libro,
    l.titulo,
    l.genero,
    l.idioma,
    COUNT(ej.id_ejemplar) AS ejemplares_totales,
    SUM(ej.estado = 'DISPONIBLE') AS ejemplares_disponibles
FROM libros AS l
JOIN ediciones AS e ON e.id_libro = l.id_libro
JOIN ejemplares AS ej ON ej.id_edicion = e.id_edicion
WHERE l.activo = TRUE
GROUP BY l.id_libro, l.titulo, l.genero, l.idioma
HAVING ejemplares_disponibles > 0
ORDER BY l.titulo;
```

## Buscar libros por género

```sql
SELECT id_libro, titulo, genero, idioma
FROM libros
WHERE activo = TRUE
  AND LOWER(genero) = LOWER(?);
```

## Obtener información de un libro por ISBN

```sql
SELECT
    l.id_libro,
    l.titulo,
    l.genero,
    l.descripcion,
    e.id_edicion,
    e.isbn,
    e.numero_edicion,
    e.fecha_publicacion,
    e.editorial,
    COUNT(ej.id_ejemplar) AS ejemplares_totales,
    COALESCE(SUM(ej.estado = 'DISPONIBLE'), 0) AS ejemplares_disponibles
FROM libros AS l
JOIN ediciones AS e ON e.id_libro = l.id_libro
LEFT JOIN ejemplares AS ej ON ej.id_edicion = e.id_edicion
WHERE e.isbn = ?
GROUP BY l.id_libro, l.titulo, l.genero, l.descripcion,
         e.id_edicion, e.isbn, e.numero_edicion,
         e.fecha_publicacion, e.editorial;
```

## Contar el número de libros en la biblioteca

```sql
SELECT COUNT(*) AS total_libros
FROM libros
WHERE activo = TRUE;
```

## Listar todos los autores

```sql
SELECT
    id_autor,
    CONCAT(nombres, ' ', apellidos) AS autor,
    nacionalidad,
    fecha_nacimiento
FROM autores
ORDER BY apellidos, nombres;
```

## Buscar autores por nombre

```sql
SELECT
    id_autor,
    CONCAT(nombres, ' ', apellidos) AS autor,
    nacionalidad
FROM autores
WHERE CONCAT_WS(' ', nombres, apellidos) LIKE CONCAT('%', ?, '%')
ORDER BY apellidos, nombres;
```

## Obtener todos los libros de un autor específico

```sql
SELECT
    a.id_autor,
    CONCAT(a.nombres, ' ', a.apellidos) AS autor,
    l.id_libro,
    l.titulo,
    l.genero,
    la.rol_autoria
FROM autores AS a
JOIN libro_autor AS la ON la.id_autor = a.id_autor
JOIN libros AS l ON l.id_libro = la.id_libro
WHERE a.id_autor = ?
ORDER BY l.titulo;
```

## Listar todas las ediciones de un libro

```sql
SELECT
    e.id_edicion,
    e.id_libro,
    e.isbn,
    e.numero_edicion,
    e.fecha_publicacion,
    e.editorial,
    e.paginas,
    e.formato,
    e.idioma
FROM ediciones AS e
WHERE e.id_libro = ?
ORDER BY e.numero_edicion;
```

## Obtener la última edición de un libro

```sql
SELECT
    e.id_edicion,
    e.id_libro,
    e.isbn,
    e.numero_edicion,
    e.fecha_publicacion,
    e.editorial,
    e.paginas,
    e.formato
FROM ediciones AS e
WHERE e.id_libro = ?
ORDER BY e.numero_edicion DESC, e.fecha_publicacion DESC
LIMIT 1;
```

## Contar cuántas ediciones hay de un libro específico

```sql
SELECT
    id_libro,
    COUNT(*) AS total_ediciones
FROM ediciones
WHERE id_libro = ?
GROUP BY id_libro;
```

## Listar todas las transacciones de préstamo

```sql
SELECT
    p.id_prestamo,
    p.fecha_prestamo,
    p.fecha_vencimiento,
    p.fecha_devolucion,
    p.estado,
    CONCAT(m.nombres, ' ', m.apellidos) AS miembro,
    l.titulo AS libro,
    e.isbn,
    ej.codigo_inventario
FROM prestamos AS p
JOIN miembros AS m ON m.id_miembro = p.id_miembro
JOIN ejemplares AS ej ON ej.id_ejemplar = p.id_ejemplar
JOIN ediciones AS e ON e.id_edicion = ej.id_edicion
JOIN libros AS l ON l.id_libro = e.id_libro
ORDER BY p.fecha_prestamo DESC, p.id_prestamo DESC;
```

## Obtener los libros prestados actualmente

```sql
SELECT
    p.id_prestamo,
    l.titulo AS libro,
    e.isbn,
    ej.codigo_inventario,
    CONCAT(m.nombres, ' ', m.apellidos) AS miembro,
    p.fecha_prestamo,
    p.fecha_vencimiento,
    p.estado
FROM prestamos AS p
JOIN miembros AS m ON m.id_miembro = p.id_miembro
JOIN ejemplares AS ej ON ej.id_ejemplar = p.id_ejemplar
JOIN ediciones AS e ON e.id_edicion = ej.id_edicion
JOIN libros AS l ON l.id_libro = e.id_libro
WHERE p.fecha_devolucion IS NULL
  AND p.estado IN ('PRESTADO', 'ATRASADO')
ORDER BY p.fecha_vencimiento;
```

## Contar el número de transacciones de un miembro específico

```sql
SELECT
    id_miembro,
    COUNT(*) AS total_transacciones
FROM prestamos
WHERE id_miembro = ?
GROUP BY id_miembro;
```

## Listar todos los miembros de la biblioteca

```sql
SELECT
    id_miembro,
    documento,
    CONCAT(nombres, ' ', apellidos) AS miembro,
    correo,
    telefono,
    fecha_registro,
    estado
FROM miembros
ORDER BY apellidos, nombres;
```

## Buscar un miembro por nombre

```sql
SELECT
    id_miembro,
    documento,
    CONCAT(nombres, ' ', apellidos) AS miembro,
    correo,
    telefono,
    estado
FROM miembros
WHERE CONCAT_WS(' ', nombres, apellidos) LIKE CONCAT('%', ?, '%')
ORDER BY apellidos, nombres;
```

## Obtener las transacciones de un miembro específico

```sql
SELECT
    p.id_prestamo,
    p.id_miembro,
    l.titulo AS libro,
    e.isbn,
    ej.codigo_inventario,
    p.fecha_prestamo,
    p.fecha_vencimiento,
    p.fecha_devolucion,
    p.estado
FROM prestamos AS p
JOIN ejemplares AS ej ON ej.id_ejemplar = p.id_ejemplar
JOIN ediciones AS e ON e.id_edicion = ej.id_edicion
JOIN libros AS l ON l.id_libro = e.id_libro
WHERE p.id_miembro = ?
ORDER BY p.fecha_prestamo DESC;
```

## Listar todos los libros y sus autores

```sql
SELECT
    l.id_libro,
    l.titulo,
    COALESCE(
        GROUP_CONCAT(
            CONCAT(a.nombres, ' ', a.apellidos)
            ORDER BY la.orden_autoria SEPARATOR ', '
        ),
        'Sin autor registrado'
    ) AS autores
FROM libros AS l
LEFT JOIN libro_autor AS la ON la.id_libro = l.id_libro
LEFT JOIN autores AS a ON a.id_autor = la.id_autor
GROUP BY l.id_libro, l.titulo
ORDER BY l.titulo;
```

## Obtener el historial de préstamos de un libro específico

```sql
SELECT
    l.id_libro,
    l.titulo,
    p.id_prestamo,
    ej.codigo_inventario,
    CONCAT(m.nombres, ' ', m.apellidos) AS miembro,
    p.fecha_prestamo,
    p.fecha_vencimiento,
    p.fecha_devolucion,
    p.estado
FROM libros AS l
JOIN ediciones AS e ON e.id_libro = l.id_libro
JOIN ejemplares AS ej ON ej.id_edicion = e.id_edicion
JOIN prestamos AS p ON p.id_ejemplar = ej.id_ejemplar
JOIN miembros AS m ON m.id_miembro = p.id_miembro
WHERE l.id_libro = ?
ORDER BY p.fecha_prestamo DESC;
```

## Contar cuántos libros han sido prestados en total

```sql
SELECT COUNT(*) AS total_libros_prestados
FROM prestamos;
```

## Listar todos los libros junto con su última edición y estado de disponibilidad

```sql
WITH ultima_edicion AS (
    SELECT
        e.*,
        ROW_NUMBER() OVER (
            PARTITION BY e.id_libro
            ORDER BY e.numero_edicion DESC, e.fecha_publicacion DESC, e.id_edicion DESC
        ) AS fila
    FROM ediciones AS e
)
SELECT
    l.id_libro,
    l.titulo,
    ue.isbn,
    ue.numero_edicion,
    ue.fecha_publicacion,
    ue.editorial,
    COUNT(ej.id_ejemplar) AS ejemplares_totales,
    COALESCE(SUM(ej.estado = 'DISPONIBLE'), 0) AS ejemplares_disponibles,
    CASE
        WHEN COALESCE(SUM(ej.estado = 'DISPONIBLE'), 0) > 0 THEN 'DISPONIBLE'
        ELSE 'NO DISPONIBLE'
    END AS disponibilidad
FROM libros AS l
LEFT JOIN ultima_edicion AS ue
       ON ue.id_libro = l.id_libro AND ue.fila = 1
LEFT JOIN ejemplares AS ej ON ej.id_edicion = ue.id_edicion
WHERE l.activo = TRUE
GROUP BY l.id_libro, l.titulo, ue.isbn, ue.numero_edicion,
         ue.fecha_publicacion, ue.editorial
ORDER BY l.titulo;
```
