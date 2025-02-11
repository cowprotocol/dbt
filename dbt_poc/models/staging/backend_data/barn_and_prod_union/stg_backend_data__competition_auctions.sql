{{ config(
    materialized='table'
)}}

with barn as (
    select 
        *,
        'barn' as environment
    from {{ref('stg_backend_data_barn__competition_auctions')}}
),

prod as (
    select 
        *,
        'prod' as environment
    from {{ref('stg_backend_data_prod__competition_auctions')}}
),

final as (
    select *
    from barn
    union all
    select *
    from prod

)

select * from final 