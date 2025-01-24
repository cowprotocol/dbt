with 

source as (
    select 
        pool_name, 
        service_fee, 
        concat('0x', encode(solver::bytea, 'hex')) as solver_address,
        solver_name, 
        start_time,
        end_time
    from
        {{ source('dune_data', 'dune_data__service_fee_tracker')}}
)

select * from source