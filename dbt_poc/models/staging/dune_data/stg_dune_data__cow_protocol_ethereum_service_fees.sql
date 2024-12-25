with 

source as (
    select 
        pool_name, 
        service_fee, 
        concat('0x', encode(solver::bytea, 'hex')) as solver_address,
        solver_name
    from
        {{ source('dune_data', 'cow_protocol_ethereum_service_fees')}}
)

select * from source