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
site_map <- function(studyArea,land,IDWraster,buf) {
  # buf is in km, and now converted to degrees
  buf <- buf/100
  #png("pez_and_site.png", width=1616, height=1410)
  
  # bounding box from the raster extent
  bb <- as.data.frame(bbox(IDWraster))
  
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
  
  ggplot() +
    ggspatial::geom_osm(type = "hillshade") + 
    ggspatial::geom_spatial(studyArea, aes(colour = STREAMTYPE)) +
    ggspatial::geom_spatial(land, colour = "black", fill = NA) +
    coord_map() + 
    theme_void()
  
  # plot the data 
  map1 <- ggplot() +
    geom_path(data = land, aes(x = long, y = lat, group = group)) +
    labs(title = "Global Coastlines - using ggplot")
  
  map1 <- map1 + geom_polygon(data=studyArea, aes(x=long, y=lat, group=group), 
                                  colour="black", fill="black", alpha=0)
  raster_df <- as.data.frame(IDWraster, xy = TRUE)
  names(raster_df)

map1 <- map1 + ggplot(IDWraster)
  
    map1 <- map1 +   geom_raster(data = raster_df , aes(x = x, y = y ), scale_fill_manual(values = 'var1.pred', name = "Elevation")) + 
    coord_quickmap()
  
  plot1 <- as.grob(map1)
  
  
  # ADD LAND
  p <- map(land,fill=TRUE,col="lightgrey",xlim=lonLim, ylim=latLim) 
  # Add RASTER layer
  p <- p + plot(IDWraster, add=TRUE)
  
  # plot studyArea on the map with buffer around polygon, specified in buf
  p <- p + map(studyArea,fill=FALSE, col="deepskyblue", add = TRUE)

  # ADD AXES
  p <-p + map.axes(las=1, cex.axis=0.8)
  
  # add axis labels - does not want to add y label???
  title(xlab="Longitude [deg]",ylab="Latitude [deg]")

}



p <- abiotic %>%
  left_join(biomass, by = c("year", "trawl_id")) %>%       # merge abiotic and biomass data                          
  filter(year == 2010) %>%                                 # filter to 2010 data
  group_by(nafo_div, strata) %>%                           # set-up groups
  summarise(mean_shrimp = mean(shrimp)) %>%                # calculate mean biomass of shrimp by strat
  left_join(strata, by = "strata") %>%                     # merge with sf object
  ggplot(aes(fill = mean_shrimp)) +
  #geom_sf() +            # strata map
  geom_sf(data = nl, fill = "lightgrey") +                      # NL map
  ggtitle("Mean biomass of shrimp by strata in 2010") +    # plot labels
  labs(fill = "Mean\nbiomass") +
  scale_fill_viridis() + theme_bw()                      # colour and theme
p # print map



-------------------------------------------------------
gplot(biomass, aes(x=LA, y=tt)) +   geom_sf(data = strata, fill = "white") +            # strata map
  geom_sf(data = nl, fill = "lightgrey") +            # NL map
  ggtitle("e.g. 2010 - 2020") +                       # plot labels
  labs(fill = "Mean\nbiomass") +
  scale_fill_viridis() + theme_bw()