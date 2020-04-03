# The term Rj^2 is the R^2 from a linear regression model in which:
# covariate Xj is used as a response variable
# and all other covariates as explanatory variables

#  the variance inflation factor (VIF): the square root of 1/(1 - Rj^2)

# from Zuur et al. 2010

library(car) # contains 'vif' function

library(raster)


#   VIF between enviromental variables in different seasons          
################################################################################################################

setwd("C:/Users/KONRADC/Desktop/SDMs_Angelia/Data/Shelf_Study_Area/Environmental_Layers/Tif_files/")

#Read in raster files --------------------------------------------------------
bathy <- raster("bathy.tif")

FallChlP <- raster("chl_pers_autumn.tif")
SummerChlP <- raster("chl_pers_summer.tif")
SpringChlP <- raster("chl_pers_spring.tif")
WinterChlP <- raster("chl_pers_winter.tif")

FallSST <- raster("sst_autumn.tif")
SummerSST <- raster("sst_summer.tif")
SpringSST <- raster("sst_spring.tif")
WinterSST <- raster("sst_winter.tif")

CTI <- raster("tci.tif")

crs(bathy) <- "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0" 
crs(FallChlP) <- "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0" 
crs(SummerChlP) <- "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0" 
crs(SpringChlP) <- "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0" 
crs(WinterChlP) <- "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0" 
crs(FallSST) <- "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0" 
crs(SummerSST) <- "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0" 
crs(SpringSST) <- "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0" 
crs(WinterSST) <- "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0" 
crs(CTI) <- "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0" 

# Fall -------------------------------------------------------------------------------------------------
FallVars <- stack(CTI, bathy, FallChlP, SummerChlP, FallSST)
FallVars <- setMinMax(FallVars) #Defining Min/Max Values, by default the raster doesn't have the min / max values associated with it's attributes.
#plot(FallVars)
FallVals <- values(FallVars)

i <- which(is.na(FallVals[,1]) == F)
ii <- which(is.na(FallVals[,2]) == F)
iii <- which(is.na(FallVals[,3]) == F)
iv <- which(is.na(FallVals[,4]) == F)
v <- which(is.na(FallVals[,5]) == F)

# NotAllNAs <- union(i,union(ii,union(iii,union(iv,v))))
NoNAs <- intersect(i,intersect(ii,intersect(iii,intersect(iv,v))))

FallVals <- FallVals[NoNAs,] # remove NA values


Fmod1 <- lm(tci ~ bathy + chl_pers_autumn + chl_pers_summer + sst_autumn, data = as.data.frame(FallVals))
Fmod2 <- lm(bathy ~ tci + chl_pers_autumn + chl_pers_summer + sst_autumn, data = as.data.frame(FallVals))
Fmod3 <- lm(chl_pers_autumn ~ tci + bathy + chl_pers_summer + sst_autumn, data = as.data.frame(FallVals))
Fmod4 <- lm(chl_pers_summer ~ tci + bathy + chl_pers_autumn + sst_autumn, data = as.data.frame(FallVals))
Fmod5 <- lm(sst_autumn ~ tci + bathy + chl_pers_autumn + chl_pers_summer, data = as.data.frame(FallVals))

VIF_cti <- 1/(1-summary(Fmod1)$r.squared)
VIF_bath <- 1/(1-summary(Fmod2)$r.squared)
VIF_CPa <- 1/(1-summary(Fmod3)$r.squared)
VIF_CPs <- 1/(1-summary(Fmod4)$r.squared)
VIF_SST <- 1/(1-summary(Fmod5)$r.squared)


# Summer -------------------------------------------------------------------------------------------------
SumVars <- stack(CTI, bathy, SummerChlP, SpringChlP, SummerSST)
SumVars <- setMinMax(SumVars)
SumVals <- values(SumVars)

i <- which(is.na(SumVals[,1]) == F)
ii <- which(is.na(SumVals[,2]) == F)
iii <- which(is.na(SumVals[,3]) == F)
iv <- which(is.na(SumVals[,4]) == F)
v <- which(is.na(SumVals[,5]) == F)

# NotAllNAs <- union(i,union(ii,union(iii,union(iv,v))))
NoNAs <- intersect(i,intersect(ii,intersect(iii,intersect(iv,v))))

SumVals <- SumVals[NoNAs,] # remove NA values


Fmod1 <- lm(tci ~ bathy + chl_pers_summer + chl_pers_spring + sst_summer, data = as.data.frame(SumVals))
Fmod2 <- lm(bathy ~ tci + chl_pers_summer + chl_pers_spring + sst_summer, data = as.data.frame(SumVals))
Fmod3 <- lm(chl_pers_summer ~ tci + bathy + chl_pers_spring + sst_summer, data = as.data.frame(SumVals))
Fmod4 <- lm(chl_pers_spring ~ tci + bathy + chl_pers_summer + sst_summer, data = as.data.frame(SumVals))
Fmod5 <- lm(sst_summer ~ tci + bathy + chl_pers_summer + chl_pers_spring, data = as.data.frame(SumVals))

VIF_cti <- 1/(1-summary(Fmod1)$r.squared)
VIF_bath <- 1/(1-summary(Fmod2)$r.squared)
VIF_CPa <- 1/(1-summary(Fmod3)$r.squared)
VIF_CPs <- 1/(1-summary(Fmod4)$r.squared)
VIF_SST <- 1/(1-summary(Fmod5)$r.squared)

VIF_cti
VIF_bath
VIF_CPa
VIF_CPs
VIF_SST 

# Spring -------------------------------------------------------------------------------------------------
SprVars <- stack(CTI, bathy, SpringChlP, WinterChlP, SpringSST)
SprVars <- setMinMax(SprVars)
SprVals <- values(SprVars)

i <- which(is.na(SprVals[,1]) == F)
ii <- which(is.na(SprVals[,2]) == F)
iii <- which(is.na(SprVals[,3]) == F)
iv <- which(is.na(SprVals[,4]) == F)
v <- which(is.na(SprVals[,5]) == F)

# NotAllNAs <- union(i,union(ii,union(iii,union(iv,v))))
NoNAs <- intersect(i,intersect(ii,intersect(iii,intersect(iv,v))))

SprVals <- SprVals[NoNAs,] # remove NA values


Fmod1 <- lm(tci ~ bathy + chl_pers_spring + chl_pers_winter + sst_spring, data = as.data.frame(SprVals))
Fmod2 <- lm(bathy ~ tci + chl_pers_spring + chl_pers_winter + sst_spring, data = as.data.frame(SprVals))
Fmod3 <- lm(chl_pers_spring ~ tci + bathy + chl_pers_winter + sst_spring, data = as.data.frame(SprVals))
Fmod4 <- lm(chl_pers_winter ~ tci + bathy + chl_pers_spring + sst_spring, data = as.data.frame(SprVals))
Fmod5 <- lm(sst_spring ~ tci + bathy + chl_pers_spring + chl_pers_winter, data = as.data.frame(SprVals))

VIF_cti <- 1/(1-summary(Fmod1)$r.squared)
VIF_bath <- 1/(1-summary(Fmod2)$r.squared)
VIF_CPa <- 1/(1-summary(Fmod3)$r.squared)
VIF_CPs <- 1/(1-summary(Fmod4)$r.squared)
VIF_SST <- 1/(1-summary(Fmod5)$r.squared)

VIF_cti
VIF_bath
VIF_CPa
VIF_CPs
VIF_SST 

#summary(Fmod1)
# vif(Fmod1) # also this function, but it seems to give values per pairwise variable combo, rather than overall
# vif(Fmod2)
