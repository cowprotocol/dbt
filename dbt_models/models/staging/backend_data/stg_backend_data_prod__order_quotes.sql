with 

source as (
    select 
        decode(substr(order_uid,3), 'hex') as order_uid,
        gas_amount, 
        gas_price, 
        sell_token_price,
        sell_amount, 
        buy_amount, 
        decode(substr(solver,3), 'hex') as solver,
        verified
    from
        {{ source('backend_data_aurelie', 'backend_data_prod__order_quotes')}}
)

select * from source
