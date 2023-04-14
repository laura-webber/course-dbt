{{
    config(
        materialized='table'
    )
}}

with source as (
    select * from {{source('postgres','users')}}
)
, renamed as (
    select 
        USER_ID as user_guid
        , FIRST_NAME
        , LAST_NAME
        , EMAIL
        , PHONE_NUMBER
        , CREATED_AT
        , UPDATED_AT
        , ADDRESS_ID as address_guid
    from source
)

select * from renamed