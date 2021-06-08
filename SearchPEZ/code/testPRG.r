library(shiny)
library(shinyjs)
library(leaflet)
library(leafem)
library(mapedit)
library(sf)
library(glue)
library(callr)
library(knitr) # reproducible reports from R Markdown 
library(rgdal) # read geospatial data files into report
library(maps) # uncouple lat/lon coordinates in sf objects
library(lubridate) # extract YEAR from columns containing dates
library(kableExtra) # build and manipulate tables
library(tidyverse) # a set of packages required for general data manipulation, including ggplot2 for plotting and dplyr
library(raster) # needed for manipulation of raster files
library(sf) # manipulation of simple features and to determine overlap of studyArea and databases
library(stringr) # manipulation of individual characters within strings in character vectors.
library(data.table) # manipulation of dataframes
library(gridExtra) # plot a grid of plots (priority cetacean habitat)
library(stars) # transform features and assign or modify coordinate reference systems in objects
library(ggspatial) #required for mapping
#next lines are necessary for the generation of the water mark on plots
#install.packages("remotes")
#remotes::install_github("terminological/standard-print-output")
library(standardPrintOutput) # required for watermarks on maps

lapply(list.files("app/R", pattern = ".[Rr]$", full.names = TRUE),source)
source("app/R/fn_intersect_operations.R")
source("app/R/fn_maps.R")

# studyArea <- sf::st_read("{{path_to_geoms}}")
#studyArea <- sf::st_read("geoms_slc.geojson")

# Uncomment the following to test fixed polygon:
studyArea <- st_read("app/studyAreaTest/geoms_slc_test.geojson")#Offshore
# studyArea <- st_read("app/studyAreaTest/geoms_slc_coastal_test.geojson")#coastal 
# studyArea <- st_read("app/studyAreaTest/geoms_slc_no_land.geojson") #no land
# studyArea <- st_read("app/studyAreaTest/geoms_slc_outsideMAR.geojson") # no data

# studyArea with only ISDB or only MARFIS samples
# studyArea <- st_read("app/studyAreaTest/geoms_slc_ISDBOnly.geojson") # ISDB only
# studyArea <- st_read("app/studyAreaTest/geoms_slc_Mar1Only.geojson") # MARFIS only # 1
# studyArea <- st_read("app/studyAreaTest/geoms_slc_Mar2Only.geojson") # MARFIS only # 2


site <- sf::st_centroid(studyArea) 


minYear <- 2010

load("app/data/SecureData.RData")
load("app/data/OpenData.RData")

studyBox_geom <- geom_sf(data=studyArea, fill=NA, col="red", size=1) 

# The following plots area map using function (output is a list)
areaMapList<-area_map(studyArea, site, land50k_sf, 5, bounds_sf, studyBox_geom)

# The following separates items in the output list: first item is a map and second is a bounding box of the map
areaMap <- areaMapList[[1]] # map
bboxMap <- areaMapList[[2]] # bounding box of the map
##########################################################################################

outputList <- main_intersect(RVCatch_sf, studyArea, listed_species, 
                             speciestable = RVGSSPECIES, Bbox = bboxMap, minYear = minYear)

outputListI <- main_intersect(isdb_sf, studyArea, listed_species, 
                             speciestable = ISSPECIESCODES, Bbox = bboxMap, minYear = minYear)
outputListM <- main_intersect(marfis_sf, studyArea, listed_species, 
                             speciestable = MARFISSPECIESCODES, Bbox = bboxMap, minYear = minYear)
# if (!is.null(outputList)) {
tableList <- create_tables(outputListI[[2]], listed_species, speciestable = ISSPECIESCODES,
                           Samples_study_no = outputListI[[1]]) 
# RV 
tableList <- create_tables(outputList[[2]], listed_species, speciestable = RVGSSPECIES,
                           Samples_study_no = outputList[[1]]) 
 
tableList <- create_tables(outputListM[[2]], listed_species, speciestable = MARFISSPECIESCODES, Samples_study_no = outputListM[[1]])
table_mar1 <- tableList[[1]]
table_mar2 <- tableList[[2]]


