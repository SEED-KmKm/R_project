#code for 23-8


c=c(1,2,3)
d <- c-3
e <- rep(0,9)
sum(c)

1/3*5


#---(a)



library(openxlsx)
library(estimatr)
library(lmtest)
library(sandwich)
library(plm)
library(stats)
library(aTSA)
options(scipen=3)

data <- read.xlsx("PSS2017/PSS2017.xlsx")

data$EC_c_alt_nm <- as.numeric(data$EC_c_alt)
data$EC_d_alt_nm <- as.numeric(data$EC_d_alt)
data$EG_total_nm <- as.numeric(data$EG_total)

result <- nls(
  log(EG_total_nm) ~ beta + (v / rho) * log(alpha * EC_c_alt_nm^rho + (1 - alpha) * EC_d_alt_nm^rho),
  start = list(rho = 0.3, v = 1.0, alpha = 0.3, beta = 1.6),
  trace = TRUE,
  data = data
)


coef(result)




curve((1/4)*x^4, -4,4)
