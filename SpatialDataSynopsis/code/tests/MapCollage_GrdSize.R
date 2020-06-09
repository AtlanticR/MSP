# Code built by Gordana Lazin and mildly edited by Catalina Gomez
library(magick)
library(pdftools)
#speciesNumber = "SP10"
# pdf file have species name/code included
MapCollage_GrdSize <- function(speciesNumber) {
  
  # directory where the pdf images are
  inDir <- "C:/RProjects/MSP/SpatialDataSynopsis/Output/"
  
  # list all pdf files in that folder
  fl=list.files(inDir,pattern=".pdf",full.names = T)
  
  # select species
  fl=fl[grep(speciesNumber,fl)]
  
  # read all pdfs to a list 
  iml=lapply(fl,image_read_pdf, density = 300)
  
  # group images: this will depend on the file names chosen for pdf files
  hexavg_a=c(iml[[grep("Grid10.pdf",fl)]],iml[[grep("Grid25.pdf",fl)]],iml[[grep("Grid100.pdf",fl)]],iml[[grep("Grid200.pdf",fl)]])
  hexavg_b=c(iml[[grep("Grid300.pdf",fl)]], iml[[grep("Grid400.pdf",fl)]], iml[[grep("Grid1000.pdf",fl)]])
  #hexsum_T2=c(iml[[grep("hexsum10_T2",fl)]],iml[[grep("hexsum25_T2",fl)]],iml[[grep("hexsum100_T2",fl)]],iml[[grep("hexsum200_T2",fl)]], iml[[grep("hexsum300_T2",fl)]], iml[[grep("hexsum400_T2",fl)]], iml[[grep("hexsum1000_T2",fl)]])
  #hexsum_T3=c(iml[[grep("hexsum10_T3",fl)]],iml[[grep("hexsum25_T3",fl)]],iml[[grep("hexsum100_T3",fl)]],iml[[grep("hexsum200_T3",fl)]], iml[[grep("hexsum300_T3",fl)]], iml[[grep("hexsum400_T3",fl)]], iml[[grep("hexsum1000_T3",fl)]])
  #hexsum_T4=c(iml[[grep("hexsum10_T4",fl)]],iml[[grep("hexsum25_T4",fl)]],iml[[grep("hexsum100_T4",fl)]],iml[[grep("hexsum200_T4",fl)]], iml[[grep("hexsum300_T4",fl)]], iml[[grep("hexsum400_T4",fl)]], iml[[grep("hexsum1000_T4",fl)]])
  periods_a=c("10 km^2","25 km^2","100 km^2","200 km^2")
  periods_b=c("300 km^2", "400 km^2", "1000 km^2")
  # image append
  hexavg_a=image_annotate(hexavg_a,periods_a,size=120, weight = 700, gravity = "NorthWest", location="+100+100")
  hexavg_b=image_annotate(hexavg_b,periods_b,size=120, weight = 700, gravity = "NorthWest", location="+100+100")
  col1=image_append(image_scale(hexavg_a), stack = TRUE)
  col2=image_append(image_scale(hexavg_b), stack = TRUE)
  #col3=image_append(image_scale(hexsum_T3), stack = TRUE)
  #col4=image_append(image_scale(hexsum_T4), stack = TRUE)
  #(image_scale(rclass, "x200"),#use "x200" for small output in the console
  image_append(c(col1, col2))
  }


#Example on how to sue function: 
#MapCollage_GrdSize("SP10")

#######################################################
#Uncomment this section if you would like to understand some of the argemnts used here or 
#if you want to troblehoot this function
#speciesNumber <- "SP200" # to troublehoot this function
#f1 <- image_read_pdf('C:/RProjects/MSP/SpatialDataSynopsis/code/tests/Data/outputs/Map_rclass_SP200_T1.pdf', density = 300)
# f2 <- image_read_pdf('C:/RProjects/MSP/SpatialDataSynopsis/code/tests/Data/outputs/Map_rclass_SP200_T2.pdf', density = 300)
# img <- c(f1, f2)
# image_append(image_scale(c(image_append(img[c(1,2)], stack = TRUE))))
#########################################################
