with 

source as (
    select 
        *
    from
        {{ source('backend_data_aurelie', 'backend_data_prod__settlement_observations')}}
)

select * from source