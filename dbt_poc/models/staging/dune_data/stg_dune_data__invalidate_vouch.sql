with 

source as (
    select 
        contract_address,
        evt_tx_hash as tx_hash,
        evt_index as index,
        evt_block_time as block_time,
        evt_block_number as block_number,
        "bondingPool" as bonding_pool,
        sender,
        solver
    from
        {{ source('dune_data', 'VouchRegister_evt_InvalidateVouch')}}
)

select * from source