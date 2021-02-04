
# To Do ##############################################--
#
# Instead of using the save_data() fn,  for current data
# perhaps look
# at what fields are necessary in MARFIS and ISDB and do the joins
# myself
# look at my SQL code for MARFIS and ISDB (Observer) data to 
# figure out joins
#
# Put in an if statement to separate out Current from Archvied Data
# use an argument from the function being passed?
#
# Add in some error catches for when Intersection results in zero
# data points
# END To Do ##########################################--


Function call from Rmd
MARFISCatch <-  SelectMARFIS_fn(AquaSiteName, PEZversion, MinYear)

library(Mar.datawrangling)
library(sf)
library(rgdal)

AquaSiteName <- "FarmersLedge"
PEZversion <- "4748m"
MinYear <- 2000


wd <- getwd() # store main project directory

SelectMARFIS_fn <- function(AquaSiteName, PEZversion, MinYear) {
  
  data.dir = "../../Data/mar.wrangling"  # location of MARFIS datafiles
  
  # Import PEZ polygon
  # Mar.datawrangling uses sp objects
  dsn <- "../../Data/Zones/SearchPEZpolygons"
  PEZ_poly <- readOGR(dsn,layer=paste0("PEZ_",AquaSiteName, PEZversion))
  # convert SP PEZ poly to sf object for final intersection
  PEZ_poly_sf <- st_as_sf(PEZ_poly)
  
  # ############################################################### #
  # Using current data
  
  # Import the MARFIS tables
  get_data('marfis', data.dir=data.dir)
  # limit data by MinYear and clip to PEZPoly
  PRO_SPC_INFO <- PRO_SPC_INFO[PRO_SPC_INFO$YEAR 
                                         >= MinYear,]
  PRO_SPC_INFO <-  clip_by_poly(df = PRO_SPC_INFO
                                     , lat.field = "LATITUDE"
                                     , lon.field = "LONGITUDE"
                                     , clip.poly = PEZ_poly)
  # limit by year
  self_filter(keep_nullsets = FALSE,quiet = TRUE)
  
  dsn <- "C:/Temp"
  setwd(dsn)
  save_data(db='marfis')  # this creates both a csv and a shp
  # of the clipped data.  Import the shp as an sf object and 
  # pass back to main script as MARFIS_INTERSECT
  
  # read in the newly created MARFIS shapefile
  # as an sf object.
  
  files <- list.files(dsn,".shp")
  marfis_shp <- files[grep("marfis_",files)] # get shapefile name
  marfis_shp <- substr(marfis_shp,1,nchar(marfis_shp)-4) # remove '.shp' extension
  
  marfis_sf <- st_read(dsn, layer = marfis_shp, quiet=TRUE)
  # remove all files created by save_data() (shapefile and CSV)
  fl <- list.files(dsn,marfis_shp)
  for(i in 1:length(fl)) {
    file.remove(fl[i])
  }  
  setwd(wd) #revert to origional working directory
  
  # # ############################################################### #  
  # # using archived data
  # dsn <-  "../../Data/mar.wrangling/ISDB_shp"
  # fl <- list.files(dsn,".shp")
  # # marfis <- read.csv(file.path(dataPath,fl[grep("marfis_",fl)]))
  # marfis_shp <- fl[grep("marfis_",fl)]
  # marfis_shp <- substr(marfis_shp,1,txtlen)
  # 
  # marfis_sf <- st_read(dsn, layer = marfis_shp, quiet=TRUE)
  # # limit data to MinYear and greater
  # marfis_sf <- marfis_sf[which(marfis_sf$YEAR)>=MinYear),]
  # # ############################################################### #  
  
  # Select all MARFIS points within the Exposure Zone (PEZ) using st_intersect
  # Catch <- st_intersection(marfis_sf,PEZ_poly_sf)
  
  return(marfis_sf)
  
}