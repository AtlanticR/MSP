# Code provided by Jessica Nephin and edited by Catalina Gomez and Phil Greyson
library(raster)
library(sp)
library(rgdal)
library(RColorBrewer)
library(maps)

# Load a generic land base into Environment
load("../data/Boundaries/land.RData")

# bring in OceanMask for clipping rasters
dsn <- "../data/Boundaries"
oceanMask <- readOGR(dsn,"ScotianShelfOceanMask_WithoutCoastalZone_Edit")
oceanMaskUTM <- spTransform(oceanMask,CRS("+init=epsg:26920"))

# R E A D   S T A C K   S P A T I A L   O U T P U T S
rasterdir <- "./SpatialDataSynopsis/Output/"
SpatialOutputFiles <- list.files(path = paste(rasterdir, sep=""), 
                                 pattern = "\\.grd$", full.names = F)

SpatialOutputs <-  c()
SpatialOutputList <- list()

# Import each .grd file into a stack()
# Add each stack into a list
# name each stack with the name of the .grd file
for (i in 1:length(SpatialOutputFiles)) {
  predname <- paste(rasterdir, SpatialOutputFiles[i], sep="")
  SpatialOutputs <- stack(predname)
  SpatialOutputList[[i]] <- SpatialOutputs
  RasName = substr(SpatialOutputFiles[i],1,nchar(SpatialOutputFiles[i])-4)
  names(SpatialOutputList)[i] <- RasName
}

names(SpatialOutputs)
SpatialOutputs <- setMinMax(SpatialOutputs)

# F U N C T I O N S 
# Calculate the x,y extents for all maps
getLims <- function( Layer ) {
  # convert raster for extents
  {
    ras_spdf <- as(Layer[[1]], "SpatialPixelsDataFrame")
    # Get the vertical and horizontal limits
    ext <- extent( ras_spdf )
    # Get x and y limits
    adj <- round(ext@xmin*0.01)
    lims <- list( x=c(ext@xmin-adj, ext@xmax+adj), y=c(ext@ymin-adj, ext@ymax+adj) )
    ras_spdf <- as(Layer[[1]], "SpatialPixelsDataFrame")
    # Get the vertical and horizontal limits
    ext <- extent( ras_spdf )
    # Get x and y limits
    adj <- round(ext@xmin*0.01)
    lims <- list( x=c(ext@xmin-adj, ext@xmax+adj), y=c(ext@ymin-adj, ext@ymax+adj) )
    
  }
  # return
  return(lims)
}


# Plot the predicted layers
MapLayers <- function( layers, lims, prefix="Map_", legendPos){
  
  # get layer names
  preds <- names(layers)
  
  # loop through layer names
  for(p in preds){
    
    # legend text
    if(grepl("Avg", p, ignore.case = T)) legend.title <- "Average biomass (kg)"
    if(grepl("IDW", p, ignore.case = T))  legend.title <- "Ranked Areas calculated via IDW"
    if(grepl("AvgPerKm", p, ignore.case = T))  legend.title <- "Areal density (average biomass/area of each grid cell)"
    if ( !exists("legend.title") ) legend.title <- p
    
    # Get raster from stack
    Layer <- layers[[p]]
    
    # clip the raster to the extent of the RV survey
    Layer <- crop(Layer,oceanMaskUTM)
    Layer <- mask(Layer,oceanMaskUTM)
    
    # Get raster name
    Title <- names(Layer)
    
    
    #colours
    if ( legend.title == "Standard deviation") {
      pal <- c("#fee8c8","#fdd49e","#fdbb84","#fc8d59","#ef6548","#d7301f","#b30000","#7f0000")
    } else {
      pal <- rev(brewer.pal( 8, "Spectral" ))
      #pal <- c("#D53E4F", "#F46D43", "#FDAE61", "#FEE08B", "#E6F598", "#ABDDA4", "#66C2A5", "#3288BD")  
      pal <- c("#DEEBF7", "#66C2A5", "#ABDDA4", "#E6F598", "#FEE08B", "#FDAE61", "#F46D43","#D53E4F")  
    }
    
    # Legend position
    # "bottomleft", "bottomright", "topleft", "topright"
    if( legendPos == "bottomleft") smallplot <- c(.08, .48, .14, .16)
    if( legendPos == "bottomright") smallplot <- c(.52, .92, .14, .16)
    if( legendPos == "topleft") smallplot <- c(.08, .48, .92, .94)
    if( legendPos == "topright") smallplot <- c(.52, .92, .92, .94)
    
    # Map (up to 5,000,000 pixels)
    pdf( file=file.path(rasterdir, paste0(prefix, p, "Old.pdf")),
         height=6, width=5.25*diff(lims$x)/diff(lims$y)+1 )
    par( mar=c(1,1,1,1) )
    plot( land, col = "grey80", border = NA, xlim = lims$x , ylim = lims$y,
          main = Title)
    box( lty = 'solid', col = 'black')
    plot( Layer, maxpixels=5000000, add=TRUE, col=pal, legend=FALSE )
    plot(Layer, col=pal, horizontal=TRUE,
         legend.only=TRUE, smallplot=smallplot,
         axis.args=list(cex.axis=.7, padj=-2, tck=-.5),
         legend.args=list(text=legend.title, side=1, font=1, line=1.5, cex=.8))
    dev.off()
    
    
  } # end for loop through PredSDM Layers
} # end MapLayers function

######################################-
# Run the two functions

lims <- getLims( Layer = SpatialOutputs )

# For each object in SpatialOutputList
# extract a stack one a time and send
# that stack to the MapLayers Function
# This will produce a PDF of each raster 
# within the stack

start_time <- Sys.time()
for (i in 1:length(SpatialOutputList)) {
  print(paste("Loop ",i,nlayers(SpatialOutputList[[i]]), names(SpatialOutputList[i]),sep = " "))
  RasStack <- stack(SpatialOutputList[[i]])
  MapLayers (layers=RasStack, lims=lims, legendPos="bottomright")
}
end_time <- Sys.time()
end_time - start_time

# -- END Run the two functions
######################################-

# Use just 1 or 2 of the stacks in the list
#SpatialOutputList <- SpatialOutputList[c(2,3)]
#SpatialOutputList <- SpatialOutputList[c(1)]