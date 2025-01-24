{{ config(
    materialized='table'
)}}

with 

rewards as (
    select * from {{ref('fct_sender_rewards')}}
),

trade_data as (
    select * from {{ref('int_backend_data__trade_data_processed_with_native_prices')}}
),

slippage_per_transaction as (
    select * from {{ref('int_dune_data__slippage_per_transaction')}}
),

sender_rewards_all as (
    select 
        auction_id,
        tx_hash,
        sum(protocol_fee_amount) as protocol_fee_amount,
        sum(network_fee_amount) as network_fee_amount
    from trade_data
    group by 
        auction_id,
        tx_hash

),

data_per_solution as (
    select 
        r.auction_id,
        r.block_number,
        r.block_deadline,
        r.tx_hash,
        r.solver,
        r.batch_reward_wei,
        r.is_winner,
        r.winning_score,
        r.reference_score,
        r.is_settled_in_time,
        r.reward_target,
        r.solver_name, 
        r.execution_cost,
        sra.protocol_fee_amount,
        sra.network_fee_amount,
        spt.slippage_wei,
        spt.slippage_usd
    from 
        rewards r
    left join 
        sender_rewards_all sra 
    on 
        r.auction_id = sra.auction_id
    and 
        r.tx_hash = sra.tx_hash
    left join 
        slippage_per_transaction spt 
    on
        r.tx_hash = spt.tx_hash
)

select * from data_per_solution