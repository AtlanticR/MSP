#March 2020
rm(list=ls())
setwd("D:/SDMs_Angelia/Data/Output/ISO3000_SA/CC")
# Import libraries
library(raster)

# SDM outputs simplified to arbitrary categories
# One map per species and season assembled by combining areas of high suitability habitat 
# (100 to 60%) from all scenarios of sampling bias correction. 
# These consolidated outputs indicate priority areas where monitoring efforts may be targeted

################################################################################################################
SP<-"White-beaked_Dolphin"
Season<-"Summer"

#Bias1km
SP_Season_bias1km_nosub <- raster(paste0(SP, "/", Season, "/Bias_1km/No_subsample/HSMap_cumulative_bias_1km_", SP, "_", Season, ".tif"))
SP_Season_bias1km_sub1km <- raster(paste0(SP, "/", Season, "/Bias_1km/Subsample_1km/HSMap_cumulative_1kmsubsample_1kmbias_", SP, "_", Season, ".tif"))
SP_Season_bias1km_sub2.5km <- raster(paste0(SP, "/", Season, "/Bias_1km/Subsample_2.5km/HSMap_cumulative_2.5kmsubsample_1kmbias_", SP, "_", Season, ".tif"))
SP_Season_bias1km_sub5km <- raster(paste0(SP, "/", Season, "/Bias_1km/Subsample_5km/HSMap_cumulative_5kmsubsample_1kmbias_", SP, "_", Season, ".tif"))

crs(SP_Season_bias1km_nosub) <- "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0" 
crs(SP_Season_bias1km_sub1km) <- "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0" 
crs(SP_Season_bias1km_sub2.5km) <- "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0" 
crs(SP_Season_bias1km_sub5km) <- "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"

#Bias2.5km
SP_Season_bias2.5km_nosub <- raster(paste0(SP, "/", Season, "/Bias_2.5km/No_subsample/HSMap_cumulative_bias_2.5km_", SP, "_", Season, ".tif"))
SP_Season_bias2.5km_sub1km <- raster(paste0(SP, "/", Season, "/Bias_2.5km/Subsample_1km/HSMap_cumulative_1kmsubsample_2.5kmbias_", SP, "_", Season, ".tif"))
SP_Season_bias2.5km_sub2.5km <- raster(paste0(SP, "/", Season, "/Bias_2.5km/Subsample_2.5km/HSMap_cumulative_2.5kmsubsample_2.5kmbias_", SP, "_", Season, ".tif"))
SP_Season_bias2.5km_sub5km <- raster(paste0(SP, "/", Season, "/Bias_2.5km/Subsample_5km/HSMap_cumulative_5kmsubsample_2.5kmbias_", SP, "_", Season, ".tif"))

crs(SP_Season_bias2.5km_nosub) <- "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0" 
crs(SP_Season_bias2.5km_sub1km) <- "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0" 
crs(SP_Season_bias2.5km_sub2.5km) <- "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0" 
crs(SP_Season_bias2.5km_sub5km) <- "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"

#Bias5km
SP_Season_bias5km_nosub <- raster(paste0(SP, "/", Season, "/Bias_5km/No_subsample/HSMap_cumulative_bias_5km_", SP, "_", Season, ".tif"))
SP_Season_bias5km_sub1km <- raster(paste0(SP, "/", Season, "/Bias_5km/Subsample_1km/HSMap_cumulative_1kmsubsample_5kmbias_", SP, "_", Season, ".tif"))
SP_Season_bias5km_sub2.5km <- raster(paste0(SP, "/", Season, "/Bias_5km/Subsample_2.5km/HSMap_cumulative_2.5kmsubsample_5kmbias_", SP, "_", Season, ".tif"))
SP_Season_bias5km_sub5km <- raster(paste0(SP, "/", Season, "/Bias_5km/Subsample_5km/HSMap_cumulative_5kmsubsample_5kmbias_", SP, "_", Season, ".tif"))

crs(SP_Season_bias5km_nosub) <- "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0" 
crs(SP_Season_bias5km_sub1km) <- "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0" 
crs(SP_Season_bias5km_sub2.5km) <- "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0" 
crs(SP_Season_bias5km_sub5km) <- "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"

#NoBias
SP_Season_nobias_nosub <- raster(paste0(SP, "/", Season, "/NoBias/No_subsample/HSMap_cumulative_nobias_nosubsample_", SP, "_", Season, ".tif"))
SP_Season_nobias_sub1km <- raster(paste0(SP, "/", Season, "/NoBias/Subsample_1km/HSMap_cumulative_1kmsubsample_nobias_", SP, "_", Season, ".tif"))
SP_Season_nobias_sub2.5km <- raster(paste0(SP, "/", Season, "/NoBias/Subsample_2.5km/HSMap_cumulative_2.5kmsubsmaple_nobias_", SP, "_", Season, ".tif"))
SP_Season_nobias_sub5km <- raster(paste0(SP, "/", Season, "/NoBias/Subsample_5km/HSMap_cumulative_5kmsubsample_nobias_", SP, "_", Season, ".tif"))

crs(SP_Season_nobias_nosub) <- "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0" 
crs(SP_Season_nobias_sub1km) <- "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0" 
crs(SP_Season_nobias_sub2.5km) <- "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0" 
crs(SP_Season_nobias_sub5km) <- "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"


SP_Season_HSmaps <- stack( SP_Season_nobias_nosub, SP_Season_nobias_sub1km, SP_Season_nobias_sub2.5km, SP_Season_nobias_sub5km,
                           SP_Season_bias1km_nosub, SP_Season_bias1km_sub1km, SP_Season_bias1km_sub2.5km, SP_Season_bias1km_sub5km, 
                           SP_Season_bias2.5km_nosub, SP_Season_bias2.5km_sub1km, SP_Season_bias2.5km_sub2.5km, SP_Season_bias2.5km_sub5km,
                           SP_Season_bias5km_nosub, SP_Season_bias5km_sub1km, SP_Season_bias5km_sub2.5km, SP_Season_bias5km_sub5km)

SP_Season_HSmaps <- setMinMax(SP_Season_HSmaps) #Defining Min/Max Values, by default the raster doesn't have the min / max values associated with it's attributes.
r <- SP_Season_HSmaps
r[r<=60]=0
r[r>60]=1
r_ensemble <- max(r)
#plot(r_ensemble)
outfile = paste0("D:/SDMs_Angelia/Data/Output/ISO3000_SA/CC/ensemble","/" ,SP, "_", Season,"_ensemble.tif") 
writeRaster(r_ensemble, filename=outfile, overwrite=TRUE, format="GTiff", datatype="FLT4S")






