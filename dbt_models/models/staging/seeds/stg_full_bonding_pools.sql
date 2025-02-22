with 

source as (
    select 
        convert_to(pool_address, 'utf8')::bytea as pool_address,
        pool_name,
        convert_to(initial_funder, 'utf8')::bytea as initial_funder
    from {{ref('full_bonding_pools')}}
)

select * from source
