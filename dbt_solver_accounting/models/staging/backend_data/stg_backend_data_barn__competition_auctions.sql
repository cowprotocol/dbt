with 

source as (

    select 
        id as auction_id,
        block as block_number,
        deadline as block_deadline,
        order_uids,
        price_tokens,
        price_values,
        surplus_capturing_jit_order_owners
    from
        {{ source('backend_data_aurelie', 'backend_data_barn__competition_auctions')}}
        
)

select * from source