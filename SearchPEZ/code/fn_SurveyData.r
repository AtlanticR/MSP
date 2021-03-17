
########## - Select RV data and intersect with the study area #########################-

SelectRV_fn <- function(RVCatch_sf, minYear, studyArea) {
  
  # RVdataPath = "../Data/mar.wrangling/RVSurvey_FGP"
  # Filter by year minYear
  RVCatch_sf <- RVCatch_sf %>% dplyr::filter(YEAR >= minYear)
  # Select all RV survey points within the Exposure Zone (studyArea) using st_intersect
  RVCatch_sf <- st_intersection(RVCatch_sf,studyArea)

  return(RVCatch_sf)
}

########## - Select MARFIS data and intersect with the study area #########################-

SelectMARFIS_fn <- function(studyArea, minYear) {
  
  # SurveyPath <-  "../Data/mar.wrangling"
  
  #############################################-
  # to use this .RData file and convert to a SF object
  # load data file and species file
  # NOTE: data file is already loaded as marfis1
  
  # filelist <- c(file.path(SurveyPath,"marfis.RData"), file.path(SurveyPath,"MARFIS.SPECIES.RData"))
  filelist <- c(file.path(SurveyPath,"MARFIS.SPECIES.RData"))
  lapply(filelist, load, envir=.GlobalEnv)
  
  # Reduce MARFIS species table down to only species code, common name
  SPECIES <- dplyr::select(SPECIES,SPECIES_CODE, SPECIES_NAME)
  
  # add YEAR column and filter for records from minYear onwards
  marfis1$YEAR <- lubridate::year(marfis1$DATE_FISHED)
  marfis1 <- marfis1 %>% dplyr::filter(YEAR >= minYear)
  
  # Convert to SF object
  marfis1 <- st_as_sf(marfis1, coords = c("LONGITUDE", "LATITUDE"))
  st_crs(marfis1) <-  4326
  
   # Select all MARFIS points within the Exposure Zone (PEZ) using st_intersect
  Catch <- st_intersection(marfis1,studyArea)
  # merge the data file with species names using common species codes
  Catch <- merge(Catch,SPECIES, by = 'SPECIES_CODE')
  
  return(Catch)
  
}

########## - Select ISDB data and intersect with the study area #########################-

SelectISDB_fn <- function(isdb1, studyArea, minYear) {
  # SurveyPath = "../Data/mar.wrangling"
  
  # NOTE: data file is already loaded as isdb1
  # filelist <- c(file.path(SurveyPath,"isdb.RData"), file.path(SurveyPath,"ISDB.ISSPECIESCODES.RData"))
  #filelist <- c(file.path(SurveyPath,"ISDB.ISSPECIESCODES.RData"))
  #lapply(filelist, load, envir=.GlobalEnv)
  
  # Reduce MARFIS species table down to only species code, common name
  #ISSPECIESCODES <- dplyr::select(ISSPECIESCODES,SPECCD_ID,COMMON, SCIENTIFIC)
  
  # add YEAR column and filter for records from minYear onwards

  #isdb1$DATA_TIME1 <- lubridate::parse_date_time(isdb1$DATE_TIME1, orders = "ymd")
  
  #isdb1$YEAR <- lubridate::year(isdb1$DATA_TIME1)
  #isdb1 <- isdb1 %>% dplyr::filter(YEAR >= minYear)
  
  # Convert to SF object
  isdb1 <- st_as_sf(isdb1, coords = c("LONGITUDE", "LATITUDE"))
  st_crs(isdb1) <-  4326
  
  # Select all MARFIS points within the Exposure Zone (PEZ) using st_intersect
  Catch <- st_intersection(isdb1,studyArea)
  # merge the data file with species names using common species codes
  #Catch <- merge(Catch,ISSPECIESCODES, by = 'SPECCD_ID')
  
  return(Catch)

}