
# Create an empty grid from the samples, 100,000 cells
# It's necessary to create an empty grid of all samples initially so that the individual
# date range grids have the same extents
# If the extents aren't identical the SUM function won't work

SelectRV_fn <- function(season, sampletype, ncells) {
  GSMISSIONS <- GSMISSIONS[GSMISSIONS$SEASON==season,]
  GSXTYPE <- GSXTYPE[GSXTYPE$XTYPE==sampletype,]
  self_filter(keep_nullsets = FALSE,quiet = TRUE)
  
  # Keep only the columns necessary
  # ("MISSION" "SETNO" "SDATE" "LATITUDE" "LONGITUDE")
  GSINF_all <- dplyr::select(GSINF,1:3,33:34)
  #names(GSINF_all)
  
  # Convert to the SpatialPointsFeature
  # using SP package to create a SPATIAL OBJECT
  # Convert to the Spatial Object
  coordinates(GSINF_all) <- ~LONGITUDE+LATITUDE
  proj4string(GSINF_all) <- CRS("+init=epsg:4326") # Define coordinate system (WGS84)
  GSINF_allUTM <- spTransform(GSINF_all,CRS("+init=epsg:26920")) # Project to UTM
  
  grd2 <- as.data.frame(spsample(GSINF_allUTM, "regular", n=ncells))
  names(grd2) <- c("X", "Y")
  coordinates(grd2) <- c("X", "Y")
  gridded(grd2) <- TRUE  # Create SpatialPixel object
  proj4string(grd2) <- proj4string(grd2) <- CRS("+init=epsg:26920") # define grd2 projection (UTM Zone 20)
  fullgrid(grd2) <- TRUE  # Create SpatialGrid object
  return(grd2)
}