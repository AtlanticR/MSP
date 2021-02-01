# Lines 352-354 will not be needed
# Lines 450-451 not needed
# Line 457 replaced by function call



###############################################################
# These variable assignments would go in your main Rmd code
SurveyPrefix <- c("4VSW", "FALL", "SPRING", "SUMMER")
File <- c("_2020_GSCAT.csv", "_2020_GSINF.csv", "_2020_GSSPECIES.csv")

# THESE GET PASSED FROM THE FUNCTION CALL
AquaSiteName <- "FarmersLedge"
PEZversion <- "4748m"
MinYear <- 2010 #user-defined
###############################################################

###############################################################
# This function call would replace your Line 457
RVCatch <-  SelectRV_fn(SurveyPrefix, File, AquaSiteName, PEZversion, MinYear)
###############################################################


# Select RV data function
# bring in the four RV sets of data, add a column to GSINF for each MISSION, SETNO combination
# add SEASON and YEAR to the table
# merge all the tables together
# create an sf object
# clip with PEZ polygon
# then join with GSCAT and species name

SelectRV_fn <- function(SurveyPrefix, File, AquaSiteName, PEZversion, MinYear) {

  data.dir = "../../Data/mar.wrangling/RVSurvey_FGP"  # for my connection to the data.
  
  # Create single GSCAT table, rename the SPEC field to CODE
  f = File[1]
  tablelist <- list()
  for(i in 1:length(SurveyPrefix)) {
    df <- read.csv(file.path(data.dir, paste(SurveyPrefix[i], f, sep = "", collapse = NULL)))
    df <- df %>% tidyr::unite("MISSION_SET", MISSION:SETNO, remove = TRUE)
    # Keep only the columns necessary
    # ("MISSION_SET" "SPEC", "TOTNO")
    df <- dplyr::select(df,1:2,4)
    #Change column name
    df <- df %>% 
      rename(
        CODE = SPEC)
    tablelist[[i]] <- df
  }
  
  # combine all four RV survey catch tables together
  GSCAT <- rbind(tablelist[[1]],tablelist[[2]],tablelist[[3]],tablelist[[4]])
  
  # Create single GSINF table
  f = File[2]
  tablelist <- list()
  for(i in 1:length(SurveyPrefix)) {
    df <- read.csv(file.path(data.dir, paste(SurveyPrefix[i], f, sep = "", collapse = NULL)))
    df <- df %>% tidyr::unite("MISSION_SET", MISSION:SETNO, remove = FALSE)
    # Keep only the columns necessary
    # ("MISSION_SET", "MISSION", "SETNO", "SDATE", "SLAT", "SLONG", "ELAT", "ELONG")
    df <- dplyr::select(df,1:4,7:10)
    # Add YEAR and SEASON to the table
    df$YEAR <- lubridate::year(df$SDATE)
    df$SEASON <- SurveyPrefix[i]
    tablelist[[i]] <- df
  }
  # combine all four RV survey Information tables together
  # Filter down by Minumum Year
  GSINF <- rbind(tablelist[[1]],tablelist[[2]],tablelist[[3]],tablelist[[4]])
  GSINF <- GSINF %>% dplyr::filter(YEAR >= MinYear)
  
  # Create single GSSPECIES table
  f = File[3]
  tablelist <- list()
  for(i in 1:length(SurveyPrefix)) {
    df <- read.csv(file.path(data.dir, paste(SurveyPrefix[i], f, sep = "", collapse = NULL)))
    # Remove TSN field
    df <- dplyr::select(df,(1:3))
    tablelist[[i]] <- df
  }
  
  # combine all four RV SPECIES tables together
  GSSPECIES <- rbind(tablelist[[1]],tablelist[[2]],tablelist[[3]],tablelist[[4]])
  # remove duplicate records
  GSSPECIES <- dplyr::distinct(GSSPECIES)
  
  # Convert GSINF to sf object
  GSINF_sf = st_as_sf(GSINF, coords = c("SLONG", "SLAT"), crs = 4326) #WGS84
  RVsf <- GSINF_sf
  dsn <- "../../Data/Zones/SearchPEZpolygons"
  PEZ_poly_st <- st_read(dsn, layer=paste0("PEZ_",AquaSiteName, PEZversion))
  
  # Select all RV survey points within the Exposure Zone (PEZ) using st_intersect
  rv_intersect <- st_intersection(RVsf,PEZ_poly_st)
  
  # Join all GSCAT records that match those RV survey points AND join species
  # names to those records
  Catch <- left_join(rv_intersect, GSCAT, by = "MISSION_SET")
  Catch <- left_join(Catch, GSSPECIES, by = "CODE")
  
  return(Catch)
}