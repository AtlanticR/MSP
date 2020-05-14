# Simple code to read in a shapefile, create a map and convert to a grob

library(ggplot2)
library(ggplotify)
library(sp)
library(rgdal)

# working directory
wd <- "C:/BIO/20200306/GIT/R/MSP"
setwd(wd)

# If you run this more than once you only need to download and unzip the file once.

# Download the shapefile. 
download.file("http://thematicmapping.org/downloads/TM_WORLD_BORDERS_SIMPL-0.3.zip" , destfile="./world_shape_file.zip")
# You now have it in your current working directory, have a look!

# Unzip this file. You can do it with R (as below), or clicking on the object you downloaded.
system("unzip ./world_shape_file.zip")

# Read in the shapefile
wld_shape <- readOGR( dsn = wd , 
                      layer="TM_WORLD_BORDERS_SIMPL-0.3",
                      verbose=FALSE
)

# create a simple map with the shapefile
map1 <- ggplot() +
  geom_path(data = wld_shape, aes(x = long, y = lat, group = group)) +
  labs(title = "Global Coastlines - using ggplot")

plot1 <- as.grob(map1) #convert map1 to a grob
