with valid_vouches as (
    select *
    from {{ref('int_dune_data__valid_vouches')}}
),

invalid_vouches as (
    select *
    from {{ref('int_dune_data__valid_unvouches')}}
)


select * from invalid_vouches