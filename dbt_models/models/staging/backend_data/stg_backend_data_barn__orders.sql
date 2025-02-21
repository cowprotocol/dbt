with 

source as (
    select 
        decode(substr(uid,3), 'hex') as uid,
        creation_timestamp, 
        decode(substr(sell_token,3), 'hex') as sell_token,
        decode(substr(buy_token,3), 'hex') as buy_token,
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
