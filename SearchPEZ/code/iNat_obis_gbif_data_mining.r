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
#gbif <- occ_data(scientificName=listed_species$Scientific_Name, 
#                 geometry="POLYGON ((-68.59863 41.42625, -66.79688 48.40003, -50.91064 48.15143, -53.23975 39.97712, -68.59863 41.42625))",
#                 limit=1000000)

Coregonus <- occ_data(scientificName="Coregonus", 
                              geometry="POLYGON ((-68.59863 41.42625, -66.79688 48.40003, -50.91064 48.15143, -53.23975 39.97712, -68.59863 41.42625))",
                              limit=1000000)

Acipenser_brevirostrum<-gbif[["Acipenser brevirostrum"]][["data"]]
Acipenser_oxyrinchus<-gbif[["Acipenser oxyrinchus"]][["data"]]
Alasmidonta_varicosa<-gbif[["Alasmidonta varicosa"]][["data"]]
Alopias_vulpinus<-gbif[["Alopias vulpinus"]][["data"]]
Amblyraja_radiata2<-Amblyraja_radiata[["data"]]
Anarhichas_denticulatus<-gbif[["Anarhichas denticulatus"]][["data"]]
Anarhichas_lupus2<-Anarhichas_lupus[["data"]]
Anarhichas_minor<-gbif[["Anarhichas minor"]][["data"]]
Anguilla_rostrata2<-Anguilla_rostrata[["data"]]
Anthoptilum_murrayi<-gbif[["Anthoptilum murrayi"]][["data"]]
Balaenoptera_borealis2<-Balaenoptera_borealis[["data"]]
Balaenoptera_musculus<-gbif[["Balaenoptera musculus"]][["data"]]
Balaenoptera_physalus2<-Balaenoptera_physalus[["data"]]
Barnea_truncata<-gbif[["Barnea truncata"]][["data"]]
Bathyraja_spinicauda<-gbif[["Bathyraja spinicauda"]][["data"]]
Brosme_brosme2<-Brosme_brosme[["data"]]
Carcharodon_carcharias<-gbif[["Carcharodon carcharias"]][["data"]]
Caretta_caretta<-gbif[["Caretta caretta"]][["data"]]
Cetorhinus_maximus<-gbif[["Cetorhinus maximus"]][["data"]]
Chaceon_quinquedens<-gbif[["Chaceon quinquedens"]][["data"]]
Chrysogorgia_agassizii<-gbif[["Chrysogorgia agassizii"]][["data"]]
Coregonus_huntsmani<-gbif[["Coregonus huntsmani"]][["data"]]
Coregonus<-Coregonus[["data"]]
Coryphaenoides_rupestris<-gbif[["Coryphaenoides rupestris"]][["data"]]
Cyclopterus_lumpus2<-Cyclopterus_lumpus[["data"]]
Delphinapterus_leucas<-gbif[["Delphinapterus leucas"]][["data"]]
Dermochelys_coriacea2<-Dermochelys_coriacea[["data"]]
Eubalaena_glacialis2<-Eubalaena_glacialis[["data"]]
Fundulus_diaphanus<-gbif[["Fundulus diaphanus"]][["data"]]
Gadus_morhua2<-Gadus_morhua[["data"]]
Glyptocephalus_cynoglossus2<-Glyptocephalus_cynoglossus[["data"]]
Hippoglossoides_platessoides2<-Hippoglossoides_platessoides[["data"]]
Hyperoodon_ampullatus2<-Hyperoodon_ampullatus[["data"]]
Isurus_oxyrinchus<-gbif[["Isurus oxyrinchus"]][["data"]]
Lamna_nasus<-gbif[["Lamna nasus"]][["data"]]
Lampsilis_cariosa<-gbif[["Lampsilis cariosa"]][["data"]]
Lepomis_auritus<-gbif[["Lepomis auritus"]][["data"]]
Leucoraja_ocellata2<-Leucoraja_ocellata[["data"]]
Macrourus_berglax<-gbif[["Macrourus berglax"]][["data"]]
Makaira_nigricans<-gbif[["Makaira nigricans"]][["data"]]
Malacoraja_senta2<-Malacoraja_senta[["data"]]
Megaptera_novaeangliae2<-Megaptera_novaeangliae[["data"]]
Mesoplodon_bidens<-gbif[["Mesoplodon bidens"]][["data"]]
Morone_saxatilis<-gbif[["Morone saxatilis"]][["data"]]
Odobenus_rosmarus_rosmarus<-gbif[["Odobenus rosmarus  rosmarus"]][["data"]]
Orcinus_orca<-gbif[["Orcinus orca"]][["data"]]
Ovalipes_ocellatus<-gbif[["Ovalipes ocellatus"]][["data"]]
Pennatula_phosphorea<-gbif[["Pennatula phosphorea"]][["data"]]
Phocoena_phocoena2<-Phocoena_phocoena[["data"]]
Salmo_salar2<-Salmo_salar[["data"]]
Scomber_scombrus<-scomber_scombrus[["data"]]
Sebastes_mentella2<-Sebastes_mentella[["data"]]
Sebastes_fasciatus2<-Sebastes_fasciatus[["data"]]
Squalus_acanthias2<-Squalus_acanthias[["data"]]
Thunnus_albacares<-gbif[["Thunnus albacares"]][["data"]]
Thunnus_obesus<-gbif[["Thunnus obesus"]][["data"]]
Thunnus_thynnus<-gbif[["Thunnus thynnus"]][["data"]]
Urophycis_tenuis2<-Urophycis_tenuis[["data"]]

