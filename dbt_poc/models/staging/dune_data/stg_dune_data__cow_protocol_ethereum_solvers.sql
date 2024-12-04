with 

source as (
    select * -- my preferred types: address::bytea, environment::string, name::string, active::bool
    from
        {{ source('dune_data', 'cow_protocol_ethereum_solvers')}}
)

select * from source