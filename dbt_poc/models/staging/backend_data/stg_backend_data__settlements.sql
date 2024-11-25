with 

source as (
    select * 
    from
        {{ source('backend_data', 'settlements')}}
)

select * from source