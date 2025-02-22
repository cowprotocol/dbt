with 

source as (
    select 
        block_number,
        log_index,
        decode(substr(order_uid,3), 'hex') as order_uid,
        sell_amount,
        buy_amount,
        fee_amount
    from
        {{ source('backend_data_aurelie', 'backend_data_barn__trades')}}
)

select * from source
