"""DAG de ejemplo: pipeline minimo de 3 tareas con la TaskFlow API.

extraer -> transformar -> cargar. No usa conexiones externas, solo
pasa datos entre tareas vía XCom para demostrar el flujo.
"""
from __future__ import annotations

from airflow.decorators import dag, task
import pendulum


@dag(
    schedule=None,
    start_date=pendulum.datetime(2026, 1, 1, tz="UTC"),
    catchup=False,
    tags=["ejemplo", "demo"],
)
def ejemplo_hola_mundo():
    @task
    def extraer() -> list[int]:
        datos = [1, 2, 3, 4, 5]
        print(f"Extraidos: {datos}")
        return datos

    @task
    def transformar(datos: list[int]) -> list[int]:
        cuadrados = [x * x for x in datos]
        print(f"Transformados (al cuadrado): {cuadrados}")
        return cuadrados

    @task
    def cargar(datos: list[int]) -> None:
        total = sum(datos)
        print(f"Carga completa. Suma total = {total}")

    cargar(transformar(extraer()))


ejemplo_hola_mundo()
