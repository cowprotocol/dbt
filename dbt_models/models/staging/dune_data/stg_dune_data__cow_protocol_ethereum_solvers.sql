{{
    config(
        materialized='incremental',
        unique_key=['address', 'environment', 'name']
    )
}}


with 

source as (
    select 
        nullif(replace(replace(updated_at::text, '"', ''), '\', ''), 'null')::timestamp as updated_at,
        address,
        environment, 
        "name", 
        active
    from
        {{ source('dune_data', 'dune_data__cow_protocol_ethereum_solvers')}}
)

select * from source

{% if is_incremental() %}
    where source.updated_at > (select max(updated_at) from {{ this }})
{% endif %}
