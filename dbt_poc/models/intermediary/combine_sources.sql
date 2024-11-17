
WITH dune_data AS (
    SELECT * FROM ref {{ 'stg_dune__model1' }}
),
backend_data AS (
    SELECT * FROM ref {{ 'stg_backend__model1' }}
)
SELECT
    dune_data.column1 AS dune_column1,
    test_data.column1 AS test_column1,
    dune_data.column2,
    test_data.column2
FROM dune_data
JOIN backend_data
ON dune_data.id = backend_data.dune_id;