# }
# table_rv1 <- tableList[[1]]
# table_rv2 <- tableList[[2]]

OBIS
tableList <- create_tables(outputList[[2]], listed_species, Samples_study_no = outputList[[1]])
table_obis1 <- tableList[[1]]
table_obis2 <- tableList[[2]]



datafile <- RVCatch_sf
listed_table <- listed_species
speciestable <- RVGSSPECIES
Samples_study_no <- outputList[[1]]

datafile <- outputListI[[2]]
listed_table <- listed_species
speciestable <- ISSPECIESCODES
Samples_study_no <- outputListI[[1]]

datafile <- outputListM[[2]]
listed_table <- listed_species
speciestable <- MARFISSPECIESCODES
Samples_study_no <- outputListM[[1]]




studyArea <- sf::st_read("{{path_to_geoms}}")
# studyArea <- sf::st_read("geoms_slc.geojson")

# Uncomment the following to test fixed polygon:
# studyArea <- st_read("../studyAreaTest/geoms_slc_test.geojson")#Offshore
# studyArea <- st_read("../studyAreaTest/geoms_slc_coastal_test.geojson")#coastal 
# studyArea <- st_read("../studyAreaTest/geoms_slc_no_land.geojson") #no land
# studyArea <- st_read("../studyAreaTest/geoms_slc_outsideMAR.geojson") #no samples at all


site <- sf::st_centroid(studyArea) 

studyBox_geom <- geom_sf(data=studyArea, fill=NA, col="red", size=1) 

# The following plots area map using function (output is a list)
areaMapList<-area_map(studyArea, site, land50k_sf, 5, bounds_sf, studyBox_geom)

# The following separates items in the output list: first item is a map and second is a bounding box of the map
areaMap <- areaMapList[[1]] # map
bboxMap <- areaMapList[[2]] # bounding box of the map


########################################################################

outputList <- main_intersect(isdb_sf, studyArea, Bbox = bboxMap, minYear)
isdb_samples_no <- outputList[[1]]
isdb_final <- outputList[[2]]
isdb_finalinside <- outputList[[3]]
isdb_finaloutside <- outputList[[4]]
outputList <- main_intersect(RVCatch_sf, studyArea, Bbox = bboxMap, minYear)
rv_samples_no <- outputList[[1]]
rv_final <- outputList[[2]]
rv_finalinside <- outputList[[3]]
rv_finaloutside <- outputList[[4]]
outputList <- main_intersect(marfis_sf, studyArea, Bbox = bboxMap, minYear)
marfis_samples_no <- outputList[[1]]
marfis_final <- outputList[[2]]
marfis_finalinside <- outputList[[3]]
marfis_finaloutside <- outputList[[4]]

areaMap+
     geom_point(data = outputList[[4]], aes(x = long, y = lat), size = 3, 
                shape = 16, col = "red")+
     geom_point(data = outputList[[3]], aes(x = long, y = lat), size = 3, 
                shape = 16, col = "black")

							 
isdb_samples_no <- outputList[[1]]
isdb_data <- outputList[[2]]
isdb_finalinside <- outputList[[3]]
isdb_finaloutside <- outputList[[4]]
isdb_occur1 <- outputList[[5]]
isdb_occur2 <- outputList[[6]]


load("app/data/SecureData.RData")

load("../data/SecureData.RData")
load("../data/OpenData.RData")

load("app/data/SecureData.RData")
load("app/data/OpenData.RData")

listed_species <- listed_species %>% rename("SCIENTIFICNAME" = Scientific_Name)

listed_species <- listed_species %>% rename("SARA status"=Schedule.status,
                                            "COSEWIC listing"=COSEWIC.status,
                                            "Wild Species listing"=Wild_Species,
                                            "SCIENTIFICNAME"=Scientific_Name_upper,
                                            "COMMONNAME"=Common_Name)




load("app/data/OpenData.RData")
# load("../data/OpenData_sardist.RData")
# load("../data/SecureData.RData")

