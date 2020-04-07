#June 2016
#C Gomez
rm(list=ls())
setwd("C:/Users/KONRADC/Desktop/SDMs_Angelia/Data/Output/ISO3000_SA/CC/")

# Import libraries
library(raster)

library(rgdal) #,lib.loc="C:/Users/VanderlaanA/Documents/R/win-library/3.2")
options(java.parameters = "-Xmx1g" )
library(rJava)
library(maptools)
#source('D:/GIS/Data/HighstatLibV7.R')
library(RColorBrewer) 
P4S.latlon <- CRS("+proj=longlat +datum=WGS84")
#library(spcosa) # for random sampling - not used here
require(maps)
require(mapdata)
require(dismo)# dismo has the SDM analyses we"ll need
library(squash) #colours for maps
library(GISTools)

#################################################################################################################
#Analysis of MaxEnt Results
#################################################################################################################



#   Analysis of spatial correlation between maps obtained using different settings          
################################################################################################################
SP<-"Harbour_Porpoise"
Season<-"Autumn"

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
#plot(SP_Season_HSmaps)

Covariance <- layerStats(SP_Season_HSmaps, 'cov', na.rm=TRUE) 
write.csv(Covariance,  paste0(SP,"/", Season, "/" , SP, "_", Season,  "_Covariance.csv"))
PearsonCorrelation <- layerStats(SP_Season_HSmaps, 'pearson', na.rm=TRUE) 
write.csv(PearsonCorrelation, paste0(SP,"/", Season, "/" , SP, "_", Season, "_PearsonCorrelation.csv"))

#####Plot all maps
#display.brewer.all()
col=jet(11)
brk <- c(0,10, 20,30, 40,50, 60, 70, 80, 90, 100)
#plot(SP_Season, col=col, breaks=brk, main="")
plot(SP_Season_HSmaps, col=col, breaks=brk, main="")
# legend( par()$usr[2], 44,
#         legend = c("Very high", "High", "Medium", "Low", "Very low"), 
#         fill = col)

#plot (NBW, zlim=c(40,60), add = TRUE)

