with 

source as (
    select 
        auction_id, 
        convert_to(winner, 'utf8')::bytea as winner,
        winning_score, 
        reference_score, 
        block_deadline, 
        simulation_block
    from
        {{ source('backend_data_aurelie', 'backend_data_barn__settlement_scores')}}
)

select * from source