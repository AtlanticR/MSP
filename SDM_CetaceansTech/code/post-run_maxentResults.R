#May 2017
#A.S.M Vanderlaan
# June 2018 C.M.Konrad - slight modifications
library(plyr)
# # Import libraries
# library(read.csv)
library(rgdal)
options(java.parameters = "-Xmx1g" )
library(rJava)
library(maptools)
# source('D:/GIS/Data/HighstatLibV7.R')
library(RColorBrewer) 
P4S.latlon <- CRS("+proj=longlat +datum=WGS84")
#library(spcosa) # for random sampling - not used here
require(maps)
require(mapdata)
require(dismo)# dismo has the SDM analyses we"ll need
library(squash) #colours for maps
# library(GISTools)

#################################################################################################################
#Summary of MaxEnt Results
#################################################################################################################

# Define function ----------------------------------------

SDM_results<-function(SoI, Season, directory)
{
SoI_out<-gsub(" ", "_", SoI)

season_char<-toupper(Season)

if (season_char == "AUTUMN"){               ## I don't think this block of code actually gets applied anywhere...can I remove it?
  season<-c(9,10,11)
} else if (season_char == "SUMMER"){
  season<-c(6,7,8)
} else if (season_char == "SPRING"){
  season <-c(3,4,5)
} else if (season_char == "WINTER") {
  season<-c(1,2,12)
}

setwd(directory)


#Bias1km
biasres<-"1km"
SoI_bias1km_nosub <- read.csv(paste0(SoI_out, "/", season_char, "/Bias_", biasres, "/No_subsample/maxentResults.csv"), header=TRUE, na.strings = "NA", sep=",", as.is=T, strip.white=T)
SoI_bias1km_nosub$ID <- "SoI_bias1km_nosub"
SoI_bias1km_sub1km <- read.csv(paste0(SoI_out, "/", season_char, "/Bias_", biasres, "/Subsample_1km/maxentResults.csv"), header=TRUE, na.strings = "NA", sep=",", as.is=T, strip.white=T)
SoI_bias1km_sub1km$ID <- "SoI_bias1km_sub1km"
SoI_bias1km_sub2.5km <- read.csv(paste0(SoI_out, "/", season_char, "/Bias_", biasres, "/Subsample_2.5km/maxentResults.csv"), header=TRUE, na.strings = "NA", sep=",", as.is=T, strip.white=T)
SoI_bias1km_sub2.5km$ID <- "SoI_bias1km_sub2.5km"
SoI_bias1km_sub5km <- read.csv(paste0(SoI_out, "/", season_char, "/Bias_", biasres, "/Subsample_5km/maxentResults.csv"), header=TRUE, na.strings = "NA", sep=",", as.is=T, strip.white=T)
SoI_bias1km_sub5km$ID <- "SoI_bias1km_sub5km"

#Bias2.5km
biasres<-"2.5km"
SoI_bias2.5km_nosub <- read.csv(paste0(SoI_out, "/", season_char, "/Bias_", biasres, "/No_subsample/maxentResults.csv"), header=TRUE, na.strings = "NA", sep=",", as.is=T, strip.white=T)
SoI_bias2.5km_nosub$ID <- "SoI_bias2.5km_nosub"
SoI_bias2.5km_sub1km <- read.csv(paste0(SoI_out, "/", season_char, "/Bias_", biasres, "/Subsample_1km/maxentResults.csv"), header=TRUE, na.strings = "NA", sep=",", as.is=T, strip.white=T)
SoI_bias2.5km_sub1km$ID <- "SoI_bias2.5km_sub1km"
SoI_bias2.5km_sub2.5km <-  read.csv(paste0(SoI_out, "/", season_char, "/Bias_", biasres, "/Subsample_2.5km/maxentResults.csv"), header=TRUE, na.strings = "NA", sep=",", as.is=T, strip.white=T)
SoI_bias2.5km_sub2.5km$ID <- "SoI_bias2.5km_sub2.5km"
SoI_bias2.5km_sub5km <-  read.csv(paste0(SoI_out, "/", season_char, "/Bias_", biasres, "/Subsample_5km/maxentResults.csv"), header=TRUE, na.strings = "NA", sep=",", as.is=T, strip.white=T)
SoI_bias2.5km_sub5km$ID <- "SoI_bias2.5km_sub5km"

#Bias5km
biasres<-"5km"
SoI_bias5km_nosub <- read.csv(paste0(SoI_out, "/", season_char, "/Bias_", biasres, "/No_subsample/maxentResults.csv"), header=TRUE, na.strings = "NA", sep=",", as.is=T, strip.white=T)
SoI_bias5km_nosub$ID <- "SoI_bias5km_nosub"
SoI_bias5km_sub1km <- read.csv(paste0(SoI_out, "/", season_char, "/Bias_", biasres, "/Subsample_1km/maxentResults.csv"), header=TRUE, na.strings = "NA", sep=",", as.is=T, strip.white=T)
SoI_bias5km_sub1km$ID <- "SoI_bias5km_sub1km"
SoI_bias5km_sub2.5km <- read.csv(paste0(SoI_out, "/", season_char, "/Bias_", biasres, "/Subsample_2.5km/maxentResults.csv"), header=TRUE, na.strings = "NA", sep=",", as.is=T, strip.white=T)
SoI_bias5km_sub2.5km$ID <- "SoI_bias5km_sub2.5km"
SoI_bias5km_sub5km <- read.csv(paste0(SoI_out, "/", season_char, "/Bias_", biasres, "/Subsample_5km/maxentResults.csv"), header=TRUE, na.strings = "NA", sep=",", as.is=T, strip.white=T)
SoI_bias5km_sub5km$ID <- "SoI_bias5km_sub5km"

#NoBias

SoI_nobias_nosub <- read.csv(paste0(SoI_out, "/", season_char, "/NoBias/No_subsample/maxentResults.csv"), header=TRUE, na.strings = "NA", sep=",", as.is=T, strip.white=T)
SoI_nobias_nosub$ID <- "SoI_nobias_nosub"
SoI_nobias_sub1km <- read.csv(paste0(SoI_out,"/", season_char, "/NoBias/Subsample_1km/maxentResults.csv"), header=TRUE, na.strings = "NA", sep=",", as.is=T, strip.white=T)
SoI_nobias_sub1km$ID <- "SoI_nobias_sub1km"
SoI_nobias_sub2.5km <- read.csv(paste0(SoI_out,"/", season_char, "/NoBias/Subsample_2.5km/maxentResults.csv"), header=TRUE, na.strings = "NA", sep=",", as.is=T, strip.white=T)
SoI_nobias_sub2.5km$ID <- "SoI_nobias_sub2.5km"
SoI_nobias_sub5km <- read.csv(paste0(SoI_out,"/", season_char, "/NoBias/Subsample_5km/maxentResults.csv"), header=TRUE, na.strings = "NA", sep=",", as.is=T, strip.white=T)
SoI_nobias_sub5km$ID <- "SoI_nobias_sub5km"

SoI_HS_MaxentResults <- rbind(SoI_nobias_nosub, SoI_nobias_sub1km, SoI_nobias_sub2.5km, SoI_nobias_sub5km,
                    SoI_bias1km_nosub, SoI_bias1km_sub1km, SoI_bias1km_sub2.5km, SoI_bias1km_sub5km, 
                    SoI_bias2.5km_nosub, SoI_bias2.5km_sub1km, SoI_bias2.5km_sub2.5km, SoI_bias2.5km_sub5km,
                    SoI_bias5km_nosub, SoI_bias5km_sub1km, SoI_bias5km_sub2.5km, SoI_bias5km_sub5km)



if (season_char == "AUTUMN"){
  seasonvars <- c('chl_magn_autumn.contribution', 'chl_magn_summer.contribution', 'chl_pers_autumn.contribution', 'chl_pers_summer.contribution', 'sst_autumn.contribution')

} else if (season_char == "SUMMER"){
  seasonvars <- c('chl_magn_summer.contribution', 'chl_magn_spring.contribution', 'chl_pers_summer.contribution', 'chl_pers_spring.contribution', 'sst_summer.contribution')

} else if (season_char == "SPRING"){
  seasonvars <- c('chl_magn_spring.contribution', 'chl_magn_winter.contribution', 'chl_pers_spring.contribution', 'chl_pers_winter.contribution', 'sst_spring.contribution')

} else if (season_char == "WINTER") {
  seasonvars <- c('chl_magn_winter.contribution', 'chl_magn_autumn.contribution', 'chl_pers_winter.contribution', 'chl_pers_autumn.contribution', 'sst_winter.contribution')
}


#NBW_HS_MaxentResults <- as.data.frame(NBW_HS_MaxentResults)
SoI_HS_MaxentResults <- SoI_HS_MaxentResults[,c('ID','Species', 'Test.AUC', 'AUC.Standard.Deviation', 'bathy.contribution', seasonvars, 'tci_modified.contribution')] 
SoI_HS_MaxentResults <- SoI_HS_MaxentResults[SoI_HS_MaxentResults$Species ==c ('species (average)'),]
write.csv(SoI_HS_MaxentResults, paste0(SoI_out, "/", season_char, "/maxentResults.csv"), row.names = F)

}

