CreatePresenceObject_fn <- function(yearb1, yeare1,season, type,species) {
  GSMISSIONS <- GSMISSIONS[GSMISSIONS$YEAR >= yearb1 & GSMISSIONS$YEAR < yeare1 & GSMISSIONS$SEASON==season,]
  GSXTYPE <- GSXTYPE[GSXTYPE$XTYPE==type,]
  self_filter(keep_nullsets = FALSE,quiet = TRUE) # 659 in GSCAT
  GSINF2 <- GSINF # make copy of GSINF to use for a full set of samples
  GSSPECIES <- GSSPECIES[GSSPECIES$CODE %in% species,] # WORKS
  self_filter(keep_nullsets = FALSE,quiet = TRUE)
  # Create a valid DEPTH field (Depth values are in fathoms)
  GSINF2$DEPTH <- round((GSINF2$DMIN*1.8288+GSINF2$DMAX*1.8288)/2,2)
  # Keep only the columns necessary
  # ("MISSION" "SETNO" "SDATE" "STRAT" "DIST" "DEPTH" "BOTTOM_TEMPERATURE" "BOTTOM_SALINITY" "LATITUDE" "LONGITUDE")
  GSINF2 <- dplyr::select(GSINF2,1:3,5,12,24,30:31,33:34)
  # rename some fields
  names(GSINF2)[7:8] <- c("BTEMP","BSAL")

  # use a merge() to combine MISSION,SETNO with all species to create a presence/absence table
  SpecOnly <- dplyr::select(GSSPECIES,3)
  # rename 'CODE' to 'SPEC'
  names(SpecOnly)[1] <- c("SPEC")

  # this merge() creates a full set of all MISSION/SETNO and SPECIES combinations
  Combined <- merge(GSINF2,SpecOnly)
  GSCAT2 <- dplyr::select(GSCAT,1:3,5:6)
  # SUM TOTNO and TOTWGT on MISSION and SETNO to get rid of the different size classes
  GSCAT2 <- aggregate(GSCAT2[,4:5], by=list(GSCAT2$MISSION, GSCAT2$SETNO, GSCAT2$SPEC), FUN=sum)
  # Column names after aggregate() function need to be re-established
  names(GSCAT2)[1:3] <- c("MISSION","SETNO","SPEC")
  # names(Combined)
  # Merge Combined and GSCAT2 on MISSION and SETNO
  allCatch <- merge(Combined, GSCAT2, all.x=T, by = c("MISSION", "SETNO", "SPEC"))
  # Fill NA records with zero
  allCatch$TOTNO[is.na(allCatch$TOTNO)] <- 0
  allCatch$TOTWGT[is.na(allCatch$TOTWGT)] <- 0
  # Standardize all catch numbers and weights to a distance of 1.75 nm
  allCatch$STDNO <- allCatch$TOTNO*1.75/allCatch$DIST
  allCatch$STDWGT <- allCatch$TOTWGT*1.75/allCatch$DIST
  write.csv(allCatch,"./SpatialDataSynopsis/Output/AllCatch.csv")
  rowcount <- list()
  #rowcount[[i]] <- nrow(allCatch)

  # Create an sf Spatial Object from the data and project to UTM
  allCatch_sf <- st_as_sf(allCatch, coords = c("LONGITUDE","LATITUDE"), crs = 4326)
  allCatchUTM_sf <- st_transform(allCatch_sf, crs = 26920)
  
  dsn <- paste("./SpatialDataSynopsis/Output/SP",species,"_2test.shp",sep = "")
  st_write(allCatchUTM_sf, dsn,driver = "ESRI Shapefile")

  
  # writeOGR(allCatchUTM_sf,dsn,"Test1",driver="ESRI Shapefile")
  restore_tables('rv',clean = FALSE)

  # GSMISSIONS <- GSMISSIONS[GSMISSIONS$YEAR >= yearb1 & GSMISSIONS$YEAR < yeare1 & GSMISSIONS$SEASON==season,]
  # GSXTYPE <- GSXTYPE[GSXTYPE$XTYPE==type,]
  # self_filter(keep_nullsets = FALSE,quiet = TRUE) # 659 in GSCAT
  # 
  # returnList <- list("year1"= yearb1,"year2" = yeare1, "missions" = GSMISSIONS, "type1" = GSXTYPE)
  # return(returnList)

  return(allCatchUTM_sf)




}