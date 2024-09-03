from dagster import load_assets_from_modules

from . import airbyte_assets, dbt_assets

dbt_project_assets = load_assets_from_modules(
    modules=[dbt_assets],
    group_name="DBT",
)

airbyte_project_assets = load_assets_from_modules(modules=[airbyte_assets])

all_assets = [*dbt_project_assets] + [*airbyte_project_assets]
