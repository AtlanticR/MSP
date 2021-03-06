###Species At Risk distribution and Critical Habitat data###

#SAR distribution
table_dist <- function(sardist_sf,studyArea) {
  
  intersect_dist <- st_intersection(sardist_sf,studyArea)
  intersect_dist$Common_Nam[intersect_dist$Common_Nam == "Sowerby`s Beaked Whale"] <- "Sowerby's Beaked Whale"
  dist_table<-intersect_dist %>% 
    select(Scientific, Common_Nam, Population, Waterbody)
  st_geometry(dist_table)<-NULL
  dist_table<- dist_table %>% rename("Scientific_Name"=Scientific)
  dist_table<-merge(dist_table, listed_species, by='Scientific_Name')
  dist_table<-dist_table %>% 
    select(Common_Name, Scientific_Name, Population, Waterbody, Schedule.status, COSEWIC.status, Wild_Species)
  dist_table<- dist_table %>% rename("SARA status"=Schedule.status,
                                     "COSEWIC listing"=COSEWIC.status,
                                     "Wild Species listing"=Wild_Species,
                                     "Common Name"=Common_Name,
                                     "Scientific Name"=Scientific_Name)
}

#SAR critical habitat
table_crit <- function(ClippedCritHab_sf,studyArea, leatherback_sf) {
  
  intersect_crit <- st_intersection(ClippedCritHab_sf,studyArea)
  intersect_crit_result<-nrow(intersect_crit)
  crit_table<-data.frame(CommonName=intersect_crit$Common_Nam,
                        Population=intersect_crit$Population, 
                        Area=intersect_crit$Waterbody,
                        SARA_status=intersect_crit$SARA_Statu)
  
  leatherback_table<-data.frame(CommonName="",Population="", Area="", SARA_status="")
  intersect_leatherback <- st_intersection(leatherback_sf,studyArea)
  leatherback_result<-nrow(intersect_leatherback)
  leatherback_table[1,1]<-"Leatherback Sea Turtle"
  leatherback_table[1,2]<-NA
  if(leatherback_result>=1){
  leatherback_table[1,3]<-intersect_leatherback$AreaName
  }else{
  leatherback_table[1,3]<-NA  
  }
  leatherback_table[1,4]<-"Endangered"
  crit_table<-bind_rows(crit_table,leatherback_table)
  crit_table<-crit_table[!is.na(crit_table$Area), ]
}

###Fish and Invertebrate section###

#Create table of RV records of SAR species caught in studyArea

table_rv_SAR <- function(RVCatch_intersect) {
  
  Total_number_sets_RV<-length(unique(RVCatch_intersect$SETNO))
  
  if(Total_number_sets_RV >= 1){
  
  rv_freq_all_ind_sum <- aggregate(RVCatch_intersect$TOTNO, by=list(Scientific_Name_upper = RVCatch_intersect$SPEC), FUN=sum)
  rv_freq_all_ind_sum<-rv_freq_all_ind_sum %>% rename(Individuals=x)
  
  rv_freq_all_set_sum <- aggregate(SETNO ~ SPEC, RVCatch_intersect, function(x) length(unique(x)))
  rv_freq_all_set_sum<-rv_freq_all_set_sum %>% rename(Sets=SETNO,
                                                      Scientific_Name_upper=SPEC)
  
  rv_SAR_table<-merge(rv_freq_all_ind_sum, listed_fish_invert_species, by='Scientific_Name_upper')
  rv_SAR_table<-merge(rv_SAR_table, rv_freq_all_set_sum, by='Scientific_Name_upper')
  rv_SAR_table<-mutate(rv_SAR_table, Capture_Event_Frequency=format(round((Sets/Total_number_sets_RV)*100,1), nsmall=1))
  rv_SAR_table<-mutate(rv_SAR_table, Capture_Event_Frequency=paste(Sets, "/",Total_number_sets_RV, " trawls"))
  rv_SAR_table<-select(rv_SAR_table, Scientific_Name, Common_Name, COSEWIC.status, Schedule.status, Wild_Species, Individuals, Capture_Event_Frequency)
    rv_SAR_table<- rv_SAR_table %>% rename("SARA status"=Schedule.status,
                                         "COSEWIC listing"=COSEWIC.status,
                                         "Wild Species listing"=Wild_Species,
                                         "Capture Event Frequency"=Capture_Event_Frequency,
                                         "Scientific Name"=Scientific_Name,
                                         "Common Name"=Common_Name)
  }  
}

