with 

source as (
    select *
    from
        {{ source('dune_data', 'cow_protocol_ethereum_solvers')}}
)

select * from source