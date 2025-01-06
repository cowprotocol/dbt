{{ config(
    materialized='table'
)}}

with s as (
    select 
        *
    from {{ref('stg_backend_data__settlements')}}
),

ss as (
    select 
        *
    from {{ref('stg_backend_data__settlement_scores')}}
),

t as (
    select 
        *
    from {{ref('stg_backend_data__trades')}}
),

od as (
    select 
        *
    from {{ref('int_backend_data__order_data')}}
),

oe as (
    select 
        *
    from {{ref('stg_backend_data__order_execution')}}
),

ad as (
    select 
        *
    from {{ref('stg_backend_data__app_data')}}
),

trade_data_unprocessed as (
    select
        ss.winner as solver,
        s.auction_id,
        s.tx_hash,
        t.order_uid,
        t.block_number,
        od.sell_token,
        od.buy_token,
        t.sell_amount, -- the total amount the user sends
        t.buy_amount, -- the total amount the user receives
        oe.executed_fee  as observed_fee, -- the total discrepancy between what the user sends and what they would have send if they traded at clearing price
        od.kind,
        case
            when od.kind = 'sell' then od.buy_token
            when od.kind = 'buy' then od.sell_token
        end as surplus_token,
        ad.partner_fee_recipient,
        oe.first_protocol_fee_amount,
        oe.second_protocol_fee_amount
    from s inner join ss -- contains block_deadline
        on s.auction_id = ss.auction_id
    inner join t -- contains traded amounts
        on s.block_number = t.block_number -- given the join that follows with the order execution table, this works even when multiple txs appear in the same block
    inner join od -- contains tokens and limit amounts
        on t.order_uid = od.uid
    inner join oe -- contains executed fee
        on t.order_uid = oe.order_uid 
        and s.auction_id = oe.auction_id
    left outer join ad -- contains full app data
        on od.app_data = ad.contract_app_data

)

select * from trade_data_unprocessed