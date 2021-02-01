#This function plots the PEZ polygon relative to MAR critical habitats.

plot_bw_hab <- function(Blue_4326, PEZ_poly_st, Landshp) {

ggplot()+
geom_sf(data=Blue_4326,fill="skyblue1",col="skyblue1")+
geom_sf(data=PEZ_poly_st,fill=NA, col="blue", size=1)+
geom_sf(data=Landshp,fill=c("grey90"), col="black")+
annotation_scale(location="br")+
theme_bw()+
coord_sf(xlim = c(-67.6, -56.5), ylim = c(42, 47.7))+
labs(x=expression(paste("Longitude ",degree,"W",sep="")),
     y=expression(paste("Latitude ",degree,"N",sep="")),
     col="")+
watermark(show = TRUE, lab = "DFO Internal Use Only")

}

