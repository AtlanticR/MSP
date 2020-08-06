SelectData_fn <- function(yearb, yeare,season, type,species) {
  GSMISSIONS <- GSMISSIONS[GSMISSIONS$YEAR >= yearb & GSMISSIONS$YEAR < yeare & GSMISSIONS$SEASON==season,]
  GSXTYPE <- GSXTYPE[GSXTYPE$XTYPE==type,]
  self_filter(keep_nullsets = FALSE,quiet = TRUE) # 659 in GSCAT
  GSINF2 <- GSINF # make copy of GSINF to use for a full set of samples
  GSSPECIES <- GSSPECIES[GSSPECIES$CODE %in% species,] # WORKS
  self_filter(keep_nullsets = FALSE,quiet = TRUE)
  
  Catch <- GSCAT
  Mission <- GSMISSIONS

  # write.csv(Mission,"./SpatialDataSynopsis/Output/GSMissions.csv")
  # write.csv(GSINF,"./SpatialDataSynopsis/Output/GSINF.csv")
  # write.csv(Catch,"./SpatialDataSynopsis/Output/GSCat.csv")
 
  # writeOGR(allCatchUTM_sf,dsn,"Test1",driver="ESRI Shapefile")
  # restore_tables('rv',clean = FALSE)


  # 
  returnList <- list("missions" = GSMISSIONS, "Catch1" = Catch)
  return(returnList)

  # return(Catch)

}