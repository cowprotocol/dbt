with 

source as (
    select 
        auction_id,
        uid,
        id,
        convert_to(solver, 'utf8')::bytea as solver,
        is_winner,
        score
        -- price_tokens, this column is not used later and it is causing issues in the dune synch because it's a bytea array of binary data
        -- price_values same as above
    from
        {{ source('backend_data_aurelie', 'backend_data_barn__proposed_solutions')}}
)

select * from source