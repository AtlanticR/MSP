#This function provides a zoomed view of the plotted PEZ polygon relative to MAR critical habitats.
plot_crithab_zoom <- function(ClippedCritHab, PEZ_poly_st, ClippedCritLand) {
  
bbox_list <- lapply(st_geometry(PEZ_poly_st), st_bbox)
maxmin <- as.data.frame(matrix(unlist(bbox_list),nrow=nrow(PEZ_poly_st)))
longmin<-(maxmin$V1)-1
longmax<-(maxmin$V3)+1
latmin<-(maxmin$V2)-0.5
latmax<-(maxmin$V4)+0.5

ggplot()+
  geom_sf(data=ClippedCritHab,fill="red",col="red")+
  geom_sf(data=PEZ_poly_st,fill=NA, col="blue", size=1)+
  geom_sf(data=ClippedCritLand,fill=c("grey90"), col="black")+
  annotation_scale(location="br")+
  theme_bw()+
  coord_sf(xlim = c(longmin, longmax), ylim = c(latmin, latmax))+
  labs(x=expression(paste("Longitude ",degree,"W",sep="")),
       y=expression(paste("Latitude ",degree,"N",sep="")),
       col="")

}