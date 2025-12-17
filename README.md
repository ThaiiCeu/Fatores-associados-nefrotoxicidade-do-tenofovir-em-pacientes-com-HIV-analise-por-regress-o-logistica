# Identificação de fatores associados à nefrotoxicidade associada ao TDF em pacientes com HIV

## 📌 Visão geral
Este projeto tem como objetivo identificar **fatores clínicos, laboratoriais e demográficos associados à nefrotoxicidade** em pacientes vivendo com HIV em uso de **Fumarato de Tenofovir Disoproxil (TDF)**. Para isso, foram aplicados **modelos de Regressão Logística** clássicos e penalizados, com foco em interpretação clínica e desempenho preditivo.

Os dados utilizados são **dados reais** de pacientes acompanhados longitudinalmente, contendo informações renais, metabólicas, virológicas e antropométricas.

---

## 📊 Dados
- **Fonte**: Repositório Dryad
- **Amostra**: 203 pacientes vivendo com HIV
- **Desfecho**: Nefrotoxicidade (binário: sim/não)
- **Variáveis**: 26 no total
  - Demográficas: sexo, idade
  - Clínicas: IMC, pressão arterial média
  - Laboratoriais: creatinina, eGFR, CD4, carga viral, colesterol, glicemia
  - Marcadores renais: UACR, PHCR, AKD35, AKD50

---

## 🔍 O que foi feito
1. **Análise descritiva completa**
   - Comparação entre grupos com e sem nefrotoxicidade
   - Tabelas, boxplots e gráficos de barras
   - Avaliação de distribuição, dispersão e outliers

2. **Análise de correlação**
   - Identificação de colinearidade entre marcadores renais (ex.: creatinina e eGFR)

3. **Modelagem estatística**
   - Regressão Logística:
     - Modelo completo
     - Modelo completo padronizado
     - Modelos com seleção de variáveis (Stepwise)
   - Regressão Logística Penalizada:
     - Lasso (regularização L1)

4. **Avaliação dos modelos**
   - Odds Ratio (OR) e IC 95%
   - Diagnóstico: resíduos, VIF, observações influentes
   - Métricas preditivas:
     - Acurácia
     - Sensibilidade
     - Especificidade
     - Precisão
     - Curva ROC

---

## 🧠 Métodos utilizados
- Regressão Logística (Máxima Verossimilhança)
- Regularização L1 (Lasso)
- Seleção de variáveis Stepwise (AIC)
- Padronização de variáveis quantitativas
- Avaliação diagnóstica e validação gráfica

---

## 🏆 Principais resultados

### 🔹 Modelo Stepwise Padronizado (melhor desempenho geral)
**Variáveis associadas à nefrotoxicidade:**
- **Sexo masculino** → fator protetor (OR ≈ 0.32)
- **Idade** → aumento do risco (OR ≈ 1.93)
- **Baixo peso (IMC)** → forte fator de risco (OR ≈ 3.52)
- **Creatinina sérica (scr10ct)** → aumento do risco
- **eGFR (egfr10ct)** → associado ao desfecho

**Desempenho preditivo:**
- Acurácia: **56,6%**
- Sensibilidade: **68,9%**
- Especificidade: **53,2%**
- Melhor equilíbrio entre identificação de casos positivos e negativos

---

### 🔹 Modelo Lasso
**Variáveis selecionadas:**
- eGFR (egfr10ct)
- Creatinina sérica (scr10ct)

**Interpretação:**
- Modelos mais simples e parcimoniosos
- Boa identificação de marcadores renais diretos
- Menor desempenho preditivo global

**Desempenho:**
- Acurácia: **51,7%**
- Sensibilidade: **53,3%**
- Precisão baixa (muitos falsos positivos)

---

## 📈 Comparação dos modelos
| Modelo | Acurácia | Sensibilidade | Destaque |
|------|---------|---------------|----------|
| Stepwise | ⭐ 56,6% | ⭐ 68,9% | Melhor desempenho geral |
| Lasso | 51,7% | 53,3% | Modelo mais simples |

➡️ O **modelo Stepwise** mostrou-se mais adequado para este conjunto de dados, com melhor capacidade de identificar pacientes com nefrotoxicidade.

---

## 🧪 Principais conclusões
- A nefrotoxicidade associada ao TDF é multifatorial
- **Idade avançada**, **baixo peso** e **alterações renais** são fatores-chave
- Modelos interpretáveis (como regressão logística com seleção de variáveis) são mais eficazes neste contexto do que modelos excessivamente penalizados
- O estudo reforça a importância do monitoramento renal em pacientes em uso de TDF

---

## 🎯 Impacto
- Apoio à tomada de decisão clínica
- Identificação precoce de grupos de risco
- Contribuição metodológica para aplicações de regressão logística na saúde

---

## 📚 Ferramentas e referências
- Linguagem: **R**
- Métodos estatísticos: Regressão Logística, Lasso
- Referências principais:
  - Hosmer, Lemeshow & Sturdivant (2013)
  - Hastie, Tibshirani & Friedman (2009)
  - Santos et al. (2023)

---

📌 *Projeto desenvolvido como Relatório Semestral – Bolsa COPE-Conecta*
```
