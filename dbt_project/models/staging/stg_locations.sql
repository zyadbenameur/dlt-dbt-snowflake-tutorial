with

    source as (

        -- Using a Dagster source instead of a DBT source
        -- REF: https://docs.dagster.io/integrations/dbt/reference#upstream-dependencies
        -- {# select * from {{ source('raw_data', 'raw_stores') }} #}
        select * from {{ source("dagster_airbyte_assets", "raw_stores") }}

    ),

    renamed as (

        select

            -- --------  ids
            id as location_id,

            -- -------- text
            name as location_name,

            -- -------- numerics
            tax_rate,

            -- -------- timestamps
            {{ dbt.date_trunc("day", "opened_at") }} as opened_date

        from source

    )

select *
from renamed
