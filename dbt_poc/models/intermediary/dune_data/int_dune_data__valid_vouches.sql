with bonding_pool as (
    select *
    from {{ref('full_bonding_pools')}}
),

vouches as (
    select *
    from {{ref('stg_dune_data_vouch')}}
),

valid_vouches as (
    select * 
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