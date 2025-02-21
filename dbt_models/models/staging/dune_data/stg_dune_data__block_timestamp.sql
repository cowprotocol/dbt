with 

source as (
    select 
        block_number, 
        "time"
    from {{ source('dune_data', 'dune_data__block_timestamp')}}
)

select * from source
