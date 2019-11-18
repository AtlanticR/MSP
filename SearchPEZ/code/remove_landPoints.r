# Remove land data from the dataframe

remove_landPoints <- function(df,land) {
  
  # subset points to have only lat and lon
  ptsLL=df[,c("LATITUDE","LONGITUDE")]
  
  # convert to spatial points with the same projection as land
  pts= SpatialPoints(ptsLL,proj4string=CRS(proj4string(land)))
  
    # index for points in the water
  ipw=which(is.na(over(pts,land)$Shape_Length))
  
  dfWater=df[ipw,]
  
  return(dfWater)
  
}