filter_wsdb <- function(wsdb) {
  
  wsdb_filt <- wsdb[wsdb$COMMONNAME %in% c('PORPOISE-HARBOUR', 'WHALE-SEI','WHALE-FIN', 'WHALE-NORTH ATLANTIC RIGHT',
                                           'WHALE-NORTHERN BOTTLENOSE', 'WHALE-KILLER', 'WHALE-BLUE', "WHALE-SOWERBY'S BEAKED"), ]
  
  wsdb_filt$COMMONNAME[which(wsdb_filt$COMMONNAME=="PORPOISE-HARBOUR")]= "Harbour Porpoise: Threatened (SARA) Special Concern (COSEWIC)"
  wsdb_filt$COMMONNAME[which(wsdb_filt$COMMONNAME=="WHALE-FIN")]= "Fin Whale: Special Concern (SARA & COSEWIC)"
  wsdb_filt$COMMONNAME[which(wsdb_filt$COMMONNAME=="WHALE-NORTH ATLANTIC RIGHT")]= "North Atlantic Right Whale: Endangered (SARA & COSEWIC)"
  wsdb_filt$COMMONNAME[which(wsdb_filt$COMMONNAME=="WHALE-NORTHERN BOTTLENOSE")]= "Northern Bottlenose Whale: Endangered (SARA & COSEWIC)"
  wsdb_filt$COMMONNAME[which(wsdb_filt$COMMONNAME=="WHALE-KILLER")]= "Killer Whale: No Status (SARA) & Special Concern (COSEWIC)"
  wsdb_filt$COMMONNAME[which(wsdb_filt$COMMONNAME=="WHALE-BLUE")]= "Blue Whale: Endangered (SARA & COSEWIC)"
  wsdb_filt$COMMONNAME[which(wsdb_filt$COMMONNAME=="WHALE-SEI")]= "Sei Whale: No Status (SARA) & Endangered (COSEWIC)"
  wsdb_filt$COMMONNAME[which(wsdb_filt$COMMONNAME=="WHALE-SOWERBY'S BEAKED")]= "Sowerby's Beaked Whale: Special Concern (SARA & COSEWIC)"
  wsdb_filt<-wsdb_filt %>% rename(Scientific_Name = SCIENTIFICNAME)
  wsdb_filt<-merge(wsdb_filt, listed_cetacean_species, by='Scientific_Name')
  
  return(wsdb_filt)
}


intersect_points_wsdb <- function(wsdb_filter, PEZ_poly_sf) {
  
  wsdb_sf<-st_as_sf(wsdb_filter, coords = c("LONGITUDE", "LATITUDE"), crs = 4326)
  intersect_wsdb <- st_intersection(wsdb_sf,PEZ_poly_sf)
  wsdb_intersect_points <- intersect_wsdb %>%
    mutate(long = unlist(map(intersect_wsdb$geometry,1)),
           lat = unlist(map(intersect_wsdb$geometry,2)))
}

table_wsdb <- function(wsdb_filter, PEZ_poly_sf) {
  wsdb_sf<-st_as_sf(wsdb_filter, coords = c("LONGITUDE", "LATITUDE"), crs = 4326)
  intersect_wsdb <- st_intersection(wsdb_sf,PEZ_poly_sf)
  wsdb_table<-merge(intersect_wsdb, listed_cetacean_species, by='Scientific_Name')
  wsdb_table<-wsdb_table %>% 
    transmute(Common_Name.x, Scientific_Name, Schedule.status.x, COSEWIC.status.x, Wild_Species.x)
  wsdb_table<- wsdb_table %>% rename("SARA status"=Schedule.status.x,
                                   "COSEWIC listing"=COSEWIC.status.x,
                                   "Wild Species listing"=Wild_Species.x,
                                   "Scientific Name"=Scientific_Name,
                                   "Common Name"=Common_Name.x)
}


