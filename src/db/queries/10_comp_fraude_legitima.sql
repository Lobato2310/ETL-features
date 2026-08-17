SELECT 
    isFraud,
    COUNT(TransactionId) AS total_transacoes,
    ROUND(AVG(TransactionAmt), 2) AS ticket_medio,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY transactionAmt) AS mediana,
    ROUND(STDDEV(transactionAmt), 2) AS desvio_padrao,
    ROUND(VARIANCE(transactionAmt), 2) AS variancia,
    MIN(transactionAmt) AS valor_minimo,
    MAX(transactionAmt) AS valor_maximo
FROM 
    '{parquet_path}'
GROUP BY 
    isFraud;
