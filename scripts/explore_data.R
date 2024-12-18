# Carregar bibliotecas necessárias
library(dplyr)
library(ggplot2)

# Ver estrutura dos dados
print("Estrutura do GDP:")
glimpse(gdp)

print("Estrutura de World Economic Indicators:")
glimpse(world_indicators)

print("Estrutura de World Data 2023:")
glimpse(world_data)

# Resumo estatístico
print("Resumo Estatístico do GDP:")
summary(gdp)

print("Resumo Estatístico de World Economic Indicators:")
summary(world_indicators)

print("Resumo Estatístico de World Data 2023:")
summary(world_data)

# Verificar valores ausentes
print("Valores Ausentes no GDP:")
colSums(is.na(gdp))

print("Valores Ausentes em World Economic Indicators:")
colSums(is.na(world_indicators))

print("Valores Ausentes em World Data 2023:")
colSums(is.na(world_data))

# Gráfico de distribuição de uma variável numérica importante (exemplo: GDP)
ggplot(gdp, aes(x = gdp)) + 
  geom_histogram(binwidth = 5000, fill = "blue", color = "white") +
  theme_minimal() +
  labs(title = "Distribuição do GDP", x = "GDP", y = "Frequência")
