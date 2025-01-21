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
        sum(dps.batch_reward) as sum_batch_reward_wei,
        sum(dps.slippage_wei) as sum_slippage_wei,
        sum(dps.network_fee) as sum_network_fee_wei,
        sum(dps.protocol_fee_amount) as sum_protocol_fee_amount_wei,
        sum(dps.execution_cost) as sum_execution_cost_wei
    from accounting_period ap
    join data_per_solution dps
    on dps.block_number = ap.block_number
    join data_per_trade dpt
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
        coalesce(sum_batch_reward_wei, 0) + coalesce(sum_slippage_wei, 0) + coalesce(sum_network_fee_wei, 0) + coalesce(sum_protocol_fee_amount_wei, 0) + coalesce(sum_execution_cost_wei, 0) * (1 / conversion_rate_cow_to_native) + coalesce(sum_quote_reward_cow, 0) as total_cow_transfer
    from sum_individual_rewards_and_fees
),

cow_and_native_rewards_and_fees as (
    select 
        solver,
        solver_name,
        reward_target,
        accounting_period
        total_cow_transfer,
        total_cow_transfer * conversion_rate_cow_to_native as total_native_transfer,
        case when total_cow_transfer < 0 then true
       	else false
      	end as overdraft
      from sum_cow_rewards_and_fees
)

select * from cow_and_native_rewards_and_fees