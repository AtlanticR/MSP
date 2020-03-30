#This chunk of code should be run to do a re-extraction of data or to extract data using a new polygon.
#Note taht you need 64-bit ODBC driver to be able to extract MARFIS data. Mike provided data to Catalina on Sept 2019 and waiting to get Oracle 64 bit to do extraction myself.

rm(list=ls(all=TRUE))
library(Mar.datawrangling)
library(rgdal)
AquaSiteName <- "Whycocomagh"
PEZversion <- "5km"
cat(AquaSiteName)
polyPath <- "//ent.dfo-mpo.ca/ATLShares/Science/CESD/HES_MSP/R/SearchPEZ/inputs/polygons"

pl <- list.files(polyPath,"*.shp")
pl <- pl[-grep("xml",pl)]
PEZ_poly <- readOGR(file.path(polyPath,pl[grep(paste0("PEZ_",AquaSiteName,PEZversion),pl)]))
site <- readOGR(polyPath,layer=paste0("Site_",AquaSiteName))

source("C:/RProjects/MSP/SearchPEZ/code/.Rprofile") #Catalina's path to access Oracle passwords
get_data(db = 'rv', data.dir = data.dir)
GSINF = clip_by_poly(df = GSINF
                     , lat.field = "LATITUDE"
                     , lon.field = "LONGITUDE"
                     , clip.poly = PEZ_poly)
self_filter()
save_data(db='rv')
cleanup('rv')

get_data('isdb', data.dir=data.dir)
ISSETPROFILE_WIDE = clip_by_poly(df = ISSETPROFILE_WIDE
                                 , lat.field = "LATITUDE"
                                 , lon.field = "LONGITUDE"
                                 , clip.poly = PEZ_poly)
self_filter()
save_data(db='isdb')
cleanup('isdb')

get_data('marfis', data.dir = data.dir)
PRO_SPC_INFO = clip_by_poly(df = PRO_SPC_INFO
                            , lat.field = "LATITUDE"
                            , lon.field = "LONGITUDE"
                            , clip.poly = PEZ_poly)
self_filter()
save_data(db='marfis')
cleanup('marfis')