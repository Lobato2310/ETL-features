import duckdb
from pathlib import Path
import sys

sys.path.append(str(Path(__file__).resolve().parent.parent))


BASE_DIR = Path(__file__).resolve().parent.parent.parent
QUERIES_DIR = BASE_DIR / "src" / "db" / "queries"
PARQUET_PATH = BASE_DIR / "data" / "processed" / "train_clean.parquet"

def run_query(query_filename: str, *args, **kwargs):
    query_path = QUERIES_DIR / query_filename
    
    with open(query_path, "r", encoding="utf-8",) as f:
        sql_script = f.read()
    
    sql_script = sql_script.format(parquet_path=PARQUET_PATH.as_posix(), **kwargs)
    
    return duckdb.execute(sql_script).df()