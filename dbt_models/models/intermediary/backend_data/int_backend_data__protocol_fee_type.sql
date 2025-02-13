with fee_policies as (
    select 
        *
    from {{ref('stg_backend_data__fee_policies')}}
),

ranked_data as (
    select
        *,
        row_number() over (partition by auction_id, order_uid order by application_order asc) as smallest_rank 
    from fee_policies 
)

select 
    auction_id,
    order_uid,
    application_order,
    kind as protocol_fee_type,
    surplus_factor,
    surplus_max_volume_factor,
    volume_factor,
    price_improvement_factor,
    price_improvement_max_volume_factor,
    environment
from ranked_data
where smallest_rank = 1