#Ammocrypta_pellucida<-gbif[["Ammocrypta pellucida"]][["data"]]
#Moxostoma_hubbsi<-gbif[["Moxostoma hubbsi"]][["data"]]
#Paragorgia_johnsoni<-gbif[["Paragorgia johnsoni"]][["data"]]
#Phoca_vitulina__mellonae<-gbif[["Phoca vitulina  mellonae"]][["data"]]
#Scleroptilum_grandiflorum<-gbif[["Scleroptilum grandiflorum"]][["data"]]
#Umbellula_encrinus<-gbif[["Umbellula encrinus"]][["data"]]

dplyr::select(Sebastes_mentella, species, decimalLatitude, decimalLongitude, basisOfRecord, year, month, 
              day, rightsHolder, datasetName, institutionCode, individualCount, organismQuantity, collectionCode)

Sebastes_mentella2<-dplyr::select(Sebastes_mentella, species, decimalLatitude, decimalLongitude, basisOfRecord, year, month, 
                                  day, rightsHolder, datasetName, institutionCode, individualCount, collectionCode)
dplyr::select(Sebastes_mentella, species, decimalLatitude, decimalLongitude, basisOfRecord, year, month, 
              day, rightsHolder, datasetName, institutionCode, individualCount, organismQuantity, collectionCode)

