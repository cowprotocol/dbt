with 

source as (
    select 
        block_number,
        log_index,
        concat('0x', encode(solver::bytea, 'hex')) as solver,
        tx_hash,
        tx_from,
        tx_nonce,
        auction_id
    from
        {{ source('backend_data', 'settlements')}}
)

select * from source