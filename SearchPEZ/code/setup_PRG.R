####### Libraries  #######
library(Mar.datawrangling)
library(knitr)
library(kableExtra)
library(rgdal)
library(maps)
library(lubridate)
library(raster)
library(RCurl)
library(sf)
library(stringr)
library(ggplot2)
library(data.table)
library(gridExtra)
library(dplyr)
library(stars)
library(ggspatial)
library(tidyverse)
library(standardPrintOutput)
####### Functions  #######
source("site_map_PRG.r")
source("fn_maps.r")
source("fn_intersect_operations.R")
source("fn_SurveyData.r") # functions for selecting and intersecting RV, MARFIS, and ISDB data



####### Search Area  #######
AquaSiteName <- "AtlanticDestiny"
PEZversion <- "60km"
minYear <- 2002

####### Paths  #######
mspPath <- "../"
SurveyPath = "../../../Data/mar.wrangling"
RDataPath <- "../../../Data/RData"
polyPath <- "../../../Data/Zones/SearchPEZpolygons"
RVdataPath = "../../../Data/mar.wrangling/RVSurvey_FGP"



# read in the site boundary, a landbase file and the Search polygon
pl <- list.files(polyPath,"*.shp") # get a list of shapefiles in the SeachPEZ folder
pl <- pl[-grep("xml",pl)] # remove xml files from list
site_sf <- st_read(file.path(polyPath,pl[grep(paste0("Site_",AquaSiteName),pl)]))
studyArea <- st_read(file.path(polyPath,pl[grep(paste0("PEZ_",AquaSiteName,PEZversion),pl)]))


#### Arguments for RV survey data #################-
# for SelectRV_fn
SurveyPrefix <- c("4VSW", "FALL", "SPRING", "SUMMER")
File <- c("_2020_GSCAT.csv", "_2020_GSINF.csv", "_2020_GSSPECIES.csv")

load(file.path(RDataPath,"OpenData.RData"))
load(file.path(RDataPath,"SecureData.RData"))




