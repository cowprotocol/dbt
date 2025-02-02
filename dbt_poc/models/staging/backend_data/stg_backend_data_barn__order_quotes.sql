with 

source as (
    select 
        *
    from
        {{ source('backend_data_aurelie', 'backend_data_barn__order_quotes')}}
)

select * from source