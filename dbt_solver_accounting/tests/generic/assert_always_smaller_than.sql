{% test assert_always_smaller_than(model, smaller_column, bigger_column) %}
    select *
    from {{ model }}
    where {{ smaller_column }} >= {{ bigger_column }}
{% endtest %}