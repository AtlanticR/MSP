CreatePresenceObject_fn <- function(yearb1, yeare1,season, type,species) {
  GSMISSIONS <- GSMISSIONS[GSMISSIONS$YEAR >= yearb1 & GSMISSIONS$YEAR < yeare1 & GSMISSIONS$SEASON==season,]
  GSXTYPE <- GSXTYPE[GSXTYPE$XTYPE==type,]
  self_filter(keep_nullsets = FALSE,quiet = TRUE) # 659 in GSCAT
  GSINF2 <- GSINF # make copy of GSINF to use for a full set of samples
  GSSPECIES <- GSSPECIES[GSSPECIES$CODE %in% species,] # WORKS
  self_filter(keep_nullsets = FALSE,quiet = TRUE)
  
  Catch <- GSCAT
  Mission <- GSMISSIONS

  write.csv(Mission,"./SpatialDataSynopsis/Output/GSMissions.csv")
  write.csv(GSINF,"./SpatialDataSynopsis/Output/GSINF.csv")
  write.csv(Catch,"./SpatialDataSynopsis/Output/GSCat.csv")
 
  # writeOGR(allCatchUTM_sf,dsn,"Test1",driver="ESRI Shapefile")
  restore_tables('rv',clean = FALSE)

  # GSMISSIONS <- GSMISSIONS[GSMISSIONS$YEAR >= yearb1 & GSMISSIONS$YEAR < yeare1 & GSMISSIONS$SEASON==season,]
  # GSXTYPE <- GSXTYPE[GSXTYPE$XTYPE==type,]
  # self_filter(keep_nullsets = FALSE,quiet = TRUE) # 659 in GSCAT
  # 
  returnList <- list("year1"= yearb1,"year2" = yeare1, "missions" = GSMISSIONS, "Catch1" = Catch)
  return(returnList)

   #return(Catch)

}