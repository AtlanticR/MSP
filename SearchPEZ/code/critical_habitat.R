#This function identifies whether a PEZ polygon overlaps with identified critical habitat. It also identifies
#the name of the critical habitat and the SAR species.

#Multipolygon of Canadian critical habitats cropped to the maritime region.

critical_habitat <- function(ClippedCritHab, PEZ_poly_st) {
  
#Overlay critical habitat and   
intersect <- st_intersection(ClippedCritHab,PEZ_poly_st)
x<-as.numeric(nrow(intersect))
Query_output_crit<-if(x < 1){
  "Does not overlap with defined critical habitat"
} else {
  "Overlaps with Critical Habitat"
}


Query_output_crit2<-noquote(Query_output_crit)

Query_output_species<-if(x < 1){
  "Does not overlap with defined critical habitat"
} else {
    c(("Species: "),intersect$Common_Nam)
}

Query_output_sp2<-paste(unique(Query_output_species), collapse = ' ')
Query_output_sp3<-noquote(Query_output_sp2)

Query_output_area<-if(x < 1){
  "Does not overlap with defined critical habitat"
} else {
  c(("Area: "),intersect$Waterbody)
}

Query_output_area2<-paste(unique(Query_output_area), collapse = ' ')
Query_output_area3<-noquote(Query_output_area2)

result<-paste(unique(Query_output_crit2,Query_output_area3,Query_output_sp3, fromLast=TRUE))
writeLines(c(result), sep = "\n")

}
