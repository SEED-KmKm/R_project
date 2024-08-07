pacman::p_load(tidyverse, readxl, xtable, ivreg, gmm, modelsummary)

# import data
ajr_dt <- read_excel("AJR2001.xlsx")

# convert data format
ajr_dt$logmrtl = as.numeric(ajr_dt$logmort0)
ajr_dt$logmrtl_sq = as.numeric(ajr_dt$logmort0)^2

# 1st stage
stg1 <- lm(risk ~ logmrtl, data = ajr_dt)
stg1_sq <- lm(risk ~ logmrtl + logmrtl_sq, data = ajr_dt)

msummary(list(stg1, stg1_sq), gof_map = c("nobs"), stars = TRUE)

fstat_stg1 <- summary(stg1)$fstatistic[1]
fstat_stg1_sq <- summary(stg1_sq)$fstatistic[1]

fstat_stg1
fstat_stg1_sq

# 2SLS
tsls <- ivreg(loggdp ~ risk | logmrtl, data = ajr_dt)
tsls_sq <- ivreg(loggdp ~ risk | logmrtl + logmrtl_sq, data = ajr_dt)

msummary(list(tsls, tsls_sq), gof_map = c("nobs"), stars = TRUE)

# 2SLS resiguals
tsls_rd <- residuals(tsls)
tsls_sq_rd <- residuals(tsls_sq)

# Compute weighting matrix for GMM using 2SLS residuals
effiMat <- function(ins_mat, residuals) {
  n <- nrow(ins_mat)
  omega <- t(ins_mat) %*% diag(residuals^2) %*% ins_mat / n
  weight <- solve(omega)
  return(weight)
}

ins_mat <- model.matrix(~ logmrtl, data = ajr_dt)
ins_mat_sq <- model.matrix(~ logmrtl + logmrtl_sq, data = ajr_dt)

weimat <- effiMat(ins_mat, tsls_rd)
weimat_sq <- effiMat(ins_mat_sq, tsls_sq_rd)

# GMM using 2SLS weighting matrix
model_gmm <- gmm(loggdp ~ risk, ~logmrtl, data = ajr_dt,  weightsMatrix = weimat)
model_gmm_sq <- gmm(loggdp ~ risk, ~logmrtl + logmrtl_sq, data = ajr_dt,  weightsMatrix = weimat_sq)

# Results
msummary(
  list("2SLS without square" = tsls, "GMM without square" = model_gmm, 
       "2SLS with square" = tsls_sq, "GMM with square" = model_gmm_sq), 
  gof_map = c("nobs"), stars = TRUE)

# Summaries
summary(model_gmm)
summary(model_gmm_sq)
