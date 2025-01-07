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

service_fees as (
    select * from {{ref('stg_dune_data__cow_protocol_ethereum_service_fees')}}
),

sender_rewards_all as (
    select 
        auction_id,
        tx_hash,
        sum(observed_fee) as observed_fee,
        sum(protocol_fee) as protocol_fee,
        sum(network_fee) as network_fee
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
        r.uncapped_payment_eth,
        r.capped_payment_eth,
        r.is_winner,
        r.winning_score,
        r.reference_score,
        r.is_settled_in_time,
        r.reward_target,
        r.solver_name, 
        sra.observed_fee,
        sra.protocol_fee,
        sra.network_fee,
        spt.slippage_wei,
        spt.slippage_usd,
        sf.service_fee as service_fee_enabled
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
    left join 
        service_fees sf 
    on 
        r.solver_name = sf.solver_name
)

select * from data_per_solution