colnames(isdb_sf)
listed_species <- listed_species %>% rename("SCIENTIFICNAME"= Scientific_Name)

I may have to pass the twospecies tables to the function() 

isdb_final <- main_intersect(isdb_sf, studyArea, listed_species)
main_intersect <- function(datafile, studyArea, listed_table, speciestable, Bbox, ...) 
  
  Bbox2 <- st_as_sfc(areaMapList[[2]])  

outputList <- main_intersect(isdb_sf, studyArea, listed_species, 
                             speciestable = ISSPECIESCODES, Bbox = areaMapList[[2]])
outputList <- main_intersect(isdb_sf, studyArea, listed_species, 
                             speciestable = ISSPECIESCODES, Bbox = bboxMap, minYear)

isdb_samples <- outputList[[1]]
isdb_finalAll <- outputList[[2]]
isdb_finalinside <- outputList[[3]]
isdb_finaloutside <- outputList[[4]]
isdb_occur1 <- outputList[[5]]
isdb_occur2 <- outputList[[6]]
outList <- list(Allsamples, data1, data2, datatable1, datatable2)

outList <- list(Samples_study_no, data1, Samples_study, Samples_bbox, datatable1, datatable2)


outputList <- main_intersect(marfis_sf, studyArea, listed_species, 
                             speciestable = MARFISSPECIESCODES, Bbox = bboxMap, minYear)
outputList <- main_intersect(marfis_sf, studyArea, listed_species, speciestable = MARFISSPECIESCODES)
marfis_samples <- outputList[[1]]
marfis_final <- outputList[[2]]
marfis_occur1 <- outputList[[3]]
marfis_occur2 <- outputList[[4]]

outputList <- main_intersect(RVCatch_sf, studyArea, listed_species, 
                             speciestable = RVGSSPECIES,Bbox = bboxMap, minYear)
RV_samples <- outputList[[1]]
RV_final <- outputList[[2]]
RV_occur1 <- outputList[[4]]
RV_occur2 <- outputList[[5]]

site_map <- function(studyArea,site_sf,land_layer,buf, bound)

areaMap+
  geom_point(data = outputList[[4]], aes(x = long, y = lat), size = 3, 
             shape = 16, col = "red")+
  geom_point(data = outputList[[3]], aes(x = long, y = lat), size = 3, 
             shape = 16, col = "black")
  
  
map1 <- site_map(studyArea,site,land50k_sf,10, bounds_sf)

areaMapList<-area_map(studyArea,site,land10m_sf, 5, bounds_sf,studyBox_geom)
  
map1 <- areaMapList[[1]]

areaMap+
  geom_point(data = RV_final, aes(x = long, y = lat), size = 3, 
             shape = 16, fill = "black")

areaMap+
  geom_point(data = outputList[[4]], aes(x = long, y = lat), size = 3, 
             shape = 16, col = "red")+
  geom_point(data = outputList[[3]], aes(x = long, y = lat), size = 3, 
             shape = 16, col = "black")

site_map(studyArea,site_sf,land50k_sf,10)+
  geom_point(data = isdb_sites, aes(x = longitude, y = latitude), size = 3, 
             shape = 16, fill = "black")+
  geom_point(data = marfis_sites, aes(x = longitude, y = latitude), size = 3, 
             shape = 16, fill = "black")

rvmap <- site_map(studyArea, RV_final, land10m_sf, 5, bounds_sf)
rvmap <- site_map(studyArea, outputList[[2]], land10m_sf, 5, bounds_sf)
rvmap


outputList <- main_intersect(obis_sf, studyArea, listed_species)
obis_final <- outputList[[1]]
samples <- outputList[[2]]

datafile <- RVCatch_sf
data1 <- sf::st_intersection(datafile,studyArea)
data2 <- sf::st_intersection(datafile,st_as_sfc(Bbox))
data2 <- sf::st_intersection(datafile,Bbox2)

