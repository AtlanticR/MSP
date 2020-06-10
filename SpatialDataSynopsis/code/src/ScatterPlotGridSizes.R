data <- read.csv("./SpatialDataSynopsis/Output/GridCellSizeStats.csv")
plot(data$GridSize,data$AvgPerSqKm,
     xlab="Grid cell area (sq km)",
     ylab="Average Biomass /sq km",
     pch = 21,
     col="red",
     bg = "red")


plot(data$GridSize,data$SD,
     xlab="Grid cell area (sq km)",
     ylab="Standard deviation",
     pch = 21,
     col="blue",
     bg = "blue")