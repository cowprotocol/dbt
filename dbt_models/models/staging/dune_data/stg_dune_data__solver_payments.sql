with 

source as (
    select 
        replace(replace(block_deadline::text, '"', ''), '\', '')::integer as block_deadline, 
        replace(replace(block_number::text, '"', ''), '\', '')::integer as block_number, 
        replace(replace(capped_payment::text, '"', ''), '\', '')::bigint as capped_payment, 
        replace(replace(reference_score::text, '"', ''), '\', '')::bigint as reference_score, 
        convert_to( replace(replace(solver::text, '"', ''), '\', ''), 'utf8')::bytea as solver,
        convert_to(tx_hash, 'utf8')::bytea as tx_hash,
        replace(replace(uncapped_payment_eth::text, '"', ''), '\', '')::bigint as uncapped_payment_eth, 
        replace(replace(winning_score::text, '"', ''), '\', '')::bigint as winning_score

    from
        {{ source('dune_data', 'src_dune_solver_payments')}}
)

select * from source