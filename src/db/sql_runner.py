import duckdb
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent.parent.parent
QUERIES_DIR = BASE_DIR / "src" / "db" / "queries"
PARQUET_PATH = BASE_DIR / "data" / "processed" / "train_consolidated.parquet"

def run_query(query_filename: str):
    query_path = QUERIES_DIR / query_filename
    
    with open(query_path, "r", encoding="utf-8") as f:
        sql_script = f.read()
    
    sql_script = sql_script.format(parquet_path=PARQUET_PATH)
    
    return duckdb.execute(sql_script).df()