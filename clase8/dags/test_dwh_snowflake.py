"""DAG de prueba: verifica la conexion al DWH snowflake y lee una agregacion."""
from __future__ import annotations

from airflow.decorators import dag, task
from airflow.providers.postgres.hooks.postgres import PostgresHook
import pendulum


@dag(
    schedule=None,
    start_date=pendulum.datetime(2026, 1, 1, tz="UTC"),
    catchup=False,
    tags=["dwh", "snowflake"],
)
def test_dwh_snowflake():
    @task
    def ventas_por_pais():
        hook = PostgresHook(postgres_conn_id="dwh")
        sql = """
            SET search_path TO dwh;
            SELECT p.nombre_pais, SUM(f.monto_total) AS total
            FROM fact_ventas f
            JOIN dim_cliente c ON c.cliente_id = f.cliente_id
            JOIN dim_ciudad ci ON ci.ciudad_id = c.ciudad_id
            JOIN dim_region r ON r.region_id = ci.region_id
            JOIN dim_pais p   ON p.pais_id   = r.pais_id
            GROUP BY p.nombre_pais
            ORDER BY total DESC;
        """
        rows = hook.get_records(sql)
        for nombre_pais, total in rows:
            print(f"{nombre_pais}: {total}")
        return rows

    ventas_por_pais()


test_dwh_snowflake()
