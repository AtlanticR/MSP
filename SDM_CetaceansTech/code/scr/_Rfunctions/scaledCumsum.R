###**************************************************************************************************##
scaledCumsum <- function(x){
  z <- values(x)
  nas <- is.na(z)
  sorted <- sort(z, index.return = TRUE, na.last = NA, method = "quick")
  cum <- cumsum(sorted$x)
  z2 <- rep(NA, length(z))
  z2[!nas][sorted$ix] <- cum/max(cum)*100

  values(x)=z2
  return(x)
}

