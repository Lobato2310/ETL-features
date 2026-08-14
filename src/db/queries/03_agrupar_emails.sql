SELECT  
    COUNT(*) AS qtde_por_provedor, 
    CASE 
        WHEN LOWER(P_emaildomain) LIKE 'gmail%' THEN 'google'
        WHEN LOWER(P_emaildomain) LIKE 'hotmail%' 
          OR LOWER(P_emaildomain) LIKE 'outlook%' 
          OR LOWER(P_emaildomain) LIKE 'msn%' 
          OR LOWER(P_emaildomain) LIKE 'live%' THEN 'microsoft'
        WHEN LOWER(P_emaildomain) LIKE 'yahoo%' 
          OR LOWER(P_emaildomain) LIKE 'ymail%' 
          OR LOWER(P_emaildomain) LIKE 'rocketmail%' THEN 'yahoo'
        WHEN LOWER(P_emaildomain) LIKE 'icloud%' 
          OR LOWER(P_emaildomain) LIKE 'me.%' 
          OR LOWER(P_emaildomain) LIKE 'mac.%' THEN 'apple'
        WHEN LOWER(P_emaildomain) LIKE 'anonymous%' THEN 'anonymous'
        WHEN (P_emaildomain) IS NULL THEN 'missing'
        ELSE 'outro' 
    END AS categoria_provedor 
FROM '{parquet_path}' 
GROUP BY categoria_provedor;
