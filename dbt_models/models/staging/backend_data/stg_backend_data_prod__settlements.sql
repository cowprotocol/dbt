with 

source as (
    select 
        block_number,
        log_index,
        decode(substr(solver,3), 'hex') as solver,
        decode(substr(tx_hash,3), 'hex') as tx_hash,
        tx_from,
        tx_nonce,
        auction_id
    from
        {{ source('backend_data_aurelie', 'backend_data_prod__settlements')}}
)

select * from source
