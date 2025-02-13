{{ config(
    materialized='table'
)}}

with ranked_scores as (
    select
        auction_id,
        uid,
        is_winner,
        score,
        row_number() over (partition by auction_id order by score desc) as rank,
        max(score) over (partition by auction_id) as max_score,
        environment
    from
         {{ref('stg_backend_data__proposed_solutions')}}
),

scores_with_second_highest as (
    select
        auction_id,
        rank,
        uid,
        is_winner,
        score,
        max_score,
        -- get the second-highest score (rank = 2)
        coalesce(
            max(case when rank = 2 then score end) over (partition by auction_id), 0
        ) as second_highest_score,
        environment
    from
        ranked_scores
)

select * from scores_with_second_highest