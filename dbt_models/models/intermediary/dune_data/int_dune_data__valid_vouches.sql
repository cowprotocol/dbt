{{ config(
    materialized='table'
)}}

with bonding_pool as (
    select *
    from {{ref('stg_full_bonding_pools')}}
),

vouches as (
    select *
    from {{ref('stg_dune_data__cow_protocol_ethereum_vouches')}}
),

valid_vouches as (
    select 
        * ,
        true as is_vouched
    from 
        vouches v
    inner join 
        bonding_pool b
    on 
        b.pool_address = v.bonding_pool
    and 
        b.initial_funder = v.sender

)

select * from valid_vouches