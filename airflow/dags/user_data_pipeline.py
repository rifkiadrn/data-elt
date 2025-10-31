from airflow import DAG
from airflow.providers.airbyte.operators.airbyte import AirbyteTriggerSyncOperator
from airflow.operators.bash import BashOperator
from datetime import datetime

AIRBYTE_CONNECTION_TO_LAKE_ID = "8ab2f854-4cc5-4f73-95d7-fd5d78f769c2"
AIRBYTE_CONNECTION_TO_WAREHOUSE_ID = "e36e413e-5724-4944-a440-210a863cfdea"

with DAG(
    "user_data_pipeline",
    start_date=datetime(2025, 10, 27),
    # schedule="@daily",  # Uncomment when ready to schedule
    catchup=False,
) as dag:

    sync_to_lake_task = AirbyteTriggerSyncOperator(
        task_id="sync_postgres_to_minio",
        airbyte_conn_id="airbyte_conn",
        connection_id=AIRBYTE_CONNECTION_TO_LAKE_ID,
        asynchronous=False,
        wait_seconds=3,
        timeout=3600,
    )

    sync_to_warehouse_task = AirbyteTriggerSyncOperator(
        task_id="sync_minio_to_warehouse",
        airbyte_conn_id="airbyte_conn",
        connection_id=AIRBYTE_CONNECTION_TO_WAREHOUSE_ID,
        asynchronous=False,
        wait_seconds=3,
        timeout=3600,
    )

    dbt_run_staging = BashOperator(
        task_id='dbt_run_staging',
        bash_command='cd /opt/dbt && dbt run --models staging --profiles-dir /opt/dbt',
        dag=dag,
    )

    dbt_run_marts = BashOperator(
        task_id='dbt_run_marts',
        bash_command='cd /opt/dbt && dbt run --models marts --profiles-dir /opt/dbt',
        dag=dag,
    )

    sync_to_lake_task >> sync_to_warehouse_task >> dbt_run_staging >> dbt_run_marts