with excluded_batches as (
    select *
    from {{ref('stg_dune_data__excluded_batches')}}
),

raw_slippage as (
    select *
    from {{ref('stg_dune_data__raw_slippage')}}
),

cow_protocol_ethereum_batches as (
    select *
    from {{ref('stg_dune_data__cow_protocol_ethereum_batches')}}
), 

slippage_per_transaction as (
    select
        rs.block_time,
        rs.tx_hash,
        solver_address,
        sum(slippage_usd) as slippage_usd,
        sum(slippage_native) as slippage_native
    from raw_slippage as rs
    inner join cow_protocol_ethereum_batches as b
        on rs.tx_hash = b.tx_hash
    where rs.tx_hash not in (select tx_hash from excluded_batches)
    group by 1, 2, 3
    having bool_and(slippage_native is not null or slippage_atoms = 0)

)

select * from slippage_per_transaction