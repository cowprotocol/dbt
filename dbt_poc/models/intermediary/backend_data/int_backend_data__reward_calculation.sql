{{ config(
    materialized='table'
)}}

with two_highest as (
    select * from {{ref('int_backend_data__two_highest_scores')}}
),

settlements as (
    select * from {{ref('int_backend_data__settlements_in_time')}}
),

reward_calculations_uncapped as (

    select
        th.rank,
        th.uid,
        th.is_winner,
        th.score,
        th.max_score,
        th.second_highest_score,
        s.*,
        case
            when s.is_settled_in_time = true and th.is_winner = true then th.max_score - th.second_highest_score
            else -th.second_highest_score
        end as uncapped_reward
    from
        two_highest th
    right join
        settlements s
    on
        th.auction_id = s.auction_id

),

reward_calculations_capped as (
    select 
        auction_id,
        rank,
        uid,
        is_winner,
        score,
        max_score,
        second_highest_score,
        tx_hash,
        solver,
        block_number,
        block_deadline,
        is_settled_in_time,
        is_settled,
        uncapped_reward,
        case
            when uncapped_reward > 12 * 10^15 then 12 * 10^15
            when uncapped_reward < -10 * 10^15 then -10 * 10^15
            else uncapped_reward
        end as capped_reward
    from 
        reward_calculations_uncapped
)

select * from reward_calculations_capped