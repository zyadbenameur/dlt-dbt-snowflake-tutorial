-- set variables (these need to be uppercase)
-- Airbyte
set airbyte_role = 'AIRBYTE_ROLE';
set airbyte_username = 'AIRBYTE_USER';
set airbyte_password = 'password';

set airbyte_warehouse = 'AIRBYTE_WAREHOUSE';

set airbyte_database = 'AIRBYTE_DATABASE';
set airbyte_schema = 'AIRBYTE_SCHEMA';

-- RAW Data DB
set raw_data_database = 'RAW_DATABASE';
set raw_data_schema = 'RAW_SCHEMA';

-- DBT
set dbt_role = 'DBT_ROLE';
set dbt_username = 'DBT_USER';
set dbt_password = 'password';

set dbt_warehouse = 'DBT_WAREHOUSE';

set dbt_staging_database = 'STAGING';
set dbt_staging_schema = 'JAFFLE_SHOP';

set dbt_datamart_database = 'DATAMART';
set dbt_datamart_schema = 'JAFFLE_SHOP';


begin;

-- create Airbyte role
use role securityadmin;
create role if not exists identifier($airbyte_role);
grant role identifier($airbyte_role) to role SYSADMIN;

-- create DBT role
use role securityadmin;
create role if not exists identifier($dbt_role);
grant role identifier($dbt_role) to role SYSADMIN;

-- create Airbyte user
create user if not exists identifier($airbyte_username)
password = $airbyte_password
default_role = $airbyte_role
default_warehouse = $airbyte_warehouse;

grant role identifier($airbyte_role) to user identifier($airbyte_username);

-- create DBT user
create user if not exists identifier($dbt_username)
password = $dbt_password
default_role = $dbt_role
default_warehouse = $dbt_warehouse;

grant role identifier($dbt_role) to user identifier($dbt_username);



-- change role to sysadmin for warehouse / database steps
use role sysadmin;

-- create Airbyte warehouse
create warehouse if not exists identifier($airbyte_warehouse)
warehouse_size = xsmall
warehouse_type = standard
auto_suspend = 30
auto_resume = true
initially_suspended = true;

-- grant Airbyte warehouse access
grant USAGE
on warehouse identifier($airbyte_warehouse)
to role identifier($airbyte_role);

-- create DBT warehouse
create warehouse if not exists identifier($dbt_warehouse)
warehouse_size = xsmall
warehouse_type = standard
auto_suspend = 30
auto_resume = true
initially_suspended = true;

-- grant DBT warehouse access
grant USAGE
on warehouse identifier($dbt_warehouse)
to role identifier($dbt_role);



-- create Airbyte database
create database if not exists identifier($airbyte_database);

-- create Raw Data database
create database if not exists identifier($raw_data_database);

-- create DBT databases
create database if not exists identifier($dbt_staging_database);
create database if not exists identifier($dbt_datamart_database);


-- grant Airbyte database access
grant OWNERSHIP
on database identifier($airbyte_database)
to role identifier($airbyte_role);

GRANT USAGE ON DATABASE identifier($raw_data_database) to ROLE identifier($airbyte_role);

-- grant DBT database access
GRANT USAGE ON DATABASE identifier($airbyte_database) to ROLE identifier($dbt_role);

GRANT USAGE ON DATABASE identifier($dbt_staging_database) to ROLE identifier($dbt_role);

GRANT USAGE ON DATABASE identifier($dbt_datamart_database) to ROLE identifier($dbt_role);

commit;


-- Airbyte - Raw Data Source
begin;

USE DATABASE identifier($raw_data_database);

-- create schema for Raw data
CREATE SCHEMA IF NOT EXISTS identifier($raw_data_schema);

commit;

begin;

-- Grant read only access to Airbyte to ingest Raw Data
GRANT USAGE ON SCHEMA identifier($raw_data_schema) to ROLE identifier($airbyte_role);
GRANT SELECT ON ALL TABLES IN SCHEMA identifier($raw_data_schema) TO ROLE identifier($airbyte_role);
GRANT SELECT ON ALL VIEWS IN SCHEMA identifier($raw_data_schema) TO ROLE identifier($airbyte_role);
GRANT SELECT ON FUTURE TABLES IN SCHEMA identifier($raw_data_schema) TO ROLE identifier($airbyte_role);
GRANT SELECT ON FUTURE VIEWS IN SCHEMA identifier($raw_data_schema) TO ROLE identifier($airbyte_role);

commit;


-- Airbyte - Destination
begin;

USE DATABASE identifier($airbyte_database);

-- create schema for Airbyte data
CREATE SCHEMA IF NOT EXISTS identifier($airbyte_schema);

commit;

begin;

-- grant Airbyte schema access
grant OWNERSHIP
on schema identifier($airbyte_schema)
to role identifier($airbyte_role);

-- Grant read access to DBT to ingested data by Airbyte
GRANT USAGE ON SCHEMA identifier($airbyte_schema) to ROLE identifier($dbt_role);
GRANT SELECT ON ALL TABLES IN SCHEMA identifier($airbyte_schema) TO ROLE identifier($dbt_role);
GRANT SELECT ON ALL VIEWS IN SCHEMA identifier($airbyte_schema) TO ROLE identifier($dbt_role);
GRANT SELECT ON FUTURE TABLES IN SCHEMA identifier($airbyte_schema) TO ROLE identifier($dbt_role);
GRANT SELECT ON FUTURE VIEWS IN SCHEMA identifier($airbyte_schema) TO ROLE identifier($dbt_role);

commit;



-- DBT
begin;

USE DATABASE identifier($dbt_staging_database);

-- create schema for Airbyte data
CREATE SCHEMA IF NOT EXISTS identifier($dbt_staging_schema);

commit;

begin;

grant OWNERSHIP
on schema identifier($dbt_staging_schema)
to role identifier($dbt_role);


GRANT USAGE ON SCHEMA identifier($dbt_staging_schema) to ROLE identifier($dbt_role);

-- Grant SELECT, INSERT, UPDATE, and DELETE on tables and views
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA identifier($dbt_staging_schema) TO ROLE identifier($dbt_role);
GRANT SELECT ON ALL VIEWS IN SCHEMA identifier($dbt_staging_schema) TO ROLE identifier($dbt_role);


commit;

-- DBT
begin;

USE DATABASE identifier($dbt_datamart_database);

-- create schema for Airbyte data
CREATE SCHEMA IF NOT EXISTS identifier($dbt_datamart_schema);

grant OWNERSHIP
on schema identifier($dbt_datamart_schema)
to role identifier($dbt_role);

GRANT USAGE ON SCHEMA identifier($dbt_datamart_schema) to ROLE identifier($dbt_role);

-- Grant SELECT, INSERT, UPDATE, and DELETE on tables and views
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA identifier($dbt_datamart_schema) TO ROLE identifier($dbt_role);
GRANT SELECT ON ALL VIEWS IN SCHEMA identifier($dbt_datamart_schema) TO ROLE identifier($dbt_role);


commit;