import duckdb
import time
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent.parent.parent
RAW_DIR = BASE_DIR / "data" / "raw"
PROCESSED_DIR = BASE_DIR / "data" / "processed"

PROCESSED_DIR.mkdir(parents=True, exist_ok=True)

def convert_csv_to_parquet(split: str = "train"):
    """
    Converte e une as tabelas de transaction e identity em Parquet.
    split: 'train' ou 'test'
    """
    print(f"🚀 Processando conjunto de dados: [{split.upper()}]...")
    start_time = time.time()

    con = duckdb.connect(database=":memory:")

    transaction_path = RAW_DIR / f"{split}_transaction.csv"
    identity_path = RAW_DIR / f"{split}_identity.csv"
    output_parquet_path = PROCESSED_DIR / f"{split}_consolidated.parquet"

    if not transaction_path.exists():
        print(f"⚠️ Arquivo {transaction_path} não encontrado em data/raw/!")
        return

    query = f"""
    COPY (
        SELECT 
            t.*,
            i.* EXCLUDE (TransactionID)
        FROM read_csv_auto('{transaction_path}', HEADER=True) t
        LEFT JOIN read_csv_auto('{identity_path}', HEADER=True) i
            ON t.TransactionID = i.TransactionID
    ) TO '{output_parquet_path}' (FORMAT 'PARQUET', COMPRESSION 'SNAPPY');
    """

    con.execute(query)

    elapsed_time = time.time() - start_time
    print(f"✅ [{split.upper()}] convertido com sucesso em {elapsed_time:.2f} segundos!")
    print(f"📦 Gerado: {output_parquet_path}\n")

if __name__ == "__main__":
    # Processa ambas as bases em lote
    convert_csv_to_parquet("train")
    convert_csv_to_parquet("test")