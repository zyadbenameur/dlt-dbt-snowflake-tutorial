from dagster import OpExecutionContext
from dagster_dbt import DbtCliResource, dbt_assets

from ..constants import dbt_manifest_path


@dbt_assets(manifest=dbt_manifest_path)
def dbt_project_dbt_assets(context: OpExecutionContext, dbt: DbtCliResource):
    yield from dbt.cli(["build"], context=context).stream()
