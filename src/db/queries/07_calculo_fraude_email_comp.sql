SELECT 
    categoria_provedor_comprador,
    COUNT(*) AS total_transacoes_email_comprador,
    SUM(isFraud) AS total_fraudes_email_comprador,
    ROUND(AVG(isFraud) * 100, 2) AS porcentagem_fraude_email_comprador
FROM 
    '{parquet_path}' 
GROUP BY 
    categoria_provedor_comprador
ORDER BY 
    porcentagem_fraude_email_comprador DESC;