#Script used to plot a 3x3 grid of EBSAs.

plot_cetaceans_4grid <- function(fin_whale_sf, harbour_porpoise_sf, humpback_whale_sf,
                                sei_whale_sf, PEZ_poly_st, land_sf) {

#Fin Whale

fin_whale_plot <- ggplot()+
  geom_sf(data=fin_whale_sf,fill="yellowgreen",col="yellowgreen")+
  geom_sf(data=PEZ_poly_st,fill=NA, col="blue", size=1)+
  geom_sf(data=land_sf,fill=c("grey90"), col="black")+
  annotation_scale(location="br")+
  theme_bw()+
  ggtitle("Fin Whale")+
  coord_sf(xlim = c(-67.6, -56.5), ylim = c(42, 47.7))+
  labs(x=expression(paste("Longitude ",degree,"W",sep="")),
     y=expression(paste("Latitude ",degree,"N",sep="")),
     col="")
  
fin_whale_plot
#Harbour Porpoise

harbour_porpoise_plot <- ggplot()+
    geom_sf(data=harbour_porpoise_sf,fill="aquamarine",col="aquamarine")+
    geom_sf(data=PEZ_poly_st,fill=NA, col="blue", size=1)+
    geom_sf(data=land_sf,fill=c("grey90"), col="black")+
    annotation_scale(location="br")+
    theme_bw()+
    ggtitle("Harbour Porpoise")+
    coord_sf(xlim = c(-67.6, -56.5), ylim = c(42, 47.7))+
    labs(x=expression(paste("Longitude ",degree,"W",sep="")),
         y=expression(paste("Latitude ",degree,"N",sep="")),
         col="")

#humpback whale

humpback_whale_plot <- ggplot()+
    geom_sf(data=humpback_whale_sf,fill="royalblue1",col="royalblue1")+
    geom_sf(data=PEZ_poly_st,fill=NA, col="blue", size=1)+
    geom_sf(data=land_sf,fill=c("grey90"), col="black")+
    annotation_scale(location="br")+
    theme_bw()+
    ggtitle("Humpback Whale")+
    coord_sf(xlim = c(-67.6, -56.5), ylim = c(42, 47.7))+
    labs(x=expression(paste("Longitude ",degree,"W",sep="")),
         y=expression(paste("Latitude ",degree,"N",sep="")),
         col="")

#Sei Whale

sei_whale_plot <- ggplot()+
    geom_sf(data=sei_whale_sf,fill="blue4",col="blue4")+
    geom_sf(data=PEZ_poly_st,fill=NA, col="blue", size=1)+
    geom_sf(data=land_sf,fill=c("grey90"), col="black")+
    annotation_scale(location="br")+
    theme_bw()+
    ggtitle("Sei Whale")+
    coord_sf(xlim = c(-67.6, -56.5), ylim = c(42, 47.7))+
    labs(x=expression(paste("Longitude ",degree,"W",sep="")),
         y=expression(paste("Latitude ",degree,"N",sep="")),
         col="")

grid.arrange(fin_whale_plot, harbour_porpoise_plot, humpback_whale_plot,
             sei_whale_plot,
             bottom = expression(paste("Longitude ",degree,"N",sep="")),
             left = expression(paste("Latitude ",degree,"N",sep="")),
             nrow = 2)
}