Acipenser_brevirostrum<-dplyr::select(Acipenser_brevirostrum, species, decimalLatitude, decimalLongitude, basisOfRecord, year, month, day, rightsHolder, datasetName, institutionCode, individualCount, organismQuantity, collectionCode)
Acipenser_oxyrinchus<-dplyr::select(Acipenser_oxyrinchus, species, decimalLatitude, decimalLongitude, basisOfRecord, year, month, day, rightsHolder, datasetName, institutionCode, individualCount, organismQuantity, collectionCode)
Alasmidonta_varicosa<-dplyr::select(Alasmidonta_varicosa, species, decimalLatitude, decimalLongitude, basisOfRecord, year, month, day, rightsHolder, datasetName, institutionCode, individualCount, collectionCode)
Alopias_vulpinus<-dplyr::select(Alopias_vulpinus, species, decimalLatitude, decimalLongitude, basisOfRecord, year, month, day, rightsHolder, datasetName, institutionCode, individualCount, organismQuantity, collectionCode)
Amblyraja_radiata<-dplyr::select(Amblyraja_radiata2, species, decimalLatitude, decimalLongitude, basisOfRecord, year, month, day, rightsHolder, datasetName, institutionCode, individualCount, organismQuantity, collectionCode)
Anarhichas_denticulatus<-dplyr::select(Anarhichas_denticulatus, species, decimalLatitude, decimalLongitude, basisOfRecord, year, month, day, rightsHolder, datasetName, institutionCode, individualCount, organismQuantity, collectionCode)
Anarhichas_lupus<-dplyr::select(Anarhichas_lupus2, species, decimalLatitude, decimalLongitude, basisOfRecord, year, month, day, rightsHolder, datasetName, institutionCode, individualCount, organismQuantity, collectionCode)
Anarhichas_minor<-dplyr::select(Anarhichas_minor, species, decimalLatitude, decimalLongitude, basisOfRecord, year, month, day, rightsHolder, datasetName, institutionCode, individualCount, organismQuantity, collectionCode)
Anguilla_rostrata<-dplyr::select(Anguilla_rostrata2, species, decimalLatitude, decimalLongitude, basisOfRecord, year, month, day, rightsHolder, datasetName, institutionCode, individualCount, organismQuantity, collectionCode)
Anthoptilum_murrayi<-dplyr::select(Anthoptilum_murrayi, species, decimalLatitude, decimalLongitude, basisOfRecord, year, month, day, rightsHolder, institutionCode, individualCount, collectionCode)
Balaenoptera_borealis<-dplyr::select(Balaenoptera_borealis2, species, decimalLatitude, decimalLongitude, basisOfRecord, year, month, day, rightsHolder, datasetName, institutionCode, individualCount, organismQuantity, collectionCode)
Balaenoptera_musculus<-dplyr::select(Balaenoptera_musculus, species, decimalLatitude, decimalLongitude, basisOfRecord, year, month, day, rightsHolder, datasetName, institutionCode, individualCount, organismQuantity, collectionCode)
Balaenoptera_physalus<-dplyr::select(Balaenoptera_physalus2, species, decimalLatitude, decimalLongitude, basisOfRecord, year, month, day, rightsHolder, datasetName, institutionCode, individualCount, organismQuantity, collectionCode)
Barnea_truncata<-dplyr::select(Barnea_truncata, species, decimalLatitude, decimalLongitude, basisOfRecord, year, month, day, rightsHolder, datasetName, institutionCode, individualCount, collectionCode)
Bathyraja_spinicauda<-dplyr::select(Bathyraja_spinicauda, species, decimalLatitude, decimalLongitude, basisOfRecord, year, month, day, rightsHolder, datasetName, institutionCode, individualCount, organismQuantity, collectionCode)
Brosme_brosme<-dplyr::select(Brosme_brosme2, species, decimalLatitude, decimalLongitude, basisOfRecord, year, month, day, rightsHolder, datasetName, institutionCode, individualCount, organismQuantity, collectionCode)
Carcharodon_carcharias<-dplyr::select(Carcharodon_carcharias, species, decimalLatitude, decimalLongitude, basisOfRecord, year, month, day, rightsHolder, datasetName, institutionCode, individualCount, organismQuantity, collectionCode)
Caretta_caretta<-dplyr::select(Caretta_caretta, species, decimalLatitude, decimalLongitude, basisOfRecord, year, month, day, rightsHolder, datasetName, institutionCode, individualCount, organismQuantity, collectionCode)
Cetorhinus_maximus<-dplyr::select(Cetorhinus_maximus, species, decimalLatitude, decimalLongitude, basisOfRecord, year, month, day, rightsHolder, datasetName, institutionCode, individualCount, organismQuantity, collectionCode)
Chaceon_quinquedens<-dplyr::select(Chaceon_quinquedens, species, decimalLatitude, decimalLongitude, basisOfRecord, year, month, day, rightsHolder, datasetName, institutionCode, individualCount, collectionCode)
Chrysogorgia_agassizii<-dplyr::select(Chrysogorgia_agassizii, species, decimalLatitude, decimalLongitude, basisOfRecord, year, month, day, rightsHolder, datasetName, institutionCode, individualCount, collectionCode)
Coregonus_huntsmani<-dplyr::select(Coregonus_huntsmani, species, decimalLatitude, decimalLongitude, basisOfRecord, year, month, day, rightsHolder, datasetName, institutionCode, individualCount, collectionCode)
Coryphaenoides_rupestris<-dplyr::select(Coryphaenoides_rupestris, species, decimalLatitude, decimalLongitude, basisOfRecord, year, month, day, rightsHolder, datasetName, institutionCode, individualCount, organismQuantity, collectionCode)
Cyclopterus_lumpus<-dplyr::select(Cyclopterus_lumpus2, species, decimalLatitude, decimalLongitude, basisOfRecord, year, month, day, rightsHolder, datasetName, institutionCode, individualCount, organismQuantity, collectionCode)
Delphinapterus_leucas<-dplyr::select(Delphinapterus_leucas, species, decimalLatitude, decimalLongitude, basisOfRecord, year, month, day, rightsHolder, datasetName, institutionCode, individualCount, organismQuantity, collectionCode)
Dermochelys_coriacea<-dplyr::select(Dermochelys_coriacea2, species, decimalLatitude, decimalLongitude, basisOfRecord, year, month, day, rightsHolder, datasetName, institutionCode, individualCount, organismQuantity, collectionCode)
Eubalaena_glacialis<-dplyr::select(Eubalaena_glacialis2, species, decimalLatitude, decimalLongitude, basisOfRecord, year, month, day, rightsHolder, datasetName, institutionCode, individualCount, organismQuantity, collectionCode)
Fundulus_diaphanus<-dplyr::select(Fundulus_diaphanus, species, decimalLatitude, decimalLongitude, basisOfRecord, year, month, day, rightsHolder, datasetName, institutionCode, individualCount, organismQuantity, collectionCode)
Gadus_morhua<-dplyr::select(Gadus_morhua2, species, decimalLatitude, decimalLongitude, basisOfRecord, year, month, day, rightsHolder, datasetName, institutionCode, individualCount, organismQuantity, collectionCode)
Glyptocephalus_cynoglossus<-dplyr::select(Glyptocephalus_cynoglossus2, species, decimalLatitude, decimalLongitude, basisOfRecord, year, month, day, rightsHolder, datasetName, institutionCode, individualCount, organismQuantity, collectionCode)
Hippoglossoides_platessoides<-dplyr::select(Hippoglossoides_platessoides2, species, decimalLatitude, decimalLongitude, basisOfRecord, year, month, day, rightsHolder, datasetName, institutionCode, individualCount, organismQuantity, collectionCode)
Hyperoodon_ampullatus<-dplyr::select(Hyperoodon_ampullatus2, species, decimalLatitude, decimalLongitude, basisOfRecord, year, month, day, rightsHolder, datasetName, institutionCode, individualCount, organismQuantity, collectionCode)
Isurus_oxyrinchus<-dplyr::select(Isurus_oxyrinchus, species, decimalLatitude, decimalLongitude, basisOfRecord, year, month, day, rightsHolder, datasetName, institutionCode, individualCount, organismQuantity, collectionCode)
Lamna_nasus<-dplyr::select(Lamna_nasus, species, decimalLatitude, decimalLongitude, basisOfRecord, year, month, day, rightsHolder, datasetName, institutionCode, individualCount, organismQuantity, collectionCode)
Lampsilis_cariosa<-dplyr::select(Lampsilis_cariosa, species, decimalLatitude, decimalLongitude, basisOfRecord, year, month, day, rightsHolder, datasetName, institutionCode, individualCount, collectionCode)
Lepomis_auritus<-dplyr::select(Lepomis_auritus, species, decimalLatitude, decimalLongitude, basisOfRecord, year, month, day, rightsHolder, datasetName, institutionCode, individualCount, organismQuantity, collectionCode)
Leucoraja_ocellata<-dplyr::select(Leucoraja_ocellata2, species, decimalLatitude, decimalLongitude, basisOfRecord, year, month, day, rightsHolder, datasetName, institutionCode, individualCount, organismQuantity, collectionCode)
Macrourus_berglax<-dplyr::select(Macrourus_berglax, species, decimalLatitude, decimalLongitude, basisOfRecord, year, month, day, rightsHolder, datasetName, institutionCode, individualCount, organismQuantity, collectionCode)
Makaira_nigricans<-dplyr::select(Makaira_nigricans, species, decimalLatitude, decimalLongitude, basisOfRecord, year, month, day, rightsHolder, datasetName, institutionCode, individualCount, organismQuantity, collectionCode)
Malacoraja_senta<-dplyr::select(Malacoraja_senta2, species, decimalLatitude, decimalLongitude, basisOfRecord, year, month, day, rightsHolder, datasetName, institutionCode, individualCount, organismQuantity, collectionCode)
Megaptera_novaeangliae<-dplyr::select(Megaptera_novaeangliae2, species, decimalLatitude, decimalLongitude, basisOfRecord, year, month, day, rightsHolder, datasetName, institutionCode, individualCount, organismQuantity, collectionCode)
Mesoplodon_bidens<-dplyr::select(Mesoplodon_bidens, species, decimalLatitude, decimalLongitude, basisOfRecord, year, month, day, rightsHolder, datasetName, institutionCode, individualCount, organismQuantity, collectionCode)
Morone_saxatilis<-dplyr::select(Morone_saxatilis, species, decimalLatitude, decimalLongitude, basisOfRecord, year, month, day, rightsHolder, datasetName, institutionCode, individualCount, organismQuantity, collectionCode)
Odobenus_rosmarus_rosmarus<-dplyr::select(Odobenus_rosmarus_rosmarus, species, decimalLatitude, decimalLongitude, basisOfRecord, year, month, day, rightsHolder, datasetName, institutionCode, individualCount, collectionCode)
Orcinus_orca<-dplyr::select(Orcinus_orca, species, decimalLatitude, decimalLongitude, basisOfRecord, year, month, day, rightsHolder, datasetName, institutionCode, individualCount, organismQuantity, collectionCode)
Ovalipes_ocellatus<-dplyr::select(Ovalipes_ocellatus, species, decimalLatitude, decimalLongitude, basisOfRecord, year, month, day, rightsHolder, datasetName, institutionCode, individualCount, collectionCode)
Pennatula_phosphorea<-dplyr::select(Pennatula_phosphorea, species, decimalLatitude, decimalLongitude, basisOfRecord, year, month, day, datasetName, institutionCode, individualCount, collectionCode)
Phocoena_phocoena<-dplyr::select(Phocoena_phocoena2, species, decimalLatitude, decimalLongitude, basisOfRecord, year, month, day, rightsHolder, datasetName, institutionCode, individualCount, organismQuantity, collectionCode)
Salmo_salar<-dplyr::select(Salmo_salar2, species, decimalLatitude, decimalLongitude, basisOfRecord, year, month, day, rightsHolder, datasetName, institutionCode, individualCount, organismQuantity, collectionCode)
Scomber_scombrus<-dplyr::select(Scomber_scombrus, species, decimalLatitude, decimalLongitude, basisOfRecord, year, month, day, rightsHolder, datasetName, institutionCode, individualCount, organismQuantity, collectionCode)
Sebastes_mentella<-dplyr::select(Sebastes_mentella2, species, decimalLatitude, decimalLongitude, basisOfRecord, year, month, day, rightsHolder, datasetName, institutionCode, individualCount, collectionCode)
Sebastes_fasciatus<-dplyr::select(Sebastes_fasciatus2, species, decimalLatitude, decimalLongitude, basisOfRecord, year, month, day, rightsHolder, datasetName, institutionCode, individualCount, organismQuantity, collectionCode)
Squalus_acanthias<-dplyr::select(Squalus_acanthias2, species, decimalLatitude, decimalLongitude, basisOfRecord, year, month, day, rightsHolder, datasetName, institutionCode, individualCount, organismQuantity, collectionCode)
Thunnus_albacares<-dplyr::select(Thunnus_albacares, species, decimalLatitude, decimalLongitude, basisOfRecord, year, month, day, datasetName, institutionCode, individualCount, collectionCode)
Thunnus_obesus<-dplyr::select(Thunnus_obesus, species, decimalLatitude, decimalLongitude, basisOfRecord, year, month, day, rightsHolder, datasetName, institutionCode, individualCount, collectionCode)
Thunnus_thynnus<-dplyr::select(Thunnus_thynnus, species, decimalLatitude, decimalLongitude, basisOfRecord, year, month, day, rightsHolder, datasetName, institutionCode, individualCount, organismQuantity, collectionCode)
Urophycis_tenuis<-dplyr::select(Urophycis_tenuis2, species, decimalLatitude, decimalLongitude, basisOfRecord, year, month, day, rightsHolder, datasetName, institutionCode, individualCount, organismQuantity, collectionCode)

