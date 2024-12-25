with 

source as (
    select 
        batch_value, 
        block_date, 
        block_number, 
        block_time, 
        call_data_size, 
        dex_swaps, 
        fee_value, 
        gas_price, 
        gas_used, 
        num_trades, 
        concat('0x', encode(solver_address::bytea, 'hex')) as solver_address,
        token_approvals, 
        tx_cost_usd,
        concat('0x', encode(tx_hash::bytea, 'hex')) as tx_hash,
        unwraps
    from
        {{ source('dune_data', 'cow_protocol_ethereum_batches')}}
)

select * from source