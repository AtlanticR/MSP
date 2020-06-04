# Some test bits of code for the NephinMap_grd.r script.
# I need to extract bits of the name to create a better title using substr()

###- TEST -#####################################--

# Take just 2 of the stacks in the list()RasName = substr(SpatialOutputFiles[i],1,nchar(SpatialOutputFiles[i])-4)
RasName = substr(SpatialOutputFiles[i],1,nchar(SpatialOutputFiles[i])-4)
substr(Title1, LastN, nchar(Title1)) # Extract last three characters
substr(Title1, LastN + 1, nchar(Title1)) # Extract last three characters
substr(Title1, -(LastN + 1), nchar(Title1)) # Extract last three characters
LastN <- nchar(Title1) - ((nchar(Title1) - 12)+1)


# Use just2 of the stack in the list
SpatialOutputList <- SpatialOutputList[c(1,2)]





for(i in 1:length(SpatialOutputList)) {
  print(paste("Loop ",i,nlayers(SpatialOutputList[[i]]), names(SpatialOutputList[i]),sep = " "))
  RasStack <- stack(SpatialOutputList[i])
  for (y in 1:nlayers(RasStack)) {
    Raster1 <- RasStack[[y]]
    print(names(Raster1))
  }
}

###- END TEST -#####################################--