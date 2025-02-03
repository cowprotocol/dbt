{{ config(
    materialized='table'
)}}

with barn as (
    select 
        *,
        'barn' as environment
    from {{ref('stg_backend_data_barn__auction_prices')}}
),

prod as (
    select 
        *,
        'prod' as environment
    from {{ref('stg_backend_data_prod__auction_prices')}}
),

final as (
    select *
    from barn
    union all
    select *
    from prod

)

select * from final 
