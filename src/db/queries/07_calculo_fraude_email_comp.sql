SELECT 
    categoria_provedor_comprador,
    ROUND(AVG(isFraud) * 100, 2) AS porcentagem_fraude
FROM 
    vw_train_clean
GROUP BY 
    categoria_provedor_comprador
ORDER BY 
    porcentagem_fraude DESC;