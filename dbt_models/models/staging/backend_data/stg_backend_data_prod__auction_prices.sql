with 

source as (
    select 
        auction_id, 
        convert_to("token", 'utf8')::bytea as "token", 
        price
    from
        {{ source('backend_data_aurelie', 'backend_data_prod__auction_prices')}}
)

select *
from source