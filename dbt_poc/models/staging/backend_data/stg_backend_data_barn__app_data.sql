with 

source as (
    select 
        contract_app_data ,
        cast("jsonb" as jsonb) -> 'metadata' -> 'partnerFee' ->> 'recipient' AS partner_fee_recipient
    from
        {{ source('backend_data_aurelie', 'backend_data_barn__app_data')}}
)

select * from source