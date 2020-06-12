data <- read.csv("./SpatialDataSynopsis/Output/GridCellSizeStats.csv")
data2 <- read.csv("./SpatialDataSynopsis/Output/GridCellSizeAllData.csv")

data <- data[order(data$GridSize),]


plot(data$GridSize,data$AvgPerSqKm,
     xlab="Grid cell area (sq km)",
     ylab="Average Biomass /sq km",
     pch = 21,
     col="red",
     bg = "red")

# This is the same as above but pch = 16
# doesn't have an exterior boundary
# 1. Open jpeg file
jpeg("./SpatialDataSynopsis/Output/AvgPerSqKm.jpg", width = 350, height = 350)

plot(data2$GridSize, data2$AvgPerSqKm,
     xlab="Grid cell area (sq km)",
     ylab="Average Biomass /sq km",
     pch = 16,
     col = "blue",
     log = "y")
par(new = TRUE)
plot(data$GridSize,data$AvgPerSqKm,
     type = "b",
     pch = 16,
     col="red",
     log = "y",
     xlab="", ylab="")
dev.off()

jpeg("./SpatialDataSynopsis/Output/SD.jpg", width = 350, height = 350)
plot(data$GridSize,data$SD,
     xlab="Grid cell area (sq km)",
     ylab="Standard deviation",
     pch = 21,
     col="blue",
     bg = "blue")
dev.off()

jpeg("./SpatialDataSynopsis/Output/CV.jpg", width = 350, height = 350)
plot(data$GridSize,data$CV,
     xlab="Grid cell area (sq km)",
     ylab="Coefficient of variation",
     pch = 21,
     col="blue",
     bg = "blue", 
     log = "y")
dev.off()

# graphical parameters 
# https://www.statmethods.net/advgraphs/parameters.html
# https://www.datanovia.com/en/blog/pch-in-r-best-tips/

plot(data$GridSize,data$AvgPerSqKm,
     
     pch = 16,
     col="red",
     log = "y",
     axes=TRUE,
     xlab="", ylab="")