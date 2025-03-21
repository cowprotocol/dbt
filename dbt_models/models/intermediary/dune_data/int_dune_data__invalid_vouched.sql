with full_bonding_pools as (
    select 
        *
    from {{ref('stg_full_bonding_pools')}}
),

vouches as (
    select *
    from {{ref('stg_dune_data__cow_protocol_ethereum_vouches')}}
),

invalid_vouches as (
    select 
        * 
    from 
        vouches v 
    where not exists (
        select 1 
        from full_bonding_pools fb
        where v.bonding_pool = fb.pool_address
        and v.sender = fb.initial_funder
    )
)

select * from invalid_vouches