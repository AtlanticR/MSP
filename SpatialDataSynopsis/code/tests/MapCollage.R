library(magick)
library(pdftools)

speciesNumber <- "SP200"
  
  # pdf file have species name/code included
MapCollage <- function(speciesNumber) {

  # directory where the pdf images are
  inDir <- "C:/RProjects/MSP/SpatialDataSynopsis/code/tests/Data/outputs/"
  
  # list all pdf files in that folder
  fl=list.files(inDir,pattern=".pdf",full.names = T)
  
  # select species
  fl=fl[grep(speciesNumber,fl)]
  
  # read all pdfs to a list 
  iml=lapply(fl,image_read_pdf)
  
  # group images: this will depend on the file names chosen for pdf files
  rclass=c(iml[[grep("rclass_T1",fl)]],iml[[grep("rclass_T2",fl)]],iml[[grep("rclass_T3",fl)]],iml[[grep("rclass_T4",fl)]])
  hexsum=c(iml[[grep("hexsum_T1",fl)]],iml[[grep("hexsum_T2",fl)]],iml[[grep("hexsum_T3",fl)]],iml[[grep("hexsum_T4",fl)]])
  periods=c("2004-2008","2005-2008","2009-2013","2014-2019")
  
  # image append
  rclass=image_annotate(rclass,periods,size=120, weight = 700, gravity = "NorthWest", location="+100+100")
  col1=image_append(image_scale(rclass, "x200"), stack = TRUE)
  col2=image_append(image_scale(hexsum, "x200"), stack = TRUE)
  image_append(c(col1,col2))
  #image_append(image_scale(rclass, "x200"), stack = TRUE)
  #image_append(image_scale(hexsum, "x200"), stack = TRUE)
 }

#MapCollage("SP200")
  