# Carregar bibliotecas
library(dplyr)
library(plm)
library(gmm)
library(readr)

# 1. Carregar os dados preparados
data <- read_csv("outputs/final_combined_data.csv")

# Verificar estrutura dos dados
print("Estrutura dos Dados:")
glimpse(data)

# 2. Converter os dados para formato painel
# Identificar País como 'id' e Ano como 'time'
data_panel <- pdata.frame(data, index = c("Country", "Year"))

# 3. Especificar o Modelo de Painel Dinâmico (Arellano-Bond)
# Fórmula: Unemployment depende de sua lag, log_GDP e outras variáveis
model_ab <- pgmm(
  Unemployment ~ lag(Unemployment, 1) + log_GDP | lag(Unemployment, 2:3),
  data = data_panel,
  effect = "individual",
  model = "twosteps"
)

# 4. Resumo do Modelo
summary(model_ab)

# 5. Modelo de Efeitos Fixos como Comparação
model_fe <- plm(
  Unemployment ~ lag(Unemployment, 1) + log_GDP,
  data = data_panel,
  model = "within",
  effect = "individual"
)

# Resumo do Modelo de Efeitos Fixos
summary(model_fe)

# Mensagem final
print("Modelos econométricos estimados com sucesso!")
