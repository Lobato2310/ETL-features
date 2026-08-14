SELECT P_emaildomain, COUNT(*) AS qtde_emails
FROM '{parquet_path}'
GROUP BY P_emaildomain
ORDER BY qtde_emails DESC;
