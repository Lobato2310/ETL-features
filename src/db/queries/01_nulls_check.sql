SELECT 
    column_name,
    column_type,
    ROUND(null_percentage, 2) AS pct_nulos,
    approx_unique AS valores_unicos
FROM (
    SUMMARIZE SELECT * FROM '{parquet_path}'
)
ORDER BY pct_nulos DESC;