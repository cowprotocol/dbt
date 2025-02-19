with 

source as (
    select 
        block_number, 
        log_index, 
        gas_used, 
        effective_gas_price, 
        surplus, 
        fee
    from
        {{ source('backend_data_aurelie', 'backend_data_prod__settlement_observations')}}
)

select * from source