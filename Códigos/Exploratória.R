# Carregar pacotes necessários
library(ggplot2)
library(dplyr)
library(corrplot)
library(readxl)
library(GGally)
library(patchwork)
library(tidyr)


# Carregando a base
dados <- read_excel("C:/Users/luiz1/OneDrive/Área de Trabalho/TERCEIRO PROJETO/S1_Dataset.xlsx")

# Remover a variável ID antes do modelo
dados <- dados %>% dplyr:: select(-id)

# Frequências para variáveis categóricas por grupo 'nephtox'
cat_summary <- lapply(cat_vars[cat_vars != "nephtox"], function(var){
  tab <- table(dados[[var]], dados$nephtox)
  as.data.frame.matrix(tab) %>%
    mutate(Variavel = var, Categoria = rownames(.)) %>%
    dplyr::select(Variavel, Categoria, everything())
})
cat_summary <- bind_rows(cat_summary)

cat_summary
# 1. Tabelas de Frequência
cat_vars <- names(dados)[sapply(dados, is.factor) | sapply(dados, is.character)]
plot_list <- list()  # Lista para armazenar os gráficos

for (var in cat_vars) {
  if (var != "nephtox") {
    freq_df <- as.data.frame(table(dados[[var]], dados$nephtox))
    colnames(freq_df) <- c("Categoria", "Nephtox", "Frequencia")
    
    p <- ggplot(freq_df, aes(x = Categoria, y = Frequencia, fill = Nephtox)) +
      geom_bar(stat = "identity", position = position_dodge(width = 0.9)) +
      geom_text(aes(label = Frequencia), 
                position = position_dodge(width = 0.9), 
                vjust = -0.3, size = 3.5) +
      labs(title = paste("Distribuição de", var, "por Nephtox"),
           x = var,
           y = "Frequência") +
      theme_minimal() +
      theme(axis.text.x = element_text(angle = 45, hjust = 1))
    
    plot_list[[var]] <- p
  }
}

# Número de gráficos por página
n_por_pagina <- 4
n_total <- length(plot_list)
paginas <- ceiling(n_total / n_por_pagina)

for (i in 1:paginas) {
  inicio <- (i - 1) * n_por_pagina + 1
  fim <- min(i * n_por_pagina, n_total)
  
  # Seleciona os gráficos da vez
  graficos <- plot_list[inicio:fim]
  
  # Usa patchwork para combinar (automaticamente 2x2)
  combinado <- wrap_plots(graficos, ncol = 2)
  print(combinado)
}

# Estatísticas para variáveis numéricas por grupo 'nephtox'
num_summary <- dados %>%
  group_by(nephtox) %>%
  summarise(across(all_of(num_vars), 
                   list(media = ~mean(.x, na.rm=TRUE), 
                        sd = ~sd(.x, na.rm=TRUE)), .names = "{col}_{fn}")) %>%
  pivot_longer(-nephtox, names_to = c("Variavel","Estatistica"), names_sep = "_", values_to = "Valor") %>%
  pivot_wider(names_from = c(nephtox, Estatistica), values_from = Valor)

num_summary
# 2. Boxplots das variáveis numéricas em relação a nephtox
num_vars <- names(dados)[sapply(dados, is.numeric)]

# Gera todos os boxplots e guarda em uma lista
plots <- lapply(num_vars, function(var) {
  ggplot(dados, aes(x = as.factor(nephtox), y = .data[[var]])) +
    geom_boxplot() +
    labs(title = paste("Boxplot de", var, "por Nefrotoxicidade"),
         x = "Nefrotoxicidade",
         y = var) +
    theme_minimal()
})

# Função para combinar os plots 4 a 4
num_plots <- length(plots)
for (i in seq(1, num_plots, by = 4)) {
  group <- plots[i:min(i+3, num_plots)]  # Pega até 4 plots
  if (length(group) == 4) {
    print((group[[1]] | group[[2]]) / (group[[3]] | group[[4]]))
  } else if (length(group) == 3) {
    print((group[[1]] | group[[2]]) / group[[3]])
  } else if (length(group) == 2) {
    print(group[[1]] | group[[2]])
  } else {
    print(group[[1]])
  }
} 
# 3. Matriz de Correlação das variáveis numéricas
cor_matrix <- cor(dados[, num_vars], use = "complete.obs")  # Calcula a matriz de correlação

# Matriz de correlação (cor)
corrplot(cor_matrix, method = "color", type = "lower", tl.cex = 0.8, tl.col = "black")

# Matriz de correlação (numérica)
ggpairs(dados[,num_vars], upper = list(continuous = wrap("cor", size = 4)))