library(plyr)
gbif2<-rbind.fill(Acipenser_brevirostrum, Acipenser_oxyrinchus, Alasmidonta_varicosa, Alopias_vulpinus, Amblyraja_radiata, Anarhichas_denticulatus, Anarhichas_lupus, Anarhichas_minor, Anguilla_rostrata, Anthoptilum_murrayi, Balaenoptera_borealis, Balaenoptera_musculus, Balaenoptera_physalus, Barnea_truncata, Bathyraja_spinicauda, Brosme_brosme, Carcharodon_carcharias, Caretta_caretta, Cetorhinus_maximus, Chaceon_quinquedens, Chrysogorgia_agassizii, Coregonus_huntsmani, Coryphaenoides_rupestris, Cyclopterus_lumpus, Delphinapterus_leucas, Dermochelys_coriacea, 
                  Eubalaena_glacialis, Fundulus_diaphanus, Gadus_morhua, Glyptocephalus_cynoglossus, Hippoglossoides_platessoides, Hyperoodon_ampullatus, Isurus_oxyrinchus, Lamna_nasus, Lampsilis_cariosa, Lepomis_auritus, Leucoraja_ocellata, Macrourus_berglax, Makaira_nigricans, Malacoraja_senta, Megaptera_novaeangliae, Mesoplodon_bidens, Morone_saxatilis, Odobenus_rosmarus_rosmarus, Orcinus_orca, Ovalipes_ocellatus, Pennatula_phosphorea, Phocoena_phocoena, Salmo_salar, Scomber_scombrus, Sebastes_mentella, Sebastes_fasciatus, Squalus_acanthias, Thunnus_albacares, Thunnus_obesus, Thunnus_thynnus, Urophycis_tenuis)

#  remove iNaturalist records
ina=which(gbif2$institutionCode=="iNaturalist")
gbif3=gbif2[-ina,]
WS=which(gbif3$collectionCode=="WHALESITINGS")
gbif4=gbif3[-WS,]


unique(gbif3$rightsHolder)
unique(gbif3$collectionCode)
unique(gbif4$species)

write.csv(gbif4, "GBIF_MAR_priority_records.csv")