#Create table of of RV records of all species caught in studyArea

table_rv <- function(RVCatch_intersect) {
  
  Total_number_sets_RV<-length(unique(RVCatch_intersect$SETNO))
  
  if(Total_number_sets_RV >= 1){
  
  rv_freq_all_ind_sum <- aggregate(RVCatch_intersect$TOTNO, by=list(SPEC = RVCatch_intersect$SPEC), FUN=sum)
  rv_freq_all_ind_sum <- rv_freq_all_ind_sum %>% rename(Individuals=x)
  
  rv_freq_all_set_sum <- aggregate(SETNO ~ SPEC, RVCatch_intersect, function(x) length(unique(x)))
  rv_freq_all_set_sum <- rv_freq_all_set_sum %>% rename(Sets=SETNO)
  
  rv_table <- merge(rv_freq_all_ind_sum, rv_freq_all_set_sum, by='SPEC')
  
  #rv_table <- mutate(rv_table, Capture_Event_Frequency=format(round((Sets/Total_number_sets_RV)*100,1), nsmall=1))
  rv_table <- mutate(rv_table, Capture_Event_Frequency=paste(Sets, "/",Total_number_sets_RV, " trawls"))
  
  names <- select(RVCatch_intersect,SPEC,COMM)
  st_geometry(names)<-NULL
  names <- unique(names)
  rv_table <- dplyr::left_join(rv_table, names, by="SPEC")
  rv_table <- rv_table %>% transmute(rv_table, Common_Name=str_to_sentence(COMM))
  rv_table <- rv_table %>% transmute(rv_table, Scientific_Name=str_to_sentence(SPEC))
  rv_table <- select(rv_table, Scientific_Name, Common_Name, Individuals, Capture_Event_Frequency)
  rv_table <- rv_table %>% rename("Capture Event Frequency"=Capture_Event_Frequency,
                                 "Scientific Name"=Scientific_Name,
                                 "Common Name"=Common_Name)

  }  
}

#Create table of of ISDB records of all species caught in studyArea

table_isdb <- function(isdb_intersect) {

  isdb_table <- aggregate(
    x = list(Records = isdb_intersect$SCIENTIFIC),
    by = list(SCIENTIFIC_NAME = isdb_intersect$SCIENTIFIC, COMMON_NAME = isdb_intersect$COMMON),
    length)
  isdb_table <- isdb_table %>% transmute(isdb_table, Scientific_Name=str_to_sentence(SCIENTIFIC_NAME))
  isdb_table <- isdb_table %>% transmute(isdb_table, Common_Name=str_to_sentence(COMMON_NAME))
  isdb_table <- isdb_table %>% select(Scientific_Name, Common_Name, Records)
  isdb_table <- arrange(isdb_table, Scientific_Name)
  isdb_table <- isdb_table %>% rename("Scientific Name"=Scientific_Name,
                                      "Common Name"=Common_Name)

}

