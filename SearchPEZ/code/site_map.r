# This function is created specifically for the Aquaculture request purposes
#
# It plots aquaculture site map and zone of influence (PEZ)
#
# Input polygons (from shape files): 
# 1. studyArea- study area or zone of influence (PEZ)
# 2. site- aquaculture site polygon
# 3. land- landmask
# 
# Input parameteras:
# buf - distance in km from the study area to be plotted on the map
# this controls the "zoom" of the plot
#
# Output: map 


site_map <- function(PEZ_poly_sf,site_sf,land_sf,buf) {

  # buf is in km, and now converted to degrees
  buf=buf/100
  #png("pez_and_site.png", width=1616, height=1410)
  
  # bounding box
  bb=st_as_sf(st_bbox(PEZ_poly_sf))
  bbox <- st_bbox(bb)

  # longitude and latitude limits for the map
  longmin<-(bbox$xmin)-buf
  longmax<-bbox$xmax+buf
  latmin<-bbox$ymin-buf
  latmax<-bbox$ymax+buf
  
ggplot()+
  geom_sf(data=PEZ_poly_sf,fill="deepskyblue", col="black", size=0.6, alpha=0.4)+
  geom_sf(data=site_sf,fill="yellow",col="black", size=0.6)+
  geom_sf(data=land_sf,fill=c("lightgrey"), col="black", size=0.7)+
  watermark(show = TRUE, lab = "DFO Internal Use Only")+
  annotation_scale(location="bl")+
  theme_bw()+
  coord_sf(xlim = c(longmin, longmax), ylim = c(latmin, latmax))+
  labs(x="Longitude", y="Latitude", col="")+
  theme(axis.title.y = element_text(size = 13))+
  theme(axis.title.x = element_text(size = 13))
  
}
