{{ config(
    materialized='table'
)}}

with settlements as (
    select 
        *
    from {{ref('stg_backend_data__settlements')}}
),

trades as (
    select 
        *
    from {{ref('stg_backend_data__trades')}}
),

ranked_trades as (
    select
        *,
        row_number() over (partition by block_number order by log_index) as rank
    from
        trades
),

ranked_settlements as (
    select
        *,
        row_number() over (partition by block_number order by log_index) as rank
    from
        settlements
),

trade_with_tx_hash as (

    select
        t.block_number,
        t.order_uid,
        t.log_index as trade_log_index,
        t.sell_amount,
        t.buy_amount,
        t.fee_amount,
        s.tx_hash,
        s.log_index as settlement_log_index,
        s.solver,
        s.tx_from,
        s.tx_nonce,
        s.auction_id
    from
        ranked_trades t
    join
        ranked_settlements s
    on
        t.block_number = s.block_number
        and t.rank = s.rank

)

select * from trade_with_tx_hash