-- 02_seed.sql — Datos mínimos de ejemplo para probar el modelo
SET search_path TO dwh;

-- Geografía
INSERT INTO dim_pais (nombre_pais) VALUES ('Guatemala'), ('Mexico');
INSERT INTO dim_region (nombre_region, pais_id) VALUES
    ('Region Central', 1), ('Region Occidente', 1), ('CDMX', 2);
INSERT INTO dim_ciudad (nombre_ciudad, region_id) VALUES
    ('Ciudad de Guatemala', 1), ('Quetzaltenango', 2), ('Ciudad de Mexico', 3);

-- Producto
INSERT INTO dim_departamento (nombre_departamento) VALUES ('Tecnologia'), ('Hogar');
INSERT INTO dim_categoria (nombre_categoria, departamento_id) VALUES
    ('Laptops', 1), ('Telefonos', 1), ('Cocina', 2);
INSERT INTO dim_producto (nombre, precio_lista, categoria_id) VALUES
    ('Laptop Pro 14', 8500.00, 1),
    ('Telefono X', 4200.00, 2),
    ('Licuadora Plus', 350.00, 3);

-- Clientes y tiendas
INSERT INTO dim_cliente (nombre, email, ciudad_id) VALUES
    ('Ana Lopez', 'ana@example.com', 1),
    ('Bruno Diaz', 'bruno@example.com', 3);
INSERT INTO dim_tienda (nombre, ciudad_id) VALUES
    ('Tienda Centro', 1), ('Tienda Xela', 2);

-- Tiempo
INSERT INTO dim_tiempo (tiempo_id, fecha, dia, mes, anio, trimestre, nombre_dia) VALUES
    (20260618, DATE '2026-06-18', 18, 6, 2026, 2, 'Jueves'),
    (20260619, DATE '2026-06-19', 19, 6, 2026, 2, 'Viernes');

-- Hechos
INSERT INTO fact_ventas (tiempo_id, producto_id, cliente_id, tienda_id, cantidad, monto_total) VALUES
    (20260618, 1, 1, 1, 1, 8500.00),
    (20260619, 2, 1, 1, 2, 8400.00),
    (20260619, 3, 2, 2, 3, 1050.00);
