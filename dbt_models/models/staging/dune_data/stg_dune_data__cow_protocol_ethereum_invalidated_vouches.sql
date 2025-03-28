{{
    config(
        materialized='incremental',
        unique_key=['tx_hash', 'index']
    )
}}

with 

source as (
    select 
        nullif(replace(replace(updated_at::text, '"', ''), '\', ''), 'null')::timestamp as updated_at,
        contract_address,
        evt_tx_hash as tx_hash,
        evt_index as index,
        evt_block_time as block_time,
        evt_block_number as block_number,
        "bondingPool" as bonding_pool,
        sender,
        solver
    from
        {{ source('dune_data', 'dune_data__cow_protocol_ethereum_invalidated_vouches')}}
)

select * from source

{% if is_incremental() %}
    where source.updated_at > (select max(updated_at) from {{ this }})
{% endif %}
