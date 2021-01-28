#Load file containing scientific and common names of priority species.

listed_species<-read.csv("../../../Data/NaturalResources/Species/SAR_MAR_Region_SORTED.csv")
MARSAR_com <- listed_species$Common_Name
MARSAR_com_up <- listed_species$Common_Name_upper
MARSAR_sci <- listed_species$Scientific_Name

# ==== iNaturalist ====

library(rinat)

# query iNaturalist
MARSAR_sci

iNatPoly <- c(42, -67.6, 47.7, -56.5)

inat1 <- get_inat_obs(query = c("Acipenser brevirostrum"), bounds = iNatPoly)
inat2 <- get_inat_obs(query = c("Acipenser oxyrinchus"), bounds = iNatPoly)
inat3 <- get_inat_obs(query = c("Alasmidonta varicosa"), bounds = iNatPoly)
inat4 <- get_inat_obs(query = c("Alopias vulpinus"), bounds = iNatPoly)
inat5 <- get_inat_obs(query = c("Amblyraja radiata"), bounds = iNatPoly)
inat6 <- get_inat_obs(query = c("Ammocrypta pellucida"), bounds = iNatPoly)
inat7 <- get_inat_obs(query = c("Anarhichas denticulatus"), bounds = iNatPoly)
inat8 <- get_inat_obs(query = c("Anarhichas lupus"), bounds = iNatPoly)
inat9 <- get_inat_obs(query = c("Anarhichas minor"), bounds = iNatPoly)
inat10 <- get_inat_obs(query = c("Anguilla rostrata"), bounds = iNatPoly)
inat11 <- get_inat_obs(query = c("Anthoptilum murrayi"), bounds = iNatPoly)
inat12 <- get_inat_obs(query = c("Balaenoptera borealis"), bounds = iNatPoly)
inat13 <- get_inat_obs(query = c("Balaenoptera musculus"), bounds = iNatPoly)
inat14 <- get_inat_obs(query = c("Balaenoptera physalus"), bounds = iNatPoly)
inat15 <- get_inat_obs(query = c("Barnea truncata"), bounds = iNatPoly)
inat16 <- get_inat_obs(query = c("Bathyraja spinicauda"), bounds = iNatPoly)
inat17 <- get_inat_obs(query = c("Brosme brosme"), bounds = iNatPoly)
inat18 <- get_inat_obs(query = c("Carcharodon carcharias"), bounds = iNatPoly)
inat19 <- get_inat_obs(query = c("Caretta caretta"), bounds = iNatPoly)
inat20 <- get_inat_obs(query = c("Cetorhinus maximus"), bounds = iNatPoly)
inat21 <- get_inat_obs(query = c("Chaceon quinquedens"), bounds = iNatPoly)
inat22 <- get_inat_obs(query = c("Chrysogorgia agassizii"), bounds = iNatPoly)
inat23 <- get_inat_obs(query = c("Coregonus"), bounds = iNatPoly)
inat24 <- get_inat_obs(query = c("Coryphaenoides rupestris"), bounds = iNatPoly)
inat25 <- get_inat_obs(query = c("Cyclopterus lumpus"), bounds = iNatPoly)
inat26 <- get_inat_obs(query = c("Delphinapterus leucas"), bounds = iNatPoly)
inat27 <- get_inat_obs(query = c("Dermochelys coriacea"), bounds = iNatPoly)
inat28 <- get_inat_obs(query = c("Eubalaena glacialis"), bounds = iNatPoly)
inat29 <- get_inat_obs(query = c("Fundulus diaphanus"), bounds = iNatPoly)
inat30 <- get_inat_obs(query = c("Gadus morhua"), bounds = iNatPoly)
inat31 <- get_inat_obs(query = c("Glyptocephalus cynoglossus"), bounds = iNatPoly)
inat32 <- get_inat_obs(query = c("Hippoglossoides platessoides"), bounds = iNatPoly)
inat33 <- get_inat_obs(query = c("Hyperoodon ampullatus"), bounds = iNatPoly)
inat34 <- get_inat_obs(query = c("Isurus oxyrinchus"), bounds = iNatPoly)
inat35 <- get_inat_obs(query = c("Lamna nasus"), bounds = iNatPoly)
inat36 <- get_inat_obs(query = c("Lampsilis cariosa"), bounds = iNatPoly)
inat37 <- get_inat_obs(query = c("Lepomis auritus"), bounds = iNatPoly)
inat38 <- get_inat_obs(query = c("Leucoraja ocellata"), bounds = iNatPoly)
inat39 <- get_inat_obs(query = c("Macrourus berglax"), bounds = iNatPoly)
inat40 <- get_inat_obs(query = c("Makaira nigricans"), bounds = iNatPoly)
inat41 <- get_inat_obs(query = c("Malacoraja senta"), bounds = iNatPoly)
inat42 <- get_inat_obs(query = c("Megaptera novaeangliae"), bounds = iNatPoly)
inat43 <- get_inat_obs(query = c("Mesoplodon bidens"), bounds = iNatPoly)
inat44 <- get_inat_obs(query = c("Morone saxatilis"), bounds = iNatPoly)
inat45 <- get_inat_obs(query = c("Moxostoma hubbsi"), bounds = iNatPoly)
inat46 <- get_inat_obs(query = c("Odobenus rosmarus"), bounds = iNatPoly)
inat47 <- get_inat_obs(query = c("Orcinus orca"), bounds = iNatPoly)
inat48 <- get_inat_obs(query = c("Ovalipes ocellatus"), bounds = iNatPoly)
inat49 <- get_inat_obs(query = c("Paragorgia johnsoni"), bounds = iNatPoly)
inat50 <- get_inat_obs(query = c("Pennatula phosphorea"), bounds = iNatPoly)
inat51 <- get_inat_obs(query = c("Phoca vitulina vitulina"), bounds = iNatPoly)
inat52 <- get_inat_obs(query = c("Phocoena phocoena"), bounds = iNatPoly)
inat53 <- get_inat_obs(query = c("Salmo salar"), bounds = iNatPoly)
inat54 <- get_inat_obs(query = c("Scleroptilum grandiflorum"), bounds = iNatPoly)
inat55 <- get_inat_obs(query = c("Scomber scombrus"), bounds = iNatPoly)
inat56 <- get_inat_obs(query = c("Sebastes fasciatus"), bounds = iNatPoly)
inat57 <- get_inat_obs(query = c("Sebastes mentella"), bounds = iNatPoly)
inat58 <- get_inat_obs(query = c("Squalus acanthias"), bounds = iNatPoly)
inat59 <- get_inat_obs(query = c("Tetrapturus albidus"), bounds = iNatPoly)
inat60 <- get_inat_obs(query = c("Thunnus albacares"), bounds = iNatPoly)
inat61 <- get_inat_obs(query = c("Thunnus obesus"), bounds = iNatPoly)
inat62 <- get_inat_obs(query = c("Thunnus thynnus"), bounds = iNatPoly)
inat63 <- get_inat_obs(query = c("Umbellula encrinus"), bounds = iNatPoly)
inat64 <- get_inat_obs(query = c("Urophycis tenuis"), bounds = iNatPoly)


