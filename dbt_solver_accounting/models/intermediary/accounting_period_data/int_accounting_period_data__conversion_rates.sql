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

min_max_time as (
    select 
        min(time) as min_time,
        max(time) as max_time
    from block_timestamp
),

accounting_periods as (
    select 
        date_trunc('WEEK', min_time + INTERVAL '1 day') + INTERVAL '1 day' as first_tuesday,
        date_trunc('WEEK', max_time + INTERVAL '1 day') + INTERVAL '1 day' as last_tuesday
    from min_max_time
),

generated_periods as (
    select 
        first_tuesday + INTERVAL '7 days' * n as accounting_period_start_time,
        (first_tuesday + INTERVAL '7 days' * (n + 1)) - INTERVAL '1 second' as accounting_period_end_time
    from accounting_periods,
    generate_series(0, 
        extract(day from (last_tuesday - first_tuesday))::int / 7) n
),

accounting_period as (

    select 
        g.accounting_period_start_time,
        g.accounting_period_end_time,
        concat(
            to_char(g.accounting_period_start_time, 'YYYY-MM-DD HH24:MI:SS'),
            ' - ',
            to_char(g.accounting_period_end_time, 'YYYY-MM-DD HH24:MI:SS')
        ) as accounting_period,
        c.conversion_rate_cow_to_native
    from generated_periods g
    left join 
        conversion_rate c
    on 
        c.start_time >= g.accounting_period_start_time and c.start_time < g.accounting_period_end_time
)

select 
    b.block_number,
    b.time as block_time,
    a.*
from 
    block_timestamp b
left join 
    accounting_period a
on 
    b.time >= a.accounting_period_start_time and b.time < a.accounting_period_end_time
    
