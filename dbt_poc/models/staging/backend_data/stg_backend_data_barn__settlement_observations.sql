with 

source as (
    select 
        *
    from
        {{ source('backend_data_aurelie', 'backend_data_barn__settlement_observations')}}
)

select * from source