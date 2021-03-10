#This function identifies whether a PEZ polygon overlaps with identified Ecologically and Biologically Significant Areas (EBSA). 
#It also identifies the region in which the the EBSA is.

#Multipolygon of EBSA.
#Overlay EBSA
EBSA_overlap <- function(EBSA_sf, PEZ_poly_sf) {
  
  intersect <- st_intersection(EBSA_sf,PEZ_poly_sf)
  x<-as.numeric(nrow(intersect))
  Query_output_EBSA<-if(x < 1){
    "The search area does not overlap with identified Ecologically and Biologically Significant Areas (EBSA)."
  } else {
    "The search area overlaps with identified Ecologically and Biologically Significant Areas (EBSA)."
  }
  
  Query_output_EBSA2<-noquote(Query_output_EBSA)
  
  writeLines(Query_output_EBSA2)
  
}


#EBSA report
EBSA_report <- function(EBSA_sf, PEZ_poly_sf) {
  
  intersect <- st_intersection(EBSA_sf,PEZ_poly_sf)
  x<-as.numeric(nrow(intersect))
  Query_output_EBSA_report<-if(x < 1){
    ""
  } else {
    c("Report: ",intersect$Report)
  }
  
  Query_output_EBSA_report2<-unique(noquote(Query_output_EBSA_report))

  writeLines(Query_output_EBSA_report2, sep="\n")
  
}

#EBSA report URL

EBSA_reporturl <- function(EBSA_sf, PEZ_poly_sf) {
  
  intersect <- st_intersection(EBSA_sf,PEZ_poly_sf)
  x<-as.numeric(nrow(intersect))
  Query_output_EBSA_reporturl<-if(x < 1){
    ""
  } else {
    c("Report URL:",intersect$Report_URL)
  }
  
  Query_output_EBSA_reporturl2<-unique(noquote(Query_output_EBSA_reporturl))
  
  writeLines(Query_output_EBSA_reporturl2, sep="\n")
  
}

#Location intersect
EBSA_location <- function(EBSA_sf, PEZ_poly_sf) {
  
  intersect <- st_intersection(EBSA_sf,PEZ_poly_sf)
  x<-as.numeric(nrow(intersect))
  Location_result<-if(x < 1){
    ""
  } else {
    c(("Location: "),intersect$Name, sep="\n")
  }
  
  writeLines(Location_result, sep="\n")
}
  

#Bioregion intersect
EBSA_bioregion <- function(EBSA_sf, PEZ_poly_sf) {
  
  intersect <- st_intersection(EBSA_sf,PEZ_poly_sf)
  x<-as.numeric(nrow(intersect))
  Query_output_area<-if(x < 1){
    ""
  } else {
    c(("Bioregion: "),intersect$Bioregion)
  }
  
  Query_output_area2<-paste(unique(Query_output_area), collapse = ' ')
  Query_output_area3<-noquote(Query_output_area2)
  
  Bioregion_result<-if(x < 1){
    ""
  } else {
    writeLines(Query_output_area3, sep="\n")
  }
  
  
}
