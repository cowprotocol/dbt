{{ config(
    materialized='table'
)}}

with jo as (
    select 
        *
    from {{ref('stg_backend_data__jit_orders')}}
),

o as (
    select 
        *
    from {{ref('stg_backend_data__orders')}}
),

order_data as (
    select
        uid,
        sell_token,
        buy_token,
        sell_amount,
        buy_amount,
        kind,
        app_data
    from o
    union all
    select
        uid,
        sell_token,
        buy_token,
        sell_amount,
        buy_amount,
        kind,
        app_data
    from jo

)

select * from order_data