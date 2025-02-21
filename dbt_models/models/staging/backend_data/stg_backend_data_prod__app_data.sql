with 

source as (
    select 
        contract_app_data,
        decode(substr(cast("jsonb" as jsonb) -> 'metadata' -> 'partnerFee' ->> 'recipient',3), 'hex') as partner_fee_recipient
    from
        {{ source('backend_data_aurelie', 'backend_data_prod__app_data')}}
)

select * from source
