
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
}
