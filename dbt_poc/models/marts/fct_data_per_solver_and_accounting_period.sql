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
        sum(dps.batch_reward_wei) as sum_batch_reward_wei,
        sum(dps.slippage_wei) as sum_slippage_wei,
        sum(dpt.network_fee_native) as sum_network_fee_native,
        sum(dps.execution_cost) as sum_execution_cost_wei
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
        solver,
        solver_name,
        reward_target,
        accounting_period,
        conversion_rate_cow_to_native,
        sum_quote_reward_cow,
        sum_batch_reward_wei,
        sum_slippage_wei,
        sum_network_fee_native,
        sum_execution_cost_wei,
        service_fee_enabled,
        coalesce(sum_batch_reward_wei, 0) / conversion_rate_cow_to_native + coalesce(sum_quote_reward_cow, 0) as total_cow_transfer,
        (coalesce(sum_slippage_wei, 0) + coalesce(sum_network_fee_native, 0))  as total_wei_transfer
    from sum_individual_rewards_and_fees
),

sum_cow_rewards_and_fees_with_service_fee as (
    select 
        *,
        case 
            when service_fee_enabled = true then 
                case 
                    when total_cow_transfer >= 0 then total_cow_transfer * 0.85
                    else total_cow_transfer
                end
            else total_cow_transfer
        end as total_cow_transfer_with_service_fee
    from sum_cow_rewards_and_fees
),

sum_cow_rewards_and_fees_with_service_fee_and_overdraft as (
    select 
        *,
        case 
            when (total_cow_transfer_with_service_fee * conversion_rate_cow_to_native + total_wei_transfer) < 0 then true
       	    else false
      	end as overdraft
    from sum_cow_rewards_and_fees_with_service_fee
)

select * from sum_cow_rewards_and_fees_with_service_fee_and_overdraft