table_isdb_SAR <- function(isdb_intersect) {
  
  isdb_SAR_table <- aggregate(
    x = list(Records = isdb_intersect$SCIENTIFIC),
    by = list(Scientific_Name = isdb_intersect$SCIENTIFIC, Common_Name = isdb_intersect$COMMON),
    length)
  isdb_SAR_table <- isdb_SAR_table %>% rename("Scientific_Name_upper"=Scientific_Name)
  isdb_SAR_table <-merge(isdb_SAR_table, listed_fish_invert_species, by='Scientific_Name_upper')
  isdb_SAR_table <-isdb_SAR_table %>% 
    select(Scientific_Name, Common_Name.y, Schedule.status, COSEWIC.status, Wild_Species, Records)
  isdb_SAR_table<- isdb_SAR_table %>% rename("SARA status"=Schedule.status,
                                             "COSEWIC listing"=COSEWIC.status,
                                             "Wild Species listing"=Wild_Species,
                                             "Scientific Name"=Scientific_Name,
                                             "Common Name"=Common_Name.y)
  isdb_SAR_table<-arrange(isdb_SAR_table, "Scientific Name")

}

#Create table of of MARFIS records of all species caught in studyArea

table_marfis <- function(marfis_intersect) {
  marfis_table <- aggregate(
    x = list(Records = marfis_intersect$SPECIES_CODE),
    by = list(SPECIES_CODE = marfis_intersect$SPECIES_CODE),
    length)
  marfis_table <- merge(marfis_table,SPECIES, by = 'SPECIES_CODE')
  marfis_table <- marfis_table %>% transmute(marfis_table, Common_Name=str_to_sentence(SPECIES_NAME))
  marfis_table <- marfis_table %>% select(Common_Name, Records)
  marfis_table <- arrange(marfis_table, Common_Name)
  marfis_table <- marfis_table %>% rename("Common Name"=Common_Name)

}

table_marfis_SAR <- function(marfis_intersect) {
  
  marfis_SAR_table <- aggregate(
    x = list(Records = marfis_intersect$SPECIES_CODE),
    by = list(SPECIES_CODE = marfis_intersect$SPECIES_CODE),
    length)
  marfis_SAR_table <- merge(marfis_SAR_table,SPECIES, by = 'SPECIES_CODE')
  marfis_SAR_table <- marfis_SAR_table %>% rename("Common_Name_MARFIS"=SPECIES_NAME)
  marfis_SAR_table <-merge(marfis_SAR_table, listed_fish_invert_species, by='Common_Name_MARFIS')
  marfis_SAR_table <-marfis_SAR_table %>% 
    select(Scientific_Name, Common_Name, Schedule.status, COSEWIC.status, Wild_Species, Records)
  marfis_SAR_table<- marfis_SAR_table %>% rename("SARA status"=Schedule.status,
                                                       "COSEWIC listing"=COSEWIC.status,
                                                       "Wild Species listing"=Wild_Species,
                                                       "Scientific Name"=Scientific_Name,
                                                       "Common Name"=Common_Name)
  marfis_SAR_table<-arrange(marfis_SAR_table, "Scientific Name")

}

#Ocean Biodiversity Information System - FISH

filter_obis_fish <- function(obis_sf) {
  obis_sf<-obis_sf %>%
    filter(! collectionCode =="WHALESITINGS")
  obis_sf_filter <- obis_sf %>% rename(Scientific_Name=scientificName)
}


intersect_points_obis_fish <- function(obis_sf_filter, studyArea) {
  intersect_obis <- st_intersection(obis_sf_filter,studyArea)
  intersect_obis<-merge(intersect_obis, listed_fish_invert_species, by='Scientific_Name')
  obis_intersect_points <- intersect_obis %>%
    mutate(long = unlist(map(intersect_obis$geometry,1)),
           lat = unlist(map(intersect_obis$geometry,2)))
}

table_obis_fish <- function(obis_sf_filter, studyArea) {
  intersect_obis <- st_intersection(obis_sf_filter,studyArea)
  obis_fish_table<-merge(intersect_obis, listed_fish_invert_species, by='Scientific_Name')
  obis_fish_table<-obis_fish_table %>% 
    select(Common_Name, Scientific_Name, Schedule.status, COSEWIC.status, Wild_Species)
  obis_fish_table<- obis_fish_table %>% rename("SARA status"=Schedule.status,
                                                 "COSEWIC listing"=COSEWIC.status,
                                                 "Wild Species listing"=Wild_Species,
                                                 "Scientific Name"=Scientific_Name,
                                                 "Common Name"=Common_Name)
  obis_fish_table$geometry<-NULL
  obis_fish_table<-unique(obis_fish_table)

}


