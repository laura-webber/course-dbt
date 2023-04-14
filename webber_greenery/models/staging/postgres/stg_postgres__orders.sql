{{ 
    config(
        materialized='table'
    )
}}

with source as (
    select * from {{source('postgres','orders')}}
)

, renamed as (
    select 
        order_id as order_guid
        , user_id as user_guid
        , lower(promo_id) as promo_id
        , address_id as address_guid
        , created_at
        , order_cost
        , shipping_cost 
        , order_total 
        , tracking_id
        , shipping_service
        , estimated_delivery_at
        , delivered_at
        , status as order_status
    from source
)

select * from renamed