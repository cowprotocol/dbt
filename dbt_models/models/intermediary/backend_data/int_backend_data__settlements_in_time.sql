{{ config(
    materialized='table'
)}}

with settlements as (
    select 
        auction_id,
        tx_hash,
        solver,
        block_number,
        execution_cost
    from {{ref('int_backend_data__settlements_execution_costs')}}
),

competition_auctions as (
    select 
        auction_id,
        block_deadline,
        environment
    from {{ref('stg_backend_data__competition_auctions2')}}
),

final as (
    select 
        s.*,
        ca.block_deadline,
        (s.tx_hash is not null) as is_settled,
        case  
            when s.block_number <= (ca.block_deadline + 1) and s.tx_hash is not null then TRUE -- this includes a grace period of one block for settling a batch
            else FALSE
        end as is_settled_in_time,
        ca.environment
    from 
        settlements s
    right join 
        competition_auctions ca
    on 
        s.auction_id = ca.auction_id
)

select * from final