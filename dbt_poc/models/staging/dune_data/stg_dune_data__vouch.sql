with 

source as (
    select 
        contract_address, -- my preferred types: bytea
        evt_tx_hash as tx_hash, -- bytea
        evt_index as index, -- bitint
        evt_block_time as block_time, -- not sure, maybe timestamp
        evt_block_number as block_number, -- bigint (as is)
        "bondingPool" as bonding_pool, -- bytea
        "cowRewardTarget" as reward_target, -- byeta
        sender, -- bytea
        solver -- bytea
    from
        {{ source('dune_data', 'VouchRegister_evt_Vouch')}}
)

select * from source