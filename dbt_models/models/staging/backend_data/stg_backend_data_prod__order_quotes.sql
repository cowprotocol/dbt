with 

source as (
    select 
        convert_to(order_uid, 'utf8')::bytea as order_uid,
        gas_amount, 
        gas_price, 
        sell_token_price,
        sell_amount, 
        buy_amount, 
        convert_to(solver, 'utf8')::bytea as solver,
        verified
    from
        {{ source('backend_data_aurelie', 'backend_data_prod__order_quotes')}}
)

select * from source