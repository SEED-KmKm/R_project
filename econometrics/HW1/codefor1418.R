#code for 14-18


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

data <- read.xlsx("FRED-QD/FRED-QD.xlsx")

pnfix <- data$pnfix
p_len=length(pnfix)

pnfix_lag1 <- pnfix[1:p_len-1]
pnfix_lag0 <- pnfix[2:p_len]

length(pnfix)

q_grow=(pnfix_lag0-pnfix_lag1)/(pnfix_lag1)
q_len=length(q_grow)
plot(q_grow, ylab = "quartely growth rate", type="l")


#---(b)

ql0=q_grow[5:q_len]
ql1=q_grow[4:(q_len-1)]
ql2=q_grow[3:(q_len-2)]
ql3=q_grow[2:(q_len-3)]
ql4=q_grow[1:(q_len-4)]

grrData <- data.frame(ql0, ql1, ql2, ql3, ql4)

#pnfix_l0 <- pnfix[5:p_len]
#pnfix_l1 <- pnfix[4:(p_len-1)]
#pnfix_l2 <- pnfix[3:(p_len-2)]
#pnfix_l3 <- pnfix[2:(p_len-3)]
#pnfix_l4 <- pnfix[1:(p_len-4)]

ql0

#lag4data <- data.frame(pnfix_l0, pnfix_l1, pnfix_l2, pnfix_l3, pnfix_l4)


result <- lm_robust(ql0~ql1+ql2+ql3+ql4, grrData)
summary(result)

(c)


rlt_for_NW<-lm(ql0~ql1+ql2+ql3+ql4, grrData)
NW <- coeftest(result, vcov = NeweyWest(rlt_for_NW, lag = 5))

NW

(d)

(e)



irf=rep(0,14)
irf[4]=1

for (i in 5:14){
  i
  irf[i]=result$coefficients[2]*irf[i-1]+result$coefficients[3]*irf[i-2]+result$coefficients[4]*irf[i-3]+result$coefficients[5]*irf[i-4]
}
irf
plot(c(1:10), irf[5:14], type="l", ylab="irf", xlab="Impulse Response")




###16-12

Indexes=c("rpi", "indpro", "houst", "hwi", "clf16ov", "claimsx", "ipfuels")

FRED_MD <- read.xlsx("FRED-MD/FRED-MD.xlsx")

data1612 <- FRED_MD[Indexes]
data1612["logrpi"] <- log(data1612["rpi"])

newIndexes=c("logrpi", "indpro", "houst", "hwi", "clf16ov", "claimsx", "ipfuels")

par(mfrow=c(1,1))
for (index in newIndexes){
  plot(data1612[[index]], type="l", ylab=index)
}

for (index in newIndexes){
  print(sprintf("-------------%s--------------", index))
  sprintf("")
  dt = data1612[[index]]
  ar_result = ar(dt, method="ols")
  order = ar_result$order
  print(sprintf("order=%d", order))
  
  adf.test(dt, nlag=(order+1))
}
