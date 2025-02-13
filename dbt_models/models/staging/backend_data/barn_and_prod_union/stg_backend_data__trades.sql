{{ config(
    materialized='table'
)}}

with barn as (
    select 
        *,
        'barn' as environment
    from {{ref('stg_backend_data_barn__trades')}}
),

prod as (
    select 
        *,
        'prod' as environment
    from {{ref('stg_backend_data_prod__trades')}}
),

with_duplicates as (
    select *
    from barn
    union all
    select *
    from prod

),

ranked_data as (
    select 
        *,
        row_number() over (partition by block_number, log_index, order_uid, sell_amount, buy_amount, fee_amount order by environment desc) as row_num 
    from with_duplicates 
),

final as (
    select 
        block_number, 
        log_index, 
        order_uid, 
        sell_amount, 
        buy_amount, 
        fee_amount,
        environment
    from ranked_data
    where row_num = 1 
)

select * from final 
