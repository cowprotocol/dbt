with actual_valid_vouches as (
    select *
    from {{ref('int_dune_data__actual_valid_vouches')}}
),

ethereum_solvers as (
    select *
    from {{ref('stg_dune_data__cow_protocol_ethereum_solvers')}}
),  
  
named_solvers as (
    select
        vv.solver,
        vv.reward_target,
        vv.pool_address,
        vv.pool_name,
        concat(environment, '-', s.name) as solver_name
    from actual_valid_vouches as vv
    inner join ethereum_solvers as s
        on vv.solver = s.address
)

select * from named_solvers