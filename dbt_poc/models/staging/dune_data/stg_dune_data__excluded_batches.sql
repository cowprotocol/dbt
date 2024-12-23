with 

source as (
    select 
        concat('0x', encode(tx_hash::bytea, 'hex')) as tx_hash
    from
        {{ source('dune_data', 'excluded_batches')}}
)

select * from source