###**************************************************************************************************##
####------------------------------------PART IV: Creates function to select non-target species and bias file------------------------#
# Bias file - sightings used icome often from opportunistic surveys and thus do not have a measure of survey effort. 
#Sightings of cetacean species other than the ones that will be modeled are available, and we term these 
#non-target group species (non-TGS). This section creates a sampling distribution bias map 
#by plotting these non-TGS records in the study area. 

maxentData <- function(db = NULL, # provide mammal database here
                       hires.r = NULL, # high resolution raster (must match predictors raster)
                       lowres.r = NULL, # low resolution raster
                       species = NULL # focal species
) {
  
  target <- db[db$Species == species , c("Longitude", "Latitude")] # grabs data from specific species
  ts <- db[db$Species != species , ] # grabs all other species data
  x <- rasterize(ts[, c("Longitude", "Latitude")], lowres.r, fun = sum) # rasterize using big grid
  x[x > 0] <- 1
  bias <- resample(x, hires.r, method = "ngb") # match resolution of small grid
  crs(bias) <- proj4string(hires.r)
  bias <- randomPoints(bias, 10000)
  list(target = SpatialPoints(target), bias = SpatialPoints(bias)) # return data in a list
  
}
