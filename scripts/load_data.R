# Carregar a biblioteca necessária
library(readr)
library(dplyr)

# Carregar os arquivos de dados
gdp <- read_csv("data/gdp.csv")
world_indicators <- read_csv("data/world_economic_indicators.csv")
world_data <- read_csv("data/world-data-2023.csv")

# Verificar as primeiras linhas de cada dataset
print("Dados do GDP:")
head(gdp)

print("Dados de World Economic Indicators:")
head(world_indicators)

print("Dados de World Data 2023:")
head(world_data)
