{{ config(
    materialized='table'
)}}

with trade_data_unprocessed as (
    select 
        *
    from {{ref('int_backend_data__trade_data_unprocessed')}}
),

trade_data_processed as (
    select 
        auction_id,
        solver,
        tx_hash,
        order_uid,
        block_number,
        sell_amount,
        buy_amount,
        sell_token,
        observed_fee,  
        surplus_token,
        second_protocol_fee_amount,
        first_protocol_fee_amount + second_protocol_fee_amount as protocol_fee_amount,
        partner_fee_recipient,
        case
            when partner_fee_recipient is not null then second_protocol_fee_amount
            else 0
        end as partner_fee_amount,
        surplus_token as protocol_fee_token
    from trade_data_unprocessed
)

select * from trade_data_processed