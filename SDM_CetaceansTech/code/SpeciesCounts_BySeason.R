
setwd("C:/Users/KONRADC/Desktop/SDMs_Angelia/Data")

###**************************************************************************************************##
##------------------------------------PART I: Open CSV file with sightings of your species of interest ---

MarMammSightings <- read.csv("CetaceanData/Correct_data/MarMammSightings.csv", header=TRUE, na.strings = "NA", sep=",", as.is=T, strip.white=T)
MarMammSightings$Species <- factor(MarMammSightings$Species)

###**************************************************************************************************##
#####---------------------------------PART II: Select species you want to model and season------------#
#(1975 - 2015)

MarMamm_Fall <- MarMammSightings[MarMammSightings$Month %in% c(9,10,11), ]
MarMamm_Summer <- MarMammSightings[MarMammSightings$Month %in% c(6,7,8), ]
MarMamm_Spring <- MarMammSightings[MarMammSightings$Month %in% c(3,4,5), ]
MarMamm_Winter <- MarMammSightings[MarMammSightings$Month %in% c(1,2,12), ]

#MarMamm_Season <- MarMammSightings[MarMammSightings$Month %in% season, ]
#Total_Whales_in_Season<-table(MarMamm_Season$Species)
#print(Total_Whales_in_Season)

###------------------------------------PART V: Select only sightings that are inside of the study area-------#

library(rgdal)
StudyArea <- readOGR("Shelf_Study_Area/Environmental_Layers/StudyArea", "StudyArea")

library(raster)
crs(StudyArea) <- "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0" 

# Fall
pts <- SpatialPoints(MarMamm_Fall[c(2,3)])
pts <- SpatialPointsDataFrame(pts, MarMamm_Fall)
proj4string(pts) = proj4string(StudyArea)
inside.StudyArea <- !is.na(over(pts, as(StudyArea, "SpatialPolygons"))) 
sum(inside.StudyArea) #Number of sightings inside of the study area that will be used in SDM

MarMamm_Fall_NWAO <- pts[inside.StudyArea, ]
MarMamm_Fall_NWAO <- as.data.frame(MarMamm_Fall_NWAO)
Whales_in_Study_Area_during_Fall<-table(MarMamm_Fall_NWAO$Species)
print(Whales_in_Study_Area_during_Fall)

# Summer
pts <- SpatialPoints(MarMamm_Summer[c(2,3)])
pts <- SpatialPointsDataFrame(pts, MarMamm_Summer)
proj4string(pts) = proj4string(StudyArea)
inside.StudyArea <- !is.na(over(pts, as(StudyArea, "SpatialPolygons"))) 
sum(inside.StudyArea) #Number of sightings inside of the study area that will be used in SDM

MarMamm_Summer_NWAO <- pts[inside.StudyArea, ]
MarMamm_Summer_NWAO <- as.data.frame(MarMamm_Summer_NWAO)
Whales_in_Study_Area_during_Summer<-table(MarMamm_Summer_NWAO$Species)
print(Whales_in_Study_Area_during_Summer)

# Spring
pts <- SpatialPoints(MarMamm_Spring[c(2,3)])
pts <- SpatialPointsDataFrame(pts, MarMamm_Spring)
proj4string(pts) = proj4string(StudyArea)
inside.StudyArea <- !is.na(over(pts, as(StudyArea, "SpatialPolygons"))) 
sum(inside.StudyArea) #Number of sightings inside of the study area that will be used in SDM

MarMamm_Spring_NWAO <- pts[inside.StudyArea, ]
MarMamm_Spring_NWAO <- as.data.frame(MarMamm_Spring_NWAO)
Whales_in_Study_Area_during_Spring<-table(MarMamm_Spring_NWAO$Species)
print(Whales_in_Study_Area_during_Spring)

# Winter
pts <- SpatialPoints(MarMamm_Winter[c(2,3)])
pts <- SpatialPointsDataFrame(pts, MarMamm_Winter)
proj4string(pts) = proj4string(StudyArea)
inside.StudyArea <- !is.na(over(pts, as(StudyArea, "SpatialPolygons"))) 
sum(inside.StudyArea) #Number of sightings inside of the study area that will be used in SDM

MarMamm_Winter_NWAO <- pts[inside.StudyArea, ]
MarMamm_Winter_NWAO <- as.data.frame(MarMamm_Winter_NWAO)
Whales_in_Study_Area_during_Winter<-table(MarMamm_Winter_NWAO$Species)
print(Whales_in_Study_Area_during_Winter)

# all seasons

fallsp <- as.data.frame(Whales_in_Study_Area_during_Fall)
colnames(fallsp) <- c("Species", "Fall Count")
summsp <- as.data.frame(Whales_in_Study_Area_during_Summer)
colnames(summsp) <- c("Species", "Summer Count")
sprisp <- as.data.frame(Whales_in_Study_Area_during_Spring)
colnames(sprisp) <- c("Species", "Spring Count")
wintsp <- as.data.frame(Whales_in_Study_Area_during_Winter)
colnames(wintsp) <- c("Species", "Winter Count")

sprisp$Species == summsp$Species
sprisp$Species == fallsp$Species
sprisp$Species == wintsp$Species

cbind(sprisp, summsp[2], fallsp[2], wintsp[2])

write.csv(cbind(sprisp, summsp[2], fallsp[2], wintsp[2]), "MarMammSigthings_StudyArea_BySeason.csv", row.names=FALSE)


###------------------------------------Plot data if needed -------#

x11()
plot(StudyArea)

pts <- SpatialPoints(MarMamm_Season[c(2,3)])
options(warn=1)
pts <- SpatialPointsDataFrame(pts, MarMamm_Season)
proj4string(pts) = proj4string(StudyArea)
inside.StudyArea <- !is.na(over(pts, as(StudyArea, "SpatialPolygons"))) 

sum(inside.StudyArea) #Number of sightings inside of the study area that will be used in SDM
sum(!inside.StudyArea)

points(pts[!inside.StudyArea, ], pch=20, col="red", cex=0.5) #--> will not be inlucuded in MaxEnt
points(pts[inside.StudyArea, ], pch=20, col="green", cex=0.5) #--> will be included in Maxent

#*****************************
