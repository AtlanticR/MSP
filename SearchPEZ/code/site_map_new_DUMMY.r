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


site_map_new <- function(studyArea,studyArea_st,site,land,buf) {

  # buf is in km, and now converted to degrees
  buf=buf/100
  #png("pez_and_site.png", width=1616, height=1410)
  
  # bounding box
  bb=as.data.frame(summary(studyArea)$bbox)
  
  # buffer around bounding box
  #buf=0.05
  
  # longitude and latitude limits for the map
  lonLim=c(bb$min[1]-buf, bb$max[1]+buf)
  latLim=c(bb$min[2]-buf, bb$max[2]+buf)
  longmin<-bb$min[1]-buf
  longmax<-bb$max[1]+buf
  latmin<-bb$min[2]-buf
  latmax<-bb$max[2]+buf
  
ggplot()+
  geom_sf(data=studyArea_st,fill="deepskyblue", col="black", size=0.6, alpha=0.4)+
  geom_sf(data=site,fill="yellow",col="black", size=0.6)+
  geom_sf(data=land,fill=c("lightgrey"), col="black", size=0.7)+
  annotation_scale(location="bl")+
  theme_bw()+
  coord_sf(xlim = c(longmin, longmax), ylim = c(latmin, latmax))+
  labs(x="Longitude", y="Latitude", col="")+
  theme(axis.title.y = element_text(size = 13))+
  theme(axis.title.x = element_text(size = 13))
  
}
