with 

source as (
    select 
        block_number,
        log_index,
        convert_to(solver, 'utf8')::bytea as solver,
        convert_to(tx_hash, 'utf8')::bytea as tx_hash,
        tx_from,
        tx_nonce,
        auction_id
    from
        {{ source('backend_data_aurelie', 'backend_data_prod__settlements')}}
)

select * from source
