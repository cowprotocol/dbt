with 

source as (
    select 
        pool_name, 
        service_fee, 
        concat('0x', encode(solver::bytea, 'hex'))::bytea as solver_address,
        solver_name, 
        cast(start_time as timestamp),
        cast(end_time as timestamp)
    from
        {{ source('dune_data', 'dune_data__service_fee_tracker')}}
)

select * from source