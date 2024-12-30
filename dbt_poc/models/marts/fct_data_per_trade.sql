{{ config(
    materialized='table'
)}}

with 

quote_rewards as (
    select * from {{ref('int_backend_data__orders_with_winning_quotes')}}
),

trade_data as (
    select * from {{ref('int_backend_data__trade_data_processed_with_native_prices')}}
),

data_per_trade as (
    select 
        td.order_uid,
        td.tx_hash,
        td.auction_id ,
        --block_number TODO find where to get this,
        td.solver as solver,
        'TODO' as quote_reward,
        qr.sell_amount as quote_sell_amount,
        qr.buy_amount as quote_buy_amount,
        qr.gas_amount * qr.gas_price as quote_gas_cost,
        qr.sell_token_price as quote_sell_token_price,
        qr.solver as quote_solver,
        td.protocol_fee_token as partner_fee_token, 
        td.partner_fee as partner_fee_amount,
        td.protocol_fee_token_native_price as partner_fee_price, 
        td.partner_fee_native,
        td.protocol_fee_token,
        td.protocol_fee as protocol_fee_amount,
        td.protocol_fee_token_native_price as protocol_fee_price,
        td.protocol_fee_native,
        -- protocol_fee_type TODO what is this? 
        td.network_fee as network_fee_amount,
        td.network_fee_token_native_price as network_fee_price,
        td.network_fee_native
    from 
        trade_data as td 
    left join 
        quote_rewards as qr
    on 
        td.order_uid = qr.order_uid 
)

select 
    *
from data_per_trade