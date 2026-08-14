SELECT 
    categoria_provedor_comprador,
    COUNT(*) AS total_transacoes,
    SUM(isFraud) AS total_fraudes,
    ROUND(AVG(isFraud) * 100, 2) AS porcentagem_fraude
FROM 
    vw_train_clean
GROUP BY 
    categoria_provedor_comprador
ORDER BY 
    porcentagem_fraude DESC;