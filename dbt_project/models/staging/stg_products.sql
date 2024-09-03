with

    source as (

        -- Using a Dagster source instead of a DBT source
        -- REF: https://docs.dagster.io/integrations/dbt/reference#upstream-dependencies
        -- {# select * from {{ source('raw_data', 'raw_products') }} #}
        select * from {{ source("dagster_airbyte_assets", "raw_products") }}

    ),

    renamed as (

        select

            -- --------  ids
            sku as product_id,

            -- -------- text
            name as product_name,
            type as product_type,
            description as product_description,

            -- -------- numerics
            {{ cents_to_dollars("price") }} as product_price,

            -- -------- booleans
            coalesce(type = 'jaffle', false) as is_food_item,

            coalesce(type = 'beverage', false) as is_drink_item

        from source

    )

select *
from renamed
