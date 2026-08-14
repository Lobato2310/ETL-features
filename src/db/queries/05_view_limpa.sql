CREATE OR REPLACE VIEW vw_train_clean AS
SELECT * 
    EXCLUDE ({colunas_descarte_str}),
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
    END AS categoria_provedor_comprador,
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
    END AS categoria_provedor_destino
    FROM '{parquet_path}' 