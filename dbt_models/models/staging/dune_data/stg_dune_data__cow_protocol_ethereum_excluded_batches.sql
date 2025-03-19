with 

source as (
    select 
        tx_hash
    from
        {{ source('dune_data', 'dune_data__cow_protocol_ethereum_excluded_batches')}}
)

select * from source
