
#Critical habitat
plot_crithab<-function(ClippedCritHab, PEZ_poly_st, land_layer) {
  
  ggplot()+
    geom_sf(data=ClippedCritHab,fill="red",col="red")+
    geom_sf(data=PEZ_poly_st,fill=NA, col="blue", size=1)+
    geom_sf(data=land_layer,fill=c("grey90"), col="black")+
    annotation_scale(location="br")+
    theme_bw()+
    coord_sf(xlim = c(-67.6, -56.5), ylim = c(42, 47.7))+
    labs(x=expression(paste("Longitude ",degree,"W",sep="")),
         y=expression(paste("Latitude ",degree,"N",sep="")),
         col="")+
    watermark(show = TRUE, lab = "DFO Internal Use Only")
  
}

#critical habitat zoom
plot_crithab_zoom<-function(ClippedCritHab, PEZ_poly_st, land_layer) {
  
  bbox_list <- lapply(st_geometry(PEZ_poly_st), st_bbox)
  maxmin <- as.data.frame(matrix(unlist(bbox_list),nrow=nrow(PEZ_poly_st)))
  longmin<-(maxmin$V1)-1
  longmax<-(maxmin$V3)+1
  latmin<-(maxmin$V2)-0.5
  latmax<-(maxmin$V4)+0.5
  
  ggplot()+
    geom_sf(data=ClippedCritHab,fill="red",col="black")+
    geom_sf(data=PEZ_poly_st,fill=NA, col="blue", size=1)+
    geom_sf(data=land_layer,fill=c("grey90"), col="black")+
    annotation_scale(location="br")+
    theme_bw()+
    coord_sf(xlim = c(longmin, longmax), ylim = c(latmin, latmax))+
    labs(x=expression(paste("Longitude ",degree,"W",sep="")),
         y=expression(paste("Latitude ",degree,"N",sep="")),
         col="")+
    watermark(show = TRUE, lab = "DFO Internal Use Only")
  
}

#OBIS

plot_obis<-function(studyArea,studyArea_st,site,land,intersect_obis,buf) {
  
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
    geom_sf(data=intersect_obis, size = 3, shape = 16, fill = "black")+
    annotation_scale(location="bl")+
    theme_bw()+
    coord_sf(xlim = c(longmin, longmax), ylim = c(latmin, latmax))+
    labs(x="Longitude", y="Latitude", col="")+
    theme(axis.title.y = element_text(size = 13))+
    theme(axis.title.x = element_text(size = 13))+
    watermark(show = TRUE, lab = "DFO Internal Use Only")
  
}

#iNaturalist

plot_inat<-function(studyArea,studyArea_st,site,land,intersect_inat,buf) {
  
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
    geom_sf(data=intersect_inat, size = 3, shape = 16, fill = "black")+
    annotation_scale(location="bl")+
    theme_bw()+
    coord_sf(xlim = c(longmin, longmax), ylim = c(latmin, latmax))+
    labs(x="Longitude", y="Latitude", col="")+
    theme(axis.title.y = element_text(size = 13))+
    theme(axis.title.x = element_text(size = 13))+
    watermark(show = TRUE, lab = "DFO Internal Use Only")
  
}

#GBIF

plot_gbif<-function(studyArea,studyArea_st,site,land,intersect_gbif,buf) {
  
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
    geom_sf(data=intersect_gbif, size = 3, shape = 16, fill = "black")+
    annotation_scale(location="bl")+
    theme_bw()+
    coord_sf(xlim = c(longmin, longmax), ylim = c(latmin, latmax))+
    labs(x="Longitude", y="Latitude", col="")+
    theme(axis.title.y = element_text(size = 13))+
    theme(axis.title.x = element_text(size = 13))+
    watermark(show = TRUE, lab = "DFO Internal Use Only")
  
}


#CWS

