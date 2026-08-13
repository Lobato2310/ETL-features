import duckdb
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent.parent.parent
PROCESSED_DIR = BASE_DIR / "data" / "processed"

def run_sanity_check(split: str = "train"):
    parquet_path = PROCESSED_DIR / f"{split}_consolidated.parquet"
    
    if not parquet_path.exists():
        print(f"⚠️ Arquivo {parquet_path.name} não encontrado!")
        return

    con = duckdb.connect()
    
    columns_info = con.execute(f"DESCRIBE SELECT * FROM '{parquet_path}'").fetchall()
    column_names = [col[0] for col in columns_info]
    has_target = "isFraud" in column_names

    print(f"\n📊 --- Sanity Check: [{split.upper()}] ---")
    
    if has_target:
        query = f"""
        SELECT 
            count(*) AS total_linhas,
            count(DISTINCT TransactionID) AS ids_unicos,
            sum(isFraud) AS total_fraudes,
            round(avg(isFraud) * 100, 2) AS pct_fraude
        FROM '{parquet_path}';
        """
    else:
        query = f"""
        SELECT 
            count(*) AS total_linhas,
            count(DISTINCT TransactionID) AS ids_unicos
        FROM '{parquet_path}';
        """
    
    result = con.execute(query).df()
    print(result.to_string(index=False))
    print(f"📐 Total de colunas: {len(column_names)}")

if __name__ == "__main__":
    run_sanity_check("train")
    run_sanity_check("test")