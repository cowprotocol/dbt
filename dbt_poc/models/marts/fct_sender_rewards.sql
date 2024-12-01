{{ config(
    materialized='table'
)}}

with 

rewards as (
    select * from {{ref('int_backend_data__reward_calculation')}}
),

named_solvers as (
    select * from {{ref('int_dune_data__vouched_named_solvers')}}
),

sender_rewards_all as (
    select 
        r.*,
        ns.reward_target,
        ns.solver_name
    from 
        rewards r
    right join 
        named_solvers ns
    on 
        r.solver = ns.solver
    where r.is_settled = true

),

unique_solver_rewards as (-- only keep one row per solver and auction_id
    select *
    from (
        select *,
            row_number() over (
                partition by auction_id, solver
                order by is_winner desc
            ) as solver_rank
        from sender_rewards_all
    ) ranked_table
    where solver_rank = 1
)

select 
    auction_id,
    is_winner,
    tx_hash,
    solver,
    is_settled_in_time,
    final_reward,
    reward_target,
    solver_name
from unique_solver_rewards