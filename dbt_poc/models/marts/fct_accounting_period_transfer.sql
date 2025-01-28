
{{ config(
    materialized='table'
)}}

with 

solver_and_accounting_period as (
    select * from {{ref('fct_data_per_solver_and_accounting_period')}}

),
