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


site_map <- function(studyArea,site,land,buf) {

  # buf is in km, and now converted to degrees
  buf <- buf/100

  # get bounding box
  bb <- st_bbox(studyArea)
  
  # buffer around bounding box
  # buf <- buf/100
  
  # longitude and latitude limits for the map
  lonLim <- c(bb[[1]]-buf, bb[[3]]+buf)
  latLim <- c(bb[[2]]-buf, bb[[4]]+buf)

  
  # longitude and latitude limits for the map
  lonLim <- c(bb[[1]]-buf, bb[[3]]+buf)
  latLim <- c(bb[[2]]-buf, bb[[4]]+buf)
  longmin<-bb[[1]]-buf
  longmax<-bb[[3]]+buf
  latmin<-bb[[2]]-buf
  latmax<-bb[[4]]+buf
  
ggplot()+
  geom_sf(data=studyArea,fill="deepskyblue", col="black", size=0.6, alpha=0.4)+
  geom_sf(data=site,fill="yellow",col="black", size=0.6)+
  geom_sf(data=land,fill=c("lightgrey"), col="black", size=0.7)+
  #watermark(show = TRUE, lab = "DFO Internal Use Only")+
  annotation_scale(location="bl")+
  theme_bw()+
  coord_sf(xlim = c(longmin, longmax), ylim = c(latmin, latmax))+
  labs(x="Longitude", y="Latitude", col="")+
  theme(axis.title.y = element_text(size = 13))+
  theme(axis.title.x = element_text(size = 13))
  
}
