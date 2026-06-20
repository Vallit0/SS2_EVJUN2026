# Dockerfile — Data Warehouse en Postgres con modelo snowflake
# Los scripts en /docker-entrypoint-initdb.d se ejecutan solo la PRIMERA vez
# que se crea el volumen de datos (cuando la base aún no existe).
FROM postgres:16

# Codificación recomendada para el DWH
ENV LANG=en_US.utf8

# Scripts de inicialización (se corren en orden alfabético)
COPY init/ /docker-entrypoint-initdb.d/
