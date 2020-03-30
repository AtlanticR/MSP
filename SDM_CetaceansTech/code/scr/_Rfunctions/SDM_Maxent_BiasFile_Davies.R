
### Define the variables of interest Will be defined in the function call  *********************************************************************
SDM_Maxent_BiasFile_Davies<-function(SoI, season_char, biasres){
graphics.off()
  SoI_out<-gsub(" ", "_", SoI)

  season_CHAR<-toupper(season_char)

  if (season_CHAR == "AUTUMN"){
    season<-c(9,10,11)
  } else if (season_CHAR == "SUMMER"){
  season<-c(6,7,8)
  } else if (season_CHAR == "SPRING"){
  season <-c(3,4,5)
  } else if (season_WHAT == "WINTER") {
    season<-c(1,2,12)

  }


setwd("C:/SDMs_Angelia/Data")

###**************************************************************************************************##
##------------------------------------PART I: Open CSV file with sightings of your species of interest ---
## The minimum infomration that you need is species, latitude and longitude
# head(MarMammSightings)
#     
#               Unknown Dolphin -43.71667 43.86667 1999     7             
#                   Minke Whale -44.33833 44.27833 2006     8                  
#                   Minke Whale -44.33833 44.28000 2007     7                  

MarMammSightings <- read.csv("CetaceanData/Correct_data/MarMammSightings.csv", header=TRUE, na.strings = "NA", sep=",", as.is=T, strip.white=T)
MarMammSightings$Species <- factor(MarMammSightings$Species)
MarMammSightings$Platform <- factor(MarMammSightings$Platform) # should check this with Catalina


###**************************************************************************************************##
#####---------------------------------PART II: Select species you want to model and season------------#
#(1975 - 2015)

MarMamm_Season <- MarMammSightings[MarMammSightings$Month %in% season, ]
Total_Whales_in_Season<-table(MarMamm_Season$Species)
print(Total_Whales_in_Season)


###**************************************************************************************************##
###------------------------------------PART III: Read/select your predictors/environmental layers------------------------#
# CG prepared the environmental layers for MaxEnt using ArcMap. There are several tutorial to do this in more detail e.g. http://clp-foss4g-workshop.readthedocs.io/en/latest/maxent_data_prep.html
# This crip will read the ones for the cetacean SDM - DO NOT DISTRIBUTE THIS LAYERS (contact: Cesar Fuentes Yavo for SST and CHL)

#Once layers are ready, place them in the folder (predictors) and read them all:  
rasterdir <- "Davies/ASCII_for_MaxEnt/"
predictorfiles = list.files(path = paste(rasterdir, sep=""), 
                            pattern = "\\.asc$", full.names = F)



# #****************************** Predictor Files *******************************************


  if (season_CHAR == "AUTUMN"){
              predictorfiles_season <- predictorfiles[  predictorfiles != "chl_magn_spring.asc" &
                                     predictorfiles != "chl_pers_winter.asc" &
                                     predictorfiles != "chl_magn_winter.asc" &
                                     predictorfiles != "sst_summer.asc" &
                                     predictorfiles != "chl_concen_spring.asc" &
                                     predictorfiles != "chl_concen_summer.asc" &
                                     predictorfiles != "chl_magn_spring.asc" &
                                     predictorfiles != "chl_pers_spring.asc" &
                                     predictorfiles !=  "chl_magn_wint.asc" &
                                     predictorfiles !=  "sst_spring.asc" &
                                     predictorfiles !=  "chl_pers_wint.asc" &
                                     predictorfiles !=  "sst_winter.asc"]  
predictors = c()
for(x in predictorfiles_season)
{
  predname = paste(rasterdir, x, sep="")
  predictors = stack(c(predictors, raster(predname)))
}
predictors <- setMinMax(predictors)
predictors
x11()
plot(predictors)

  } else if (season_CHAR == "SUMMER"){
predictorfiles_season <- predictorfiles[predictorfiles != "chl_concen_spring.asc" &
                                  predictorfiles != "chl_concen_summer.asc" &
                                  predictorfiles != "chl_magn_autumn.asc" &
                                  predictorfiles != "chl_pers_autumn.asc" &
                                  predictorfiles != "sst_autumn.asc" &
                                  predictorfiles !=  "chl_magn_wint.asc" &
                                  predictorfiles !=  "sst_spring.asc" &
                                  predictorfiles !=  "chl_magn_winter.asc" &
                                  predictorfiles !=  "chl_pers_wint.asc" &
                                  predictorfiles !=  "chl_pers_winter.asc" &
                                  predictorfiles !=  "sst_winter.asc"] 
predictors = c()
for(x in predictorfiles_season)
{
  predname = paste(rasterdir, x, sep="")
  predictors = stack(c(predictors, raster(predname)))
}
predictors <- setMinMax(predictors)
predictors 
x11()
plot(predictors) #Check that these are the preictors you want to include in you model!


  } else if (season_CHAR == "SPRING"){
predictorfiles_season  <- predictorfiles[predictorfiles != "chl_concen_summer.asc" &
                              predictorfiles != "chl_concen_spring.asc" &
                              predictorfiles != "chl_magn_wint.asc" &
                              predictorfiles != "chl_magn_fall.asc" &
                              predictorfiles != "chl_pers_autumn.asc" &
                              predictorfiles != "chl_magn_summer.asc" &
                              predictorfiles != "chl_magn_autumn.asc" &
                              predictorfiles != "chl_per_summer.asc" &
                              predictorfiles != "sst_autumn.asc" &
                              predictorfiles != "sst_summer.asc" &
                              predictorfiles !=  "sst_winter.asc"] 
predictors = c()
for(x in predictorfiles_season)
{
  predname = paste(rasterdir, x, sep="")
  predictors = stack(c(predictors, raster(predname)))
}
predictors <- setMinMax(predictors)
predictors 
x11()
plot(predictors) #Check that these are the preictors you want to include in you model!

  } 





###**************************************************************************************************##
###------------------------------------PART V: Select only sightings that are inside of the study area-------#
StudyArea <- readOGR("Shelf_Study_Area/Environmental_Layers/StudyArea", "StudyArea")
crs(StudyArea) <- "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0" 
x11()
plot(StudyArea)
#pts <- points(MarMamm_Season$Longitude, MarMamm_Season$Latitude, pch=20, col="red", cex=0.5) 
pts <- SpatialPoints(MarMamm_Season[c(2,3)])
options(warn=1)
pts <- SpatialPointsDataFrame(pts, MarMamm_Season)
proj4string(pts) = proj4string(StudyArea)
#points(pts[StudyArea,], pch = 3)
inside.StudyArea <- !is.na(over(pts, as(StudyArea, "SpatialPolygons"))) 
sum(inside.StudyArea) #Number of sightings inside of the study area that will be used in SDM
points(pts[!inside.StudyArea, ], pch=20, col="red", cex=0.5) #--> will not be inlucuded in MaxEnt
sum(!inside.StudyArea)
points(pts[inside.StudyArea, ], pch=20, col="green", cex=0.5) #--> will not be included in Maxent
MarMamm_Season_NWAO <- pts[inside.StudyArea, ]
#str(MarMamm_Season_NWAO)
#str(MarMamm_Season)
MarMamm_Season_NWAO <- as.data.frame(MarMamm_Season_NWAO)
Whales_in_Study_Area_during_Season<-table(MarMamm_Season_NWAO$Species)
print(Whales_in_Study_Area_during_Season)
#write.csv(MarMamm_Summer_NWAO, "D:/GIS/Data/MarMammData/MarMamm_Summer.csv", row.names=FALSE)
#*****************************


###**************************************************************************************************##
###------------------------------------PART VI: Select species to be modeled: TGS------------------------#
table(MarMamm_Season_NWAO$Species)
hires.r <-lowres.r <-raster(predictors) #to slice up the lowres.r grid into finer grid (matching to enviro layers) so that it would run in MaxEnt.
#res(lowres.r) <- c(0.5, 0.5) #aggregates all the records (except the target species) in a 0.5 degree X 0.5 degree grid to get densities.  Hence, that is the grid that we report, since that is what the densities come from.
# Modify according with your preferences/hypothesis:

if (biasres == '1km'){
res(lowres.r) <- c(0.009, 0.009) # 0.0090 degrees -> 1 km
} else if (biasres == '2.5km') {
res(lowres.r) <- c(0.0224, 0.0224) # 0.0224 degrees - 2.5 km
} else if (biasres == '5km') {
res(lowres.r) <- c(0.0448, 0.0448) # 0.0224 degrees - 5 km
}


dat <- maxentData(db = MarMamm_Season_NWAO, hires.r = hires.r,
                   lowres.r = lowres.r, species = SoI)
#str(dat)
 
TGS_Season <- MarMamm_Season_NWAO[MarMamm_Season_NWAO$Species %in% SoI, ]
#str(TGS_Season)   

###**************************************************************************************************##
###---------------------PART VII: Visualize sightings and bias map that will be used in SDM: ALWAYS a good idea!------#
plot(dat$bias, pch=20,col="lightgrey") #-->plot bias file
plot(StudyArea, add=TRUE)
points(dat$target, pch = 20, col = "red", cex=0.5)


###**************************************************************************************************##
###---------------------PART VIII: Sub-sampling per species - code ammended from http://www.molecularecologist.com/2013/04/species-distribution-models-in-r/
# Mixed random- systematic sampling of TGS records – 
# MaxEnt discards redundant records that occur in a single cell (records with the same geographic coordinates); 
# however, it does not discard multiple records that can occur in neighbouring cells and thus may over represent 
# regions with high sampling efforts (Kadmon et al.  2004). With the aim of reducing the spatial aggregation of 
# records in neighbouring cells, we randomly subsampled one whale sighting on a predetermined grid (Fourcade et al. 2014).
# To explore how the size of the grids may impact the SDM results, we conducted this subsampling at three different spatial
# resolutions: 1, 2.5, and 5 km. In this way, we used four datasets for each species to model their suitable habitat: 
#   not sampled, and sampled at 1, 2.5 and 5 km spatial resolutions.

#Check sample sizes first!
locs <- dat$target
locs <-as.data.frame(locs)
dim(locs)
#str(locs)
head(locs)

#uncomment the following to do each sub-sample at different scales

# ############## S u b  - s a m p l e    0.0090 degrees - 1 km
# ############## S u b  - s a m p l e    0.0090 degrees - 1 km
# longrid = seq(-67.81438,-41.98105,0.00895335303071)
# latgrid = seq(39.09167,60.99167,0.00895335303071)

Xbounds<-c(-67.81438,-41.98105)
Ybounds<- c(39.09167,60.99167)
res <-  0.00895335303071

subs_1km<-subsample_whales_in_grid(locs, Xbounds, Ybounds, res)



# # identify points within each grid cell, draw one at random
# subs_1km = c()

# for(i in 1:(length(longrid)-1)){
#   for(j in 1:(length(latgrid)-1)){
#     gridsq = subset(locs, Latitude > latgrid[j]
#                     & Latitude < latgrid[j+1]
#                     & Longitude > longrid[i]
#                     & Longitude < longrid[i+1])
#     if(dim(gridsq)[1]>0){subs_1km = rbind(subs_1km, gridsq[sample(1:dim(gridsq)[1],1 ), ])}
#   }
# }

dim(subs_1km) # confirm that you have a smaller dataset than you started with
dim(locs)

subs_1km <- SpatialPoints(subs_1km)

#points(locs$Longitude, locs$Latitude, col='deeppink', pch=1, cex=0.1)
#points(subs$Longitude, subs$Latitude, col='black', pch=20, cex=0.01)
#str(subs)
#
# ############## S u b  - s a m p l e    0.0224 degrees - 2.5 km
# longrid = seq(-67.81438,-41.98105,0.022383382576775)
# latgrid = seq(39.09167,60.99167,0.022383382576775)

Xbounds<-c(-67.81438,-41.98105)
Ybounds<- c(39.09167,60.99167)
res <-  0.022383382576775

subs_2.5km<-subsample_whales_in_grid(locs, Xbounds, Ybounds, res)


# # identify points within each grid cell, draw one at random
# subs_2.5km = c()

# for(i in 1:(length(longrid)-1)){
#   for(j in 1:(length(latgrid)-1)){
#     gridsq = subset(locs, Latitude > latgrid[j]
#                     & Latitude < latgrid[j+1]
#                     & Longitude > longrid[i]
#                     & Longitude < longrid[i+1])
#     if(dim(gridsq)[1]>0){subs_2.5km = rbind(subs_2.5km, gridsq[sample(1:dim(gridsq)[1],1 ), ])}
#   }
# }

dim(subs_2.5km) # confirm that you have a smaller dataset than you started with
dim(locs)

subs_2.5km <- SpatialPoints(subs_2.5km)

#points(locs$Longitude, locs$Latitude, col='deeppink', pch=1, cex=0.1)
#points(subs$Longitude, subs$Latitude, col='black', pch=20, cex=0.01)
#str(subs)

############## S u b  - s a m p l e    0.0448 degrees - 5 km


Xbounds<-c(-67.81438,-41.98105)
Ybounds<- c(39.09167,60.99167)
res <-  0.04476676515355

subs_5km<-subsample_whales_in_grid(locs, Xbounds, Ybounds, res)


# subs_5km = c()

# for(i in 1:(length(longrid)-1)){
#   for(j in 1:(length(latgrid)-1)){
#     gridsq = subset(locs, Latitude > latgrid[j] 
#                     & Latitude < latgrid[j+1] 
#                     & Longitude > longrid[i] 
#                     & Longitude < longrid[i+1])    
#     if(dim(gridsq)[1]>0){subs_5km = rbind(subs_5km, gridsq[sample(1:dim(gridsq)[1],1 ), ])}
#   }
# }


dim(subs_5km) # confirm that you have a smaller dataset than you started with
dim(locs)

subs_5km <- SpatialPoints(subs_5km)

###**************************************************************************************************##



###**************************************************************************************************##
###------------------------------------PART IX: Run Model---------------------------------------------#
#http://www.recibio.net/wp-content/uploads/2014/11/Modelando-el-nicho-ecologico_MaribelArenasNavarro.pdf
#vignette('sdm', 'dismo')
# Following Phillips et al. (2006) and Merow et al. (2013), the MaxEnt runs were conducted using the following settings: 
#   selected random seed, 
#   maximum number of background points = 10,000 (a random sample of point locations from the landscape to represent the environmental conditions in the study area), 
#   regularization multiplier = 1 (included to reduce over-fitting), 
#   number of replicates = 100 (to do multiple runs for the same species/season as a means to provide averages of the results from all models created), 
#   no output grids, 
#   maximum iterations = 5000 (allows the model to have adequate opportunity for convergence), 
#   convergence threshold = 0.00001. 
#   To assess uncertainty in model predictions, cross-validation replication was used,which incorporates all available sightings, making better use of smaller data-sets
#   Cumulative output type was selected to visualize MaxEnt results; this output does not rely on post-processing assumptions and it is useful when illustrating potential species range boundaries 


# # ########## 2: No subsample, with bias file ################
model <- maxent(x = predictors, p = dat$target, removeDuplicates=TRUE, a = dat$bias,
                path=paste0("Output/Davies/", SoI_out, "/", season_char, "/Bias_", biasres, "/No_subsample"),
                args = c("-P", "-J", "replicates=100", "replicatetype=Crossvalidate",
                         "randomseed", "nooutputgrids",
                         "maximumiterations=5000",
                         "betamultiplier=1"))

map <- predict(model, predictors, progress='text', args=c("outputformat=raw"))
x11()
plot(map)
HSMap <- mean(map)
x11()
plot(HSMap)

x11()
plot(HSMap)
points(pts[inside.StudyArea, ], pch=20, col="black", cex=0.5)




HSMap_cumulative <- scaledCumsum(HSMap)
x11()
plot(HSMap_cumulative)
outfile = paste0("Output/Davies/", SoI_out, "/", season_char, "/Bias_", biasres, "/No_subsample/HSMap_cumulative_bias_",biasres,"_", SoI_out, "_", season_char, ".tif")
writeRaster(HSMap_cumulative, filename=outfile, overwrite=TRUE, format="GTiff", datatype="FLT4S")


# ########## 4: 1km subsample, with bias file ################

model <- maxent(x = predictors, p = subs_1km, removeDuplicates=TRUE, a = dat$bias,
                path=paste0("Output/Davies/", SoI_out, "/", season_char, "/Bias_",  biasres, "/Subsample_1km"),
                args = c("-P", "-J", "replicates=100", "replicatetype=Crossvalidate",
                         "randomseed", "nooutputgrids",
                         "maximumiterations=5000",
                         "betamultiplier=1"))

map <- predict(model, predictors, progress='text', args=c("outputformat=raw"))
plot(map)
HSMap <- mean(map)
plot(HSMap)
points(pts[inside.StudyArea, ], pch=20, col="black", cex=0.5)


HSMap_cumulative <- scaledCumsum(HSMap)
plot(HSMap_cumulative)

outfile = paste0("Output/Davies/", SoI_out, "/", season_char, "/Bias_", biasres, "/Subsample_1km/HSMap_cumulative_1kmsubsample_", biasres,"bias_",SoI_out, "_", season_char,   ".tif")
writeRaster(HSMap_cumulative, filename=outfile, overwrite=TRUE, format="GTiff", datatype="FLT4S")


# ########## 6: 2.5km subsample, with bias file ################

model <- maxent(x = predictors, p = subs_2.5km, removeDuplicates=TRUE, a = dat$bias,
                path=paste0("Output/Davies/", SoI_out, "/", season_char, "/Bias_",biasres, "/Subsample_2.5km"),
                args = c("-P", "-J", "replicates=100", "replicatetype=Crossvalidate",
                         "randomseed", "nooutputgrids",
                         "maximumiterations=5000",
                         "betamultiplier=1"))

map <- predict(model, predictors, progress='text', args=c("outputformat=raw"))
plot(map)
HSMap <- mean(map)
plot(HSMap)
points(pts[inside.StudyArea, ], pch=20, col="black", cex=0.5)

HSMap_cumulative <- scaledCumsum(HSMap)
plot(HSMap_cumulative)
outfile = paste0("Output/Davies/", SoI_out, "/", season_char, "/Bias_", biasres, "/Subsample_2.5km/HSMap_cumulative_2.5kmsubsample_", biasres,"bias_",SoI_out, "_", season_char,   ".tif")
writeRaster(HSMap_cumulative, filename=outfile, overwrite=TRUE, format="GTiff", datatype="FLT4S")


########## 8: 5km subsample, with bias file ################
model <- maxent(x = predictors, p = subs_5km, removeDuplicates=TRUE, a = dat$bias,
                path=paste0("Output/Davies/", SoI_out, "/", season_char, "/Bias_", biasres, "/Subsample_5km"),    
                args = c("-P", "-J", "replicates=100", "replicatetype=Crossvalidate",
                         "randomseed", "nooutputgrids",
                         "maximumiterations=5000", 
                         "betamultiplier=1"))

map <- predict(model, predictors, progress='text', args=c("outputformat=raw"))
#plot(map)
HSMap <- mean(map)
#plot(HSMap)
#points(pts[inside.StudyArea, ], pch=20, col="black", cex=0.5)


HSMap_cumulative <- scaledCumsum(HSMap)
#plot(HSMap_cumulative)
outfile = paste0("Output/Davies/", SoI_out, "/", season_char, "/Bias_", biasres, "/Subsample_5km/HSMap_cumulative_5kmsubsample_", biasres,"bias_",SoI_out, "_", season_char,   ".tif")
writeRaster(HSMap_cumulative, filename=outfile, overwrite=TRUE, format="GTiff", datatype="FLT4S")


}



#********************************************************************************************************************

# #testing
# # background data
# bg <- randomPoints(predictors, 1000)
# #simplest way to use 'evaluate'
# e1 <- evaluate(model, p=dat$target, a=dat$bias, x=predictors)
# # alternative 1
# # extract values
# pvtest <- data.frame(extract(predictors, occtest))
# avtest <- data.frame(extract(predictors, bg))
# e2 <- evaluate(model, p=pvtest, a=avtest)




