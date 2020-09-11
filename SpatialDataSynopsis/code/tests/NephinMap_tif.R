# Code provided by Jessica Nephin and mildly edited by Catalina Gomez
library(raster)
library(sp)
library(rgdal)
library(RColorBrewer)
load("SpatialDataSynopsis/code/tests/Data/Boundaries/LandPolygon.RData")

# R E A D   S T A C K   S P A T I A L   O U T P U T S 
rasterdir <- "SpatialDataSynopsis/code/tests/Data/outputs/"
SpatialOutputsFiles = list.files(path = paste(rasterdir, sep=""), 
                            pattern = "\\.tif$", full.names = F)
SpatialOutputs = c()
for(x in SpatialOutputsFiles)
{
  predname = paste(rasterdir, x, sep="")
  SpatialOutputs = stack(c(SpatialOutputs, raster(predname)))
}
SpatialOutputs <- setMinMax(SpatialOutputs)

CRS_ras <- CRS("+init=epsg:26920") #EPSG code for UTM Zone 20, NAD83
SpatialOutputs <- projectRaster(SpatialOutputs, crs=CRS_ras)

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
    if(grepl("HEXAVG", p, ignore.case = T))  legend.title <- "Average Biomass per grid cell"
    if(grepl("rclass", p, ignore.case = T))  legend.title <- "Ranked Areas"
    if ( !exists("legend.title") ) legend.title <- p
    
    # Get raster from stack
    Layer <- layers[[p]]
    
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
    pdf( file=file.path(rasterdir, paste0(prefix, p, ".pdf")),
         height=6, width=5.25*diff(lims$x)/diff(lims$y)+1 )
    par( mar=c(1,1,1,1) )
    plot( land[[1]], col = "grey80", border = NA, xlim = lims$x , ylim = lims$y )
    box( lty = 'solid', col = 'black')
    plot( Layer, maxpixels=5000000, add=TRUE, col=pal, legend=FALSE )
    plot(Layer, col=pal, horizontal=TRUE,
         legend.only=TRUE, smallplot=smallplot,
         axis.args=list(cex.axis=.7, padj=-2, tck=-.5),
         legend.args=list(text=legend.title, side=1, font=1, line=1.5, cex=.8))
    dev.off()
    
    
  } # end for loop through PredSDM Layers
} # end MapLayers function

#plot(SpatialOutputs)
lims <- getLims( Layer = SpatialOutputs )
MapLayers (layers=SpatialOutputs, lims=lims, legendPos="bottomright")






