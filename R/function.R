

fit_rls <- function(model, data, meanstructure=FALSE, int.ov.free=FALSE, std.lv=FALSE) {

  fml <- cfa(model = mymodel, data=rls_data, meanstructure=meanstructure, int.ov.free = int.ov.free, std.lv = std.lv, estimator = "ML")
  fitted(fml)[1]

  S_N<-var(data)
  P<-ncol(data)
  N<-nrow(data)

  Sigma_hat0 <- fitted(fml)[1]
  Sigma_hat <- matrix(unlist(Sigma_hat0), ncol = P, byrow = TRUE) ## BQZ: turn them it matrix form
  R <- (S_N-Sigma_hat)%*%solve(Sigma_hat)
  T_RLS  <- (N-1)/2*sum(diag( R%*%R ))


  # Get degrees of freedom for the test
  df_RLS <- lavInspect(fml, "test")[[1]]$df

  # Calculate p-value
  p_value <- 1 - pchisq(T_RLS, df_RLS)

  # Return a list with results
  result <- list(T_RLS = T_RLS, p_value = p_value)
  return(result)

}



