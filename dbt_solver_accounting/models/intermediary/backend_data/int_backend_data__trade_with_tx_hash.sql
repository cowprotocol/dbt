{{ config(
    materialized='table'
)}}

with settlements as (
    select 
        *
    from {{ref('int_backend_data__settlements_execution_costs')}}
),

trades as (
    select 
        *
    from {{ref('stg_backend_data__trades')}}
),

settlements_with_previous as (
    -- for each settlement, calculate the previous settlement's log_index within the same block
    select
        tx_hash,
        block_number,
        log_index as settlement_log_index,
        lag(log_index) over (partition by block_number order by log_index) as previous_settlement_log_index,
        solver,
        tx_from,
        tx_nonce,
        auction_id,
        execution_cost
    from
        settlements
),
trade_settlement_matching as (
    -- match each trade to the settlement that happens immediately after it
    select
        t.block_number,
        t.order_uid,
        t.log_index as trade_log_index,
        t.sell_amount,
        t.buy_amount,
        t.fee_amount,
        s.tx_hash,
        s.settlement_log_index,
        s.solver,
        s.tx_from,
        s.tx_nonce,
        s.auction_id,
        s.execution_cost
    from
        trades t
    inner join
        settlements_with_previous s
    on
        t.block_number = s.block_number
    where
        -- the trade log_index must be greater than the previous settlement (or no previous settlement exists)
        (t.log_index > coalesce(s.previous_settlement_log_index, -1))
        -- the trade log_index must be less than or equal to the current settlement
        and t.log_index <= s.settlement_log_index
)
-- final output
select
    *
from
    trade_settlement_matching