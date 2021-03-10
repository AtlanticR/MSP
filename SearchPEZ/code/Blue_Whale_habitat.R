#This function identifies whether a PEZ polygon overlaps with identified blue whale habitat. It also identifies
#the name of the sector, activity and months.

#Multipolygon of blue whale habitat cropped to the maritime region.
#Overlay blue whale habitat
blue_whale_habitat_overlap <- function(Blue_Whale_sf, PEZ_poly_sf) {
  
  intersect <- st_intersection(Blue_Whale_sf,PEZ_poly_sf)
  x<-as.numeric(nrow(intersect))
  Query_output_crit<-if(x < 1){
    "Search area overlaps with Blue Whale Important Habitat in the Western North Atlantic."
  } else {
    "Search area does not overlaps with Blue Whale Important Habitat in the Western North Atlantic."
  }
  
  Query_output_crit2<-noquote(Query_output_crit)
  
  #writeLines(Query_output_crit2)
  
}

#Sector intersect
blue_whale_habitat_sector <- function(Blue_Whale_sf, PEZ_poly_sf) {
  
  intersect <- st_intersection(Blue_Whale_sf,PEZ_poly_sf)
  x<-as.numeric(nrow(intersect))
  Sector_result<-if(x < 1){
    ""
  } else {
    c(("Sector: "),intersect$sector)
  }
  
  Sector_result<-if(x < 1){
    ""
  } else {
    writeLines(Sector_result, sep="\n")
  }


}

#Activity intersect
blue_whale_habitat_activity <- function(Blue_Whale_sf, PEZ_poly_sf) {
  intersect <- st_intersection(Blue_Whale_sf,PEZ_poly_sf)
  x<-as.numeric(nrow(intersect))
  Activity_result<-if(x < 1){
    ""
  } else {
    c(("Activity: "),intersect$Activity)
  }
  
  Activity_result<-if(x < 1){
    ""
  } else {
    writeLines(Activity_result, sep="\n")
  }    
  
}

#Months intersect
blue_whale_habitat_months <- function(Blue_Whale_sf, PEZ_poly_st) {
  intersect <- st_intersection(Blue_Whale_sf,PEZ_poly_st)
  x<-as.numeric(nrow(intersect))
  Months_result<-if(x < 1){
    ""
  } else {
    c(("Months: "),intersect$months)
  }
  
    Months_result<-if(x < 1){
    ""
  } else {
    writeLines(Months_result, sep="\n")
  }    
  
}
