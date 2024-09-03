-- set variables (these need to be uppercase)
-- Airbyte
set airbyte_role
= 'AIRBYTE_ROLE'
;
set airbyte_username
= 'AIRBYTE_USER'
;
set airbyte_password
= 'password'
;
set airbyte_warehouse
= 'AIRBYTE_WAREHOUSE'
;
set airbyte_database
= 'AIRBYTE_DATABASE'
;
set airbyte_schema
= 'AIRBYTE_SCHEMA'
;

-- RAW Data DB
set raw_data_database
= 'RAW_DATABASE'
;
set raw_data_schema
= 'RAW_SCHEMA'
;

-- DBT
set dbt_role
= 'DBT_ROLE'
;
set dbt_username
= 'DBT_USER'
;
set dbt_password
= 'password'
;
set dbt_warehouse
= 'DBT_WAREHOUSE'
;
set dbt_staging_database
= 'STAGING'
;
set dbt_staging_schema
= 'JAFFLE_SHOP'
;
set dbt_datamart_database
= 'DATAMART'
;
set dbt_datamart_schema
= 'JAFFLE_SHOP'
;


begin
;

-- create Airbyte role
use role securityadmin
;
create role if not exists identifier($airbyte_role);
grant role identifier($airbyte_role)
to role sysadmin
;

-- create DBT role
use role securityadmin
;
create role if not exists identifier($dbt_role);
grant role identifier($dbt_role)
to role sysadmin
;

-- create Airbyte user
create user if not exists identifier($airbyte_username)
password = $airbyte_password
default_role = $airbyte_role
default_warehouse = $airbyte_warehouse;

grant role identifier($airbyte_role)
to user identifier($airbyte_username)
;

-- create DBT user
create user if not exists identifier($dbt_username)
password = $dbt_password
default_role = $dbt_role
default_warehouse = $dbt_warehouse;

grant role identifier($dbt_role)
to user identifier($dbt_username)
;


-- change role to sysadmin for warehouse / database steps
use role sysadmin
;

-- create Airbyte warehouse
create warehouse if not exists identifier($airbyte_warehouse)
warehouse_size = xsmall
warehouse_type = standard
auto_suspend = 30
auto_resume = true
initially_suspended = true
;

-- grant Airbyte warehouse access
grant usage
on warehouse identifier($airbyte_warehouse)
to role identifier($airbyte_role)
;

-- create DBT warehouse
create warehouse if not exists identifier($dbt_warehouse)
warehouse_size = xsmall
warehouse_type = standard
auto_suspend = 30
auto_resume = true
initially_suspended = true
;

-- grant DBT warehouse access
grant usage
on warehouse identifier($dbt_warehouse)
to role identifier($dbt_role)
;


-- create Airbyte database
create database if not exists identifier($airbyte_database);

-- create Raw Data database
create database if not exists identifier($raw_data_database);

-- create DBT databases
create database if not exists identifier($dbt_staging_database);
create database if not exists identifier($dbt_datamart_database);


-- grant Airbyte database access
grant ownership
on database identifier($airbyte_database)
to role identifier($airbyte_role)
;

grant usage
on database identifier($raw_data_database)
to role identifier($airbyte_role)
;

-- grant DBT database access
grant usage
on database identifier($airbyte_database)
to role identifier($dbt_role)
;

grant usage
on database identifier($dbt_staging_database)
to role identifier($dbt_role)
;

grant usage
on database identifier($dbt_datamart_database)
to role identifier($dbt_role)
;

commit
;


-- Airbyte - Raw Data Source
begin
;

use database identifier($raw_data_database)
;

-- create schema for Raw data
CREATE SCHEMA IF NOT EXISTS identifier($raw_data_schema);

commit
;

begin
;

-- Grant read only access to Airbyte to ingest Raw Data
grant usage
on schema identifier($raw_data_schema)
to role identifier($airbyte_role)
;
grant select
on all tables in schema identifier($raw_data_schema)
to role identifier($airbyte_role)
;
grant select
on all views in schema identifier($raw_data_schema)
to role identifier($airbyte_role)
;
grant select
on future tables in schema identifier($raw_data_schema)
to role identifier($airbyte_role)
;
grant select
on future views in schema identifier($raw_data_schema)
to role identifier($airbyte_role)
;

commit
;


-- Airbyte - Destination
begin
;

use database identifier($airbyte_database)
;

-- create schema for Airbyte data
CREATE SCHEMA IF NOT EXISTS identifier($airbyte_schema);

commit
;

begin
;

-- grant Airbyte schema access
grant ownership
on schema identifier($airbyte_schema)
to role identifier($airbyte_role)
;

-- Grant read access to DBT to ingested data by Airbyte
grant usage
on schema identifier($airbyte_schema)
to role identifier($dbt_role)
;
grant select
on all tables in schema identifier($airbyte_schema)
to role identifier($dbt_role)
;
grant select
on all views in schema identifier($airbyte_schema)
to role identifier($dbt_role)
;
grant select
on future tables in schema identifier($airbyte_schema)
to role identifier($dbt_role)
;
grant select
on future views in schema identifier($airbyte_schema)
to role identifier($dbt_role)
;

commit
;


-- DBT
begin
;

use database identifier($dbt_staging_database)
;

-- create schema for Airbyte data
CREATE SCHEMA IF NOT EXISTS identifier($dbt_staging_schema);

commit
;

begin
;

grant ownership
on schema identifier($dbt_staging_schema)
to role identifier($dbt_role)
;


grant usage
on schema identifier($dbt_staging_schema)
to role identifier($dbt_role)
;

-- Grant SELECT, INSERT, UPDATE, and DELETE on tables and views
grant select, insert, update, delete
on all tables in schema identifier($dbt_staging_schema)
to role identifier($dbt_role)
;
grant select
on all views in schema identifier($dbt_staging_schema)
to role identifier($dbt_role)
;


commit
;

-- DBT
begin
;

use database identifier($dbt_datamart_database)
;

-- create schema for Airbyte data
CREATE SCHEMA IF NOT EXISTS identifier($dbt_datamart_schema);

grant ownership
on schema identifier($dbt_datamart_schema)
to role identifier($dbt_role)
;

grant usage
on schema identifier($dbt_datamart_schema)
to role identifier($dbt_role)
;

-- Grant SELECT, INSERT, UPDATE, and DELETE on tables and views
grant select, insert, update, delete
on all tables in schema identifier($dbt_datamart_schema)
to role identifier($dbt_role)
;
grant select
on all views in schema identifier($dbt_datamart_schema)
to role identifier($dbt_role)
;


commit
;
