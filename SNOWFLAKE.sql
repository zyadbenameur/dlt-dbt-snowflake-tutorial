--
CREATE ROLE dbt_role;
CREATE WAREHOUSE dbt_warehouse WITH WAREHOUSE_SIZE='XSMALL' AUTO_SUSPEND = 30 AUTO_RESUME = TRUE;
CREATE USER dbt_user PASSWORD='password' DEFAULT_ROLE=dbt_role DEFAULT_WAREHOUSE=dbt_warehouse;
GRANT ROLE dbt_role TO USER dbt_user;

-- database and schema
-- raw
CREATE DATABASE raw_data;
CREATE SCHEMA raw_data.jaffle_shop;
CREATE SCHEMA raw_data.iron_shop;
-- datamart
CREATE DATABASE datamart;
CREATE SCHEMA datamart.jaffle_shop;
CREATE SCHEMA datamart.iron_shop;

-- grants
-- warehouse
GRANT USAGE ON WAREHOUSE dbt_warehouse TO ROLE dbt_role;
-- raw
GRANT USAGE ON DATABASE raw_data TO ROLE dbt_role;
GRANT USAGE ON ALL SCHEMAS IN DATABASE raw_data TO ROLE dbt_role;

GRANT CREATE TABLE, CREATE VIEW ON ALL SCHEMAS IN DATABASE raw_data TO ROLE dbt_role;

GRANT SELECT ON ALL TABLES IN DATABASE raw_data TO ROLE dbt_role;
GRANT SELECT ON ALL VIEWS IN DATABASE raw_data TO ROLE dbt_role;

-- datamart
GRANT USAGE ON DATABASE datamart TO ROLE dbt_role;
GRANT USAGE ON ALL SCHEMAS IN DATABASE datamart TO ROLE dbt_role;

GRANT CREATE TABLE, CREATE VIEW ON ALL SCHEMAS IN DATABASE datamart TO ROLE dbt_role;

GRANT SELECT ON ALL TABLES IN DATABASE datamart TO ROLE dbt_role;
GRANT SELECT ON ALL VIEWS IN DATABASE datamart TO ROLE dbt_role;

-- TODO: create AIRBYTE_ROLE AIRBYTE_SCHEMA AIRBYTE_USER AIRBYTE_WAREHOUSE
-- set variables (these need to be uppercase)
set airbyte_role = 'AIRBYTE_ROLE';
set airbyte_username = 'AIRBYTE_USER';
set airbyte_warehouse = 'AIRBYTE_WAREHOUSE';
set airbyte_database = 'AIRBYTE_DATABASE';
set airbyte_schema = 'AIRBYTE_SCHEMA';

-- set user password
set airbyte_password = 'password';

begin;

-- create Airbyte role
use role securityadmin;
create role if not exists identifier($airbyte_role);
grant role identifier($airbyte_role) to role SYSADMIN;

-- create Airbyte user
create user if not exists identifier($airbyte_username)
password = $airbyte_password
default_role = $airbyte_role
default_warehouse = $airbyte_warehouse;

grant role identifier($airbyte_role) to user identifier($airbyte_username);

-- change role to sysadmin for warehouse / database steps
use role sysadmin;

-- create Airbyte warehouse
create warehouse if not exists identifier($airbyte_warehouse)
warehouse_size = xsmall
warehouse_type = standard
auto_suspend = 60
auto_resume = true
initially_suspended = true;

-- create Airbyte database
create database if not exists identifier($airbyte_database);

-- grant Airbyte warehouse access
grant USAGE
on warehouse identifier($airbyte_warehouse)
to role identifier($airbyte_role);

-- grant Airbyte database access
grant OWNERSHIP
on database identifier($airbyte_database)
to role identifier($airbyte_role);

commit;

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

commit;