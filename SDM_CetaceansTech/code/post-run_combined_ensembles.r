###########################################################################################
###########################################################################################
### by Phil Greyson
### This code imports a series of cetecean seasonal suitable habitat tif files (simple 1/0 grids)
### - adds the seasonal grids of each species together, 
### - converts the summed grid to a 1/0 grid
### - and exports the resultant grid as a new tif
###
### The indexing and naming of the grids was done in a spreadsheet using text functions
### 
###########################################################################################
###########################################################################################

library(raster)

# Import tifs as raster objects
r1_1 <- raster("C:/CetaceanTiffs/Atlantic_White-sided_Dolphin_Autumn_ensemble.tif")
r1_2 <- raster("C:/CetaceanTiffs/Atlantic_White-sided_Dolphin_Summer_ensemble.tif")
r2_3 <- raster("C:/CetaceanTiffs/Common_Dolphin_Autumn_ensemble.tif")
r2_4 <- raster("C:/CetaceanTiffs/Common_Dolphin_Summer_ensemble.tif")
r3_5 <- raster("C:/CetaceanTiffs/Fin_Whale_Autumn_ensemble.tif")
r3_6 <- raster("C:/CetaceanTiffs/Fin_Whale_Summer_ensemble.tif")
r4_7 <- raster("C:/CetaceanTiffs/Harbour_Porpoise_Autumn_ensemble.tif")
r4_8 <- raster("C:/CetaceanTiffs/Harbour_Porpoise_Summer_ensemble.tif")
r5_9 <- raster("C:/CetaceanTiffs/Humpback_Whale_Autumn_ensemble.tif")
r5_10 <- raster("C:/CetaceanTiffs/Humpback_Whale_Spring_ensemble.tif")
r5_11 <- raster("C:/CetaceanTiffs/Humpback_Whale_Summer_ensemble.tif")
r6_12 <- raster("C:/CetaceanTiffs/Minke_Whale_Autumn_ensemble.tif")
r6_13 <- raster("C:/CetaceanTiffs/Minke_Whale_Summer_ensemble.tif")
r7_14 <- raster("C:/CetaceanTiffs/Pilot_Whale_Autumn_ensemble.tif")
r7_15 <- raster("C:/CetaceanTiffs/Pilot_Whale_Spring_ensemble.tif")
r7_16 <- raster("C:/CetaceanTiffs/Pilot_Whale_Summer_ensemble.tif")
# Sum the relevant rasters
r1 <- r1_1 + r1_2
r2 <- r2_3 + r2_4
r3 <- r3_5 + r3_6
r4 <- r4_7 + r4_8
r5 <- r5_10 + r5_11 + r5_9
r6 <- r6_12 + r6_13
r7 <- r7_15 + r7_16 + r7_14
# Convert all values greater than zero to 1
r1 <- r1 >0
r2 <- r2 >0
r3 <- r3 >0
r4 <- r4 >0
r5 <- r5 >0
r6 <- r6 >0
r7 <- r7 >0
# Write to a tif file
writeRaster(r1,"C:/CetaceanTiffs/Atlantic_WhiteSided_Dolphin_Sum.tif",options=c('TFW=YES'))
writeRaster(r2,"C:/CetaceanTiffs/Common_Dolphin_Sum.tif",options=c('TFW=YES'))
writeRaster(r3,"C:/CetaceanTiffs/Fin_Whale_Sum.tif",options=c('TFW=YES'))
writeRaster(r4,"C:/CetaceanTiffs/Harbour_Porpoise_Sum.tif",options=c('TFW=YES'))
writeRaster(r5,"C:/CetaceanTiffs/Humpback_Whale_Sum.tif",options=c('TFW=YES'))
writeRaster(r6,"C:/CetaceanTiffs/Minke_Whale_Sum.tif",options=c('TFW=YES'))
writeRaster(r7,"C:/CetaceanTiffs/Pilot_Whale_Sum.tif",options=c('TFW=YES'))



