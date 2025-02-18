{{ config(
    materialized='table'
)}}

with barn as (
    select 
        *,
        'barn' as environment
    from {{ref('stg_backend_data_barn__app_data')}}
),

prod as (
    select 
        *,
        'prod' as environment
    from {{ref('stg_backend_data_prod__app_data')}}
),
-- todo: check deduplicate
final as (
    select *
    from barn
    union distinct
    select *
    from prod

)

select * from final 