#####################################################################

# Run function -----------------------------------------------------

directory<-"C:/Users/KONRADC/Desktop/SDMs_Angelia/Data/Output/ISO3000_SA/CC/"


# as a batch
allspp <- list.files(directory) # list of species with models run 

for(SoI in allspp){
  Seasons <- list.files(paste(directory, SoI, sep = "/"))   # list all seasons for each spp with models run 
  
  for(Season in Seasons){
    SDM_results(SoI, Season, directory)
  }
}

# or one by one

# summer

SoI<-c("Blue Whale")
Season<-"Summer"
SDM_results(SoI, Season, directory)

SoI<-c("Fin Whale")
Season<-"Summer"
SDM_results(SoI, Season, directory)

SoI<-c("Sei Whale")
Season<-"Summer"
SDM_results(SoI, Season, directory)

SoI<-c("Minke Whale")
Season<-"Summer"
SDM_results(SoI, Season, directory)

SoI<-c("Humpback Whale")
Season<-"Summer"
SDM_results(SoI, Season, directory)

SoI<-c("North Atlantic Right Whale")
Season<-"Summer"
SDM_results(SoI, Season, directory)

SoI<-c("Sperm Whale")
Season<-"Summer"
SDM_results(SoI, Season, directory)

SoI<-c("Northern Bottlenose Whale")
Season<-"Summer"
SDM_results(SoI, Season, directory)

SoI<-c("Killer Whale")
Season<-"Summer"
SDM_results(SoI, Season, directory)

SoI<-c("Pilot Whale")
Season<-"Summer"
SDM_results(SoI, Season, directory)


SoI<-c("Atlantic White-sided Dolphin")
Season<-"Summer"
SDM_results(SoI, Season, directory)

SoI<-c("Common Dolphin")
Season<-"Summer"
SDM_results(SoI, Season, directory)

SoI<-c("Harbour Porpoise")
Season<-"Summer"
SDM_results(SoI, Season, directory)


# autumn

SoI<-c("Fin Whale")
Season<-"Autumn"
SDM_results(SoI, Season, directory)

SoI<-c("Minke Whale")
Season<-"Autumn"
SDM_results(SoI, Season, directory)


SoI<-c("Common Dolphin")
Season<-"Autumn"
SDM_results(SoI, Season, directory)

SoI<-c("Harbour Porpoise")
Season<-"Autumn"
SDM_results(SoI, Season, directory)