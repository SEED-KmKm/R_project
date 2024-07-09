pacman::p_load(tidyverse, readxl, xtable, ivreg, gmm, modelsummary)

# Load data
ajr_df <- read_excel("AJR2001.xlsx")

# Prepare data
ajr_df <- ajr_df %>% 
  mutate(
    logmortality = as.numeric(logmort0),
    logmortality_sq = logmortality^2)

# First Stage and F-stat
fstg <- lm(risk ~ logmortality, data = ajr_df)
fstg_sq <- lm(risk ~ logmortality + logmortality_sq, data = ajr_df)

msummary(list(fstg, fstg_sq), gof_map = c("nobs"), stars = TRUE)

fstat_fstg <- summary(fstg)$fstatistic[1]
fstat_fstg_sq <- summary(fstg_sq)$fstatistic[1]

fstat_fstg
fstat_fstg_sq

# 2SLS
tsls <- ivreg(loggdp ~ risk | logmortality, data = ajr_df)
tsls_sq <- ivreg(loggdp ~ risk | logmortality + logmortality_sq, data = ajr_df)

msummary(list(tsls, tsls_sq), gof_map = c("nobs"), stars = TRUE)

# Extract residuals from 2SLS
tsls_resid <- residuals(tsls)
tsls_sq_resid <- residuals(tsls_sq)

# Compute weighting matrix for GMM using 2SLS residuals
compute_weighting_matrix <- function(instrument_matrix, residuals) {
  n <- nrow(instrument_matrix)
  omega <- t(instrument_matrix) %*% diag(residuals^2) %*% instrument_matrix / n
  weight_matrix <- solve(omega)
  return(weight_matrix)
}

instrument_matrix <- model.matrix(~ logmortality, data = ajr_df)
instrument_matrix_sq <- model.matrix(~ logmortality + logmortality_sq, data = ajr_df)

weight_matrix <- compute_weighting_matrix(instrument_matrix, tsls_resid)
weight_matrix_sq <- compute_weighting_matrix(instrument_matrix_sq, tsls_sq_resid)

# GMM using 2SLS weighting matrix
model_gmm <- gmm(loggdp ~ risk, ~logmortality, data = ajr_df,  weightsMatrix = weight_matrix)
model_gmm_sq <- gmm(loggdp ~ risk, ~logmortality + logmortality_sq, data = ajr_df,  weightsMatrix = weight_matrix_sq)

# Results
msummary(
  list("2SLS without square" = tsls, "GMM without square" = model_gmm, 
       "2SLS with square" = tsls_sq, "GMM with square" = model_gmm_sq), 
  gof_map = c("nobs"), stars = TRUE, output = "latex")

# Summaries
summary(model_gmm)
summary(model_gmm_sq)