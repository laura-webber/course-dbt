-- tells dbt whether you want a table or a view when it's materialized
{{
    config(
        materialized = 'table'
    )
}}

with source as (
    select * from {{ source('postgres', 'addresses') }}
)
, renamed_recast as (
    SELECT
        address_id as address_guid
        , address
        , state
        , country
        , lpad(zipcode, 5, 0) as zip_code
    from addresses
)

select * from renamed_recast