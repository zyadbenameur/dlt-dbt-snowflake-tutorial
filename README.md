https://motherduck.com/product/ https://dlthub.com/docs/blog/on-orchestrators?utm_source=slack https://dlthub.com/docs/blog/pandas-to-production https://github.com/dlt-hub/dlt_demos/blob/main/dlt-init-openapi-demo/README.md

https://frpviom-az19035.snowflakecomputing.com/console/login

https://docs.airbyte.com/deploying-airbyte/docker-compose

## clone Airbyte from GitHub

git clone --depth=1 https://github.com/airbytehq/airbyte.git

## switch into Airbyte directory

cd airbyte

## start Airbyte

./run-ab-platform.sh

1- add jaffle shop raw data to snowflake and in local folder
https://github.com/dbt-labs/jaffle-shop/tree/main/jaffle-data
2- configure properly the roles, users, warehouses, databases and schemas and privileges.
2.1- configure schema name by user for dbt developers
3- create connection between raw database and prep database
4- create dbt models from prep database to marts database
5- add tests to models
6- small intro to dagster
7- next step : power bi dashboard
8- add documentation and links
9- develop power bi + power bu workshop

Subject :
ETL vs ELT
Modern data stack
what we will use (airbyte, dbt, snowflake and dagster)
demo
word on Codespaces and dev environment setup
snowflake demo
airbyte demo
dbt explanation (advantages, legacy code example) and demo
dagster explanation and demo

Power BI report with datamart layer

highlight important notes :
Ingestion strategies and challenges (merge, append, replace)
clean code (python and sql)
use of version control (github)

https://docs.airbyte.com/using-airbyte/core-concepts/sync-modes/full-refresh-append
