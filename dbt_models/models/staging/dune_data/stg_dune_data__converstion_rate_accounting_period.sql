with 

source as (
    select 
        conversion_rate_cow_to_native, 
        nullif(replace(replace(end_time::text, '"', ''), '\', ''), 'null')::timestamp as end_time,
        nullif(replace(replace(start_time::text, '"', ''), '\', ''), 'null')::timestamp as start_time
    from
        {{ source('dune_data', 'dune_data__converstion-rate-accounting-period-november-22')}}
)

select * from source