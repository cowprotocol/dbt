with 

source as (
    select 
        *
    from
        {{ source('backend_data_aurelie', 'backend_data__jit_orders')}}
)

select * from source