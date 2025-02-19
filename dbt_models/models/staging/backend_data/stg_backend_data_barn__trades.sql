with 

source as (
    select 
        block_number,
        log_index,
        convert_to(order_uid, 'utf8')::bytea as order_uid ,
        sell_amount,
        buy_amount,
        fee_amount
    from
        {{ source('backend_data_aurelie', 'backend_data_barn__trades')}}
)

select * from source