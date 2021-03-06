####### Libraries  #######

library(knitr) # generates reproducible reports from R Markdown scripts
library(kableExtra) # needed to build and manipulate tables
library(rgdal) # needed top read geospatial data files into report
library(maps) # uncouple latitude and longitude coordinates in sf objects
library(lubridate) # extract YEAR from columns containing dates
library(raster) # needed for manipulation of raster files
#library(RCurl)
library(sf) # needed for manipulation of simple features and to determine overlap of studyArea and databases
library(stringr) # general manipulation of individual characters within strings in character vectors.
library(ggplot2) #needed to plot maps
library(data.table) # needed for manipulation of dataframes
library(gridExtra) # used to plot a grid of plots (priority cetacean habitat)
library(dplyr) # core R package used for manipulation of dataframes
library(stars) # needed to transform features and assign or modify coordinate reference systems in objects
library(ggspatial) #required for mapping
library(tidyverse) # a set of packages required for general data manipulation
library(Mar.datawrangling) # needed to harvest and manipulate data from ISDB, MARFIS and RV databases
#These next two lines are necessary for the generation of the water mark on all plots.
#install.packages("remotes")
#remotes::install_github("terminological/standard-print-output")
library(standardPrintOutput) # required for watermarks on maps

####### Functions  #######
source("fn_maps.r") #Functions used to plot figure
source("fn_intersect_operations.R") #Functions used to intersect data polygons and points with studyArea 

####### Search Area  #######
AquaSiteName <- "FarmersLedge"
PEZversion <- "4748m"
minYear <- 2002

####### Paths  #######
mspPath <- "../"
SurveyPath = "../../../Data/mar.wrangling"
dataPath <- file.path("../../../Data/outputs",paste0(AquaSiteName,PEZversion))
RDataPath <- "../../../Data/RData"
polyPath <- "../../../Data/Zones/SearchPEZpolygons"
pl <- list.files(polyPath,"*.shp")
pl <- pl[-grep("xml",pl)]
site_sf <- st_read(file.path(polyPath,pl[grep(paste0("Site_",AquaSiteName),pl)]))
studyArea <- st_read(file.path(polyPath,pl[grep(paste0("PEZ_",AquaSiteName,PEZversion),pl)]))

####### Load datasets #######
load("../../../Data/RData/OpenData.RData")
load("../../../Data/RData/SecureData.RData")
load("../../../Data/RData/MARFISSCI.SPECIES.RData")
ISDB_info<-file.info("../../../Data/RData/ISDB.ISSETTYPECODES.RData")
MARFIS_info<-file.info("../../../Data/RData/MARFISSCI.SPECIES.RData")
rockweed_sf<-st_read("../../../Data/NaturalResources/Species/Rockweed/MAR_rockweed_presence_validated.shp")
rockweed_sf<-st_transform(rockweed_sf, 4326)
land50k_sf <- st_read("../../../Data/Boundaries/Coast50K/Coastline50k_SHP/Land_AtlCanada_ESeaboardUS.shp")

####### Species Lists  #######
# This section reads table that lists species listed by SARA, assessed by COSEWIC or assessed by Wildlife Species listings
listed_species<-read.csv("../../../Data/NaturalResources/Species/MAR_listed_species.csv")
cetacean_list<-c("Beluga Whale", "North Atlantic Right Whale", "Fin Whale", "Northern Bottlenose Whale", 
                 "Harbour Porpoise", "Killer Whale", "Blue Whale", "Sei Whale", "Sowerby's Beaked Whale")
other_species_list<-c("Loggerhead Sea Turtle", "Atlantic Walrus", "Harbour Seal Lacs des Loups Marins subspecies", "Leatherback Sea Turtle")
listed_cetacean_species<-subset(listed_species, Common_Name %in% cetacean_list)
listed_other_species<-subset(listed_species, Common_Name %in% other_species_list)
listed_fish_invert_species<-listed_species[ ! listed_species$Common_Name %in% c(other_species_list,cetacean_list), ]

# load("../../../Data/mar.wrangling/MARFISSCI.SPECIES.RData")


###### Modify file formats ######
fin_whale[fin_whale==0] <- NA
fin_whale_sf<-st_as_stars(fin_whale)%>%st_as_sf()

harbour_porpoise[harbour_porpoise==0] <- NA
harbour_porpoise_sf<-st_as_stars(harbour_porpoise)%>%st_as_sf()

humpback_whale[humpback_whale==0] <- NA
humpback_whale_sf<-st_as_stars(humpback_whale)%>%st_as_sf()

sei_whale[sei_whale==0] <- NA
sei_whale_sf<-st_as_stars(sei_whale)%>%st_as_sf()

Blue_Whale_sf<-setNames(Blue_Whale_sf, replace(names(Blue_Whale_sf), names(Blue_Whale_sf) == 'activité', 'activite'))
Blue_Whale_sf$activity[Blue_Whale_sf$activity == "foraging/Feeding"] <- "Foraging/Feeding"
Blue_Whale_sf$activity[Blue_Whale_sf$activity == "Migrant"] <- "Migration"
Blue_Whale_sf$months[Blue_Whale_sf$months == "all year"] <- "All year"
Blue_Whale_sf$months[Blue_Whale_sf$months == "December to February/March to May"] <- "Dec-Feb/Mar-May"
Blue_Whale_sf$months[Blue_Whale_sf$months == "December to February/June to August"] <- "Dec-Feb/Jun-Aug"
Blue_Whale_sf$months[Blue_Whale_sf$months == "March to May/June to August"] <- "Mar-May/Jun-Aug"
Blue_Whale_sf$Activity<-paste(Blue_Whale_sf$activity,"-",Blue_Whale_sf$months)

