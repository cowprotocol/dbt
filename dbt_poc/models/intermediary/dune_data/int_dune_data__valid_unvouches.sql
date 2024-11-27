with bonding_pool as (
    select *
    from {{ref('full_bonding_pools')}}
),

invalidate_vouches as (
    select *
    from {{ref('stg_dune_data__invalidate_vouch')}}
),

valid_unvouches as (
    select 
        * ,
        false as is_vouched
    from 
        invalidate_vouches v
    inner join 
        bonding_pool b
    on 
        b.pool_address = v.bonding_pool
    and 
        b.initial_funder = v.sender

)

select * from valid_unvouches