#Ocean Biodiversity Information System - CETACEANS

table_obis_cet <- function(obis_sf_filter, studyArea) {
  intersect_obis <- st_intersection(obis_sf_filter,studyArea)
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



###Cetacean section###

#Whale Sightings Database (WSDB)
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


intersect_points_wsdb <- function(wsdb_filter, studyArea) {
  
  wsdb_sf<-st_as_sf(wsdb_filter, coords = c("LONGITUDE", "LATITUDE"), crs = 4326)
  intersect_wsdb <- st_intersection(wsdb_sf,studyArea)
  wsdb_intersect_points <- intersect_wsdb %>%
    mutate(long = unlist(map(intersect_wsdb$geometry,1)),
           lat = unlist(map(intersect_wsdb$geometry,2)))
}

#Whitehead Lab database

filter_whitehead <- function(whitehead) {
  whitehead <- whitehead %>% rename(Scientific_Name = species.name)
  whitehead_filter <- merge(whitehead, listed_cetacean_species, by='Scientific_Name')
}

intersect_points_whitehead <- function(whitehead_filter, studyArea) {
  whitehead_sf<-st_as_sf(whitehead_filter, coords = c("Long", "Lat"), crs = 4326)
  intersect_whitehead <- st_intersection(whitehead_sf,studyArea)
  whitehead_intersect_points <- intersect_whitehead %>%
    mutate(long = unlist(map(intersect_whitehead$geometry,1)),
           lat = unlist(map(intersect_whitehead$geometry,2)))
}

#North Atlantic Right Whale Consortium (NARWC) database

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

intersect_points_narwc <- function(narwc_filter, studyArea) {
  narwc_sf<-st_as_sf(narwc_filter, coords = c("LONGITUDE", "LATITUDE"), crs = 4326)
  intersect_narwc <- st_intersection(narwc_sf,studyArea)
  narwc_intersect_points <- intersect_narwc %>%
    mutate(long = unlist(map(intersect_narwc$geometry,1)),
           lat = unlist(map(intersect_narwc$geometry,2)))
}

#Ocean Biodiversity Information System - CETACEANS

filter_obis_cet <- function(obis_sf) {
  obis_sf<-obis_sf %>%
    filter(! collectionCode =="WHALESITINGS")
  obis_sf_filter <- obis_sf %>% rename(Scientific_Name=scientificName)
}

intersect_points_obis_cet <- function(obis_sf_filter, studyArea) {
  intersect_obis <- st_intersection(obis_sf_filter,studyArea)
  intersect_obis <- merge(intersect_obis, listed_cetacean_species, by='Scientific_Name')
  obis_intersect_points <- intersect_obis %>%
    mutate(long = unlist(map(intersect_obis$geometry,1)),
           lat = unlist(map(intersect_obis$geometry,2)))
}

#Species Distribution Models (SDM): Priority Areas to Enhance Monitoring of Cetaceans

sdm_table <- function(fin_whale_sf, harbour_porpoise_sf, humpback_whale_sf, sei_whale_sf, studyArea) {

fin_intersect <- st_intersection(fin_whale_sf,studyArea)
x<-as.numeric(nrow(fin_intersect))
fin_area<-if(x < 1){
  FALSE
} else {
  TRUE
}

harbour_intersect <- st_intersection(harbour_porpoise_sf,studyArea)
x<-as.numeric(nrow(harbour_intersect))
harbour_area<-if(x < 1){
  FALSE
} else {
  TRUE
}

humpback_intersect <- st_intersection(humpback_whale_sf,studyArea)
x<-as.numeric(nrow(humpback_intersect))
humpback_area<-if(x < 1){
  FALSE
} else {
  TRUE
}

sei_intersect <- st_intersection(sei_whale_sf,studyArea)
x<-as.numeric(nrow(sei_intersect))
sei_area<-if(x < 1){
  FALSE
} else {
  TRUE
}

table_sdm<-data.frame(Fin_Whale="",Habour_Porpoise="", Humpback_Whale="", Sei_Whale="")
table_sdm[1,1]<-fin_area
table_sdm[1,2]<-harbour_area
table_sdm[1,3]<-humpback_area
table_sdm[1,4]<-sei_area
table_sdm<- table_sdm %>% rename("Fin Whale"=Fin_Whale,
                                 "Harbour Porpoise"=Habour_Porpoise,
                                 "Humpback Whale"=Humpback_Whale,
                                 "Sei Whale"=Sei_Whale)

}

#Blue Whale Important Habitat

blue_whale_habitat_overlap <- function(Blue_Whale_sf, studyArea) {
  
  intersect <- st_intersection(Blue_Whale_sf,studyArea)
  x<-as.numeric(nrow(intersect))
  Query_output_crit<-if(x < 1){
    "Search area does not overlaps with Blue Whale Important Habitat in the Western North Atlantic."
  } else {
    "Search area overlaps with Blue Whale Important Habitat in the Western North Atlantic."
  }

}

#Ecologically and Biologically Significant Areas (EBSA)

EBSA_overlap <- function(EBSA_sf, studyArea) {
  
  EBSA_intersect <- st_intersection(EBSA_sf,studyArea)
  EBSA_result<-as.numeric(nrow(EBSA_intersect))
  Query_output_EBSA<-if(EBSA_result < 1){
    "The search area does not overlap with identified Ecologically and Biologically Significant Areas (EBSA)."
  } else {
    "The search area overlaps with identified Ecologically and Biologically Significant Areas (EBSA)."
  }
  
  Query_output_EBSA2<-noquote(Query_output_EBSA)
  
  writeLines(Query_output_EBSA2)
  
}


#EBSA report
EBSA_report <- function(EBSA_sf, studyArea) {
  
  EBSA_intersect <- st_intersection(EBSA_sf,studyArea)
  EBSA_result<-as.numeric(nrow(EBSA_intersect))
  Query_output_EBSA_report<-if(EBSA_result < 1){
    ""
  } else {
    paste("Report: ", EBSA_intersect$Report)
  }

  Query_output_EBSA_report2<-unique(noquote(Query_output_EBSA_report))
  
  writeLines(Query_output_EBSA_report2, sep="\n")
  
}

#EBSA report URL

EBSA_reporturl <- function(EBSA_sf, studyArea) {
  
  intersect <- st_intersection(EBSA_sf,studyArea)
  x<-as.numeric(nrow(intersect))
  Query_output_EBSA_reporturl<-if(x < 1){
    ""
  } else {
    paste("Report URL:",intersect$Report_URL)
  }
  
  Query_output_EBSA_reporturl2<-unique(noquote(Query_output_EBSA_reporturl))
  
  writeLines(Query_output_EBSA_reporturl2, sep="\n")
  
}

#Location intersect
EBSA_location <- function(EBSA_sf, studyArea) {
  
  intersect <- st_intersection(EBSA_sf,studyArea)
  x<-as.numeric(nrow(intersect))
  Location_result<-if(x < 1){
    ""
  } else {
    paste("Location: ",intersect$Name)
  }
  
  writeLines(Location_result, sep="\n")
}


#Bioregion intersect
EBSA_bioregion <- function(EBSA_sf, studyArea) {
  
  intersect <- st_intersection(EBSA_sf,studyArea)
  x<-as.numeric(nrow(intersect))
  Query_output_area<-if(x < 1){
    ""
  } else {
    paste("Bioregion: ",intersect$Bioregion)
  }
  
  Query_output_area2<-paste(unique(Query_output_area), collapse = ' ')
  Query_output_area3<-noquote(Query_output_area2)
  
  Bioregion_result<-if(x < 1){
    ""
  } else {
    writeLines(Query_output_area3, sep="\n")
  }
  
  
}

