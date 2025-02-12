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
        concat('0x', encode(token_address::bytea, 'hex')) as token_address,
        concat('0x', encode(tx_hash::bytea, 'hex')) as tx_hash
    from
        {{ source('dune_data', 'dune_data__raw_slippage')}}
)

select * from source