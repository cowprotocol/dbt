with 

source as (
    select 
        network,
        convert_to(protocol_fee_address, 'utf8')::bytea as protocol_fee_address,
        partner_fee_cut,
        partner_fee_reduced_cut,
        convert_to(partner_fee_reduced_cut_address, 'utf8')::bytea as partner_fee_reduced_cut_address
    from {{ref('protocol_fees_config')}}
)

select * from source