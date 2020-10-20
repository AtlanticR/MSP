#Ocean Biogeographic Information System (OBIS; http://www.iobis.org/), 
#Global Biodiversity Information Facility (GBIF; https://www.gbif.org/),
#iNaturalist (https://www.inaturalist.org/),

# Remi Daigle developed a package to extract data from the above mentioned sources. 
# Daigle did a recent extraction on Nova scotia records, which was sent to C. Gomez on October 19 2020
# https://github.com/remi-daigle/AIScanR
# Following code was shared by Daigle to get them all in one df (not from the same project, so will likely need slight modification)
library(tidyverse)
library(sf)
library(data.table)

speciesdataPath <- "C:/RProjects/data/NaturalResources/Species"
datadir <- file.path(speciesdataPath,"OBIS_CBIF_iNaturalist")

files <- file.info(file.path(datadir,list.files(path = datadir, pattern="occ"))) %>% 
  mutate(filename=basename(row.names(.)),
         temp=gsub("occ_","",gsub(".rds","",filename))) %>%
  separate(temp,c("grid","year","month","day"),"_") %>% 
  filter(size>678) %>% # this removes files with zero records - may need to be adjsuted
  select(filename,grid,year,month,day)

latlong <- readRDS(file.path(datadir,files$filename[1])) %>% st_crs()
st <- Sys.time()
occ <- lapply(files$filename, function(x) readRDS(file.path(datadir,x)) %>% 
                mutate(filename=x) %>% 
                as.data.table()) %>% 
                rbindlist() %>%
  mutate(geometry=st_sfc(geometry,crs=latlong)) %>% 
  left_join(files,by="filename") %>% 
  st_as_sf()

# Convert sf geometry column to separate latitude and longitude columns for export to CSV
# and drop the geometry column
occ_coords <- do.call(rbind, st_geometry(occ)) %>% 
  as_tibble() %>% setNames(c("lon","lat"))

occ_final <- bind_cols(occ,occ_coords)
occ_final$geometry <- NULL

write.csv(occ_final, "C:/RProjects/data/NaturalResources/Species/OBIS_CBIF_iNaturalist/OBIS_CBIF_iNaturalist.csv", row.names=FALSE)

