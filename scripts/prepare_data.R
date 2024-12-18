# Carregar bibliotecas
library(dplyr)
library(readr)

# Carregar os dados limpos
gdp_clean <- read_csv("outputs/gdp_clean.csv")
world_indicators_clean <- read_csv("outputs/world_indicators_clean.csv")
world_data_clean <- read_csv("outputs/world_data_clean.csv")

# 1. Unir os datasets usando País e Ano
world_indicators_clean <- world_indicators_clean %>%
  filter(Year >= 2000 & Year <= 2023)

combined_data <- world_indicators_clean %>%
  left_join(gdp_clean, by = "Country") %>%
  left_join(world_data_clean, by = "Country")

# Verificar nomes das colunas para evitar duplicatas
print("Nomes das colunas de combined_data:")
print(names(combined_data))

# 2. Ajustar variáveis e criar novas colunas
combined_data <- combined_data %>%
  mutate(
    log_GDP = log(GDP),                  # Logaritmo do PIB
    Unemployment = Unemployment.x,       # Seleciona a variável correta
    Unemployment_lag = lag(Unemployment.x) # Cria a variável defasada
  ) %>%
  select(-Unemployment.y)                # Remove duplicata desnecessária

# 3. Remover linhas com valores ausentes pós-junção
combined_data <- combined_data %>%
  filter(!is.na(log_GDP), !is.na(Unemployment))

# 4. Salvar a tabela combinada
write_csv(combined_data, "outputs/final_combined_data.csv")

# Mensagem final
print("Dados combinados e preparados com sucesso!")