####### Species List  #######
# This section reads table that lists species listed by SARA, assesed by COSEWIC or assessed by Wildlife Species listings
# listed_species<-read.csv("../../../Data/NaturalResources/Species/MAR_listed_species.csv")
# cetacean_list<-c("Beluga Whale", "Humpback Whale" , "North Atlantic Right Whale", "Fin Whale", "Northern Bottlenose Whale", 
#                  "Harbour Porpoise", "Killer Whale", "Blue Whale", "Sei Whale", "Sowerby's Beaked Whale")
# other_species_list<-c("Loggerhead Sea Turtle", "Atlantic Walrus", "Harbour Seal Lacs des Loups Marins subspecies", "Leatherback Sea Turtle")
# listed_cetacean_species<-subset(listed_species, Common_Name %in% cetacean_list)
# listed_other_species<-subset(listed_species, Common_Name %in% other_species_list)
# listed_fish_invert_species<-listed_species[ ! listed_species$Common_Name %in% c(other_species_list,cetacean_list), ]
# 
# ####### Files used in multiple sections  #######
# 
# obis<-read.csv("../../../Data/NaturalResources/Species/OBIS_GBIF_iNaturalist/OBIS_MAR_priority_records.csv")
# obis<-subset(obis,year>minYear)
# 
# ####### Files & Code for SAR distribution and critical habitat Section  #######
# 
# ClippedCritHab <- st_read("../../../Data/NaturalResources/Species/SpeciesAtRisk/clipped_layers/ClipCritHab.shp", quiet=TRUE)
# sardist <- st_read("../../../Data/NaturalResources/Species/SpeciesAtRisk/clipped_layers/sardist_4326.shp", quiet=TRUE)
# leatherback_shp <- st_read("../../../Data/NaturalResources/Species/SpeciesAtRisk/LeatherBackTurtleCriticalHabitat/LBT_CH_2013.shp", quiet=TRUE)
# 
# ####### Files & Code for Fish and Invertebrate Section  #######
# #cws<-read.csv("../../../Data/NaturalResources/Species/CWS_ECCC/CWS_ECCC_OBIS_records.csv")
# #cws<-subset(cws,year>minYear)
# #inat<-read.csv("../../../Data/NaturalResources/Species/OBIS_GBIF_iNaturalist/iNaturalist_MAR_priority_records.csv", stringsAsFactors = FALSE)
# #inat<-subset(inat,datetime>minYear)
# #gbif<-read.csv("../../../Data/NaturalResources/Species/OBIS_GBIF_iNaturalist/GBIF_MAR_priority_records.csv",stringsAsFactors = FALSE)
# #gbif<-subset(gbif,year>minYear)
# 
# ####### Files & Code for Cetacean Section  #######
# 
# #read narwc file - update 
# narwc <- read.csv("../../../Data/NaturalResources/Species/Cetaceans/NARWC/NARWC_09-18-2020.csv")
# narwc <- narwc[which(narwc$YEAR>=minYear),]
# 
# #read wsdb file
# wsdb <- read.csv("../../../Data/NaturalResources/Species/Cetaceans/WSDB/MarWSDBSightingsForCGomez_27Oct2020.csv")
# wsdb <- wsdb[which(wsdb$YEAR>=minYear),]
# 
# # filter wsdb file
# wsdb_filter <- filter_wsdb(wsdb)
# 
# #Read Priority Areas for cetacean monitoring
# # Convert rasters to sf object
# fin_whale<- raster("../../../Data/NaturalResources/Species/Cetaceans/PriorityAreas_FGP/Fin_Whale.tif")
# fin_whale[fin_whale==0] <- NA
# fin_whale_sf<-st_as_stars(fin_whale)%>%st_as_sf()
# 
# harbour_porpoise<- raster("../../../Data/NaturalResources/Species/Cetaceans/PriorityAreas_FGP/Harbour_Porpoise.tif")
# harbour_porpoise[harbour_porpoise==0] <- NA
# harbour_porpoise_sf<-st_as_stars(harbour_porpoise)%>%st_as_sf()
# 
# humpback_whale<- raster("../../../Data/NaturalResources/Species/Cetaceans/PriorityAreas_FGP/Humpback_Whale.tif")
# humpback_whale[humpback_whale==0] <- NA
# humpback_whale_sf<-st_as_stars(humpback_whale)%>%st_as_sf()
# 
# sei_whale<- raster("../../../Data/NaturalResources/Species/Cetaceans/PriorityAreas_FGP/Sei_Whale.tif")
# sei_whale[sei_whale==0] <- NA
# sei_whale_sf<-st_as_stars(sei_whale)%>%st_as_sf()
# 
# #Read Blue Whale Important Habitat shape file crs
# Blue_32198 <- st_read("../../../Data/NaturalResources/Species/Cetaceans/BlueWhaleHabitat_FGP/BlueWhaleHabitat_HabitatBaleineBleue.shp", quiet=TRUE)
# Blue_Whale_sf <- st_transform(Blue_32198, crs = 4326)
# Blue_Whale_sf<-setNames(Blue_Whale_sf, replace(names(Blue_Whale_sf), names(Blue_Whale_sf) == 'activité', 'activite'))
# Blue_Whale_sf<-setNames(Blue_Whale_sf, replace(names(Blue_Whale_sf), names(Blue_Whale_sf) == 'activity', 'Activity'))
# Blue_Whale_sf$Activity[Blue_Whale_sf$Activity == "foraging/Feeding"] <- "Foraging/Feeding"
# 
# #Define colour coding for all cetacean plots for consistency
# whale_col=values=c("Blue Whale"="darkgoldenrod1",
#                    "Fin Whale"="chartreuse4",
#                    "Harbour Porpoise"="black",
#                    "Killer Whale"="#00AFBB",
#                    "North Atlantic Right Whale"="darkorchid4",
#                    "Northern Bottlenose Whale"="#0827EF",
#                    "Sei Whale"="#EF6408",
#                    "Sowerby's Beaked Whale"="#F5A4E7",
#                    "Humpback Whale"="red")
# 
# EBSA_sf <- st_read("../../../Data/Zones/DFO_EBSA_FGP/DFO_EBSA.shp", quiet=TRUE)
# EBSA_sf <- st_transform(EBSA_sf, crs = 4326)
# EBSA_sf$Report_URL<-str_replace(EBSA_sf$Report_URL, ".pdf", ".html")
# 
