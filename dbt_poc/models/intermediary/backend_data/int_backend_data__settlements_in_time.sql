{{ config(
    materialized='table'
)}}

with settlements as (
    select 
        auction_id,
        tx_hash,
        solver,
        block_number
    from {{ref('stg_backend_data__settlements')}}
),

competition_auctions as (
    select 
        auction_id,
        block_deadline
    from {{ref('stg_backend_data__competition_auctions')}}
),

final as (
    select 
        s.*,
        ca.block_deadline,
        (s.tx_hash is not null) as is_settled,
        case  
            when s.block_number <= (ca.block_deadline + 1) and s.tx_hash is not null then TRUE -- this includes a grace period of one block for settling a batch
            else FALSE
        end as is_settled_in_time 
    from 
        settlements s
    right join 
        competition_auctions ca
    on 
        s.auction_id = ca.auction_id
)

select * from final