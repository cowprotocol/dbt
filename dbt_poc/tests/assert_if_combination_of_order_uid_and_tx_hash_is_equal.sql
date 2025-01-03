with unprocessed as (
    select 
        order_uid,
        tx_hash
    from {{ ref('int_backend_data__trade_data_unprocessed') }}
),
with_tx_hash as (
    select 
        order_uid,
        tx_hash
    from {{ ref('int_backend_data__trade_with_tx_hash') }}
),
matching_order_uids as (
    -- find order_uids that exist in both tables
    select distinct
        unprocessed.order_uid
    from unprocessed
    inner join with_tx_hash
    on unprocessed.order_uid = with_tx_hash.order_uid
)
-- check if the tx_hash matches for the same order_uid
select 
    m.order_uid,
    unprocessed.tx_hash as unprocessed_tx_hash,
    with_tx_hash.tx_hash as with_tx_hash_tx_hash
from matching_order_uids m
left join unprocessed
on m.order_uid = unprocessed.order_uid
left join with_tx_hash
on m.order_uid = with_tx_hash.order_uid
where unprocessed.tx_hash != with_tx_hash.tx_hash
   or unprocessed.tx_hash is null
   or with_tx_hash.tx_hash is null
