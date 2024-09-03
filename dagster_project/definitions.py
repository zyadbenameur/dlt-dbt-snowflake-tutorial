import os

from dagster import Definitions
from dagster_dbt import DbtCliResource

from .assets import all_assets
from .constants import dbt_project_dir

defs = Definitions(
    assets=all_assets,
    resources={
        "dbt": DbtCliResource(project_dir=os.fspath(dbt_project_dir)),
    },
)
