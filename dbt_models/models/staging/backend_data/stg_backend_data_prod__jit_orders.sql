with 

source as (
    select 
        block_number, 
        log_index, 
        convert_to(uid, 'utf8')::bytea as uid, 
        "owner", 
        creation_timestamp, 
        convert_to(sell_token, 'utf8')::bytea as sell_token, 
        convert_to(buy_token, 'utf8')::bytea as buy_token, 
        sell_amount, 
        buy_amount, 
        valid_to, 
        app_data, 
        fee_amount, 
        kind, 
        partially_fillable, 
        signature, 
        receiver, 
        signing_scheme, 
        sell_token_balance, 
        buy_token_balance
    from
        {{ source('backend_data_aurelie', 'backend_data_prod__jit_orders')}}
)

select * from source