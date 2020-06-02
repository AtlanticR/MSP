
SaveTmpTables <- function(){
  sapply(ds_all[['rv']]$tables, USE.NAMES = F, simplify = TRUE, function(x) {
    assign(paste0("tmp_",x),value = get(x), envir = .GlobalEnv)
  }
  )
  return(NULL)
}



RestoreTables <- function(){
  sapply(ds_all[['rv']]$tables, USE.NAMES = F, simplify = TRUE, function(x) {
    assign(x,value = get(paste0("tmp_",x)), envir = .GlobalEnv)
  }
  )
  return(NULL)
<<<<<<< HEAD
}


# old attempt
# 
# RestoreDataTables <- function() {
#   GSCAT <- tmp_GSCAT
#   GSDET <- tmp_GSDET
#   GSINF <- tmp_GSINF
#   GSMISSIONS <- tmp_GSMISSIONS
#   GSSPECIES <- tmp_GSSPECIES
#   GSSTRATUM <- tmp_GSSTRATUM
#   GSXTYPE <- tmp_GSXTYPE
# }
=======
}
>>>>>>> 80d769c9bf90ed7c23263d4a4379838e60ac4c79