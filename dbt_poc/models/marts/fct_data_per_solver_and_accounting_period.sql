{{ config(
    materialized='table'
)}}

with 

accounting_period as (
    select * from {{ref('int_accounting_period_data__conversion_rates')}}

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
        ap.conversion_rate_cow_to_native, 
        count(dpt.is_eligeable_for_quote_reward) * least(0.0006* (1/ap.conversion_rate_cow_to_native), 6) as sum_quote_reward_cow, --is the minimum of 6 cow tokens or the or 0.0006 eth in cow
        sum(dps.batch_reward_wei) as sum_batch_reward_wei,
        sum(dps.slippage_wei) as sum_slippage_wei,
        sum(dpt.network_fee_native) as sum_network_fee_native,
        sum(dps.execution_cost) as sum_execution_cost_wei
    from accounting_period ap
    right join data_per_solution dps
    on dps.block_number = ap.block_number
    right join data_per_trade dpt
    on dpt.block_number = ap.block_number
    group by 
        dps.solver,
        dps.solver_name,
        dps.reward_target,
        ap.accounting_period, 
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
        coalesce(sum_batch_reward_wei, 0) / conversion_rate_cow_to_native + coalesce(sum_quote_reward_cow, 0) as total_cow_transfer, --todo check with Felix the conversion equation
        (coalesce(sum_slippage_wei, 0) + coalesce(sum_network_fee_native, 0)) * 1e18 as total_eth_transfer -- todo check with felix that this is correct
    from sum_individual_rewards_and_fees
),

cow_and_native_rewards_and_fees as (
    select 
        *,
        
        case when total_cow_transfer < 0 then true
       	else false
      	end as overdraft
      from sum_cow_rewards_and_fees
)

select * from cow_and_native_rewards_and_fees