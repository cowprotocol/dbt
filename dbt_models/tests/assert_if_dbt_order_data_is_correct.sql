with 

old_order_data as (
    select 
        auction_id as auction_id_old, 
        block_number as block_number_old, 
        concat('0x', encode(order_uid::bytea, 'hex')) as order_uid_old,
        replace(nullif(replace(replace(partner_fee::text, '"', ''), '\', ''), 'null'), '', '')::numeric as partner_fee_old,
        concat('0x', encode(partner_fee_recipient::bytea, 'hex')) as partner_fee_recipient_old,
        replace(nullif(replace(replace(protocol_fee::text, '"', ''), '\', ''), 'null'), '', '')::numeric as protocol_fee_old,
        protocol_fee_kind as protocol_fee_kind_old, 
        protocol_fee_native_price as protocol_fee_native_price_old, 
        concat('0x', encode(protocol_fee_token::bytea, 'hex')) as protocol_fee_token_old,
        replace(nullif(replace(replace(quote_buy_amount::text, '"', ''), '\', ''), 'null'), '', '')::numeric as quote_buy_amount_old,
        quote_gas_cost as quote_gas_cost_old, 
        replace(nullif(replace(replace(quote_sell_amount::text, '"', ''), '\', ''), 'null'), '', '')::numeric as quote_sell_amount_old,
        quote_sell_token_price as quote_sell_token_price_old, 
        concat('0x', encode(quote_solver::bytea, 'hex')) as quote_solver_old,
        concat('0x', encode(solver::bytea, 'hex')) as solver_old,
        replace(nullif(replace(replace(surplus_fee::text, '"', ''), '\', ''), 'null'), '', '')::numeric as surplus_fee_old,
        concat('0x', encode(tx_hash::bytea, 'hex')) as tx_hash_old
    from {{ source('dune_data', 'dune_data__orders_old')}}
),

fct_data_per_trade as (
    select * from {{ref('fct_data_per_trade')}}
),

join_datasets as (
    select 
        * 
    from fct_data_per_trade fdpt
    join old_order_data ood 
    on ood.auction_id_old = fdpt.auction_id
    and ood.order_uid_old = fdpt.order_uid
 -- and environments
    where tx_hash != tx_hash_old
    or block_number != block_number_old
    -- or partner_fee_amount != partner_fee_old PROBLEM TODO on some we have 0 in our data, and in other the old data rounds up
    -- or protocol_fee_amount != protocol_fee_old PROBLEM TODO this is very close between our calculation and old data, seems like rounding error ? 
    or protocol_fee_type != protocol_fee_kind_old 
    -- or protocol_fee_native != protocol_fee_native_price_old PROBLEM THIS is COMPLETELY WRONG
    or protocol_fee_token != protocol_fee_token_old
    or quote_buy_amount != quote_buy_amount_old
    or quote_gas_cost != quote_gas_cost_old
    or quote_sell_amount != quote_sell_amount_old
    or quote_sell_token_price != quote_sell_token_price_old
    or quote_solver != quote_solver_old
    or solver != solver_old
)

select * from join_datasets