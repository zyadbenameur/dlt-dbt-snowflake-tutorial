from setuptools import find_packages, setup

setup(
    name="modern-data-pipelines-workshop",
    version="0.0.1",
    packages=find_packages(),
    install_requires=[
        # dbt
        "dbt-core==1.8.6",  # https://pypi.org/project/dbt-core/
        "dbt-snowflake",  # https://pypi.org/project/dbt-snowflake/
        # "dbt-metricflow",  # https://pypi.org/project/dbt-metricflow/
        # dagster
        "dagster",
        "dagster-dbt",
        "dagster-airbyte",
        # dlt
        # "dlt[snowflake]==0.4.12",  # https://pypi.org/project/dlt/
        # "dlt[duckdb]==0.4.12",  # https://pypi.org/project/dlt/
        # duckdb command line
        "duckcli==0.2.1",
        # pandas
        "numpy==1.24.3",  # https://pypi.org/project/numpy/
        "pandas==2.0.3",  # https://pypi.org/project/pandas/
        # debug-friendly stack traces
        "stackprinter >= 0.2.10",  # https://pypi.org/project/stackprinter/
    ],
    extras_require={
        "dev": [
            "pytest",
            "dagster-webserver",
        ]
    },
)
