{{ config(
    materialized='table'
)}}

with 

accounting_period as (
    select * from {{ref('int_accounting_period_data__conversion_rates')}}

),

service_fee as (
    select * from {{ref('stg_dune_data__dune_data__service_fee_tracker')}}
),

data_per_solution as (
    select * from {{ref('fct_data_per_solution')}}
),

data_per_trade as (
    select * from {{ref('fct_data_per_trade')}}  
),

sum_individual_rewards_and_fees as (
    select 
        dps.solver,
        dps.solver_name,
        dps.reward_target,
        ap.accounting_period,
        sf.service_fee as service_fee_enabled,
        ap.accounting_period_start_time,
        ap.accounting_period_end_time,
        ap.conversion_rate_cow_to_native, 
        (count(dpt.is_eligeable_for_quote_reward) * least(0.0006* (1/ap.conversion_rate_cow_to_native), 6)) * 10e18 as sum_quote_reward_cow, --is the minimum of 6 cow tokens or the or 0.0006 eth in cow
        sum(dps.batch_reward_native) as sum_batch_reward_native,
        sum(dps.slippage_native) as sum_slippage_native,
        sum(dpt.network_fee_native) as sum_network_fee_native,
        sum(dps.execution_cost) as sum_execution_cost_native
    from accounting_period ap
    right join data_per_solution dps
    on dps.block_number = ap.block_number
    right join data_per_trade dpt
    on dpt.block_number = ap.block_number
    left join service_fee sf 
    on dps.solver_name = sf.solver_name
    and dps.solver = sf.solver_address
    and sf.start_time >= ap.accounting_period_start_time and sf.start_time <= ap.accounting_period_end_time
    group by 
        dps.solver,
        dps.solver_name,
        dps.reward_target,
        ap.accounting_period,
        sf.service_fee,
        ap.accounting_period_start_time,
        ap.accounting_period_end_time,
        ap.conversion_rate_cow_to_native
),

sum_cow_rewards_and_fees as (
    select 
        *,
        coalesce(sum_batch_reward_native, 0) / conversion_rate_cow_to_native + coalesce(sum_quote_reward_cow, 0) as total_cow_reward,
        (coalesce(sum_slippage_native, 0) + coalesce(sum_network_fee_native, 0))  as total_native_reward
    from sum_individual_rewards_and_fees
),

service_fee_amount_cow as (
    select 
        *,
        case 
            when service_fee_enabled = true then 
                case 
                    when total_cow_reward >= 0 then total_cow_reward * 0.15
                    else 0
                end
            else 0
        end as service_fee_amount_cow
    from sum_cow_rewards_and_fees
),

cow_with_service_fee as (
    select *,
    total_cow_reward - service_fee_amount_cow as total_cow_reward_including_fee,
    (total_cow_reward - service_fee_amount_cow) * conversion_rate_cow_to_native + total_native_reward as total_native_balance
    from service_fee_amount_cow
),

sum_cow_rewards_and_fees_with_service_fee_and_overdraft as (
    select 
        *,
        (total_native_balance < 0) as overdraft,
        case  
            when total_native_balance < 0 then total_native_balance
       	    else 0
      	end as overdraft_amount
    from cow_with_service_fee
)

select 
    solver,
    solver_name,
    reward_target,
    accounting_period,        
    accounting_period_start_time,
    accounting_period_end_time,
    total_native_reward,
    total_cow_reward_including_fee,
    conversion_rate_cow_to_native,
    sum_quote_reward_cow,
    sum_batch_reward_native,
    sum_slippage_native,
    sum_network_fee_native,
    sum_execution_cost_native,
    service_fee_enabled,
    total_cow_reward,
    service_fee_amount_cow,
    overdraft,
    overdraft_amount
from sum_cow_rewards_and_fees_with_service_fee_and_overdraft