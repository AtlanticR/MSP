# Code built by Gordana Lazin and mildly edited by Catalina Gomez
library(magick)
library(pdftools)

  # pdf file have species name/code included
MapCollage <- function(speciesNumber) {

  # directory where the pdf images are
  inDir <- "C:/RProjects/MSP/SpatialDataSynopsis/Output/"
  
  # list all pdf files in that folder
  fl=list.files(inDir,pattern=".pdf",full.names = T)
  
  # select species
  fl=fl[grep(speciesNumber,fl)]
  
  # read all pdfs to a list 
  iml=lapply(fl,image_read_pdf, density = 300)
  
  # group images: this will depend on the file names chosen for pdf files
  rclass=c(iml[[grep("T1_IDW",fl)]],iml[[grep("T2_IDW",fl)]],iml[[grep("T3_IDW",fl)]],iml[[grep("T4_IDW",fl)]])
  hexsum=c(iml[[grep("T1_HEXAVG",fl)]],iml[[grep("T2_HEXAVG",fl)]],iml[[grep("T3_HEXAVG",fl)]],iml[[grep("T4_HEXAVG",fl)]])
  periods=c("2004-2008","2005-2008","2009-2013","2014-2019")
  
  # image append
  rclass=image_annotate(rclass,periods,size=120, weight = 700, gravity = "NorthWest", location="+100+100")
  col1=image_append(image_scale(rclass), stack = TRUE)
  col2=image_append(image_scale(hexsum), stack = TRUE)
  #(image_scale(rclass, "x200"),#use "x200" for small output in the console
  image_append(c(col1,col2))
  }

#Example on how to sue function: 
#MapCollage("SP200")

#######################################################
#Uncomment this section if you would like to understand some of the argemnts used here or 
#if you want to troblehoot this function
#speciesNumber <- "SP200" # to troublehoot this function
#f1 <- image_read_pdf('C:/RProjects/MSP/SpatialDataSynopsis/code/tests/Data/outputs/Map_rclass_SP200_T1.pdf', density = 300)
# f2 <- image_read_pdf('C:/RProjects/MSP/SpatialDataSynopsis/code/tests/Data/outputs/Map_rclass_SP200_T2.pdf', density = 300)
# img <- c(f1, f2)
# image_append(image_scale(c(image_append(img[c(1,2)], stack = TRUE))))
#########################################################
  