filter_narwc <- function(narwc) {
  narwc_filt <- narwc[narwc$SPECCODE %in% c('HAPO', 'SEWH', 'FIWH','RIWH', 'NBWH','KIWH', 'BLWH',  "SOBW"), ]
  narwc_filt$SPECCODE[which(narwc_filt$SPECCODE=="HAPO")]= "Phocoena phocoena"
  narwc_filt$SPECCODE[which(narwc_filt$SPECCODE=="FIWH")]= "Balaenoptera physalus"
  narwc_filt$SPECCODE[which(narwc_filt$SPECCODE=="RIWH")]= "Eubalaena glacialis"
  narwc_filt$SPECCODE[which(narwc_filt$SPECCODE=="NBWH")]= "Hyperoodon ampullatus"
  narwc_filt$SPECCODE[which(narwc_filt$SPECCODE=="KIWH")]= "Orcinus orca"
  narwc_filt$SPECCODE[which(narwc_filt$SPECCODE=="BLWH")]= "Balaenoptera musculus"
  narwc_filt$SPECCODE[which(narwc_filt$SPECCODE=="SEWH")]= "Balaenoptera borealis"
  narwc_filt$SPECCODE[which(narwc_filt$SPECCODE=="SOBW")]= "Mesoplodon bidens"
  narwc_filter <- narwc_filt %>% rename(Scientific_Name = SPECCODE)
  narwc_filter <- merge(narwc_filter, listed_cetacean_species, by='Scientific_Name')
}

intersect_points_narwc <- function(narwc_filter, PEZ_poly_sf) {
  narwc_sf<-st_as_sf(narwc_filter, coords = c("LONGITUDE", "LATITUDE"), crs = 4326)
  intersect_narwc <- st_intersection(narwc_sf,PEZ_poly_sf)
  narwc_intersect_points <- intersect_narwc %>%
    mutate(long = unlist(map(intersect_narwc$geometry,1)),
           lat = unlist(map(intersect_narwc$geometry,2)))
}

table_narwc <- function(narwc_filter, PEZ_poly_sf) {
  narwc_sf<-st_as_sf(narwc_filter, coords = c("LONGITUDE", "LATITUDE"), crs = 4326)
  intersect_narwc <- st_intersection(narwc_sf,PEZ_poly_sf)
  narwc_table<-merge(intersect_narwc, listed_species, by='Scientific_Name')
  narwc_table<-narwc_table %>% 
    transmute(Common_Name.x, Scientific_Name, Schedule.status.x, COSEWIC.status.x, Wild_Species.x)
  narwc_table<- narwc_table %>% rename("SARA status"=Schedule.status.x,
                                       "COSEWIC listing"=COSEWIC.status.x,
                                       "Wild Species listing"=Wild_Species.x,
                                       "Scientific Name"=Scientific_Name,
                                       "Common Name"=Common_Name.x)
}

filter_obis <- function(obis) {
  obis_filter<-obis %>% 
    transmute(scientificName, decimalLatitude, decimalLongitude, year,individualCount, rightsHolder, institutionID,
              institutionCode, collectionCode, datasetID)
  obis_filter<-obis_filter %>%
    filter(! collectionCode =="WHALESITINGS")
  obis_filter <- obis_filter %>% rename(Scientific_Name=scientificName)
}


intersect_points_obis <- function(obis_filter, PEZ_poly_sf) {
  obis_sf<-st_as_sf(obis_filter, coords = c("decimalLongitude", "decimalLatitude"), crs = 4326)
  intersect_obis <- st_intersection(obis_sf,PEZ_poly_sf)
  intersect_obis<-merge(intersect_obis, listed_cetacean_species, by='Scientific_Name')
  obis_intersect_points <- intersect_obis %>%
    mutate(long = unlist(map(intersect_obis$geometry,1)),
           lat = unlist(map(intersect_obis$geometry,2)))
}

table_obis <- function(obis_filter, PEZ_poly_sf) {
  obis_sf<-st_as_sf(obis_filter, coords = c("decimalLongitude", "decimalLatitude"), crs = 4326)
  intersect_obis <- st_intersection(obis_sf,PEZ_poly_sf)
  obis_whale_table<-merge(intersect_obis, listed_cetacean_species, by='Scientific_Name')
  obis_whale_table<-obis_whale_table %>% 
    select(Common_Name, Scientific_Name, Schedule.status, COSEWIC.status, Wild_Species)
  obis_whale_table<- obis_whale_table %>% rename("SARA status"=Schedule.status,
                                               "COSEWIC listing"=COSEWIC.status,
                                               "Wild Species listing"=Wild_Species,
                                               "Scientific Name"=Scientific_Name,
                                               "Common Name"=Common_Name)
  obis_whale_table$geometry<-NULL
  obis_whale_table<-unique(obis_whale_table)
}