####### Filter files used in multiple sections by minYear  #######

obis_sf <- obis_sf %>% dplyr::filter(year >= minYear)
wsdb <- wsdb %>% dplyr::filter(YEAR >= minYear)
whitehead$YEAR<-lubridate::year(whitehead$Date)
whitehead <- whitehead %>% dplyr::filter(YEAR >= minYear)
narwc <- narwc %>% dplyr::filter(YEAR >= minYear)


####### Define colour coding for all cetacean plots for consistency
whale_col=values=c("Blue Whale: Endangered (SARA & COSEWIC)"="darkgoldenrod1",
                   "Fin Whale: Special Concern (SARA & COSEWIC)"="chartreuse4",
                   "Harbour Porpoise: Threatened (SARA) Special Concern (COSEWIC)"="black",
                   "Killer Whale: No Status (SARA) & Special Concern (COSEWIC)"="#00AFBB",
                   "North Atlantic Right Whale: Endangered (SARA & COSEWIC)"="darkorchid4",
                   "Northern Bottlenose Whale: Endangered (SARA & COSEWIC)"="#0827EF",
                   "Sei Whale: No Status (SARA) & Endangered (COSEWIC)"="#EF6408",
                   "Sowerby's Beaked Whale: Special Concern (SARA & COSEWIC)"="#F5A4E7"
                   )

######## Habitat Information########

rockweed_sf$RWP[which(rockweed_sf$RWP=="1")]= "Present"
rockweed_sf$RWP[which(rockweed_sf$RWP=="2")]= "Likely Present"
rockweed_sf$RWP[which(rockweed_sf$RWP=="5")]= "Unknown"

####### Data sets that have been replaced with OpenData.RData and SecureData.RData files ######
#ClippedCritHab_sf <- st_read("../../../Data/NaturalResources/Species/SpeciesAtRisk/clipped_layers/ClipCritHab.shp", quiet=TRUE)
#sardist_sf<-st_read("../../../Data/NaturalResources/Species/SpeciesAtRisk/clipped_layers/sardist_4326.shp", quiet=TRUE)
#leatherback_sf<-st_read("../../../Data/NaturalResources/Species/SpeciesAtRisk/LeatherBackTurtleCriticalHabitat/LBT_CH_2013.shp", quiet=TRUE)
#obis<-read.csv("../../../Data/NaturalResources/Species/OBIS_GBIF_iNaturalist/OBIS_MAR_priority_records.csv")
#fin_whale<- raster("../../../Data/NaturalResources/Species/Cetaceans/PriorityAreas_FGP/Fin_Whale.tif")
#harbour_porpoise<- raster("../../../Data/NaturalResources/Species/Cetaceans/PriorityAreas_FGP/Harbour_Porpoise.tif")
#humpback_whale<- raster("../../../Data/NaturalResources/Species/Cetaceans/PriorityAreas_FGP/Humpback_Whale.tif")
#sei_whale<- raster("../../../Data/NaturalResources/Species/Cetaceans/PriorityAreas_FGP/Sei_Whale.tif")
#Blue_32198 <- st_read("../../../Data/NaturalResources/Species/Cetaceans/BlueWhaleHabitat_FGP/BlueWhaleHabitat_HabitatBaleineBleue.shp", quiet=TRUE)
#wsdb <- read.csv("../../../Data/NaturalResources/Species/Cetaceans/WSDB/MarWSDBSightingsForCGomez_27Oct2020.csv")
#whitehead <- read.csv("../../../Data/NaturalResources/Species/Cetaceans/Whitehead_Lab/whitehead_lab.csv")
#narwc <- read.csv("../../../Data/NaturalResources/Species/Cetaceans/NARWC/NARWC_09-18-2020.csv")
#EBSA_sf <- st_read("../../../Data/Zones/DFO_EBSA_FGP/DFO_EBSA.shp", quiet=TRUE)
# EBSA_sf <- st_transform(EBSA_sf, crs = 4326)
# EBSA_sf$Report_URL<-str_replace(EBSA_sf$Report_URL, ".pdf", ".html")
#landfile10m <- file.path(RDataPath,"Land10M.rds")
#land10m_sf <- readRDS(landfile10m)
#SurveyPrefix <- c("4VSW", "FALL", "SPRING", "SUMMER")
#File <- c("_2020_GSCAT.csv", "_2020_GSINF.csv", "_2020_GSSPECIES.csv")
#RVCatch <-  SelectRV_fn(SurveyPrefix, File, AquaSiteName, PEZversion, minYear)
#modify land files
#landfile50k <-  file.path(RDataPath,"land50k.rds")
#land50k_sf <- readRDS(landfile50k)
#remove State and Province column from land10m
#land10m_sf <- land10m_sf[-c(2)]

####### Currently unfeatured data sets #######
#cws<-read.csv("../../../Data/NaturalResources/Species/CWS_ECCC/CWS_ECCC_OBIS_records.csv")
#cws<-subset(cws,year>minYear)
#inat<-read.csv("../../../Data/NaturalResources/Species/OBIS_GBIF_iNaturalist/iNaturalist_MAR_priority_records.csv", stringsAsFactors = FALSE)
#inat<-subset(inat,datetime>minYear)
#gbif<-read.csv("../../../Data/NaturalResources/Species/OBIS_GBIF_iNaturalist/GBIF_MAR_priority_records.csv",stringsAsFactors = FALSE)
#gbif<-subset(gbif,year>minYear)