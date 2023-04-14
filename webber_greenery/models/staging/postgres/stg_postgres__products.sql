-- define config
{{
    config(
        materialized='table'
    )
}}

-- define source 

with source as (
    select * from {{source('postgres', 'products')}}
)

, renamed as (
    select 
        product_id as product_guid
        , name as product_name
        , price as product_price
        , inventory
    from source
)

select * from renamed
