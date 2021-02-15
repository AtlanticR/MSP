SelectISDB_fn <- function(AquaSiteName, PEZversion, minYear) {
  wd <- getwd() # store main project directory
  data.dir = "../../../Data/mar.wrangling"  # location of ISDB datafiles

  # Import PEZ polygon
  # Mar.datawrangling uses sp objects
  dsn <- "../../../Data/Zones/SearchPEZpolygons"
  #PEZ_poly <- readOGR(dsn,layer=paste0("PEZ_",AquaSiteName, PEZversion))
  # convert SP PEZ poly to sf object for final intersection
  #PEZ_poly_sf <- st_as_sf(PEZ_poly)
  
  # ############################################################### #
  # Using current data
  
  # Import the ISDB tables
  #This command did not work for me
  get_data('isdb', data.dir=data.dir)
  
  #ISSETPROFILE_WIDE corrections 
  set2<-ISSETPROFILE_WIDE %>%
    mutate(DATE_TIME1 = na_if(DATE_TIME1, "9999-01-01 AST"))
  set2<-set2 %>%
    mutate(DATE_TIME2 = na_if(DATE_TIME2, "9999-01-01 AST"))
  set2<-set2 %>%
    mutate(DATE_TIME3 = na_if(DATE_TIME3, "9999-01-01 AST"))
  set2<-set2 %>%
    mutate(DATE_TIME4 = na_if(DATE_TIME4, "9999-01-01 AST"))
  set2$DATE_TIME1[is.na(set2$DATE_TIME1)] <- set2$DATE_TIME2[is.na(set2$DATE_TIME1)]         
  set2$DATE_TIME4[is.na(set2$DATE_TIME4)] <- set2$DATE_TIME3[is.na(set2$DATE_TIME4)]         
  
  set2$LAT1[is.na(set2$LAT1)] <- set2$LAT2[is.na(set2$LAT1)]  
  set2$LONG1[is.na(set2$LONG1)] <- set2$LONG2[is.na(set2$LONG1)]
  
  set2$LAT4[is.na(set2$LAT4)] <- set2$LAT3[is.na(set2$LAT4)]  
  set2$LONG4[is.na(set2$LONG4)] <- set2$LONG3[is.na(set2$LONG4)]
  
  set2$YEAR<-str_sub(set2$DATE_TIME1, start=1, end=4)
  
  #I developed these instead
  #filenames <- list.files(data.dir, pattern="ISDB*", full.names=TRUE)
  #lapply(filenames,load,.GlobalEnv)
    # limit data by MinYear and clip to PEZPoly
  set2<- set2 %>% rename(LATITUDE=LAT1)
  set2<- set2 %>% rename(LONGITUDE=LONG1)
  set3 <-  clip_by_poly(df = set2,
                        lat.field = "LATITUDE",
                        lon.field = "LONGITUDE",
                        clip.poly = PEZ_poly)
  ISSETPROFILE_WIDE <- set3[set3$YEAR >= minYear,]
  
  # limit by year
  self_filter(keep_nullsets = FALSE,quiet = TRUE)
  dsn <- "C:/Temp"
  setwd(dsn)
  save_data(db='isdb')  # this creates both a csv and a shp
  # of the clipped data.  Import the shp as an sf object and 
  # pass back to main script as ISDB_INTERSECT

    # read in the newly created ISDB shapefile
  # as an sf object.

  files <- list.files(dsn,".shp")
  isdb_shp <- files[grep("isdb_",files)] # get shapefile name
  isdb_shp <- substr(isdb_shp,1,nchar(isdb_shp)-4) # remove '.shp' extension

  isdb_sf <- st_read(dsn, layer = isdb_shp, quiet=TRUE)
  # remove all files created by save_data() (shapefile and CSV)
  fl <- list.files(dsn,isdb_shp)
  for(i in 1:length(fl)) {
    file.remove(fl[i])
  }  
  setwd(wd) #revert to original working directory
  
  # # ############################################################### #  
  # # using archived data
  # dsn <-  "../../Data/mar.wrangling/ISDB_shp"
  # fl <- list.files(dsn,".shp")
  # # isdb <- read.csv(file.path(dataPath,fl[grep("isdb_",fl)]))
  # isdb_shp <- fl[grep("isdb_",fl)]
  # isdb_shp <- substr(isdb_shp,1,txtlen)
  #   
  # isdb_sf <- st_read(dsn, layer = isdb_shp, quiet=TRUE)
  # # limit data to MinYear and greater
  # isdb_sf <- isdb_sf[which(isdb_sf$YEAR)>=MinYear),]
  # # ############################################################### #  
  #PEZ_poly_sf <- st_read(dsn, layer=paste0("PEZ_",AquaSiteName, PEZversion))
  
  #ISDB_Catch <- st_intersection(isdb_sf,PEZ_poly_sf)
  
  # Select all ISDB points within the Exposure Zone (PEZ) using st_intersect
  #ISDB_Catch <- st_intersection(isdb_sf,PEZ_poly_st)
  
  return(isdb_sf)
  
}