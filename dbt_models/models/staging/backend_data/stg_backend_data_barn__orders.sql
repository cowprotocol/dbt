with 

source as (
    select 
        convert_to(uid, 'utf8')::bytea as uid, 
        creation_timestamp, 
        convert_to(sell_token, 'utf8')::bytea as sell_token, 
        convert_to(buy_token, 'utf8')::bytea as buy_token, 
        sell_amount, 
        buy_amount, 
        valid_to, 
        fee_amount, 
        kind, 
        partially_fillable, 
        signature, 
        cancellation_timestamp, 
        app_data, 
        signing_scheme, 
        sell_token_balance, 
        buy_token_balance, 
        "class"
    from
        {{ source('backend_data_aurelie', 'backend_data_barn__orders')}}
)

select * from source