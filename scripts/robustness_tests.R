# Carregar bibliotecas
library(dplyr)
library(plm)
library(gmm)
library(readr)

# Carregar os dados
data <- read_csv("outputs/final_combined_data.csv")

# Converter os dados para formato painel
data_panel <- pdata.frame(data, index = c("Country", "Year"))

# 1. Teste Hansen/Sargan para validade dos instrumentos
model_ab <- pgmm(
  Unemployment ~ lag(Unemployment, 1) + log_GDP | lag(Unemployment, 2:3),
  data = data_panel,
  effect = "individual",
  model = "twosteps"
)

summary_ab <- summary(model_ab)

# Resultado dos testes Hansen e Sargan
print("Teste Hansen/Sargan:")
print(summary_ab$tests$hansen)  # Hansen test
print(summary_ab$tests$sargan)  # Sargan test

# 2. Teste de Autocorrelação de Resíduos (Arellano-Bond)
print("Teste de Autocorrelação (Arellano-Bond):")
print(summary_ab$tests$ar)

# 3. Robustez com diferentes especificações
# Teste com mais defasagens
model_ab_alt <- pgmm(
  Unemployment ~ lag(Unemployment, 1:2) + log_GDP | lag(Unemployment, 3:4),
  data = data_panel,
  effect = "individual",
  model = "twosteps"
)

summary_ab_alt <- summary(model_ab_alt)
print("Modelo com defasagens alternativas:")
print(summary_ab_alt)

# 4. Subgrupos: Países emergentes vs. desenvolvidos
# Criar subgrupos (exemplo fictício: países com GDP acima/abaixo da mediana)
median_gdp <- median(data$GDP, na.rm = TRUE)
data_emerging <- filter(data, GDP < median_gdp)
data_developed <- filter(data, GDP >= median_gdp)

# Modelo para países emergentes
model_emerging <- pgmm(
  Unemployment ~ lag(Unemployment, 1) + log_GDP | lag(Unemployment, 2:3),
  data = pdata.frame(data_emerging, index = c("Country", "Year")),
  effect = "individual",
  model = "twosteps"
)
print("Modelo para países emergentes:")
print(summary(model_emerging))

# Modelo para países desenvolvidos
model_developed <- pgmm(
  Unemployment ~ lag(Unemployment, 1) + log_GDP | lag(Unemployment, 2:3),
  data = pdata.frame(data_developed, index = c("Country", "Year")),
  effect = "individual",
  model = "twosteps"
)
print("Modelo para países desenvolvidos:")
print(summary(model_developed))
