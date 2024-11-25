with 

source as (
    select * 
    from
        {{ source('backend_data', 'proposed_solutions')}}
)

select * from source