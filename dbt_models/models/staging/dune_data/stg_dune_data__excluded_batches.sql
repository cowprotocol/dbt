with 

source as (
    select 
        tx_hash
    from
        {{ source('dune_data', 'excluded_batches')}}
)

select * from source
