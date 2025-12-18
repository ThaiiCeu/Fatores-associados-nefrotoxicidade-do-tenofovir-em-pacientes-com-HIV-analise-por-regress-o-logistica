# Carregar pacotes necessários
library(glmnet)
library(performance)
library(readxl)
library(ggplot2)
library(dplyr)
library(ggeffects)

# Carregando a base

dados <- read_excel("C:/Users/luiz1/OneDrive/Área de Trabalho/TERCEIRO PROJETO/S1_Dataset.xlsx")

# Colocando no padrão que o Lasso lê

x <- as.matrix(dados[, c(-7,-1)])  # tirando a variável nephtox e id
y <- dados$nephtox  # variável nephtox 

################# Fazedo o modelo

# Encontrando o melhor lambda usando cross-validation
cv.lasso <- cv.glmnet(x, y, alpha = 1, family = "binomial")

plot(cv.lasso)

# Modelo final
modelo <- glmnet(x, y, alpha = 1, family = "binomial",
                lambda = cv.lasso$lambda.min)


# Coefic# Coefic# Coeficientes do modelo
coefs = coef(modelo)

# Odds
odds_ratios <- exp(coefs)
odds_ratios


dados <- read_excel("C:/Users/luiz1/OneDrive/Área de Trabalho/TERCEIRO PROJETO/S1_Dataset.xlsx")

dados_completo <- dados %>% dplyr::select(-id, -egfr1, -egfr3, -scr1)

# Remover a variável ID antes do modelo
dados_padronizados_lasso <- dados_completo %>% dplyr::select(-sex, -akd35, -akd50, -scr120_1, -egfr60_1, -viremia, -supressed, -phcr1, -bmi1, -age1)

# Identificando as variáveis numéricas
numericas = sapply(dados_padronizados_lasso, is.numeric)

# Padronizando
dados_padronizados_lasso[, numericas] <- scale(dados_padronizados_lasso[, numericas])

# Variável resposta seja fator (binária)
dados_padronizados_lasso$nephtox <- as.factor(dados_padronizados_lasso$nephtox)

# Transformar variáveis categóricas em fatores
cat_vars_padr <- names(dados_padronizados_lasso)[sapply(dados_padronizados_lasso, is.character) | sapply(dados_padronizados_lasso, is.factor)]
dados_padronizados_lasso[cat_vars_padr] <- lapply(dados_padronizados_lasso[cat_vars_padr], as.factor)

# Criar a fórmula do modelo com todas as variáveis preditoras
form_padr <- as.formula(paste("nephtox ~", paste(setdiff(names(dados_padronizados_lasso), "nephtox"), collapse = " + ")))

# Ajustar o modelo de regressão logística
modelo_completo_padr_lasso <- glm(form_padr, data = dados_padronizados_lasso, family = binomial)

summary(modelo_completo_padr_lasso)

# Diagnóstico Completo com check_model
check_model(modelo_completo_padr_lasso)

# Calcular Odds Ratio e Intervalo de Confiança
odds_ratios_padr <- exp(cbind(OR = coef(modelo_completo_padr_lasso), confint(modelo_completo_padr_lasso)))


# Exibir resultados
odds_ratios_padr

# Gráfico dos efeitos:
ggpredict(modelo_completo_padr_lasso) %>%
  plot()
