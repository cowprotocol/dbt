with 

source as (
    select 
        auction_id,
        uid,
        id,
        concat('0x', encode(solver::bytea, 'hex')) as solver,
        is_winner,
        score,
        price_tokens,
        price_values
    from
        {{ source('backend_data', 'proposed_solutions')}}
)

select * from source