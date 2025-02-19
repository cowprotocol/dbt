{{
    config(
        materialized='incremental',
        unique_key=['tx_hash', 'index']
    )
}}

with 

source as (
    select 
        updated_at,
        contract_address,
        convert_to(evt_tx_hash, 'utf8')::bytea as tx_hash,
        evt_index as index,
        evt_block_time as block_time,
        evt_block_number as block_number,
        convert_to("bondingPool", 'utf8')::bytea as bonding_pool,
        convert_to(sender, 'utf8')::bytea as sender,
        convert_to(solver, 'utf8')::bytea as solver
    from
        {{ source('dune_data', 'VouchRegister_evt_InvalidateVouch')}}
)

select * from source

{% if is_incremental() %}
    where source.updated_at > (select max(updated_at) from {{ this }})
{% endif %}