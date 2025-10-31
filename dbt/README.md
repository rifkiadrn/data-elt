# dbt Data Transformation Project

This dbt project transforms data from MinIO (via Airbyte) into a dimensional data warehouse.

## Project Structure

```
├── dbt_project.yml          # dbt project configuration
├── profiles.yml             # Database connection profiles
├── models/
│   ├── staging/             # Raw data models (schema: staging)
│   │   ├── _sources.yml     # Source table definitions
│   │   ├── _stg__models.yml # Staging model configurations
│   │   └── stg_users.sql    # User staging model
│   └── marts/               # Transformed models (schema: marts)
│       ├── _marts__models.yml
│       ├── dimensions/
│       │   └── dim_users.sql
│       └── facts/
│           └── fact_user_registrations.sql
```

## Data Flow

1. **Source**: MinIO data synced via Airbyte
2. **Staging**: Raw data loaded into `staging` schema
3. **Marts**: Transformed facts and dimensions in `marts` schema

## Usage

### Local Development

```bash
# Start dbt environment
cd dbt
docker-compose up -d

# Run in dbt container
docker exec -it dbt bash

> **Note:** The provided Docker approach may not work in all environments or may not be actively maintained. For most users, we recommend installing dbt locally instead of running it through Docker.

### Local Installation

1. **Install dbt** (for PostgreSQL, as an example):
   ```bash
   python -m pip install --upgrade pip
   pip install dbt-postgres
   ```
   See [https://docs.getdbt.com/dbt-cli/installation](https://docs.getdbt.com/dbt-cli/installation) for other adapters or platforms.

2. **Set up your profiles.yml**

   Create or edit `~/.dbt/profiles.yml` with your database credentials as shown below.

3. **Run dbt commands**

   ```bash
   dbt deps                   # Install dependencies
   dbt run --models staging   # Run staging models
   dbt run --models marts     # Run marts models
   dbt test                   # Run tests
   dbt docs generate
   dbt docs serve
   ```

> If you still want to try the Docker approach, use at your own risk, and be sure you have Docker installed and running properly.

# Install dependencies
dbt deps

# Run staging models
dbt run --models staging

# Run marts models
dbt run --models marts

# Run tests
dbt test

# Generate docs
dbt docs generate
dbt docs serve
```

### Airflow Integration

The `etl_pipeline.py` DAG in Airflow orchestrates the complete ETL process:

1. Airbyte sync from MinIO to PostgreSQL
2. dbt staging transformations
3. dbt marts transformations
4. Tests and documentation

## Configuration

### Database Connection

Update `profiles.yml` with your database credentials:

```yaml
data_elt_dbt:
  target: dev
  outputs:
    dev:
      type: postgres
      host: db
      port: 5432
      user: postgres
      password: postgres
      dbname: data-elt
      schema: public
```

### Source Tables

Update `models/staging/_sources.yml` to match your Airbyte destination tables:

```yaml
sources:
  - name: raw_minio
    schema: public  # Schema where Airbyte puts data
    tables:
      - name: users  # Table name from Airbyte
```

## Models

### Staging Models
- `stg_users`: Clean and standardize user data from Airbyte

### Marts Models
- `dim_users`: User dimension with SCD Type 2 support
- `fact_user_registrations`: User registration events

## Testing

Run tests:
```bash
dbt test
```

Add custom tests in model `.yml` files:
```yaml
models:
  - name: dim_users
    columns:
      - name: user_key
        tests:
          - not_null
          - unique
```

## Deployment

The dbt project is integrated with Airflow for automated transformations. The `etl_pipeline.py` DAG handles the complete pipeline orchestration.
