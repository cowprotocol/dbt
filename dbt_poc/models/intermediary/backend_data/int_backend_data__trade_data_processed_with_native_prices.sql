{{ config(
    materialized='table'
)}}

with trade_data_processed as (
    select 
        *
    from {{ref('int_backend_data__trade_data_processed')}}
),

price_data as (
    select 
        *
    from {{ref('int_backend_data__price_data')}}
),

trade_data_processed_with_prices as (
    select 
        tdp.auction_id,
        tdp.solver,
        tdp.tx_hash,
        tdp.order_uid,
        tdp.block_number,
        tdp.surplus_token,
        tdp.protocol_fee as protocol_fee_amount,
        tdp.protocol_fee_token,
        tdp.partner_fee,
        tdp.partner_fee_recipient,
        case
            when tdp.sell_token != tdp.surplus_token 
            then tdp.observed_fee - (tdp.sell_amount - tdp.observed_fee) / tdp.buy_amount * coalesce(tdp.protocol_fee, 0)
            else tdp.observed_fee - coalesce(tdp.protocol_fee, 0)
        end as network_fee, 
        tdp.sell_token as network_fee_token,
        pd.surplus_token_native_price,
        pd.protocol_fee_token_native_price,
        pd.network_fee_token_native_price
    from trade_data_processed as tdp 
    inner join price_data as pd
        on tdp.auction_id = pd.auction_id 
        and tdp.order_uid = pd.order_uid
),

trade_data_processed_with_native_prices as (
    select 
        *,
        protocol_fee_amount * protocol_fee_token_native_price as protocol_fee_native,
        partner_fee * protocol_fee_token_native_price as partner_fee_native,
        network_fee * network_fee_token_native_price as network_fee_native
    from trade_data_processed_with_prices
)

select * from trade_data_processed_with_native_prices