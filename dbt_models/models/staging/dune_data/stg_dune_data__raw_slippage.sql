with 

source as (
    select 
        block_time, 
        price_atom, 
        price_unit, 
        replace(NULLIF(replace(replace(slippage_atoms::text, '"', ''), '\', ''), 'null'), '', '')::NUMERIC AS slippage_atoms,
        slippage_type, 
        slippage_usd,
        replace(NULLIF(replace(replace(slippage_wei::text, '"', ''), '\', ''), 'null'), '', '')::NUMERIC AS slippage_native,
        token_address,
        tx_hash
    from
        {{ source('dune_data', 'dune_data__raw_slippage')}}
)

select * from source
