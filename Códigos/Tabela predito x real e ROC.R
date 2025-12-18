library(caret)
library(ggplot2)
library(dplyr)
library(reshape2)
library(pROC)

# ---- Supondo que você já tenha os modelos ajustados ----
# Predições dos modelos
pred_lasso <- ifelse(predict(modelo_completo_padr_lasso, type = "response") > 0.20397, "yes","no")
pred_padr  <- ifelse(predict(modelo_step_padr, type = "response") > 0.16713, "yes","no")

#Escolhi os cortes com base nos historgramas das variaveis preditas (Elas tiveram uma forma simétrica
# a direita, então escolhi pegar o valor da mediana para representar o corte)

# Matrizes de confusão
cm_lasso <- confusionMatrix(factor(pred_lasso), factor(y), positive = "yes")
cm_padr  <- confusionMatrix(factor(pred_padr), factor(y), positive = "yes")

# Extrair métricas
metrics <- data.frame(
  Modelo = c("Lasso", "Padrão"),
  Acuracia = c(cm_lasso$overall["Accuracy"], cm_padr$overall["Accuracy"]),
  Sensibilidade = c(cm_lasso$byClass["Sensitivity"], cm_padr$byClass["Sensitivity"]),
  Especificidade = c(cm_lasso$byClass["Specificity"], cm_padr$byClass["Specificity"]),
  Precisao = c(cm_lasso$byClass["Pos Pred Value"], cm_padr$byClass["Pos Pred Value"]),
  PrevNegativa = c(cm_lasso$byClass["Neg Pred Value"], cm_padr$byClass["Neg Pred Value"])
)

# Transformar em formato longo
metrics_long <- melt(metrics, id.vars = "Modelo")

# Gráfico comparativo
ggplot(metrics_long, aes(x = variable, y = value, fill = Modelo)) +
  geom_bar(stat = "identity", position = position_dodge()) +
  labs(x = "Métrica", y = "Valor", title = "Comparação de desempenho: Lasso vs Padrão") +
  scale_y_continuous(labels = scales::percent_format(accuracy = 1)) +
  theme_minimal()

prob_step <- predict(modelo_step_padr, type = "response")

prob_lasso <- predict(modelo_completo_padr_lasso, type = "response")

# --- Curvas ROC ---

# Garantir que y está como fator (yes = positivo)
y <- factor(y, levels = c("no", "yes"))

roc_step <- roc(y, as.numeric(prob_step), levels = c("no", "yes"), direction = "<")
roc_lasso <- roc(y, as.numeric(prob_lasso), levels = c("no", "yes"), direction = "<")

# Plotando as duas curvas juntas
plot(roc_step, col = "blue", lwd = 2, main = "Curvas ROC - Step vs Lasso")
plot(roc_lasso, col = "red", lwd = 2, add = TRUE)

legend("bottomright",
       legend = c(
         paste("Step (AUC =", round(auc(roc_step), 3), ")"),
         paste("Lasso (AUC =", round(auc(roc_lasso), 3), ")")
       ),
       col = c("blue", "red"),
       lwd = 2)


