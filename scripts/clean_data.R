# Carregar bibliotecas necessárias
library(dplyr)
library(stringr)
library(readr)

# Carregar os dados
gdp <- read_csv("data/gdp.csv")
world_indicators <- read_csv("data/world_economic_indicators.csv")
world_data <- read_csv("data/world-data-2023.csv")

# 1. Tratar valores ausentes
# Remover linhas com muitos NAs
gdp_clean <- gdp %>%
  filter_all(any_vars(!is.na(.)))

world_indicators_clean <- world_indicators %>%
  filter_all(any_vars(!is.na(.)))

world_data_clean <- world_data %>%
  filter_all(any_vars(!is.na(.)))

# 2. Corrigir formatos de colunas (ex: porcentagens e valores monetários)
# Função para converter porcentagens em numéricos
convert_percentage <- function(column) {
  as.numeric(str_replace(column, "%", ""))
}

# Aplicar a função nas colunas de porcentagens
world_data_clean <- world_data_clean %>%
  mutate(across(where(is.character), ~str_replace(., "\\$", ""))) %>%  # Remove '$'
  mutate(across(contains("%"), convert_percentage))                  # Converte '%'

# Corrigir a coluna "GDP" em world_data_clean
world_data_clean$GDP <- as.numeric(gsub(",", "", world_data_clean$GDP))

# 3. Selecionar variáveis importantes
# GDP e desemprego por país e ano
world_indicators_final <- world_indicators_clean %>%
  select(`Country Name`, Year, `Unemployment, total (% of total labor force)`, `GDP (current US$)_x`) %>%
  rename(Country = `Country Name`,
         Unemployment = `Unemployment, total (% of total labor force)`,
         GDP = `GDP (current US$)_x`)

# World Data: Foco em dados de desemprego, densidade populacional e urbanização
world_data_final <- world_data_clean %>%
  select(Country, `Density\n(P/Km2)`, `Unemployment rate`, Urban_population, Population) %>%
  rename(Density = `Density\n(P/Km2)`,
         Unemployment = `Unemployment rate`,
         Urbanization = Urban_population)

# 4. Salvar dados limpos na pasta outputs
write_csv(gdp_clean, "outputs/gdp_clean.csv")
write_csv(world_indicators_final, "outputs/world_indicators_clean.csv")
write_csv(world_data_final, "outputs/world_data_clean.csv")

# Mensagem final
print("Dados limpos e salvos com sucesso!")
