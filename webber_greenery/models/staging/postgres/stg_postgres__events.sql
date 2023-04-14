{{
    config(
        materialized='table'
    )
}}

with source as (
    select * from {{source('postgres','events')}}
)

, renamed as (
    select 
    EVENT_ID as event_guid
    , SESSION_ID as session_guid
    , USER_ID as user_guid
    , PAGE_URL
    , CREATED_AT
    , EVENT_TYPE
    , ORDER_ID as order_guid
    , PRODUCT_ID as product_guid
    from source 
)

select * from renamed