with 

source as (
    select 
        order_uid,
        auction_id,
        reward,
        executed_fee,
        block_number,
        coalesce((string_to_array(trim(both '{}' FROM protocol_fee_amounts), ','))[1]::NUMERIC, 0) AS first_protocol_fee_amount,
        coalesce((string_to_array(trim(both '{}' FROM protocol_fee_amounts), ','))[2]::NUMERIC, 0) AS second_protocol_fee_amount,
        executed_fee_token
    from
        {{ source('backend_data_aurelie', 'backend_data__order_execution')}}
)

select * from source