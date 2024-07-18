
pacman::p_load(VGAM)

library(modelsummary)
library(estimatr)
library(openxlsx)
library(VGAM)
library(stas)

options(scipen=2)

#25.15

#(a)

# load the data
data = read.xlsx("cps09mar/cps09mar.xlsx")

men = data[data$female==0, ]

probitReg <- glm(union ~ age+education+hisp+)
