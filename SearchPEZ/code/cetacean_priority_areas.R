#This function identifies whether a PEZ polygon overlaps with priority areas for cetaceans.

#Multipolygon of priority areas for cetaceans cropped to the maritime region.
#Overlay priority areas for cetaceans
fin_overlap <- function(fin_whale_sf, PEZ_poly_st) {
  
  fin_intersect <- st_intersection(fin_whale_sf,PEZ_poly_st)
  x<-as.numeric(nrow(fin_intersect))
  fin_area<-if(x < 1){
    FALSE
  } else {
    TRUE
  }
}  

harbour_overlap <- function(harbour_porpoise_sf, PEZ_poly_st) {  
  
  harbour_intersect <- st_intersection(harbour_porpoise_sf,PEZ_poly_st)
  x<-as.numeric(nrow(harbour_intersect))
  harbour_area<-if(x < 1){
    FALSE
  } else {
    TRUE
  }
}  

humpback_overlap <- function(humpback_whale_sf, PEZ_poly_st) {  

  humpback_intersect <- st_intersection(humpback_whale_sf,PEZ_poly_st)
  x<-as.numeric(nrow(humpback_intersect))
  humpback_area<-if(x < 1){
    FALSE
  } else {
    TRUE
  }
  
}  

sei_overlap <- function(sei_whale_sf, PEZ_poly_st) {
  
  sei_intersect <- st_intersection(sei_whale_sf,PEZ_poly_st)
  x<-as.numeric(nrow(sei_intersect))
  sei_area<-if(x < 1){
    FALSE
  } else {
    TRUE
  }
  
}

cetacean_summary <- function(fin_area,harbour_area,humpback_area,sei_area) {
cetacean_matrix<-data.frame(Fin_Whale="",Habour_Porpoise="", Humpback_Whale="", Sei_Whale="")
cetacean_matrix[1,1]<-fin_area
cetacean_matrix[1,2]<-harbour_area
cetacean_matrix[1,3]<-humpback_area
cetacean_matrix[1,4]<-sei_area
}