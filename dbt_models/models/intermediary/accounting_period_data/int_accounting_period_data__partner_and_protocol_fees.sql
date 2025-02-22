with 

accounting_period as (
    select * from {{ref('int_accounting_period_data__conversion_rates')}}
),

data_per_trade as (
    select * from {{ref('fct_data_per_trade')}}  
),

protocol_fee_config as (
	select * from {{ref('stg_protocol_fees_config')}}
	where network = 'mainnet'
	limit 1
),

sum_partner_and_protocol_fees as (
select
       ap.accounting_period,
        ap.accounting_period_start_time,
        ap.accounting_period_end_time,
        dpt.partner_fee_recipient,
        sum(dpt.protocol_fee_native) as sum_protocol_fee_native,
        sum(dpt.partner_fee_native) as  sum_partner_fee_native
        
from accounting_period ap

right join data_per_trade dpt
on dpt.block_number = ap.block_number

group by
       ap.accounting_period,
        ap.accounting_period_start_time,
        ap.accounting_period_end_time,
        dpt.partner_fee_recipient

),
      
partner_fee_cut_calculation as (
    select 
        sppf.*, 
        pfc.*,
        case when partner_fee_recipient= partner_fee_reduced_cut_address 
            then partner_fee_reduced_cut
            else partner_fee_cut
        end as effective_partner_fee_cut
    from sum_partner_and_protocol_fees sppf
    cross join protocol_fee_config pfc
),
 
final  as (
    select
        *,
        sum_partner_fee_native * effective_partner_fee_cut as partner_fee_native_transfer
    from partner_fee_cut_calculation
)

select * from final

 