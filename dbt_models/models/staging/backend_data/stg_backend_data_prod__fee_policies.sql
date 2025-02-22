with 

source as (
    select 
        auction_id, 
        decode(substr(order_uid,3), 'hex') as order_uid,
        application_order, 
        kind, 
        surplus_factor, 
        surplus_max_volume_factor, 
        volume_factor, 
        price_improvement_factor, 
        price_improvement_max_volume_factor
    from
        {{ source('backend_data_aurelie', 'backend_data_prod__fee_policies')}}
)

select * from source
