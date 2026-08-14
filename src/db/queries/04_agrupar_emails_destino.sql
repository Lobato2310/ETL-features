SELECT  
    COUNT(*) AS qtde_por_provedor, 
    CASE 
        WHEN LOWER(R_emaildomain) LIKE 'gmail%' THEN 'google'
        WHEN LOWER(R_emaildomain) LIKE 'hotmail%' 
          OR LOWER(R_emaildomain) LIKE 'outlook%' 
          OR LOWER(R_emaildomain) LIKE 'msn%' 
          OR LOWER(R_emaildomain) LIKE 'live%' THEN 'microsoft'
        WHEN LOWER(R_emaildomain) LIKE 'yahoo%' 
          OR LOWER(R_emaildomain) LIKE 'ymail%' 
          OR LOWER(R_emaildomain) LIKE 'rocketmail%' THEN 'yahoo'
        WHEN LOWER(R_emaildomain) LIKE 'icloud%' 
          OR LOWER(R_emaildomain) LIKE 'me.%' 
          OR LOWER(R_emaildomain) LIKE 'mac.%' THEN 'apple'
        WHEN LOWER(R_emaildomain) LIKE 'anonymous%' THEN 'anonymous'
        WHEN (R_emaildomain) IS NULL THEN 'missing'
        ELSE 'outro' 
    END AS categoria_provedor 
FROM '{parquet_path}' 
GROUP BY categoria_provedor;
