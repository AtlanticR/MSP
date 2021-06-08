library(tidyverse)
library(robis)

# ?robis::occurrence # the first argument is scientificname
# query by name
pbgl_df <- robis::occurrence('Lamna nasus')

View(pbgl_df)

# query by Aphia ID
taxid <- robis::occurrence(taxonid=105841)

# Search in a box around the Atlantic and the GoSL:
gosl_df <- robis::occurrence('salmonidae', geometry = "POLYGON ((-59.85352 46.25585, 
                                                    -66.79688 43.51669, 
                                                    -65.83008 38.54817, 
                                                    -49.65820 38.54817, 
                                                    -48.42773 46.61926, 
                                                    -56.16211 54.16243, 
                                                    -71.45508 47.21957, 
                                                    -59.85352 46.25585))")

robis::map_leaflet(gosl_df)

# change the default map
robis::map_leaflet(gosl_df, 
                   popup= function(x) {paste0('<a href="https://obis.org/dataset/', x['dataset_id'], '">',x['dataset_id'],'</a><br />', 
                                              x['recordedBy'])}
)
# this looks like the same map

# applying filters
# Depth
roughy_shallow <- robis::occurrence("Hoplostethus atlanticus", enddepth=400)
robis::map_leaflet(roughy_shallow)

# Date
lionfish_native <- robis::occurrence("Pterois volitans", enddate="1980-01-01")
robis::map_leaflet(lionfish_native)

lionfish_now <- robis::occurrence("Pterois volitans")
robis::map_leaflet(lionfish_now)


# manipulating output with Tidyverse or base functions

# Inside your robis occurrences object:
names(gosl_df)

# A general idea of the results and the years they were observed
table(gosl_df$year)


# MoF (Measurement of facts)??
# furrow-shell mollusc
occ_w_mof <- robis::occurrence('Abra tenuis', mof=TRUE)

# get associated measurements to these occurrence records, keeping the fields
# specified in 'fields'
mof <- robis::measurements(occ_w_mof, fields=c('scientificName', 
                                               'decimalLongitude', 
                                               'decimalLatitude', 
                                               'eventDate'))

View(mof)

# what's available with MoF?
# Human-readable mof columns for our dataset:
mof %>% select('eventDate', 'decimalLongitude', 'decimalLatitude', 
               'measurementType', 'measurementValue') %>% View

# get a unique listing of the measurement values
# What if we need a specific type of measurement?
mof$measurementTypeID %>% unique()
mof$measurementType %>% unique()

# Let's grab some length data
mof %>% filter(measurementTypeID == 'http://vocab.nerc.ac.uk/collection/P01/current/OBSINDLX/') %>% View

# Assignment
# Three orders for deepwater corals
# Alcyonacea
# Scleractinia
# Antipatharia

# without the depth criteria there were 1,300,037 records
# below 2000 m there are 42,755 records

DWC_df <- robis::occurrence(c('Alcyonacea', 'Scleractinia', 'Antipatharia'), startdepth = 2000)

# the first argument is scientificName.  How does  robis::occurrence() know that I just fed it 
# Order names and not full scientificNames

DWC_df$scientificName %>% unique()
DWC_df$order %>% unique()
colnames(DWC_df)

world <- ggplot2::map_data("world")
ggplot() +
  geom_polygon(data = world, aes(x = long, y = lat, group = group), fill = "#dddddd") +
  geom_point(data = DWC_df, aes(x = decimalLongitude, y = decimalLatitude, color = order)) + coord_fixed(1)


#### Using spocc
# install.packages('spocc')
library(spocc)
# scrubr
# we won't use this today but can confirm we've installed it
# install.packages('scrubr')
library(scrubr)
# mapr
# install.packages('mapr')
library(mapr)

############################
#1: make a vector of species you care about
spp <- c('Danaus plexippus','Accipiter striatus','Pinus contorta')
#2: ask some or all of the biodiversity databases what records they have
dat <- occ(query = spp, from = 'gbif', has_coords = TRUE, limit = 100)

#3: Map your results:
mapr::map_leaflet(dat)