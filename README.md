# Pipeline de ETL e Feature Engineering em SQL — Análise Exploratória de Padrões de Fraude (IEEE-CIS Dataset)

## Objetivo do Projeto

Este projeto foi desenvolvido como prática de **ETL e feature engineering usando SQL/DuckDB**, aplicando arquitetura em camadas (bronze → silver) sobre o dataset [IEEE-CIS Fraud Detection](https://www.kaggle.com/c/ieee-fraud-detection).


## Arquitetura

```
Dados brutos (raw) → Camada Bronze → Camada Silver (tratada) → Análise/Feature Engineering
```

- **Banco de dados analítico:** DuckDB (execução local, OLAP embarcado)
- **Orquestração de queries:** scripts Python (`sql_runner.py`) executando arquivos `.sql` versionados individualmente
- **Configuração:** regras de negócio e parâmetros centralizados em `config_regras.yaml`, carregados via `config_loader.py`
- **Validação:** script dedicado (`check_dados.py`) para checagem de qualidade dos dados

## Pipeline SQL (execução sequencial)

| Etapa | Script | Descrição |
|---|---|---|
| 1 | `01_nulls_check.sql` | Verificação de valores nulos nas colunas críticas |
| 2 | `02_ordenar_emails.sql` | Ordenação e padronização dos domínios de e-mail |
| 3 | `03_agrupar_emails_comprador.sql` | Agrupamento de transações por domínio de e-mail do comprador |
| 4 | `04_agrupar_emails_destino.sql` | Agrupamento de transações por domínio de e-mail de destino |
| 5 | `05_view_limpa.sql` | Criação da view consolidada e tratada |
| 6 | `06_test_view.sql` | Testes de sanidade sobre a view criada |
| 7 | `07_calculo_fraude_email_comp.sql` | Cálculo de taxa de fraude por domínio de e-mail do comprador |
| 8 | `08_calculo_fraude_email_dest.sql` | Cálculo de taxa de fraude por domínio de e-mail de destino |
| 9 | `09_matriz_cruz_email.sql` | Matriz cruzada de fraude entre domínio de comprador x destino |
| 10 | `10_comp_fraude_legitima.sql` | Comparação estatística entre transações fraudulentas e legítimas |

## Principais Insights

A comparação estatística entre transações legítimas (`isFraud = 0`) e fraudulentas (`isFraud = 1`) revelou padrões relevantes:

| Métrica | Legítima (0) | Fraude (1) |
|---|---|---|
| Total de transações | 569.877 | 20.663 |
| Ticket médio | R$ 134,51 | R$ 149,24 |
| Mediana | R$ 68,50 | R$ 75,00 |
| Desvio padrão | 239,40 | 232,21 |
| Variância | 57.310,00 | 53.922,49 |
| Valor mínimo | R$ 0,251 | R$ 0,292 |
| Valor máximo | R$ 31.937,39 | R$ 5.191,00 |

**Leitura dos dados:** transações fraudulentas apresentam ticket médio e mediana **ligeiramente superiores** às legítimas, porém com dispersão semelhante (desvio padrão e variância próximos). Chama atenção o valor máximo muito mais alto entre as transações legítimas (R$ 31.937,39) comparado às fraudulentas (R$ 5.191,00) — possível indício de que fraudes tendem a se concentrar em faixas de valor mais controladas, evitando transações de alto valor que poderiam disparar alertas automáticos de segurança.

A análise de matriz cruzada por domínio de e-mail (comprador x destino) também permitiu identificar combinações de domínios com maior concentração relativa de fraude, servindo de base para features categóricas de risco.

## Aprendizados Técnicos

- SQL aplicado a pipeline estruturado em múltiplas etapas (não queries isoladas)
- Arquitetura em camadas (bronze → silver) para organização de transformação de dados
- Uso de DuckDB como motor analítico local (OLAP embarcado)
- Engenharia de configuração via YAML, evitando parâmetros hardcoded
- Separação de responsabilidades em scripts Python (ingestão, execução de SQL, validação)
- Feature engineering categórico (domínios de e-mail) aplicado a problema de fraude
- Análise estatística comparativa entre classes desbalanceadas

## Limitações e Próximos Passos

Modelagem preditiva **não foi implementada** neste projeto devido à complexidade do dataset: alta dimensionalidade de features anônimas e desbalanceamento severo de classes, que exigiriam técnicas avançadas de balanceamento (ex: SMOTE) e seleção sistemática de features fora do escopo definido para esta etapa.

O próximo passo natural é aplicar os fundamentos de feature engineering e ETL aqui desenvolvidos em um dataset com maior interpretabilidade de negócio, antes de escalar para modelos de classificação supervisionada.

## Dataset

[IEEE-CIS Fraud Detection](https://www.kaggle.com/c/ieee-fraud-detection) — Kaggle Competition Dataset

## Autor

Lucas — [github.com/Lobato2310](https://github.com/Lobato2310)