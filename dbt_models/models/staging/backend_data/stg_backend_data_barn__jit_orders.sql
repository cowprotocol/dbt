with 

source as (
    select 
        block_number, 
        log_index, 
        decode(substr(uid,3), 'hex') as uid,
        "owner", 
        creation_timestamp, 
        decode(substr(sell_token,3), 'hex') as sell_token,
        decode(substr(buy_token,3), 'hex') as buy_token,
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
        {{ source('backend_data_aurelie', 'backend_data_barn__jit_orders')}}
)

select * from source
