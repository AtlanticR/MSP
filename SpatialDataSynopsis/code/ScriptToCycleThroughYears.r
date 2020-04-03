increment <- c(8, 8, 8, 13, 5, 7)
yearb <- c(1970, 1978, 1986, 1994, 2007, 2012)


for (i in 1:length(increment)) {
  i2 <- increment[i]
  year <- yearb[i]
  for (x in 1:i2) {
    print(year)
    year <- year + 1
  }  
  print("break")
}