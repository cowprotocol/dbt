
{{ config(
    materialized='table'
)}}

with 

solver_and_accounting_period as (
    select * from {{ref('fct_data_per_solver_and_accounting_period')}}

)

select 
    solver,
    solver_name,
    reward_target,
    accounting_period,
    accounting_period_start_time,
    accounting_period_end_time,
    overdraft,
    overdraft_amount,
    
    case 
        when total_cow_reward_including_fee >= 0 and total_native_reward >= 0 
            then total_native_reward  
        when overdraft = true then 0   
        when total_native_reward < 0
        	then 0
        when total_cow_reward_including_fee < 0 
            then total_native_reward + (total_cow_reward_including_fee * conversion_rate_cow_to_native) 
    end as total_native_transfer,

    case 
        when total_cow_reward_including_fee >= 0 and total_native_reward >= 0 
            then total_cow_reward_including_fee  
        when overdraft = true then 0 
        when total_cow_reward_including_fee < 0
             then 0
        when total_native_reward < 0 
            then total_cow_reward_including_fee + (total_native_reward / conversion_rate_cow_to_native) 
    end as total_cow_transfer

from solver_and_accounting_period