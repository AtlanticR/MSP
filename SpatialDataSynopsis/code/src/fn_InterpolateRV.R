Grid_fn <- function(data, grid, power, dist ) {
  # Interpolate the sample data (STDWGT) using the large extent grid
  # Using the same values for Power and Search Radius as Anna's script (idp and maxdist)
  test.idw <- gstat::idw(data$STDWGT ~ 1, data, newdata=grid, idp= power, maxdist = dist)
  
  
  # Convert IDW output to raster object then clip to Scotian Shelf
  r       <- raster(test.idw)
  r.m     <- mask(r, oceanMaskUTM)
  skew1 <- paste(Time1, speciescode[i],round(cellStats(r.m,stat = 'skew'),3),sep=":\t")
  skew_list1[[y]] <- skew1
  # create a quantile table (based on deciles for this particular grid)
  # rq <- quantile(r.m,prob = seq(0, 1, length = 10))
  # reclass_df =c(0, rq[1], 1,
  #               rq[1], rq[2], 2,
  #               rq[2], rq[3], 3,
  #               rq[3], rq[4], 4,
  #               rq[4], rq[5], 5,
  #               rq[5], rq[6], 6,
  #               rq[6], rq[7], 7,
  #               rq[7], rq[8], 8,
  #               rq[8], rq[9], 9,
  #               rq[9], rq[10], 10)
  # 
  # create a quantile table (based on 5 bins for this particular grid)
  rq <- quantile(r.m,prob = seq(0, 1, length = 5))
  reclass_df =c(0, rq[1], 1,
                rq[1], rq[2], 2,
                rq[2], rq[3], 3,
                rq[3], rq[4], 4,
                rq[4], rq[5], 5)
  
  
  reclass_m <- matrix(reclass_df,ncol = 3, byrow = TRUE)
  # using the decile values from this grid, reclassify into 10 levels
  reclass_r <- reclassify(r.m,reclass_m)
  # get the frequency table for reclass_r
  VATcount <- freq(reclass_r)
  
  # Export the raster
  # dir <- "U:/GIS/Projects/MSP/HotSpotCode/Output/"
  dir <- "./SpatialDataSynopsis/Output/"
  
  rtif <- paste(dir,"SP",speciescode[i],"_rclass_T",Time,".tif",sep = "")
  # tif <- paste(dir,Time1,"SP_",speciescode[i],"_2.tif",sep = "")
  # writeRaster(r.m,tif, overwrite = TRUE)
  # writeRaster(reclass_r,rtif, overwrite = TRUE, datatype = "INT1U")
  
  returnList <- list("rawRaster"= r,"raster" = reclass_r, "count" = VATcount, "skew" = skew_list1)
  
  return(returnList)
  
}