with 

source as (
    select * from {{ source('dune_data', 'dune_data__block_timestamp')}}
)

select * from source