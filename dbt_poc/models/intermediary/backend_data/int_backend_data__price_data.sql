{{ config(
    materialized='table'
)}}

with trade_data_processed as (
    select 
        *
    from {{ref('int_backend_data__trade_data_processed')}}
),

auction_prices as (
    select 
        *
    from {{ref('stg_backend_data__auction_prices')}}
),

price_data as (
    select
        tdp.auction_id,
        tdp.order_uid,
        ap_surplus.price / 1e18 as surplus_token_native_price,
        ap_protocol.price / 1e18 as protocol_fee_token_native_price,
        ap_sell.price / 1e18 as network_fee_token_native_price
    from trade_data_processed as tdp 
    left outer join auction_prices as ap_sell -- contains price: sell token
        on tdp.auction_id = ap_sell.auction_id 
        and tdp.sell_token = ap_sell.token
    left outer join auction_prices as ap_surplus -- contains price: surplus token
        on tdp.auction_id = ap_surplus.auction_id 
        and tdp.surplus_token = ap_surplus.token
    left outer join auction_prices as ap_protocol -- contains price: protocol fee token
        on tdp.auction_id = ap_protocol.auction_id 
        and tdp.surplus_token = ap_protocol.token
)

select * from price_data