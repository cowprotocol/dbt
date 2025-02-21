with 

source as (
    select 
        auction_id, 
        decode(substr(winner,3), 'hex') as winner,
        winning_score, 
        reference_score, 
        block_deadline, 
        simulation_block
    from
        {{ source('backend_data_aurelie', 'backend_data_barn__settlement_scores')}}
)

select * from source
