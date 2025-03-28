with 

source as (
    select 
        decode(substr(order_uid,3), 'hex') as order_uid,
        auction_id,
        reward,
        executed_fee,
        block_number,
        coalesce((string_to_array(trim(both '{}' from protocol_fee_amounts), ','))[1]::numeric, 0) as first_protocol_fee_amount,
        coalesce((string_to_array(trim(both '{}' from protocol_fee_amounts), ','))[2]::numeric, 0) as second_protocol_fee_amount,
        executed_fee_token
        -- todo why do we not use the protocol_fee_tokens columns from this table to identify the tokens? 
    from
        {{ source('backend_data_aurelie', 'backend_data_barn__order_execution')}}
),

ranked_rows as (
    select 
        *,
        row_number() over (partition by order_uid, auction_id ) as row_num
    from source
)

select *
from ranked_rows
where row_num = 1
