{{ config(
    materialized='table'
)}}

with oq as (
    select 
        *
    from {{ref('stg_backend_data__order_quotes')}}
),

o as (
    select 
        *
    from {{ref('stg_backend_data__orders')}}
),

winning_quotes as (
    select 
        oq.order_uid,
        oq.gas_amount,
        oq.gas_price,
        oq.sell_token_price,
        oq.sell_amount,
        oq.buy_amount,
        oq.solver,
        oq.verified
    from o
    inner join oq on o.uid = oq.order_uid
    where
        (
            o.class = 'market'
            or (
                o.kind = 'sell'
                and (
                    oq.sell_amount - oq.gas_amount * oq.gas_price / oq.sell_token_price
                ) * oq.buy_amount >= o.buy_amount * oq.sell_amount
            )
            or (
                o.kind = 'buy'
                and o.sell_amount >= oq.sell_amount + oq.gas_amount * oq.gas_price / oq.sell_token_price
            )
        )
        and o.partially_fillable = 'f' -- the code above might fail for partially fillable orders
        and oq.solver != '\x0000000000000000000000000000000000000000'

)

select * from winning_quotes