plot_cws<-function(studyArea,studyArea_st,site,land,intersect_cws,buf) {
  
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
    geom_sf(data=intersect_cws, size = 3, shape = 16, fill = "black")+
    annotation_scale(location="bl")+
    theme_bw()+
    coord_sf(xlim = c(longmin, longmax), ylim = c(latmin, latmax))+
    labs(x="Longitude", y="Latitude", col="")+
    theme(axis.title.y = element_text(size = 13))+
    theme(axis.title.x = element_text(size = 13))+
    watermark(show = TRUE, lab = "DFO Internal Use Only")
  
}


#Leatherback turtle

plot_leatherback<-function(leatherback_shp, PEZ_poly_st, land_layer) {
  
  ggplot()+
    geom_sf(data=leatherback_shp,fill="lightgreen",col="black")+
    geom_sf(data=PEZ_poly_st,fill=NA, col="blue", size=1)+
    geom_sf(data=land_layer,fill=c("grey90"), col="black")+
    annotation_scale(location="br")+
    theme_bw()+
    coord_sf(xlim = c(-67.6, -56.5), ylim = c(42, 47.7))+
    labs(x=expression(paste("Longitude ",degree,"W",sep="")),
         y=expression(paste("Latitude ",degree,"N",sep="")),
         col="")+
    watermark(show = TRUE, lab = "DFO Internal Use Only")
  
}

#NARWC

plot_narwc<-function(studyArea,narwc,buf) {
  
  
  # data frame for the whale sightings database
  df=narwc
  
  # bounding box for studyArea
  bb=as.data.frame(summary(studyArea)$bbox)
  
  # buffer around bounding box
  buf=buf/100
  
  # longitude and latitude limits for the map
  lonLim=c(bb$min[1]-buf, bb$max[1]+buf)
  latLim=c(bb$min[2]-buf, bb$max[2]+buf)
  
  # find sighting points within the box
  lt=which(df$LATITUDE>latLim[1] & df$LATITUDE<latLim[2] )
  lg=which(df$LONGITUDE>lonLim[1] & df$LONGITUDE<lonLim[2] )
  
  # points from the wsdb in the box
  inBox=intersect(lt,lg)
  
  # data in the box
  dfBox=df[inBox,]
  
  # unique species in the box
  species=as.character(unique(dfBox$SPECCODE))
  
  # define colours to circle through
  colors=c("darkgoldenrod1","darkgrey","blue", "red","blueviolet", "darkorange2", "cyan","magenta","darkgreen")
  colors=rep(colors, times=ceiling(length(species)/length(colors)))
  colors=colors[1:length(species)]
  
  # define shapes of symbols to use
  shapes=c(16,15,17,18,8)
  shapes=rep(shapes, times=ceiling(length(species)/length(shapes)))
  shapes=shapes[1:length(species)]
  
  # create a legend dataframe that defines symbology for each species
  leg=as.data.frame(cbind(species,colors,shapes))
  leg$shapes=as.numeric(as.character(leg$shapes))
  leg$colors=as.character(leg$colors)
  
  # add sybology to species dataframe, columns colors and shapes
  dfBox=merge(dfBox,leg,by.x="SPECCODE",by.y="species")
  
  # ADD POINT DATA, only in the box
  points(dfBox$LONGITUDE,dfBox$LATITUDE, col=dfBox$colors, cex=0.8, pch=dfBox$shapes)
  
  # add legend on separate plot
  plot(NULL ,xaxt='n',yaxt='n',bty='n',ylab='',xlab='', xlim=0:1, ylim=0:1)
  legend("topleft", legend=leg$species,col=leg$colors,pch=leg$shapes, cex=0.8,
         inset=-0.01,y.intersp=1.5,bty = "n")
  
  
}

#WSDB

