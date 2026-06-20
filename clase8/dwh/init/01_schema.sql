-- 01_schema.sql — Modelo SNOWFLAKE (copo de nieve)
-- Característica del snowflake: las dimensiones están NORMALIZADAS en
-- sub-dimensiones (jerarquías separadas en sus propias tablas), a diferencia
-- del star schema donde cada dimensión es una sola tabla plana.

CREATE SCHEMA IF NOT EXISTS dwh;
SET search_path TO dwh;

-- ============================================================
-- Sub-dimensiones (jerarquía geográfica)  pais <- region <- ciudad
-- ============================================================
CREATE TABLE dim_pais (
    pais_id      SERIAL PRIMARY KEY,
    nombre_pais  VARCHAR(80) NOT NULL UNIQUE
);

CREATE TABLE dim_region (
    region_id      SERIAL PRIMARY KEY,
    nombre_region  VARCHAR(80) NOT NULL,
    pais_id        INT NOT NULL REFERENCES dim_pais(pais_id)
);

CREATE TABLE dim_ciudad (
    ciudad_id      SERIAL PRIMARY KEY,
    nombre_ciudad  VARCHAR(80) NOT NULL,
    region_id      INT NOT NULL REFERENCES dim_region(region_id)
);

-- ============================================================
-- Sub-dimensiones (jerarquía de producto)  departamento <- categoria <- producto
-- ============================================================
CREATE TABLE dim_departamento (
    departamento_id      SERIAL PRIMARY KEY,
    nombre_departamento  VARCHAR(80) NOT NULL UNIQUE
);

CREATE TABLE dim_categoria (
    categoria_id      SERIAL PRIMARY KEY,
    nombre_categoria  VARCHAR(80) NOT NULL,
    departamento_id   INT NOT NULL REFERENCES dim_departamento(departamento_id)
);

-- ============================================================
-- Dimensiones principales
-- ============================================================
CREATE TABLE dim_producto (
    producto_id    SERIAL PRIMARY KEY,
    nombre         VARCHAR(120) NOT NULL,
    precio_lista   NUMERIC(12,2) NOT NULL CHECK (precio_lista >= 0),
    categoria_id   INT NOT NULL REFERENCES dim_categoria(categoria_id)
);

CREATE TABLE dim_cliente (
    cliente_id   SERIAL PRIMARY KEY,
    nombre       VARCHAR(120) NOT NULL,
    email        VARCHAR(150) UNIQUE,
    ciudad_id    INT NOT NULL REFERENCES dim_ciudad(ciudad_id)
);

CREATE TABLE dim_tienda (
    tienda_id   SERIAL PRIMARY KEY,
    nombre      VARCHAR(120) NOT NULL,
    ciudad_id   INT NOT NULL REFERENCES dim_ciudad(ciudad_id)
);

-- Dimensión tiempo (clave entera tipo YYYYMMDD, práctica común en DWH)
CREATE TABLE dim_tiempo (
    tiempo_id   INT PRIMARY KEY,          -- ej. 20260619
    fecha       DATE NOT NULL UNIQUE,
    dia         SMALLINT NOT NULL,
    mes         SMALLINT NOT NULL,
    anio        SMALLINT NOT NULL,
    trimestre   SMALLINT NOT NULL,
    nombre_dia  VARCHAR(12) NOT NULL
);

-- ============================================================
-- Tabla de HECHOS
-- ============================================================
CREATE TABLE fact_ventas (
    venta_id      BIGSERIAL PRIMARY KEY,
    tiempo_id     INT  NOT NULL REFERENCES dim_tiempo(tiempo_id),
    producto_id   INT  NOT NULL REFERENCES dim_producto(producto_id),
    cliente_id    INT  NOT NULL REFERENCES dim_cliente(cliente_id),
    tienda_id     INT  NOT NULL REFERENCES dim_tienda(tienda_id),
    cantidad      INT  NOT NULL CHECK (cantidad > 0),
    monto_total   NUMERIC(14,2) NOT NULL CHECK (monto_total >= 0)
);

-- Índices sobre las foreign keys del hecho (aceleran los JOIN/agregaciones)
CREATE INDEX idx_fact_tiempo   ON fact_ventas(tiempo_id);
CREATE INDEX idx_fact_producto ON fact_ventas(producto_id);
CREATE INDEX idx_fact_cliente  ON fact_ventas(cliente_id);
CREATE INDEX idx_fact_tienda   ON fact_ventas(tienda_id);
