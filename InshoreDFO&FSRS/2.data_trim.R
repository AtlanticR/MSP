data <- read.csv("data/fs7010_20191028_1430.csv")
data <- data[,c("LATITUDE", "LONGITUDE", "YEAR", "FISHSET_ID", "SET_NO", "COMAREA_ID","NAFAREA_ID",
                "EST_CATCH", "EST_NUM_CAUGHT", "S_EST_NUM_CAUGHT", "S_EST_KEPT_WT",
                "GEAR", "DESCRIPTION", "COMMON",
                "DATE_TIME2", 
                "DEP1", "VESS_SPD1", "WAT_TMP1")]
data <- write.csv(data, "data/fs7010_20191028_1430_trim.csv", row.names=FALSE)

# library(dplyr)
# 
# data1 <- data %>%
#         filter(COMMON %in% c("AMERICAN LOBSTER","CUSK"))%>%
#         group_by(COMMON,NAFAREA_ID)%>%
#         summarise(mean=mean(EST_NUM_CAUGHT,na.rm=T)) 
# 
# 
# head(data1)
