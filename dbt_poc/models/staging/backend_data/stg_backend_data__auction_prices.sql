with 

source as (
    select 
        *
    from
        {{ source('backend_data_aurelie', 'backend_data__auction_prices')}}
),

ranked_rows as (
    select 
        *,
        row_number() over (partition by auction_id ) as row_num
    from source
)

select *
from ranked_rows
where row_num = 1