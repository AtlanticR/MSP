library(Mar.datawrangling)
library(dplyr)
library(lubridate)

# this script can work from data stored locally or on the IN/MSP/Data/mar.wrangling folder

data.dir <- "../../../MSP/Data/mar.wrangling"
setwd(data.dir)


# ############################################################### #
# Using current data

# Import the MARFIS tables
get_data('marfis', data.dir=data.dir)

db='marfis'

# limit by year and remove all records with invalid coordinates
PRO_SPC_INFO <- PRO_SPC_INFO[PRO_SPC_INFO$YEAR >= 2010,]
PRO_SPC_INFO <- PRO_SPC_INFO %>% filter(!is.na(LONGITUDE))

self_filter(db= 'marfis',keep_nullsets = FALSE,quiet = TRUE)
# save database as a csv file.  This command produces a file with more 
# columnns than are needed.
save_data(db='marfis', formats = 'csv')  # this creates a timestamped csv 
# of the clipped data.  Import the csv and delete unnecessary columns 
# this produces a 5GB file


file <- list.files(data.dir,"*.csv")

# Read in the CSV datafile
marfis1 <- read.csv(file.path(data.dir, file))

# remove the CSV from the directory
file.remove(file)

# Reduce the columnns down to only those needed
# marfis1 <- dplyr::select(marfis1, 
#               one_of(c("SPECIES_CODE","DATE_FISHED","RND_WEIGHT_KGS","LATITUDE","LONGITUDE")))

marfis1$YEAR <- lubridate::year(marfis1$DATE_FISHED)
marfis1 <- dplyr::select(marfis1, 
                         one_of(c("SPECIES_CODE","YEAR","LATITUDE","LONGITUDE")))
marfis_sf <- sf::st_as_sf(marfis1, coords = c("LONGITUDE","LATITUDE"), crs = 4326)


# save as .RData file
save(marfis1, file="marfis.RData", compress = TRUE)


#############################################3-
# ISDB
# You may have to run the data_tweaks() function to fix a few
# things in the tables
# data_tweaks2('isdb', data.dir = data.dir)
get_data('isdb', data.dir=data.dir)

# select only those records later than 2009
# remove records with invalid coordinates
ISSETPROFILE_WIDE <- ISSETPROFILE_WIDE[ISSETPROFILE_WIDE$YEAR >= 2010,]
ISSETPROFILE_WIDE <- ISSETPROFILE_WIDE %>% filter(!is.na(LONGITUDE))
ISSETPROFILE_WIDE <- ISSETPROFILE_WIDE %>% filter(LONGITUDE<0)

db='isdb'
self_filter(keep_nullsets = FALSE,quiet = TRUE)

save_data(db='isdb', formats = 'csv')  # this creates a csv of the data

file <- list.files(data.dir,"*.csv")
# Read in the CSV datafile
isdb1 <- read.csv(file.path(data.dir, file), stringsAsFactors = FALSE)

# remove the CSV from the directory
file.remove(file)

# Reduce data file down to only the columnns necessary
isdb1 <- dplyr::select(isdb1, 
                         one_of(c("SPECCD_ID","YEAR","LATITUDE","LONGITUDE")))
isdb_sf <- sf::st_as_sf(isdb1, coords = c("LONGITUDE","LATITUDE"), crs = 4326)
# isdb1$DATE_TIME1 <- lubridate::parse_date_time(isdb1$DATE_TIME1, orders = "ymd")

# save as .RData file
save(isdb_sf, file="isdb.RData", compress = TRUE)
