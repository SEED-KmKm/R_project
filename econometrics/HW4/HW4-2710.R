
pacman::p_load(VGAM)

library(modelsummary)
library(estimatr)
library(openxlsx)
library(VGAM)

options(scipen=2)

#27.10

#(a)

# load the data
data = read.xlsx("cps09mar/cps09mar.xlsx")

# extract data whose education is equal to or more than 12
edu12 <- data[data$education >= 12,]
edu12$edusq <- (edu12$education)^2
edu12$wage <- (edu12$earnings)/(edu12$hours*edu12$week)
edu12$lwage <- log(edu12$wage)


initialReg <- lm_robust(lwage ~ education + edusq, data=edu12)
summary(initialReg)

#(b)

edu12$cwage <- pmin(edu12$lwage, 3.4)

capReg <- lm_robust(cwage ~ education+ edusq, data=edu12)
summary((capReg))

#(c)

omitted <- edu12[edu12$cwage<3.4,]
omitReg <- lm_robust(cwage ~ education+ edusq, data=omitted)
summary(omitReg)

#(d)
tobitReg <- vglm(cwage ~ education+edusq, tobit(Upper=3.4), trace=TRUE, data=edu12)
summary(tobitReg)
