from airflow import DAG
from airflow.operators.bash import BashOperator
from datetime import datetime, timedelta

DBT_PROJECT_DIR = "/home/hager-vm/snowflake_bank_project"
DBT_VENV_ACTIVATE = "/home/hager-vm/dbt-env/bin/activate"

default_args = {
    'owner': 'hager',
    'depends_on_past': False,
    'start_date': datetime(2026, 2, 11),
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

with DAG(
    dag_id="dbt_run_snowflake_bank_project",
    default_args=default_args,
    description="Run dbt models for Snowflake banking project",
    schedule='@daily',
    catchup=False,
) as dag:

    stg_run = BashOperator(
        task_id="run_staging",
        bash_command=f"""
        source {DBT_VENV_ACTIVATE} &&
        cd {DBT_PROJECT_DIR} &&
        dbt run --select STG_BANKING_TRANSACTIONS
        """
    )

    run_snapshot = BashOperator(
        task_id="run_snapshot",
        bash_command=f"""
        source {DBT_VENV_ACTIVATE} &&
        cd {DBT_PROJECT_DIR} &&
        dbt snapshot
        """
    )

    run_dbt = BashOperator(
        task_id="run_dbt_models",
        bash_command=f"""
        source {DBT_VENV_ACTIVATE} &&
        cd {DBT_PROJECT_DIR} &&
        dbt run --exclude STG_BANKING_TRANSACTIONS
        """
    )

    dbt_test = BashOperator(
        task_id="dbt_test",
        bash_command=f"""
        source {DBT_VENV_ACTIVATE} &&
        cd {DBT_PROJECT_DIR} &&
        dbt test
        """
    )

    stg_run >> run_snapshot >> run_dbt >> dbt_test

