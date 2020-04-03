
# figure out blue whale sd...
library(plyr)
library(rgdal)
options(java.parameters = "-Xmx1g" )
library(rJava)
library(maptools)
library(RColorBrewer) 
P4S.latlon <- CRS("+proj=longlat +datum=WGS84")
require(maps)
require(mapdata)
require(dismo)# dismo has the SDM analyses we"ll need
library(squash) #colours for maps

#################################################################################################################
#Summary of MaxEnt Results
#################################################################################################################

directory<-"C:/Users/KONRADC/Desktop/SDMs_Angelia/Data/Output/ISO3000_SA/CC/"

SoI<-c("Blue Whale")
Season<-"Summer"

# rows with species 75-99 have:
# X.training.samples = 174 (instead of 173)
# X.test.samples = 1 (instead of 2)
# AUC.standard.deviation = -1 (instead of small positive values)

# or 


SoI<-c("Killer Whale")

# rows with species 83-99 have:
# X.training.samples = 182 (instead of 181)
# X.test.samples = 1 (instead of 2)
# AUC.standard.deviation = -1 (instead of small positive values)


# or

SoI<-c("Fin Whale")

# rows with species 8-99 have:
# 2285 X.training.samples (instead of 2284)
# X.test.samples = 23 (instead of 24)
# all AUC.standard.deviation > 0 (range 0.036-0.069)





# number of training and test samples doesn't directly relate to number of sightings... (sei whale in summer = 631 records)



# Run function ----------------------------------------

  SoI_out<-gsub(" ", "_", SoI)
  
  season_char<-toupper(Season)
  
  setwd(directory)
  
  #Bias1km
  biasres<-"1km"
  SoI_bias1km_nosub <- read.csv(paste0(SoI_out, "/", season_char, "/Bias_", biasres, "/No_subsample/maxentResults.csv"), header=TRUE, na.strings = "NA", sep=",", as.is=T, strip.white=T)
  SoI_bias1km_nosub$ID <- "SoI_bias1km_nosub"
  
  summary(SoI_bias1km_nosub$AUC.Standard.Deviation)
  hist(SoI_bias1km_nosub$AUC.Standard.Deviation)
  summary(as.factor(SoI_bias1km_nosub$X.Training.samples))
  

  #Bias2.5km
  biasres<-"2.5km"
  SoI_bias2.5km_nosub <- read.csv(paste0(SoI_out, "/", season_char, "/Bias_", biasres, "/No_subsample/maxentResults.csv"), header=TRUE, na.strings = "NA", sep=",", as.is=T, strip.white=T)
  SoI_bias2.5km_nosub$ID <- "SoI_bias2.5km_nosub"

  