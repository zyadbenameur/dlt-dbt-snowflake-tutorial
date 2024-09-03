with

source as (

    -- Using a Dagster source instead of a DBT source
    -- REF: https://docs.dagster.io/integrations/dbt/reference#upstream-dependencies
    -- {# select * from {{ source('raw_data', 'raw_customers') }} #}
    select * from {{ source("dagster_airbyte_assets", "raw_customers") }}

),

renamed as (

    select

        ----------  ids
        id as customer_id,

        ---------- text
        name as customer_name

    from source

)

select * from renamed
