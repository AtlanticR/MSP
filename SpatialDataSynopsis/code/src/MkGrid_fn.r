
# Create an empty grid from the samples, 100,000 cells
# It's necessary to create an empty grid of all samples initially so that the individual
# date range grids have the same extents
# If the extents aren't identical the SUM function won't work

MakeEmptyGrid_fn <- function(data, ncells) {
  grd2 <- as.data.frame(spsample(data, "regular", n=ncells))
  names(grd2) <- c("X", "Y")
  coordinates(grd2) <- c("X", "Y")
  gridded(grd2) <- TRUE  # Create SpatialPixel object
  proj4string(grd2) <- proj4string(grd2) <- CRS("+init=epsg:26920") # define grd2 projection (UTM Zone 20)
  fullgrid(grd2) <- TRUE  # Create SpatialGrid object
  return(grd2)
}