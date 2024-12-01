{{ config(
    materialized='table'
)}}

with two_highest as (
    select * from {{ref('int_backend_data__two_highest_scores')}}
),

settlements as (
    select * from {{ref('int_backend_data__settlements_in_time')}}
),

reward_calculations as (

    select
        th.auction_id,
        th.rank,
        th.uid,
        th.is_winner,
        th.score,
        th.max_score,
        th.second_highest_score,
        s.tx_hash,
        s.solver,
        s.block_number,
        s.block_deadline,
        s.is_settled_in_time,
        s.is_settled,
        case
            when s.is_settled_in_time = true and th.is_winner = true then th.max_score - th.second_highest_score
            else -th.second_highest_score
        end as final_reward
    from
        two_highest th
    right join
        settlements s
    on
        th.auction_id = s.auction_id

)

select * from reward_calculations