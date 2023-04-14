{{ 
    config(
        materialized='table'
    )
}}

with source as (
    select * from {{source('postgres','promos')}}
)

, renamed as (
    select
        lower(PROMO_ID) as promo_id
        , DISCOUNT
        , STATUS as promo_status
    from source
)

select * from renamed