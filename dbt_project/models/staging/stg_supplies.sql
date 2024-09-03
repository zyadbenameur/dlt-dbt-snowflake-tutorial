with

    source as (

        -- Using a Dagster source instead of a DBT source
        -- REF: https://docs.dagster.io/integrations/dbt/reference#upstream-dependencies
        -- {# select * from {{ source('raw_data', 'raw_supplies') }} #}
        select * from {{ source("dagster_airbyte_assets", "raw_supplies") }}

    ),

    renamed as (

        select

            -- --------  ids
            {{ dbt_utils.generate_surrogate_key(["id", "sku"]) }} as supply_uuid,
            id as supply_id,
            sku as product_id,

            -- -------- text
            name as supply_name,

            -- -------- numerics
            {{ cents_to_dollars("cost") }} as supply_cost,

            -- -------- booleans
            perishable as is_perishable_supply

        from source

    )

select *
from renamed
