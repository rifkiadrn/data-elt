from airflow import DAG
from airflow.operators.bash import BashOperator
from datetime import datetime, timedelta

# dbt_path = "/opt/dbt"
# manifest_path = os.path.join(dbt_path, "target", "manifest.json")

# with open(manifest_path, 'r') as f:
#     manifest = json.load(f)
#     nodes = manifest['nodes']

default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'start_date': datetime(2025, 10, 22),
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

with DAG(
    'dbt_transformation',
    default_args=default_args,
    description='Run dbt transformations after Airbyte sync',
    # schedule_interval=None,  # Triggered manually or by sensor
    catchup=False,
    tags=['dbt', 'transformation'],
) as dag:
    # dbt_tasks = dict()
    # for node_id, node_info in nodes.items():
    #     dbt_tasks[node_id] = BashOperator(
    #         task_id=".".join(node_info["resource_type"], node_info["package_name"], node_info["name"]),
    #         bash_command=f'cd {dbt_path} && dbt run --models {node_info["name"]} --profiles-dir {dbt_path}/.dbt',
    #     )

    # # Set task dependencies
    # for node_id, node_info in nodes.items():
    #     if node_info["depends_on"]["nodes"]:
    #         for depends_on_node in node_info["depends_on"]["nodes"]:
    #             dbt_tasks[depends_on_node] >> dbt_tasks[node_id]

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

    dbt_run_staging >> dbt_run_marts