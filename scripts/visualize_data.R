library(ggplot2)
library(dplyr)

# Selecionar os países com as 10 maiores médias de desemprego
top_countries <- data %>%
  group_by(Country) %>%
  summarise(media_desemprego = mean(Unemployment, na.rm = TRUE)) %>%
  arrange(desc(media_desemprego)) %>%
  slice_head(n = 10) %>%
  pull(Country)

# Criar uma nova coluna para agrupar os outros países
data$Country_group <- ifelse(data$Country %in% top_countries, data$Country, "Outros")

# Gráfico de evolução com foco nos 10 países
ggplot(data, aes(x = Year, y = Unemployment, group = Country_group, color = Country_group)) +
  geom_line(size = 1.2, alpha = 0.8) +
  labs(
    title = "Evolução da Taxa de Desemprego (Top 10 Países)",
    x = "Ano",
    y = "Taxa de Desemprego (%)",
    color = "País"
  ) +
  scale_color_manual(
    values = c("Outros" = "gray80", 
               "Top Country" = "red"),
    breaks = c(top_countries, "Outros")
  ) +
  theme_minimal(base_size = 14) +
  theme(legend.text = element_text(size = 10), legend.position = "right")
