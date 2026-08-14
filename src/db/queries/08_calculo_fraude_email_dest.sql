SELECT 
    categoria_provedor_destino,
    COUNT(*) AS total_transacoes_email_destino,
    SUM(isFraud) AS total_fraudes_email_destino,
    ROUND(AVG(isFraud) * 100, 2) AS porcentagem_fraude_email_destino
FROM 
    '{parquet_path}' 
GROUP BY 
    categoria_provedor_destino
ORDER BY 
    porcentagem_fraude_email_destino DESC;