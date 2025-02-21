with 

source as (
    select 
        auction_id, 
        decode(substr("token",3), 'hex') as "token",
        price
    from
        {{ source('backend_data_aurelie', 'backend_data_barn__auction_prices')}}
)

select *
from source
