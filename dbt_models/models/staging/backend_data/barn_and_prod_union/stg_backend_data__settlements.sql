{{ config(
    materialized='table'
)}}

with barn as (
    select 
        *,
        'barn' as environment
    from {{ref('stg_backend_data_barn__settlements')}}
),

prod as (
    select 
        *,
        'prod' as environment
    from {{ref('stg_backend_data_prod__settlements')}}
),

final as (
    select *
    from barn
    union all
    select *
    from prod

)

select * from final 
