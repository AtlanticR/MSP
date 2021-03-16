library(sf)
library(raster)
library(dplyr)
library(stringr)
library(lubridate)

source("SearchPEZ/code/fn_SurveyData_GetRV.R")

#### Arguments for RV survey data #################-
# for SelectRV_fn
SurveyPrefix <- c("4VSW", "FALL", "SPRING", "SUMMER")
File <- c("_2020_GSCAT.csv", "_2020_GSINF.csv", "_2020_GSSPECIES.csv")
minYear <- 1970


########################################################################-
# save open data as single .Rdata file

land10m_sf <- st_read("../Data/Boundaries/Landmass/ne_10m_land_Clip.shp", stringsAsFactors = FALSE)
land10m_sf <- land10m_sf[-c(2)]

# ADD IN boundary files
bounds_sf <- st_read("../Data/Boundaries/AdminBoundaries/AdminBounds_SHP/Boundaries_Line.shp", stringsAsFactors = FALSE)
bounds_sf <- dplyr::select(bounds_sf,SRC_DESC, geometry)

listed_species <- read.csv("../Data/NaturalResources/Species/MAR_listed_species.csv", stringsAsFactors = FALSE)

obis <- read.csv("../Data/NaturalResources/Species/OBIS_GBIF_iNaturalist/OBIS_MAR_priority_records.csv", stringsAsFactors = FALSE)
obis <- dplyr::select(obis,scientificName, decimalLatitude, decimalLongitude, year,individualCount, rightsHolder, institutionID,
                      institutionCode, collectionCode, datasetID)
obis_sf <- st_as_sf(obis, coords = c("decimalLongitude","decimalLatitude"), crs = 4326)

sardist_sf <- st_read("../Data/NaturalResources/Species/SpeciesAtRisk/clipped_layers/sardist_4326.shp", stringsAsFactors = FALSE)
RVCatch_sf <-  SelectRV_fn(SurveyPrefix, File, minYear)
ClippedCritHab_sf <- st_read("../Data/NaturalResources/Species/SpeciesAtRisk/clipped_layers/ClipCritHab.shp", stringsAsFactors = FALSE)

fin_whale <- raster("../Data/NaturalResources/Species/Cetaceans/PriorityAreas_FGP/Fin_Whale.tif")
fin_whale[fin_whale==0] <- NA

harbour_porpoise <- raster("../Data/NaturalResources/Species/Cetaceans/PriorityAreas_FGP/Harbour_Porpoise.tif")
harbour_porpoise[harbour_porpoise==0] <- NA

humpback_whale <- raster("../Data/NaturalResources/Species/Cetaceans/PriorityAreas_FGP/Humpback_Whale.tif")
humpback_whale[humpback_whale==0] <- NA

sei_whale <- raster("../Data/NaturalResources/Species/Cetaceans/PriorityAreas_FGP/Sei_Whale.tif")
sei_whale[sei_whale==0] <- NA

#Read Blue Whale Important Habitat shapefile and Project to WGS84
Blue_32198 <- st_read("../Data/NaturalResources/Species/Cetaceans/BlueWhaleHabitat_FGP/BlueWhaleHabitat_HabitatBaleineBleue.shp", quiet=TRUE, stringsAsFactors = FALSE)
Blue_Whale_sf <- st_transform(Blue_32198, crs = 4326)
Blue_Whale_sf<-setNames(Blue_Whale_sf, replace(names(Blue_Whale_sf), names(Blue_Whale_sf) == 'activité', 'activite'))
Blue_Whale_sf$activity[Blue_Whale_sf$activity == "foraging/Feeding"] <- "Foraging/Feeding"
Blue_Whale_sf$activity[Blue_Whale_sf$activity == "Migrant"] <- "Migration"
Blue_Whale_sf$months[Blue_Whale_sf$months == "all year"] <- "All year"
Blue_Whale_sf$months[Blue_Whale_sf$months == "December to February/March to May"] <- "Dec-Feb/Mar-May"
Blue_Whale_sf$months[Blue_Whale_sf$months == "December to February/June to August"] <- "Dec-Feb/Jun-Aug"
Blue_Whale_sf$months[Blue_Whale_sf$months == "March to May/June to August"] <- "Mar-May/Jun-Aug"
Blue_Whale_sf$Activity<-paste(Blue_Whale_sf$activity,"-",Blue_Whale_sf$months)


