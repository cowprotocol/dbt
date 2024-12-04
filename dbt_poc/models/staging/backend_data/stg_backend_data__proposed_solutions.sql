with 

source as (
    select 
        auction_id,
        uid,
        id,
        concat('0x', encode(solver::bytea, 'hex')) as solver, -- I would prefer this to be a bytea. This makes it less likely to encode addresses inconsistently (e.g. by including upper cases) and joins failing silently.
        is_winner,
        score,
        price_tokens,
        price_values
    from
        {{ source('backend_data', 'proposed_solutions')}}
)

select * from source