plot_wsdb<-function(studyArea,wsdb,buf) {
  
  
  # data frame for the whale sightings database
  df=wsdb
  
  # bounding box for studyArea
  bb=as.data.frame(summary(studyArea)$bbox)
  
  # buffer around bounding box
  buf=buf/100
  
  # longitude and latitude limits for the map
  lonLim=c(bb$min[1]-buf, bb$max[1]+buf)
  latLim=c(bb$min[2]-buf, bb$max[2]+buf)
  
  # find sighting points within the box
  lt=which(df$LATITUDE>latLim[1] & df$LATITUDE<latLim[2] )
  lg=which(df$LONGITUDE>lonLim[1] & df$LONGITUDE<lonLim[2] )
  
  # points from the wsdb in the box
  inBox=intersect(lt,lg)
  
  # data in the box
  dfBox=df[inBox,]
  
  # unique species in the box
  species=as.character(unique(dfBox$COMMONNAME))
  
  # define colours to circle through
  colors=c("darkgoldenrod1","darkgrey","blue", "red","blueviolet", "darkorange2", "cyan","magenta","darkgreen")
  colors=rep(colors, times=ceiling(length(species)/length(colors)))
  colors=colors[1:length(species)]
  
  # define shapes of symbols to use
  shapes=c(16,15,17,18,8)
  shapes=rep(shapes, times=ceiling(length(species)/length(shapes)))
  shapes=shapes[1:length(species)]
  
  # create a legend dataframe that defines symbology for each species
  leg=as.data.frame(cbind(species,colors,shapes))
  leg$shapes=as.numeric(as.character(leg$shapes))
  leg$colors=as.character(leg$colors)
  
  # add sybology to species dataframe, columns colors and shapes
  dfBox=merge(dfBox,leg,by.x="COMMONNAME",by.y="species")
  
  # ADD POINT DATA, only in the box
  points(dfBox$LONGITUDE,dfBox$LATITUDE, col=dfBox$colors, cex=0.8, pch=dfBox$shapes)
  
  # add legend on separate plot
  #par(mar = c(5.1, 1, 4.1,1))
  plot(NULL ,xaxt='n',yaxt='n',bty='n',ylab='',xlab='', xlim=0:1, ylim=0:1)
  legend("topleft", legend=leg$species,col=leg$colors,pch=leg$shapes, cex=0.8,
         inset=-0.01,y.intersp=1.5,bty = "n")
  #par(mar = c(5.1, 4.1, 4.1, 2.1))
  
}

#Grid of 4 cetacean priority habitat

plot_cetaceans_4grid<-function(fin_whale_sf, harbour_porpoise_sf, 
                               humpback_whale_sf, sei_whale_sf, PEZ_poly_st, 
                               land_sf) {
  
#Fin Whale
  
  fin_whale_plot <- ggplot()+
    geom_sf(data=fin_whale_sf,fill="#F3E73B",col="#F3E73B")+
    geom_sf(data=PEZ_poly_st,fill=NA, col="blue", size=1)+
    geom_sf(data=land_sf,fill=c("grey90"), col="black")+
    annotation_scale(location="br")+
    theme_bw()+
    ggtitle("Fin Whale")+
    coord_sf(xlim = c(-67.6, -56.5), ylim = c(42, 47.7))+
    labs(x=expression(paste("Longitude ",degree,"W",sep="")),
         y=expression(paste("Latitude ",degree,"N",sep="")),
         col="")+
    watermark(show = TRUE, lab = "DFO Internal Use Only")
  
#Harbour Porpoise
  
  harbour_porpoise_plot <- ggplot()+
    geom_sf(data=harbour_porpoise_sf,fill="#F3E73B",col="#F3E73B")+
    geom_sf(data=PEZ_poly_st,fill=NA, col="blue", size=1)+
    geom_sf(data=land_sf,fill=c("grey90"), col="black")+
    annotation_scale(location="br")+
    theme_bw()+
    ggtitle("Harbour Porpoise")+
    coord_sf(xlim = c(-67.6, -56.5), ylim = c(42, 47.7))+
    labs(x=expression(paste("Longitude ",degree,"W",sep="")),
         y=expression(paste("Latitude ",degree,"N",sep="")),
         col="")+
    watermark(show = TRUE, lab = "DFO Internal Use Only")
  
#humpback whale
  
  humpback_whale_plot <- ggplot()+
    geom_sf(data=humpback_whale_sf,fill="#F3E73B",col="#F3E73B")+
    geom_sf(data=PEZ_poly_st,fill=NA, col="blue", size=1)+
    geom_sf(data=land_sf,fill=c("grey90"), col="black")+
    annotation_scale(location="br")+
    theme_bw()+
    ggtitle("Humpback Whale")+
    coord_sf(xlim = c(-67.6, -56.5), ylim = c(42, 47.7))+
    labs(x=expression(paste("Longitude ",degree,"W",sep="")),
         y=expression(paste("Latitude ",degree,"N",sep="")),
         col="")+
    watermark(show = TRUE, lab = "DFO Internal Use Only")
  
#Sei Whale
  
  sei_whale_plot <- ggplot()+
    geom_sf(data=sei_whale_sf,fill="#F3E73B",col="#F3E73B")+
    geom_sf(data=PEZ_poly_st,fill=NA, col="blue", size=1)+
    geom_sf(data=land_sf,fill=c("grey90"), col="black")+
    annotation_scale(location="br")+
    theme_bw()+
    ggtitle("Sei Whale")+
    coord_sf(xlim = c(-67.6, -56.5), ylim = c(42, 47.7))+
    labs(x=expression(paste("Longitude ",degree,"W",sep="")),
         y=expression(paste("Latitude ",degree,"N",sep="")),
         col="")+
    watermark(show = TRUE, lab = "DFO Internal Use Only")

#Arrange all 4 cetaceans into grid
  grid.arrange(fin_whale_plot, harbour_porpoise_plot, humpback_whale_plot,
               sei_whale_plot,
               bottom = expression(paste("Longitude ",degree,"N",sep="")),
               left = expression(paste("Latitude ",degree,"N",sep="")),
               nrow = 2)
}


