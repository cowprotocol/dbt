with 

source as (
    select 
        *
    from
        {{ source('backend_data_aurelie', 'backend_data__fee_policies')}}
)

select * from source