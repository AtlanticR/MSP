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
#
# Written for MSP, Gordana Lazin, September 13, 2019


#site_map <- function(studyArea,site,land,buf) {

dev.off()

site_map <- function(studyArea,land,hex, IDWraster,buf) {
  # buf is in km, and now converted to degrees
  buf <- buf/100
  #png("pez_and_site.png", width=1616, height=1410)
  
  # bounding box from the raster extent
  bb <- as.data.frame(bbox(IDWraster[[1]]))
  
  # bounding box from the land file
  bb <- as.data.frame(summary(land)$bbox)

  
  # buffer around bounding box
  #buf=0.05
  
  # longitude and latitude limits for the map
  
  lonLim <- c(bb$min[1]-buf, bb$max[1]+buf)
  latLim <- c(bb$min[2]-buf, bb$max[2]+buf)
  
  # par(oma = c(0, 0, 0, 0))
  # plot studyArea on the map with buffer around polygon, specified in buf
  # map(studyArea,fill=FALSE,xlim=lonLim, ylim=latLim)
  
  dev.off()
  par(mfrow=c(2,4))
  # Plot 1 Hex ----
  HexGridDD2 <- subset(HexGridDD,!is.na(HexGridDD$T1_Wgt))
  HexGridDD3 <- subset(HexGridDD2,HexGridDD2$T1_Wgt > 0)
  
  map(land,fill=TRUE,col="lightgrey",xlim=lonLim, ylim=latLim)
  map(HexGridDD, fill = TRUE, col = 'lightgrey', add = TRUE)
  map(HexGridDD2, fill = TRUE, col = "turquoise", add = TRUE) # add selected zones to map
  map(HexGridDD3, fill = TRUE, col = "red", add = TRUE) # add selected zones to map
  # plot studyArea on the map with buffer around polygon, specified in buf
  map(studyArea,fill=FALSE, col="deepskyblue", add = TRUE)
  # ADD AXES
  map.axes(las=1, cex.axis=0.8)
  # END Plot 1 Hex ----
  # -------------------------------------------------------------#
  # Plot 2 Hex ----
  HexGridDD2 <- subset(HexGridDD,!is.na(HexGridDD$T2_Wgt))
  HexGridDD3 <- subset(HexGridDD2,HexGridDD2$T2_Wgt > 0)
  map(land,fill=TRUE,col="lightgrey",xlim=lonLim, ylim=latLim)
  map(HexGridDD, col = 'lightgrey', add = TRUE)
  map(HexGridDD2, fill = TRUE, col = "turquoise", add = TRUE) # add selected zones to map
  map(HexGridDD3, fill = TRUE, col = "red", add = TRUE) # add selected zones to map
  # plot studyArea on the map with buffer around polygon, specified in buf
  map(studyArea,fill=FALSE, col="deepskyblue", add = TRUE)
  # ADD AXES
  map.axes(las=1, cex.axis=0.8)
  # END Plot 2 Hex ----
  # -------------------------------------------------------------#
  # Plot 3 Hex ----
  HexGridDD2 <- subset(HexGridDD,!is.na(HexGridDD$T3_Wgt))
  HexGridDD3 <- subset(HexGridDD2,HexGridDD2$T3_Wgt > 0)
  map(land,fill=TRUE,col="lightgrey",xlim=lonLim, ylim=latLim)
  map(HexGridDD, col = 'lightgrey', add = TRUE)
  map(HexGridDD2, fill = TRUE, col = "turquoise", add = TRUE) # add selected zones to map
  map(HexGridDD3, fill = TRUE, col = "red", add = TRUE) # add selected zones to map
  # plot studyArea on the map with buffer around polygon, specified in buf
  map(studyArea,fill=FALSE, col="deepskyblue", add = TRUE)
  # ADD AXES
  map.axes(las=1, cex.axis=0.8)
  # END Plot 3 Hex ----
  # -------------------------------------------------------------#
  # Plot 4 Hex ----
  HexGridDD2 <- subset(HexGridDD,!is.na(HexGridDD$T4_Wgt))
  HexGridDD3 <- subset(HexGridDD2,HexGridDD2$T4_Wgt > 0)
  map(land,fill=TRUE,col="lightgrey",xlim=lonLim, ylim=latLim)
  map(HexGridDD, col = 'lightgrey', add = TRUE)
  map(HexGridDD2, fill = TRUE, col = "turquoise", add = TRUE) # add selected zones to map
  map(HexGridDD3, fill = TRUE, col = "red", add = TRUE) # add selected zones to map
  # plot studyArea on the map with buffer around polygon, specified in buf
  map(studyArea,fill=FALSE, col="deepskyblue", add = TRUE)
  # ADD AXES
  map.axes(las=1, cex.axis=0.8)
  # END Plot 4 Hex ----
  # -------------------------------------------------------------#
  # Plot 1 Raster----
  # ADD LAND
  map(land,fill=TRUE,col="lightgrey",xlim=lonLim, ylim=latLim)
  # Add RASTER layer
  plot(raster_list[[1]], add=TRUE)
  # plot studyArea on the map with buffer around polygon, specified in buf
  map(studyArea,fill=FALSE, col="deepskyblue", add = TRUE)
  # ADD AXES
  map.axes(las=1, cex.axis=0.8)
  # add axis labels - does not want to add y label???
  title(xlab="Longitude [deg]",ylab="Latitude [deg]")
  # END Plot 1 Raster ----
  # -------------------------------------------------------------#
  # Plot 2 Raster----
  # ADD LAND
  map(land,fill=TRUE,col="lightgrey",xlim=lonLim, ylim=latLim)
  # Add RASTER layer
  plot(raster_list[[2]], add=TRUE)
  # plot studyArea on the map with buffer around polygon, specified in buf
  map(studyArea,fill=FALSE, col="deepskyblue", add = TRUE)
  # ADD AXES
  map.axes(las=1, cex.axis=0.8)
  # add axis labels - does not want to add y label???
  title(xlab="Longitude [deg]",ylab="Latitude [deg]")
  # END Plot 2 Raster----
  # -------------------------------------------------------------#
  # Plot 3 Raster ----
  # ADD LAND
  map(land,fill=TRUE,col="lightgrey",xlim=lonLim, ylim=latLim)
  # Add RASTER layer
  plot(raster_list[[3]], add=TRUE)
  # plot studyArea on the map with buffer around polygon, specified in buf
  map(studyArea,fill=FALSE, col="deepskyblue", add = TRUE, legend = FALSE)
  # ADD AXES
  map.axes(las=1, cex.axis=0.8)
  # add axis labels - does not want to add y label???
  title(xlab="Longitude [deg]",ylab="Latitude [deg]")
  # END Plot 3 Raster ----
  # -------------------------------------------------------------#
  # Plot 4 Raster ----
  # ADD LAND
  map(land,fill=TRUE,col="lightgrey",xlim=lonLim, ylim=latLim)
  # Add RASTER layer
  plot(raster_list[[4]], add=TRUE)
  # plot studyArea on the map with buffer around polygon, specified in buf
  map(studyArea,fill=FALSE, col="deepskyblue", add = TRUE)
  # ADD AXES
  # map.axes(las=1, cex.axis=0.8)
  # add axis labels - does not want to add y label???
  # title(xlab="Longitude [deg]",ylab="Latitude [deg]")
  # END Plot 4 Raster ----
}
