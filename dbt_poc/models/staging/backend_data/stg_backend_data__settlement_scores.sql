with 

source as (
    select 
        *
    from
        {{ source('backend_data_aurelie', 'backend_data__settlement_scores')}}
)

select * from source