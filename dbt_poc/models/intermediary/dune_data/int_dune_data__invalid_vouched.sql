with full_bonding_pools as (
    select 
        *
    from {{ref('full_bonding_pools')}}
),

vouches as (
    select *
    from {{ref('stg_dune_data__vouch')}}
),

invalid_vouches as (
    select 
        * 
    from 
        vouches 
    where
        bonding_pool not in (select distinct pool_address from full_bonding_pools)
    or
        sender not in (select distinct initial_funder from full_bonding_pools)
)

select * from invalid_vouches