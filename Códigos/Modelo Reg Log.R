# Carregar pacotes necessários
library(dplyr)
library(ggplot2)
library(car)        # Para VIF (multicolinearidade)
library(pscl)       # Para pseudo R²
library(pROC)       # Para curva ROC
library(readxl)
library(performance)
library(ggeffects)
library(DHARMa)  # Para diagnóstico gráfico de resíduos
library(MASS)
library(glmnet)

# Carregando a base
dados <- read_excel("C:/Users/luiz1/OneDrive/Área de Trabalho/TERCEIRO PROJETO/S1_Dataset.xlsx")

dados_completo <- dados %>% dplyr::select(-id,-egfr1, -egfr3, -scr1)

# Remover a variável ID antes do modelo
dados_padronizados <- dados_completo %>% dplyr::select(-vl1, -akd35, -akd50, -scr120_1, -egfr60_1, -viremia, -uacr1, -time)
dados_padronizados

# Identificando as variáveis numéricas
numericas = sapply(dados_padronizados, is.numeric)

# Padronizando
dados_padronizados[, numericas] <- scale(dados_padronizados[, numericas])

# Variável resposta seja fator (binária)
dados_padronizados$nephtox <- as.factor(dados_padronizados$nephtox)
dados_completo$nephtox <- as.factor(dados_completo$nephtox)

# Transformar variáveis categóricas em fatores
cat_vars_padr <- names(dados_padronizados)[sapply(dados_padronizados, is.character) | sapply(dados_padronizados, is.factor)]
dados_padronizados[cat_vars_padr] <- lapply(dados_padronizados[cat_vars_padr], as.factor)

cat_vars_completo <- names(dados_completo)[sapply(dados_completo, is.character) | sapply(dados_completo, is.factor)]
dados_completo[cat_vars_completo] <- lapply(dados_completo[cat_vars_completo], as.factor)

# Criar a fórmula do modelo com todas as variáveis preditoras
form_padr <- as.formula(paste("nephtox ~", paste(setdiff(names(dados_padronizados), "nephtox"), collapse = " + ")))
form_compl <- as.formula(paste("nephtox ~", paste(setdiff(names(dados_completo), "nephtox"), collapse = " + ")))

# Ajustar o modelo de regressão logística
modelo_completo_padr <- glm(form_padr, data = dados_padronizados, family = binomial)
modelo_completo <- glm(form_compl, data = dados_completo, family = binomial)

summary(modelo_completo_padr)
summary(modelo_completo)

modelo_step_padr <- stepAIC(modelo_completo_padr, direction = "both")
modelo_step_comp <- stepAIC(modelo_completo, direction = "both")

summary(modelo_step_padr)
summary(modelo_step_comp)

# Diagnóstico Completo com check_model
check_model(modelo_step_padr)
check_model(modelo_step_comp)

# Calcular Odds Ratio e Intervalo de Confiança
odds_ratios_padr <- exp(cbind(OR = coef(modelo_step_padr), confint(modelo_step_padr)))
odds_ratios_compl <- exp(cbind(OR = coef(modelo_step_comp), confint(modelo_step_comp)))


# Exibir resultados
odds_ratios_padr
odds_ratios_compl

# Gráfico dos efeitos:
ggpredict(modelo_step_comp) %>%
  plot()
