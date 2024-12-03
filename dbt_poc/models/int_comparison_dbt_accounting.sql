{{ config(
    materialized='table'
)}}

with 

dbt_rewards as (
    select * from {{ref('fct_sender_rewards')}}
),

accountins_rewards as (
    select * from {{ref('stg_src_dune_solver_payments')}}
),

sender_rewards_all as (
    select 
        dr.tx_hash
    from 
        dbt_rewards dr
    left join 
        accountins_rewards ar
    on
        dr.tx_hash = ar.tx_hash
    where
        dr.uncapped_reward != ar.uncapped_payment_eth
)

select * from sender_rewards_all