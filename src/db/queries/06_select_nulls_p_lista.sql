SELECT 
    column_name,
    column_type,
    approx_unique AS valores_unicos
FROM (
    SUMMARIZE SELECT * FROM '{parquet_path}');
