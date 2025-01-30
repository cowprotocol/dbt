{{ config(
    materialized='table'
)}}

with 

partner_and_protocol_fees as (
    select * from {{ref('int_accounting_period_data__partner_and_protocol_fees')}}
)
 
select 
 	accounting_period,
 	accounting_period_start_time,
 	accounting_period_end_time,
 	partner_fee_recipient,
 	partner_fee_native_transfer,
 	protocol_fee_address as protocol_fee_recipient,
 	sum_protocol_fee_native - sum_partner_fee_native as protocol_minus_partner_fee_native_transfer_to_dao,
 	sum_partner_fee_native - partner_fee_native_transfer as tax_on_partner_fee_native_transfer_to_dao
from partner_and_protocol_fees