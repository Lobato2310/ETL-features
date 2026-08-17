SELECT 
    categoria_provedor_comprador, 
    categoria_provedor_destino, 
    COUNT(*) AS total_emails,
    SUM(isFraud) AS total_fraudes,
    ROUND(AVG(isFraud) * 100, 2) AS taxa_fraude_pct
FROM 
    '{parquet_path}'
GROUP BY 
    categoria_provedor_comprador, 
    categoria_provedor_destino
ORDER BY 
    taxa_fraude_pct DESC;
