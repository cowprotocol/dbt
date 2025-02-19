with valid_vouches as (
    select 
        updated_at, 
        contract_address, 
        tx_hash, 
        "index", 
        block_time, 
        block_number, 
        bonding_pool, 
        sender, 
        solver, 
        pool_address, 
        pool_name, 
        initial_funder, 
        reward_target, 
        is_vouched
    from {{ref('int_dune_data__valid_vouches')}}
),

valid_unvouches as (
    select 
        updated_at, 
        contract_address, 
        tx_hash, 
        "index", 
        block_time, 
        block_number, 
        bonding_pool, 
        sender, 
        solver, 
        pool_address, 
        pool_name, 
        initial_funder, 
        reward_target, 
        is_vouched
    from {{ref('int_dune_data__valid_unvouches')}}
),

-- table with all the vouches and the unvouches
vouches_and_unvouches as (
    select * from  valid_vouches
    union distinct
    select * from valid_unvouches
),

-- find the latest state for each solver, pool_addres, and inital_funder trio
ranked_vouches as (
    select
        *,
        rank() over (
            partition by solver, pool_address, initial_funder
            order by block_number desc, index desc
        ) as latest_state
    from vouches_and_unvouches
),

-- keep only one row per solver in case multiple pools vouched for them 
distinct_solver as (
    select 
        distinct on (solver)
        *
    from ranked_vouches
    where 
        latest_state = 1
    and 
        is_vouched = true
    order by 
        solver, block_number, index asc
)

select * from distinct_solver