data1 <- dplyr::select(data1,geometry)
data2 <- dplyr::select(data2,geometry)
data1 <- unique(data1)
data2 <- unique(data2)

data1 <- sfcoords_as_cols(data1)
data2 <- sfcoords_as_cols(data2)



map1+
  geom_point(data = data2, aes(x = long, y = lat), size = 3, 
             shape = 16, col = "red")+
  geom_point(data = data1, aes(x = long, y = lat), size = 3, 
             shape = 16, col = "black")

# test st_crop() and st_intersection() and examine differences in number of samples
Bbox = areaMapList[[2]]
Bbox <- st_as_sfc(Bbox)
intersect1 <- st_intersection(RVCatch_sf,studyArea)
intersect2 <- st_intersection(RVCatch_sf,Bbox)

# intersect3 <- st_crop(RVCatch_sf,studyArea)
# intersect4 <- st_crop(RVCatch_sf,Bbox)

# crop and intersection in this case operate the same way

# create smaller files for the points
intersect1 <- dplyr::select(intersect1,geometry)
intersect2 <- dplyr::select(intersect2,geometry)
intersect3 <- unique(intersect1)
intersect4 <- unique(intersect2)


intersect3 <- sfcoords_as_cols(intersect3)
intersect4 <- sfcoords_as_cols(intersect4)

map1+
  geom_point(data = intersect4, aes(x = long, y = lat), size = 3, 
             shape = 16, col = "red")+
  geom_point(data = intersect3, aes(x = long, y = lat), size = 3, 
             shape = 16, col = "black")

# using function
outputList <- main_intersect(RVCatch_sf, studyArea, listed_species, 
                             speciestable = RVGSSPECIES, Bbox = bboxMap, minYear)
RV_samples <- outputList[[1]]
RV_samples2 <- outputList[[2]]
RV_final <- outputList[[3]]
RV_finaloutside <- outputList[[4]]
RV_occur1 <- outputList[[5]]
RV_occur2 <- outputList[[6]]
# outList <- list(Allsamples, Allsamples2, data1, data2, datatable1, datatable2)
map1+
  geom_point(data = RV_finaloutside, aes(x = long, y = lat), size = 3, 
             shape = 16, col = "red")+
  geom_point(data = RV_final, aes(x = long, y = lat), size = 3, 
             shape = 16, col = "black")

# TEST ON ISDB
intersect1 <- st_intersection(isdb_sf,studyArea)
intersect2 <- st_intersection(isdb_sf,Bbox)

# intersect3 <- st_crop(RVCatch_sf,studyArea)
# intersect4 <- st_crop(RVCatch_sf,Bbox)

# crop and intersection in this case operate the same way

# create smaller files for the points
intersect1 <- dplyr::select(intersect1,geometry)
intersect2 <- dplyr::select(intersect2,geometry)
intersect3 <- unique(intersect1)
intersect4 <- unique(intersect2)


intersect3 <- sfcoords_as_cols(intersect3)
intersect4 <- sfcoords_as_cols(intersect4)

map1+
  geom_point(data = intersect4, aes(x = long, y = lat), size = 3, 
             shape = 16, col = "red")+
  geom_point(data = intersect3, aes(x = long, y = lat), size = 3, 
             shape = 16, col = "black")

# using function
outputList <- main_intersect(isdb_sf, studyArea, listed_species, 
                             speciestable = ISSPECIESCODES, Bbox = Bbox)
ISDB_samples <- outputList[[1]]
ISDB_samples2 <- outputList[[2]]
ISDB_final <- outputList[[3]]
ISDB_finaloutside <- outputList[[4]]
ISDB_occur1 <- outputList[[5]]
ISDB_occur2 <- outputList[[6]]
# outList <- list(Allsamples, Allsamples2, data1, data2, datatable1, datatable2)
map1+
  geom_point(data = ISDB_finaloutside, aes(x = long, y = lat), size = 3, 
             shape = 16, col = "red")+
  geom_point(data = ISDB_final, aes(x = long, y = lat), size = 3, 
             shape = 16, col = "black")

