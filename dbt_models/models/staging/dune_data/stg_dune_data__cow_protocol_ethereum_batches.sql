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
        solver_address,
        tx_hash,
        token_approvals, 
        tx_cost_usd,
        unwraps
    from
        {{ source('dune_data', 'dune_data__cow_protocol_ethereum_batches')}}
)

select * from source