EBSA_sf <- st_read("../Data/Zones/DFO_EBSA_FGP/DFO_EBSA.shp")
EBSA_sf <- st_transform(EBSA_sf, crs = 4326)
EBSA_sf$Report_URL<-str_replace(EBSA_sf$Report_URL, ".pdf", ".html")

# Save all objects to a single .Rdata file
save(Blue_Whale_sf, bounds_sf, ClippedCritHab_sf, EBSA_sf, fin_whale, 
     harbour_porpoise, humpback_whale, land10m_sf, listed_species, 
     obis_sf, RVCatch_sf, sardist_sf, sei_whale,
     file = "../Data/Rdata/OpenData.RData")

########################################################################-
# save secure data as single .Rdata file

#read wsdb file
wsdb <- read.csv("../Data/NaturalResources/Species/Cetaceans/WSDB/MarWSDBSightingsForCGomez_27Oct2020.csv", stringsAsFactors = FALSE)

#read whitehead lab file
whitehead <- read.csv("../Data/NaturalResources/Species/Cetaceans/Whitehead_Lab/whitehead_lab.csv", stringsAsFactors = FALSE)
whitehead$YEAR<-lubridate::year(whitehead$Date)

#read narwc file - update 
narwc <- read.csv("../Data/NaturalResources/Species/Cetaceans/NARWC/NARWC_09-18-2020.csv", stringsAsFactors = FALSE)

# read in turtle habitat
leatherback_sf <- st_read("../Data/NaturalResources/Species/SpeciesAtRisk/LeatherBackTurtleCriticalHabitat/LBT_CH_2013.shp", stringsAsFactors = FALSE)

load("../Data/mar.wrangling/isdb.RData")
load("../Data/mar.wrangling/marfis.RData")

# Save all objects to a single .Rdata file
save(isdb1,leatherback_sf,marfis1,narwc, whitehead, wsdb,
     file = "../Data/Rdata/SecureData.Rdata")

########################################################-
# random code bits

list1 <- ls()
paste(list1, collapse=", ")






land50k_sf<-st_read("../Data/Boundaries/Coast50K/Coastline50k_SHP/Land_AtlCanada_ESeaboardUS.shp", quiet=TRUE, stringsAsFactors = FALSE)
getwd()

colnames(land_sf)
land50k_sf = subset(land50k_sf, select = -c(Shape_Leng,Shape_Area))
plot(land_sf)

file <- "C:/Temp/Land10M.rds"
file2 <- "C:/Temp/land50k.rds"
saveRDS(land50k_sf, file, compress = TRUE)
saveRDS(land10m, file2, compress = TRUE)
save(land_sf,file = file2, compress = TRUE)
## restore it under a different name
land50k <- readRDS(file)
land10m <- readRDS(file2)
plot(land2)

rm(land_sf)
rm(land10m)
load(file2)
plot(land_sf)


load("N:/MSP/Data/Boundaries/Landmass/land10m.RData")

land10m <- st_read(dsn = "N:/MSP/Data/Boundaries/Landmass",layer = "ne_10m_land_Clip.shp")

land10m_sf <- st_read("N:/MSP/Data/Boundaries/Landmass/ne_10m_land_Clip.shp", stringsAsFactors = FALSE)

land10m <- st_as_sf(land10m)
plot(land10m)

land2 <- readRDS(file)


landfile10m <- "../RData/Land10M.rds"
landfile50k <- "..RData/land50k.rds"

## restore it under a different name
land50k <- readRDS(landfile50k)
land10m <- readRDS(landfile10m)