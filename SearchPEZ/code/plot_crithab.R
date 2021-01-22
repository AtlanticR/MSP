#This function plots the PEZ polygon relative to MAR critical habitats.

plot_crithab <- function(ClippedCritHab, PEZ_poly_st, ClippedCritLand) {

ggplot()+
geom_sf(data=ClippedCritHab,fill="red",col="red")+
geom_sf(data=PEZ_poly_st,fill=NA, col="blue", size=1)+
geom_sf(data=ClippedCritLand,fill=c("grey90"), col="black")+
theme_bw()+
coord_sf(xlim = c(-67.6, -56.5), ylim = c(42, 47.7))+
labs(x=expression(paste("Longitude ",degree,"W",sep="")),
     y=expression(paste("Latitude ",degree,"N",sep="")),
     col="")

}