#Blue whale habitat

plot_bw_hab <- function(Blue_4326, PEZ_poly_st, Landshp) {

ggplot()+
geom_sf(data=Blue_4326,fill="skyblue1",col="black")+
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

#Blue whale habitat zoom
plot_bw_hab_zoom <- function(Blue_4326, PEZ_poly_st, Landshp) {
  
  bbox_list <- lapply(st_geometry(PEZ_poly_st), st_bbox)
  maxmin <- as.data.frame(matrix(unlist(bbox_list),nrow=nrow(PEZ_poly_st)))
  longmin<-(maxmin$V1)-1
  longmax<-(maxmin$V3)+1
  latmin<-(maxmin$V2)-0.5
  latmax<-(maxmin$V4)+0.5
  
  ggplot()+
    geom_sf(data=Blue_4326,fill="skyblue1",col="black")+
    geom_sf(data=PEZ_poly_st,fill=NA, col="blue", size=1)+
    geom_sf(data=Landshp,fill=c("grey90"), col="black")+
    annotation_scale(location="br")+
    theme_bw()+
    coord_sf(xlim = c(longmin, longmax), ylim = c(latmin, latmax))+
    labs(x=expression(paste("Longitude ",degree,"W",sep="")),
         y=expression(paste("Latitude ",degree,"N",sep="")),
         col="")+
    watermark(show = TRUE, lab = "DFO Internal Use Only")
  
}

#EBSA

plot_EBSA<-function(EBSA_shp, PEZ_poly_st, land_layer) {
  
  ggplot()+
    geom_sf(data=EBSA_shp,fill="plum1",col="black")+
    geom_sf(data=PEZ_poly_st,fill=NA, col="blue", size=1)+
    geom_sf(data=land_layer,fill=c("grey90"), col="black")+
    annotation_scale(location="br")+
    theme_bw()+
    coord_sf(xlim = c(-67.6, -56.5), ylim = c(42, 47.7))+
    labs(x=expression(paste("Longitude ",degree,"W",sep="")),
         y=expression(paste("Latitude ",degree,"N",sep="")),
         col="")+
    watermark(show = TRUE, lab = "DFO Internal Use Only")
  
}
