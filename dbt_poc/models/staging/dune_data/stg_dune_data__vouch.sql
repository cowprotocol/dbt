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
        evt_tx_hash as tx_hash,
        evt_index as index,
        evt_block_time as block_time,
        evt_block_number as block_number,
        "bondingPool" as bonding_pool,
        "cowRewardTarget" as reward_target,
        sender,
        solver
    from
        {{ source('dune_data', 'VouchRegister_evt_Vouch')}} 
)

select * from source

{% if is_incremental() %}
    where source.updated_at > (select max(updated_at) from {{ this }})
{% endif %}