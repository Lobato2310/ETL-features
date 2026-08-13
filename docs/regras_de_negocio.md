 # Business & Data Rules Specification — Fraud Sentinel AI

 # Projeto:
 Sistema Híbrido de Detecção de Fraude e Explicabilidade (IEEE-CIS Dataset)
 # Stack: 
 DuckDB | LightGBM | OpenAI (LLM) | RAG | Streamlit1. 
 
 # 1. Matriz de Decisão e Triagem de Risco: 
 A engine de inferência classifica as transações com base na probabilidade de fraude (Score $S \in [0.00, 1.00]$ gerado pelo LightGBM):

| **Faixa de Score** | **Decisão de Negócio** | **Ação do Sistema** | **SLA de Latência** |
|---|---|---|---|
| S < 0.15 | Aprovação Automática | Liberação imediata da transação sem fricção | < 50 ms |
| 0.15 >= S < 0.70 | Análise Auxiliada / 2FA | Exige autenticação reforçada (OTP/2FA) ou encaminha para a fila de revisão manual com resumo do LLM. | < 300 ms |
| S >= 0.70 | Negação imediata da transação + geração automática de Laudo de Explicabilidade via SHAP + RAG. | < 500 ms |

# 2. Regras Determinísticas e Filtros de Velocidade (DuckDB Engine)
Regras duras aplicadas na camada de ingestão/transformação para sinalização imediata ou penalização no risco:

RN-01 (Velocidade por Cartão): Disparar alerta de risco alto se a Identidade Sintética registrar mais de 5 tentativas de compra dentro de uma janela móvel de 10 minutos.
RN-02 (Anomalia de Valor por Cliente): Sinalizar transação se o valor (TransactionAmt) for superior a 500% da média móvel das últimas 20 transações do mesmo perfil.
RN-03 (Divergência Geoespacial/Dispositivo): Aumentar peso de risco se houver troca de fuso horário/dispositivo (DeviceType, id_30/id_31) para o mesmo cartão em um intervalo inferior a 1 hora.

# 3. SLA de Qualidade de Dados (Data Quality Rules)

DQ-01 (Integridade da Chave Primária): O arquivo consumido deve garantir rigorosamente count(TransactionID) = count(DISTINCT TransactionID). Nenhuma duplicação é permitida.
DQ-02 (SLA de Nulos & Feature Dropping): Variáveis com mais de 85% de dados nulos e variância quase nula serão limadas do pipeline para mitigar custos de infraestrutura e latência de inferência.
DQ-03 (Temporalidade & Data Leakage): A divisão do dataset para validação DEVE respeitar estritamente a ordem cronológica (TransactionDT). O uso de Random K-Fold Cross-Validation é estritamente proibido para evitar vazamento do futuro para o passado.
DQ-04 (Tratamento de Escala): A variável TransactionAmt deve passar por transformação logarítmica log(1 + TransactionAmt) para estabilizar os gradientes do modelo.

# 4. Engenharia de Identidade e Padronização

GV-01 (Direito à Explicabilidade - LGPD/BACEN): Toda transação submetida ao Bloqueio Automático (S > 0.70%) deve ter suas 3 variáveis técnicas de maior impacto extraídas via SHAP Values.
GV-02 (Tradução para Linguagem Natural): A camada LLM traduz os códigos técnicos do modelo (ex: v_307, card1_count_10m) em uma justificativa clara para auditoria humana.
GV-03 (Conformidade com Manuais Internos): O pipeline de RAG deve consultar os documentos de diretrizes em docs/policies/ para citar qual norma interna de compliance fundamentou a recusa.
