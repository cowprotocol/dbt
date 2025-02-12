with 

source as (
    select 
        block_number,
        log_index,
        concat('0x', encode(solver::bytea, 'hex')) as solver,
        concat('0x', encode(tx_hash::bytea, 'hex')) as tx_hash,
        tx_from,
        tx_nonce,
        auction_id
    from
        {{ source('backend_data_aurelie', 'backend_data_prod__settlements')}}
)

select * from source