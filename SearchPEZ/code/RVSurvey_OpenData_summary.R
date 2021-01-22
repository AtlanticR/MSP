library(tidyverse)
library(Mar.utils)

data.dir = "../../../Data/mar.wrangling/RVSurvey_OpenData"

#Provide survey prefix ("FALL_2020", "SPRING_2020", "4VSW_2020")

SurveyPrefix<-"FALL_2020"

#Load necessary csv files
GSCAT<-read.csv(file.path(data.dir, paste(SurveyPrefix, "_GSCAT.csv", sep = "", collapse = NULL)))
GSINF<-read.csv(file.path(data.dir, paste(SurveyPrefix, "_GSINF.csv", sep = "", collapse = NULL)))
GSSPECIES<-read.csv(file.path(data.dir, paste(SurveyPrefix, "_GSSPECIES.csv", sep = "", collapse = NULL)))

#Get shapefiles#
df_to_shp(df= GSINF, file = SurveyPrefix, lat.field = "SLAT",lon.field = "SLONG")

#Change to tibbles#
GSCAT_tib<-as_tibble(GSCAT)
GSINF_tib<-as_tibble(GSINF)
GSSPECIES_tib<-as_tibble(GSSPECIES)

#Change column names#
GSSPECIES_tib<-GSSPECIES_tib %>% 
  rename(
    SPEC.GSSPECIES = SPEC,
    SPEC.CODE = CODE)
GSCAT_tib <- GSCAT_tib %>%
  rename(
    SPEC.CODE = SPEC)

#Create new df with desired columns#
GSCAT_tib$SPEC.CODE
my_data<-select(GSCAT_tib, MISSION, SETNO, SPEC.CODE, TOTNO)
head(my_data)
my_data2<-left_join(my_data,GSSPECIES_tib,by="SPEC.CODE")
my_data2<-select(my_data2,-TSN)
my_data3<-my_data2 %>% 
  unite("MISSION_SET", MISSION:SETNO, remove = FALSE)
GS_INF_unite<-GSINF_tib %>% 
  unite("MISSION_SET", MISSION:SETNO, remove = FALSE)
my_data4<-left_join(my_data3,GS_INF_unite,by="MISSION_SET")
my_data5<-select(my_data4, MISSION_SET, SDATE, SLAT, SLONG, ELAT, ELONG, SPEC.CODE, TOTNO, SPEC.CODE, SPEC.GSSPECIES, COMM, TOTNO)
my_data6<-my_data5 %>%
  separate("MISSION_SET", c("MISSION", "SETNO"))
write.csv(my_data6, file = file.path(data.dir, paste(SurveyPrefix, "_summary.csv", sep = "", collapse = NULL)))

          