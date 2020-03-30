#load the package 
library(raster) 
#read your file 
ifn <-'HSMap_cumulative_1kmbias_5kmsubsample_Blue_Whale_Summer.tif'
idn <-'U:/SPERA/SDM/Data/Output/Blue_Whale/Smmer/Bias_1km/Subsample_5km/'

 setwd("U:/SPERA/SDM/Data/Output/Blue_Whale/Summer/Bias_1km/Subsample_5km")

r <- raster(ifn, package="raster") 

ofn <-substr(ifn,1, nchar(ifn)-3)
ofn <-paste0(ofn,"asc")
#export it to asc (ESRI ASCII) 
writeRaster(r, filename=ofn, format = "ascii", datatype='INT4S', overwrite=TRUE) #Done