library(dplyr) # all-purpose data manipulation (loaded after raster package since both have a select() function)
library(Mar.datawrangling) # required to access RV data
library(lubridate)
library(ggplot2)
library(hrbrthemes)
library(gridExtra)
# Load RV data

# home location
# wd <- "C:/BIO/20200306/GIT/R/MSP"
# setwd(wd)

# on my home directory I have to go up one dir and across to /data/
data.dir <- "C:/RProjects/MSP/data"
get_data('rv', data.dir = data.dir)

speciescode <- 200 # barndoor skate

#------ Set year variables -----------------
# Single date range
yearb <- 1999
yeare <- 2020

#------ END Set year variables -----------------
i <- 1
y <- 1

yearb1 <- yearb[y]
yeare1 <- yeare[y]
# Filter down samples to specific year range, SUMMER, 
GSMISSIONS <- GSMISSIONS[GSMISSIONS$YEAR >= yearb1 & GSMISSIONS$YEAR < yeare1 & GSMISSIONS$SEASON=="SUMMER",]
GSXTYPE <- GSXTYPE[GSXTYPE$XTYPE==1,]
self_filter(keep_nullsets = FALSE,quiet = TRUE) # 659 in GSCAT
GSINF2 <- GSINF # make copy of GSINF to use for a full set of samples
GSSPECIES <- GSSPECIES[GSSPECIES$CODE %in% speciescode[i],] # WORKS
self_filter(keep_nullsets = FALSE,quiet = TRUE)
# Keep only the columns necessary
# ("MISSION" "SETNO" "SDATE" "STRAT" "DIST" "DEPTH" "BOTTOM_TEMPERATURE" "BOTTOM_SALINITY" "LATITUDE" "LONGITUDE")
GSINF2 <- dplyr::select(GSINF2,1:3,5,12,24,30:31,33:34)
# rename some fields
names(GSINF2)[7:8] <- c("BTEMP","BSAL")

# use a merge() to combine MISSION,SETNO with all species to create a presence/absence table
SpecOnly <- dplyr::select(GSSPECIES,3)
# rename 'CODE' to 'SPEC'
names(SpecOnly)[1] <- c("SPEC")

# this merge() creates a full set of all MISSION/SETNO and SPECIES combinations
Combined <- merge(GSINF2,SpecOnly)
GSCAT2 <- dplyr::select(GSCAT,1:3,5:6)

# names(Combined)
# Merge Combined and GSCAT2 on MISSION and SETNO
allCatch <- merge(Combined, GSCAT2, all.x=T, by = c("MISSION", "SETNO", "SPEC"))
# Fill NA records with zero
allCatch$TOTNO[is.na(allCatch$TOTNO)] <- 0
allCatch$TOTWGT[is.na(allCatch$TOTWGT)] <- 0

# ****************************************
glimpse(allCatch)

RV <- allCatch %>%
  mutate(date = ymd(SDATE)) %>% 
  mutate_at(vars(date), funs(year, month, day)) %>%
  select(year, STRAT, SPEC, TOTWGT, LATITUDE, LONGITUDE)

biomass <- RV %>%
            group_by(SPEC,year)%>%
            summarise(tt=sum(TOTWGT,na.rm=T),
            mn=mean(TOTWGT,na.rm=T),
            sd=sd(TOTWGT,na.rm=T)) 

p <- ggplot(biomass, aes(x=year, y=tt)) +
    geom_line(color="#69b3a2", size=1) + 
    xlab("") +
    ylab("Total biomass") +
    theme_ipsum() +
    theme(axis.text.x=element_text(angle=60, hjust=1))

grid.arrange(p, p, ncol = 1)






