#This function identifies whether a PEZ polygon overlaps with identified leatherback turtle habitat. It also identifies
#the name of the leatherback turtle habitat and the area which it corresponds with.

#Multipolygon of leatherback turtle habitats cropped to the maritime region.
#Overlay leatherrback turtle habitat
leatherback_overlap <- function(leatherback_shp, PEZ_poly_st) {
  
  intersect <- st_intersection(leatherback_shp,PEZ_poly_st)
  x<-as.numeric(nrow(intersect))
  Query_output_crit<-if(x < 1){
    "Polygon does not overlap with areas defined as leatherback turtle habitat."
  } else {
    "Polygon overlaps with areas defined as important habitat for leatherback turtles."
  }
  
  Query_output_crit2<-noquote(Query_output_crit)
  
  writeLines(Query_output_crit2)
  
}

#Area intersect
leatherback_area <- function(leatherback_shp, PEZ_poly_st) {
  
  intersect <- st_intersection(leatherback_shp,PEZ_poly_st)
  x<-as.numeric(nrow(intersect))
  Query_output_area<-if(x < 1){
    ""
  } else {
    c(("Area: "),intersect$AreaName)
  }
  
  Query_output_area2<-noquote(Query_output_area)
  
  Area_result<-if(x < 1){
    ""
  } else {
    writeLines(Area_result, sep="\n")
  }


}

