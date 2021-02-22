#This function identifies whether a PEZ polygon overlaps with identified blue whale habitat. It also identifies
#the name of the sector, activity and months.

#Multipolygon of blue whale habitat cropped to the maritime region.
#Overlay blue whale habitat
blue_whale_habitat_overlap <- function(Blue_Whale_shp, PEZ_poly_st) {
  
  intersect <- st_intersection(Blue_Whale_shp,PEZ_poly_st)
  x<-as.numeric(nrow(intersect))
  Query_output_crit<-if(x < 1){
    "Search area overlaps with Blue Whale Important Habitat in the Western North Atlantic."
  } else {
    "Search area does not overlaps with Blue Whale Important Habitat in the Western North Atlantic."
  }
  
  Query_output_crit2<-noquote(Query_output_crit)
  
  writeLines(Query_output_crit2)
  
}

#Sector intersect
blue_whale_habitat_sector <- function(Blue_Whale_shp, PEZ_poly_st) {
  
  intersect <- st_intersection(Blue_Whale_shp,PEZ_poly_st)
  x<-as.numeric(nrow(intersect))
  Query_output_sector<-if(x < 1){
    ""
  } else {
    c(("Sector/Secteur: "),intersect$sector)
  }
  
  Query_output_sector2<-noquote(Query_output_sector)
  
  Query_output_secteur<-if(x < 1){
    ""
  } else {
    c(intersect$secteur)
  }
  
  Query_output_secteur2<-noquote(Query_output_secteur)
  
  Sector_result<-if(x < 1){
    ""
  } else {
    c(Query_output_sector2,"/",Query_output_secteur)
  }

  Activity_result<-if(x < 1){
    ""
  } else {
    writeLines(Sector_result, sep="\n")
  }


}

#Activity intersect
blue_whale_habitat_activity <- function(Blue_Whale_shp, PEZ_poly_st) {
  intersect <- st_intersection(Blue_Whale_shp,PEZ_poly_st)
  x<-as.numeric(nrow(intersect))
  Query_output_activity<-if(x < 1){
    ""
  } else {
    c(("Activity/Activite: "),intersect$activity)
  }
  
  Query_output_activity2<-noquote(Query_output_activity)
  
  Query_output_activite<-if(x < 1){
    ""
  } else {
    c(intersect$activite)
  }
  
  Query_output_activite2<-noquote(Query_output_activite)

  Activity_result<-if(x < 1){
    ""
  } else {
    c(Query_output_activity2,"/",Query_output_activite2)
  }
  
  Activity_result<-if(x < 1){
    ""
  } else {
    writeLines(Activity_result, sep="\n")
  }    
  
}

#Months intersect
blue_whale_habitat_months <- function(Blue_Whale_shp, PEZ_poly_st) {
  intersect <- st_intersection(Blue_Whale_shp,PEZ_poly_st)
  x<-as.numeric(nrow(intersect))
  Query_output_months<-if(x < 1){
    ""
  } else {
    c(("Months/Mois: "),intersect$months)
  }
  
  Query_output_months2<-noquote(Query_output_months)
  
  Query_output_mois<-if(x < 1){
    ""
  } else {
    c(intersect$mois)
  }
  
  Query_output_mois2<-noquote(Query_output_mois)
  
  Months_result<-if(x < 1){
    ""
  } else {
    c(Query_output_months2,"/",Query_output_mois2)
  }

  Months_result<-if(x < 1){
    ""
  } else {
    writeLines(Months_result, sep="\n")
  }    
  
}
