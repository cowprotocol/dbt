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
        case  
            when s.block_number < (ca.block_deadline + 100) then TRUE
            else FALSE
        end as is_settled_in_time 
    from 
        settlements s
    join 
        competition_auctions ca
    on 
        s.auction_id = ca.auction_id
)

select * from final