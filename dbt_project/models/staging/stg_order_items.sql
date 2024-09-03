with

    source as (

        -- Using a Dagster source instead of a DBT source
        -- REF: https://docs.dagster.io/integrations/dbt/reference#upstream-dependencies
        -- {# select * from {{ source('raw_data', 'raw_items') }} #}
        select * from {{ source("dagster_airbyte_assets", "raw_items") }}

    ),

    renamed as (

        select

            -- --------  ids
            id as order_item_id, order_id, sku as product_id

        from source

    )

select *
from renamed
