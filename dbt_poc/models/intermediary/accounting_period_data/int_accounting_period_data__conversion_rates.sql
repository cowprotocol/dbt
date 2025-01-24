with 

conversion_rate as (
    select 
        *
    from {{ref('stg_dune_data__converstion_rate_accounting_period')}}
),

block_timestamp as (
    select 
        *
    from {{ref('stg_dune_data__block_timestamp')}}
), 

service_fee as (
    select 
        *
    from {{ref('stg_dune_data__dune_data__service_fee_tracker')}}
)

select 
    b.block_number,
    b.time,
    c.conversion_rate_cow_to_native,
    concat(c.start_time, '-', c.end_time) as accounting_period
from 
    block_timestamp b
left join 
    conversion_rate c
on 
    b.time >= c.start_time and b.time < c.end_time