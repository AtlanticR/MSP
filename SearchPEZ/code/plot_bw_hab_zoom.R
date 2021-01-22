#This function provides a zoomed view of the plotted PEZ polygon relative to MAR critical habitats.
plot_bw_hab_zoom <- function(Blue_4326, PEZ_poly_st, Landshp) {
  
bbox_list <- lapply(st_geometry(PEZ_poly_st), st_bbox)
maxmin <- as.data.frame(matrix(unlist(bbox_list),nrow=nrow(PEZ_poly_st)))
longmin<-(maxmin$V1)-1
longmax<-(maxmin$V3)+1
latmin<-(maxmin$V2)-0.5
latmax<-(maxmin$V4)+0.5

ggplot()+
  geom_sf(data=Blue_4326,fill="skyblue1",col="skyblue1")+
  geom_sf(data=PEZ_poly_st,fill=NA, col="blue", size=1)+
  geom_sf(data=Landshp,fill=c("grey90"), col="black")+
  annotation_scale(location="br")+
  theme_bw()+
  coord_sf(xlim = c(longmin, longmax), ylim = c(latmin, latmax))+
  labs(x=expression(paste("Longitude ",degree,"W",sep="")),
       y=expression(paste("Latitude ",degree,"N",sep="")),
       col="")

}