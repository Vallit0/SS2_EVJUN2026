from datetime import datetime

from airflow import DAG
from airflow.operators.bash import BashOperator


with DAG(
    dag_id="hello_bash_dag",
    description="DAG simple usando BashOperator",
    start_date=datetime(2026, 1, 1),
    schedule=None,  # Se ejecuta manualmente
    catchup=False,
    tags=["ejemplo", "bash"],
) as dag:

    tarea_hello = BashOperator(
        task_id="imprimir_hola",
        bash_command='echo "Hola desde Airflow con BashOperator"',
    )

    tarea_fecha = BashOperator(
        task_id="imprimir_fecha",
        bash_command="date",
    )

    tarea_hello >> tarea_fecha