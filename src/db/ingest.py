import duckdb
import time
from pathlib import Path

# Definindo caminhos de forma robusta com pathlib
BASE_DIR = Path(__file__).resolve().parent.parent.parent
RAW_DIR = BASE_DIR / "data" / "raw"
PROCESSED_DIR = BASE_DIR / "data" / "processed"

# Garante que a pasta de destino exista
PROCESSED_DIR.mkdir(parents=True, exist_ok=True)

def ingest_and_convert():
    print("🚀 Iniciando ingestão de alta performance com DuckDB...")
    start_time = time.time()

    # Criação/Conexão com banco DuckDB em memória
    con = duckdb.connect(database=":memory:")

    train_transaction_path = RAW_DIR / "train_transaction.csv"
    train_identity_path = RAW_DIR / "train_identity.csv"
    output_parquet_path = PROCESSED_DIR / "train_consolidated.parquet"

    # Query SQL vetorizada no DuckDB
    # Usa a cláusula EXCLUDE para não duplicar a chave primária TransactionID
    query = f"""
    COPY (
        SELECT 
            t.*,
            i.* EXCLUDE (TransactionID)
        FROM read_csv_auto('{train_transaction_path}', HEADER=True) t
        LEFT JOIN read_csv_auto('{train_identity_path}', HEADER=True) i
            ON t.TransactionID = i.TransactionID
    ) TO '{output_parquet_path}' (FORMAT 'PARQUET', COMPRESSION 'SNAPPY');
    """

    print("⚡ Executando JOIN e exportando para Parquet...")
    con.execute(query)

    elapsed_time = time.time() - start_time
    print(f"✅ Ingestão concluída com sucesso em {elapsed_time:.2f} segundos!")
    print(f"📦 Arquivo gerado em: {output_parquet_path}")

if __name__ == "__main__":
    ingest_and_convert()