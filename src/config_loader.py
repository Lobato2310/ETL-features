# src/config_loader.py
import yaml
from pathlib import Path

# Localiza a raiz do projeto independente de onde o script for executado
BASE_DIR = Path(__file__).resolve().parent.parent
CONFIG_PATH = BASE_DIR / "config" / "rules_config.yaml"

def load_config() -> dict:
    """Carrega as configurações do projeto a partir do YAML."""
    if not CONFIG_PATH.exists():
        raise FileNotFoundError(f"Arquivo de configuração não encontrado em: {CONFIG_PATH}")
        
    with open(CONFIG_PATH, "r", encoding="utf-8") as f:
        config = yaml.safe_load(f)
        
    return config

# Exemplo rápido de uso:
if __name__ == "__main__":
    cfg = load_config()
    print("✅ Configuração carregada com sucesso!")
    print(f"Limiar de Bloqueio Automático: {cfg['risk_thresholds']['auto_block_min']}")
    print(f"SLA de Nulos: {cfg['data_quality']['null_threshold_pct']}%")