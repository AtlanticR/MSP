###########################################################################################
###########################################################################################
### 
### This code doesn't work.  The function returns the incorrect number
### of records
### 
### 
###########################################################################################
###########################################################################################

library(Mar.datawrangling) # loads and filters RV survey data 

source("./SpatialDataSynopsis/code/tests/Test_fn_SelectData.R")

data.dir <- "../data/mar.wrangling"
get_data('rv', data.dir = data.dir) # Load RV survey data tables
save_tables('rv') # creates a copy of RV survey tables to new environment ('dw')

type1 <- 1
season1 <- 'SUMMER'
species1 <- 10
yearb1 <- 2000
yeare1 <- 2005

# variables to run the function line by line
type <- 1
season <- 'SUMMER'
species <- 10
yearb <- 2000
yeare <- 2005

nrow(GSMISSIONS)
nrow(GSCAT)

ReturnList <- SelectData_fn(yearb1,yeare1,season1,type1,species1)
#Returnlist <-  SelectData_fn(yearb[y], yeare[y], "SUMMER", 1, speciescode[i])
#TestReturn2 <- SelectData_fn(2000, 2005, "SUMMER", 1, 10)

nrow(ReturnList$missions)
nrow(ReturnList$Catch1)

# missions should be 10 rows long (down from 200 )
# Catch1 should be only 520 rows long (down from 248,583)

restore_tables('rv',clean = FALSE)

