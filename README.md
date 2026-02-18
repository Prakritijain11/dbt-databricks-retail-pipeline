# dbt Databricks Analytics Project

A layered dbt project that transforms retail sales data in Databricks using a bronze -> silver -> gold model pattern.

## What this project does

- Ingests source tables (`fact_sales`, `fact_returns`, `dim_*`, `items`) from Databricks.
- Builds staging models in the `bronze` schema.
- Creates business-ready aggregates in `silver`.
- Produces curated outputs in `gold` (including deduplicated latest item records).
- Validates data quality with built-in and custom dbt tests.

## Tech stack

- `dbt-core` 1.11+
- `dbt-databricks` 1.10+
- Databricks SQL Warehouse
- Python 3.11+

## Project layout

```text
DBT_Project/
|- DBT_Project_youtube_new/
|  |- models/
|  |  |- source/      # source definitions
|  |  |- bronze/      # raw-to-clean staging
|  |  |- silver/      # transformed business layer
|  |  |- gold/        # curated analytics outputs
|  |- tests/          # singular + generic tests
|  |- macros/         # reusable SQL macros
|  |- seeds/          # seed files
|  |- snapshots/      # snapshot definitions
|- requirements.txt
`- README.md
```

## Data model flow

1. `source` tables are declared in `models/source/source.yml`.
2. `bronze_*` models select and standardize source data.
3. `silver_salesinfo` joins sales, products, and customers for analytical reporting.
4. `source_gold_items` deduplicates `items` using `ROW_NUMBER()` and latest `updateDate`.

## Included quality checks

- Generic test: `generic_non_negative` for non-negative numeric values.
- Built-in tests: `unique`, `not_null`, and `accepted_values` in `models/bronze/properties.yml`.
- Singular test: `tests/non_negative_test.sql`.

## Setup

### 1) Install dependencies

```bash
pip install -r requirements.txt
```

Or with `uv`:

```bash
uv sync
```

### 2) Configure Databricks credentials

Set your Databricks token as an environment variable:

```powershell
$env:DATABRICKS_TOKEN="<your-token>"
```

Your dbt profile is configured in `DBT_Project_youtube_new/profiles.yml`.

### 3) Run dbt

From `DBT_Project_youtube_new/`:

```bash
dbt debug
dbt run
dbt test
dbt docs generate
```

## Useful commands

```bash
dbt run --select bronze
dbt run --select silver
dbt run --select gold
dbt test --select bronze_sales
```

## Notes

- Do not commit secrets. Keep tokens in environment variables.
- `generate_schema_name` macro is customized in `macros/generate_schema.sql`.
- Sample CSV files in `Data/` can be used to validate source structure.
