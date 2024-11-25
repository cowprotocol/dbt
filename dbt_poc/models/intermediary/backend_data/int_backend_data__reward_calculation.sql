{{ config(
    materialized='table'
)}}

with reward_calculations as (

    select
        i.auction_id,
        i.rank,
        i.uid,
        i.is_winner,
        i.score,
        i.max_score,
        i.second_highest_score,
        s.tx_hash,
        s.solver,
        s.block_number,
        s.block_deadline,
        s.is_settled_in_time,
        case
            when s.is_settled_in_time = true then i.max_score - i.second_highest_score
            else -i.second_highest_score
        end as final_reward
    from
        {{ref('int_backend_data__score_calculations')}} i
    join
        {{ref('int_backend_data__settlements_in_time')}} s
    on
        i.auction_id = s.auction_id

)

select * from reward_calculations