inat<-rbind(inat1,inat10,inat14,inat15,inat18,inat19,inat2,inat20,inat23,inat25,inat26,inat27,inat28,inat29,inat3,inat30,inat31,inat32,inat35,
            inat36,inat37,inat38,inat4,inat42,inat44,inat47,inat48,inat5,inat51,inat52,inat53,inat55,inat58,inat62,inat64,inat8,inat9)

# keep research grade records
inat_res=inat[which(inat$quality_grade=="research"),]
unique(inat_res$scientific_name)

inat_res<-inat_res[!(inat_res$scientific_name=="Larus marinus"),]
inat_res<-inat_res[!(inat_res$scientific_name=="Nematoda"),]
inat_res<-inat_res[!(inat_res$scientific_name=="Rajella fyllae"),]
inat_res<-inat_res[!(inat_res$scientific_name=="Pollachius virens"),]
inat_res<-inat_res[!(inat_res$scientific_name=="Squalus suckleyi"),]

write.csv(inat_res,"iNaturalist_MAR_priority_records.csv")

getwd()

# ==== OBIS ====
# obis polygon
library(devtools)
library(robis)


OBIS_MAR_priority <- occurrence(c(MARSAR_sci), geometry = "POLYGON ((-68.59863 41.42625, -66.79688 48.40003, -50.91064 48.15143, -53.23975 39.97712, -68.59863 41.42625))")
write.csv(OBIS_MAR_priority, "OBIS_MAR_priority_records.csv")

#Filter down OBIS file to include only necessary columns
obis<-read.csv("../../../Data/NaturalResources/Species/OBIS_CBIF_iNaturalist/OBIS_MAR_priority_records.csv")

names(obis)
obis_edit<-obis %>% 
  transmute(scientificName, decimalLatitude, decimalLongitude, year,individualCount, rightsHolder, institutionID, institutionCode, collectionCode, datasetID)
names(obis_edit)
obis_datasetID<-unique(obis_edit$datasetID)
write.csv(obis_datasetID,"obis_datasetID.csv") 

#Separate CWS/ECCC records
CWS.ECCC.OBIS_records<-filter(obis_edit, institutionCode=="Canadian Wildlife Service-Atlantic, Environment and Climate Change Canada")
write.csv(CWS.ECCC.OBIS_records, "CWS_ECCC_OBIS_records.csv")

#Delete WSDB and CWS/ECCC records
obis_edit2<-obis_edit %>%
  filter(! institutionCode =="Canadian Wildlife Service-Atlantic, Environment and Climate Change Canada")
obis_edit3<-obis_edit2 %>%
  filter(! collectionCode =="WHALESITINGS")


# ==== GBIF ====

library(rgbif)

# extract from GBIF
gbif <- occ_data(scientificName=species, geometry="POLYGON ((-68.59863 41.42625, -66.79688 48.40003, -50.91064 48.15143, -53.23975 39.97712, -68.59863 41.42625))")


#  remove iNaturalist records
ina=which(gdf$institutionCode=="iNaturalist")
gdf1=gdf[-ina,]
