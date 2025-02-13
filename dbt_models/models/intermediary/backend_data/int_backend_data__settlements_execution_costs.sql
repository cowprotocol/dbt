{{ config(
    materialized='table'
)}}

with settlement_observations as (
    select 
        *
    from {{ref('stg_backend_data__settlement_observations')}}
),

settlements as (
    select 
        *
    from {{ref('stg_backend_data__settlements')}}
),

final as (
    select 
        s.*,
        so.gas_used * so.effective_gas_price as execution_cost
    from 
        settlements s
    join 
        settlement_observations so
    on 
        s.block_number = so.block_number
    and 
        s.log_index = so.log_index
)

select * from final