

#Species Distribution Models in the Northwest Atlantic Ocean
#By Catalina Gomez, Paul Regular, Amy-Lee Kouwenberg
#Last updated: August 2016

rm(list=ls())
.libPaths("C:/Users/VanderlaanA/Documents/R/win-library/3.2")
#packrat::init()  # -- https://rstudio.github.io/packrat/commands.html # Reads packages needed for plots and analysis
library(plyr)
library(raster)
library(rgdal)
options(java.parameters = "-Xmx1g" )
#system.file('java', package='dismo') #"C:/Users/gomezc/Documents/R/win-library/3.1/dismo/java"
library(dismo)
library(rJava)
library(maptools)
library(RColorBrewer) 
require(maps)
require(sp)
library(lubridate)
library(pracma)
library(EFDR)



sapply(list.files(pattern="[.]R$", path="C:/SDMs_Angelia/Code/scr/_Rfunctions/", full.names=TRUE), source);
SoI<-c("Sei Whale")
season_char<-"Autumn"
biasres<-'1km'
SDM_Maxent_BiasFile(SoI, season_char, biasres)



SoI<-c("Sei Whale")
season_char<-"Autumn"
biasres<-'5km' # I don't think this actually used, but the code needs it to set up the data
SDM_Maxent_NoBiasFile(SoI, season_char, biasres)

SoI<-c("Sei Whale")
season_char<-"Autumn"
biasres<-'5km'
SDM_Maxent_BiasFile(SoI, season_char, biasres)

SoI<-c("Sei Whale")
season_char<-"Autumn"
biasres<-'2.5km'
SDM_Maxent_BiasFile(SoI, season_char, biasres)




SoI<-c("Pilot Whale")
season_char<-"Autumn"
biasres<-'1km'
SDM_Maxent_BiasFile(SoI, season_char, biasres)


SoI<-c("Fin Whale")
season_char<-"Spring"
biasres<-'1km'
SDM_Maxent_BiasFile(SoI, season_char, biasres)


SoI<-c("Harbour Porpoise")
season_char<-"Spring"
biasres<-'1km'
SDM_Maxent_BiasFile(SoI, season_char, biasres)

SoI<-c("Atlantic White-side Dolphin")
season_char<-"Spring"
biasres<-'1km'
SDM_Maxent_BiasFile(SoI, season_char, biasres)

SoI<-c("Humpback Whale")
season_char<-"Spring"
biasres<-'1km'
SDM_Maxent_BiasFile(SoI, season_char, biasres)

SoI<-c("Pilot Whale")
season_char<-"Spring"
biasres<-'1km'
SDM_Maxent_BiasFile(SoI, season_char, biasres)

SoI<-c("White-beaked Dolphin")
season_char<-"Autumn"
biasres<-'1km'
SDM_Maxent_BiasFile(SoI, season_char, biasres)












# 
# SoI<-c("Blue Whale")
# season_char<-"Summer"
# biasres<-'5km' # I don't think this actually used, but the code needs it to set up the data
# SDM_Maxent_NoBiasFile(SoI, season_char, biasres)
# 
# SoI<-c("Blue Whale")
# season_char<-"Summer"
# biasres<-'5km'
# SDM_Maxent_BiasFile(SoI, season_char, biasres)
# 
# SoI<-c("Blue Whale")
# season_char<-"Summer"
# biasres<-'2.5km'
# SDM_Maxent_BiasFile(SoI, season_char, biasres)
# 
# SoI<-c("Blue Whale")
# season_char<-"Summer"
# biasres<-'1km'
# SDM_Maxent_BiasFile(SoI, season_char, biasres)
#############################################################################################
# SoI<-c("Humpback Whale")
# season_char<-"Summer"
# biasres<-'5km' # I don't think this actually used, but the code needs it to set up the data
# SDM_Maxent_NoBiasFile(SoI, season_char, biasres)

# SoI<-c("Humpback Whale")
# season_char<-"Summer"
# biasres<-'5km'
# SDM_Maxent_BiasFile(SoI, season_char, biasres)

# SoI<-c("Humpback Whale")
# season_char<-"Summer"
# biasres<-'2.5km'
# SDM_Maxent_BiasFile(SoI, season_char, biasres)

# SoI<-c("Humpback Whale")
# season_char<-"Summer"
# biasres<-'1km'
# SDM_Maxent_BiasFile(SoI, season_char, biasres)

# #############################################################################################

# SoI<-c("Minke Whale")
# season_char<-"Summer"
# biasres<-'5km' # I don't think this actually used, but the code needs it to set up the data
# SDM_Maxent_NoBiasFile(SoI, season_char, biasres)

# SoI<-c("Minke Whale")
# season_char<-"Summer"
# biasres<-'5km'
# SDM_Maxent_BiasFile(SoI, season_char, biasres)

# SoI<-c("Minke Whale")
# season_char<-"Summer"
# biasres<-'2.5km'
# SDM_Maxent_BiasFile(SoI, season_char, biasres)

# SoI<-c("Minke Whale")
# season_char<-"Summer"
# biasres<-'1km'
# SDM_Maxent_BiasFile(SoI, season_char, biasres)

# #############################################################################################

# SoI<-c("Sei Whale")
# season_char<-"Summer"
# biasres<-'5km' # I don't think this actually used, but the code needs it to set up the data
# SDM_Maxent_NoBiasFile(SoI, season_char, biasres)

# SoI<-c("Sei Whale")
# season_char<-"Summer"
# biasres<-'5km'
# SDM_Maxent_BiasFile(SoI, season_char, biasres)

# SoI<-c("Sei Whale")
# season_char<-"Summer"
# biasres<-'2.5km'
# SDM_Maxent_BiasFile(SoI, season_char, biasres)

# SoI<-c("Sei Whale")
# season_char<-"Summer"
# biasres<-'1km'
# SDM_Maxent_BiasFile(SoI, season_char, biasres)
# #############################################################################################

# SoI<-c("Sperm Whale")
# season_char<-"Summer"
# biasres<-'5km' # I don't think this actually used, but the code needs it to set up the data
# SDM_Maxent_NoBiasFile(SoI, season_char, biasres)

# SoI<-c("Sperm Whale")
# season_char<-"Summer"
# biasres<-'5km'
# SDM_Maxent_BiasFile(SoI, season_char, biasres)

# SoI<-c("Sperm Whale")
# season_char<-"Summer"
# biasres<-'2.5km'
# SDM_Maxent_BiasFile(SoI, season_char, biasres)

# SoI<-c("Sperm Whale")
# season_char<-"Summer"
# biasres<-'1km'
# SDM_Maxent_BiasFile(SoI, season_char, biasres)

# #############################################################################################


# SoI<-c("North Atlantic Right Whale")
# season_char<-"Summer"
# biasres<-'5km' # I don't think this actually used, but the code needs it to set up the data
# SDM_Maxent_NoBiasFile(SoI, season_char, biasres)
# 
# SoI<-c("North Atlantic Right Whale")
# season_char<-"Summer"
# biasres<-'5km'
# SDM_Maxent_BiasFile(SoI, season_char, biasres)
# 
# SoI<-c("North Atlantic Right Whale")
# season_char<-"Summer"
# biasres<-'2.5km'
# SDM_Maxent_BiasFile(SoI, season_char, biasres)
# 
# SoI<-c("North Atlantic Right Whale")
# season_char<-"Summer"
# biasres<-'1km'
# SDM_Maxent_BiasFile(SoI, season_char, biasres)
# 
# #############################################################################################



# SoI<-c("Northern Bottlenose Whale")
# season_char<-"Summer"
# biasres<-'5km' # I don't think this actually used, but the code needs it to set up the data
# SDM_Maxent_NoBiasFile(SoI, season_char, biasres)

# SoI<-c("Northern Bottlenose Whale")
# season_char<-"Summer"
# biasres<-'5km'
# SDM_Maxent_BiasFile(SoI, season_char, biasres)

# SoI<-c("Northern Bottlenose Whale")
# season_char<-"Summer"
# biasres<-'2.5km'
# SDM_Maxent_BiasFile(SoI, season_char, biasres)

# SoI<-c("Northern Bottlenose Whale")
# season_char<-"Summer"
# biasres<-'1km'
# SDM_Maxent_BiasFile(SoI, season_char, biasres)

# #############################################################################################


# SoI<-c("Atlantic White-sided Dolphin")
# season_char<-"Summer"
# biasres<-'5km' # I don't think this actually used, but the code needs it to set up the data
# SDM_Maxent_NoBiasFile(SoI, season_char, biasres)

# SoI<-c("Atlantic White-sided Dolphin")
# season_char<-"Summer"
# biasres<-'5km'
# SDM_Maxent_BiasFile(SoI, season_char, biasres)

# SoI<-c("Atlantic White-sided Dolphin")
# season_char<-"Summer"
# biasres<-'2.5km'
# SDM_Maxent_BiasFile(SoI, season_char, biasres)

# SoI<-c("Atlantic White-sided Dolphin")
# season_char<-"Summer"
# biasres<-'1km'
# SDM_Maxent_BiasFile(SoI, season_char, biasres)


# #############################################################################################

# SoI<-c("Bottlenose Dolphin")
# season_char<-"Summer"
# biasres<-'5km' # I don't think this actually used, but the code needs it to set up the data
# SDM_Maxent_NoBiasFile(SoI, season_char, biasres)

# SoI<-c("Bottlenose Dolphin")
# season_char<-"Summer"
# biasres<-'5km'
# SDM_Maxent_BiasFile(SoI, season_char, biasres)

# SoI<-c("Bottlenose Dolphin")
# season_char<-"Summer"
# biasres<-'2.5km'
# SDM_Maxent_BiasFile(SoI, season_char, biasres)

# SoI<-c("Bottlenose Dolphin")
# season_char<-"Summer"
# biasres<-'1km'
# SDM_Maxent_BiasFile(SoI, season_char, biasres)
# # 
# # #############################################################################################
# 
# SoI<-c("Common Dolphin")
# season_char<-"Summer"
# biasres<-'5km' # I don't think this actually used, but the code needs it to set up the data
# SDM_Maxent_NoBiasFile(SoI, season_char, biasres)
# 
# SoI<-c("Common Dolphin")
# season_char<-"Summer"
# biasres<-'5km'
# SDM_Maxent_BiasFile(SoI, season_char, biasres)
# 
# SoI<-c("Common Dolphin")
# season_char<-"Summer"
# biasres<-'2.5km'
# SDM_Maxent_BiasFile(SoI, season_char, biasres)
# 
# SoI<-c("Common Dolphin")
# season_char<-"Summer"
# biasres<-'1km'
# SDM_Maxent_BiasFile(SoI, season_char, biasres)

# #############################################################################################
# 
# SoI<-c("Harbour Porpoise")
# season_char<-"Summer"
# biasres<-'5km' # I don't think this actually used, but the code needs it to set up the data
# SDM_Maxent_NoBiasFile(SoI, season_char, biasres)
# 
# SoI<-c("Harbour Porpoise")
# season_char<-"Summer"
# biasres<-'5km'
# SDM_Maxent_BiasFile(SoI, season_char, biasres)
# 
# SoI<-c("Harbour Porpoise")
# season_char<-"Summer"
# biasres<-'2.5km'
# SDM_Maxent_BiasFile(SoI, season_char, biasres)
# 
# SoI<-c("Harbour Porpoise")
# season_char<-"Summer"
# biasres<-'1km'
# SDM_Maxent_BiasFile(SoI, season_char, biasres)
# 
# # #############################################################################################
# 
# SoI<-c("Killer Whale")
# season_char<-"Summer"
# biasres<-'5km' # I don't think this actually used, but the code needs it to set up the data
# SDM_Maxent_NoBiasFile(SoI, season_char, biasres)
# 
# SoI<-c("Killer Whale")
# season_char<-"Summer"
# biasres<-'5km'
# SDM_Maxent_BiasFile(SoI, season_char, biasres)
# 
# SoI<-c("Killer Whale")
# season_char<-"Summer"
# biasres<-'2.5km'
# SDM_Maxent_BiasFile(SoI, season_char, biasres)
# 
# SoI<-c("Killer Whale")
# season_char<-"Summer"
# biasres<-'1km'
# SDM_Maxent_BiasFile(SoI, season_char, biasres)
# 
# #############################################################################################
# 
# SoI<-c("Pilot Whale")
# season_char<-"Summer"
# biasres<-'5km' # I don't think this actually used, but the code needs it to set up the data
# SDM_Maxent_NoBiasFile(SoI, season_char, biasres)
# 
# SoI<-c("Pilot Whale")
# season_char<-"Summer"
# biasres<-'5km'
# SDM_Maxent_BiasFile(SoI, season_char, biasres)
# 
# SoI<-c("Pilot Whale")
# season_char<-"Summer"
# biasres<-'2.5km'
# SDM_Maxent_BiasFile(SoI, season_char, biasres)
# 
# SoI<-c("Pilot Whale")
# season_char<-"Summer"
# biasres<-'1km'
# SDM_Maxent_BiasFile(SoI, season_char, biasres)
# #############################################################################################
# 
# SoI<-c("White-beaked Dolphin")
# season_char<-"Summer"
# biasres<-'5km' # I don't think this actually used, but the code needs it to set up the data
# SDM_Maxent_NoBiasFile(SoI, season_char, biasres)
# 
# SoI<-c("White-beaked Dolphin")
# season_char<-"Summer"
# biasres<-'5km'
# SDM_Maxent_BiasFile(SoI, season_char, biasres)
# 
# SoI<-c("White-beaked Dolphin")
# season_char<-"Summer"
# biasres<-'2.5km'
# SDM_Maxent_BiasFile(SoI, season_char, biasres)
# 
# SoI<-c("White-beaked Dolphin")
# season_char<-"Summer"
# biasres<-'1km'
# SDM_Maxent_BiasFile(SoI, season_char, biasres)
# #############################################################################################
# 
SoI<-c("Fin Whale")
season_char<-"Autumn"
biasres<-'5km' # I don't think this actually used, but the code needs it to set up the data
SDM_Maxent_NoBiasFile(SoI, season_char, biasres)

SoI<-c("Fin Whale")
season_char<-"Autumn"
biasres<-'5km'
SDM_Maxent_BiasFile(SoI, season_char, biasres)

SoI<-c("Fin Whale")
season_char<-"Autumn"
biasres<-'2.5km'
SDM_Maxent_BiasFile(SoI, season_char, biasres)

SoI<-c("Fin Whale")
season_char<-"Autumn"
biasres<-'1km'
SDM_Maxent_BiasFile(SoI, season_char, biasres)
# 
# #############################################################################################

# SoI<-c("Fin Whale")
# season_char<-"Spring"
# biasres<-'5km' # I don't think this actually used, but the code needs it to set up the data
# SDM_Maxent_NoBiasFile(SoI, season_char, biasres)

# SoI<-c("Fin Whale")
# season_char<-"Spring"
# biasres<-'5km'
# SDM_Maxent_BiasFile(SoI, season_char, biasres)

# SoI<-c("Fin Whale")
# season_char<-"Spring"
# biasres<-'2.5km'
# SDM_Maxent_BiasFile(SoI, season_char, biasres)

# SoI<-c("Fin Whale")
# season_char<-"Sring"
# biasres<-'1km'
# SDM_Maxent_BiasFile(SoI, season_char, biasres)
# #############################################################################################


# SoI<-c("Atlantic White-side Dolphin")
# season_char<-"Spring"
# biasres<-'5km' # I don't think this actually used, but the code needs it to set up the data
# SDM_Maxent_NoBiasFile(SoI, season_char, biasres)

# SoI<-c("Atlantic White-side Dolphin")
# season_char<-"Spring"
# biasres<-'5km'
# SDM_Maxent_BiasFile(SoI, season_char, biasres)

# SoI<-c("Atlantic White-side Dolphin")
# season_char<-"Spring"
# biasres<-'2.5km'
# SDM_Maxent_BiasFile(SoI, season_char, biasres)

# SoI<-c("Atlantic White-side Dolphin")
# season_char<-"Spring"
# biasres<-'1km'
# SDM_Maxent_BiasFile(SoI, season_char, biasres)


#############################################################################################


SoI<-c("Atlantic White-side Dolphin")
season_char<-"Autumn"
biasres<-'5km' # I don't think this actually used, but the code needs it to set up the data
SDM_Maxent_NoBiasFile(SoI, season_char, biasres)

SoI<-c("Atlantic White-side Dolphin")
season_char<-"Autumn"
biasres<-'5km'
SDM_Maxent_BiasFile(SoI, season_char, biasres)

SoI<-c("Atlantic White-side Dolphin")
season_char<-"Autumn"
biasres<-'2.5km'
SDM_Maxent_BiasFile(SoI, season_char, biasres)

SoI<-c("Atlantic White-side Dolphin")
season_char<-"Autumn"
biasres<-'1km'
SDM_Maxent_BiasFile(SoI, season_char, biasres)

# #############################################################################################

SoI<-c("Common Dolphin")
season_char<-"Autumn"
biasres<-'5km' # I don't think this actually used, but the code needs it to set up the data
SDM_Maxent_NoBiasFile(SoI, season_char, biasres)

SoI<-c("Common Dolphin")
season_char<-"Autumn"
biasres<-'5km'
SDM_Maxent_BiasFile(SoI, season_char, biasres)

SoI<-c("Common Dolphin")
season_char<-"Autumn"
biasres<-'2.5km'
SDM_Maxent_BiasFile(SoI, season_char, biasres)

SoI<-c("Common Dolphin")
season_char<-"Autumn"
biasres<-'1km'
SDM_Maxent_BiasFile(SoI, season_char, biasres)
# #############################################################################################

# SoI<-c("Harbour Porpoise")
# season_char<-"Spring"
# biasres<-'5km' # I don't think this actually used, but the code needs it to set up the data
# SDM_Maxent_NoBiasFile(SoI, season_char, biasres)

# SoI<-c("Harbour Porpoise")
# season_char<-"Spring"
# biasres<-'5km'
# SDM_Maxent_BiasFile(SoI, season_char, biasres)

# SoI<-c("Harbour Porpoise")
# season_char<-"Spring"
# biasres<-'2.5km'
# SDM_Maxent_BiasFile(SoI, season_char, biasres)

# SoI<-c("Harbour Porpoise")
# season_char<-"Spring"
# biasres<-'1km'
# SDM_Maxent_BiasFile(SoI, season_char, biasres)

# #############################################################################################

# SoI<-c("Harbour Porpoise")
# season_char<-"Autumn"
# biasres<-'5km' # I don't think this actually used, but the code needs it to set up the data
# SDM_Maxent_NoBiasFile(SoI, season_char, biasres)
# 
# SoI<-c("Harbour Porpoise")
# season_char<-"Autumn"
# biasres<-'5km'
# SDM_Maxent_BiasFile(SoI, season_char, biasres)
# 
# SoI<-c("Harbour Porpoise")
# season_char<-"Autumn"
# biasres<-'2.5km'
# SDM_Maxent_BiasFile(SoI, season_char, biasres)
# 
# SoI<-c("Harbour Porpoise")
# season_char<-"Autumn"
# biasres<-'1km'
# SDM_Maxent_BiasFile(SoI, season_char, biasres)
# 
# #############################################################################################
# SoI<-c("Humpback Whale")
# season_char<-"Spring"
# biasres<-'5km' # I don't think this actually used, but the code needs it to set up the data
# SDM_Maxent_NoBiasFile(SoI, season_char, biasres)

# SoI<-c("Humpback Whale")
# season_char<-"Spring"
# biasres<-'5km'
# SDM_Maxent_BiasFile(SoI, season_char, biasres)

# SoI<-c("Humpback Whale")
# season_char<-"Spring"
# biasres<-'2.5km'
# SDM_Maxent_BiasFile(SoI, season_char, biasres)

# SoI<-c("Humpback Whale")
# season_char<-"Spring"
# biasres<-'1km'
# SDM_Maxent_BiasFile(SoI, season_char, biasres)
# 
# #############################################################################################
# #############################################################################################
# SoI<-c("Humpback Whale")
# season_char<-"Autumn"
# biasres<-'5km' # I don't think this actually used, but the code needs it to set up the data
# SDM_Maxent_NoBiasFile(SoI, season_char, biasres)
# 
# SoI<-c("Humpback Whale")
# season_char<-"Autumn"
# biasres<-'5km'
# SDM_Maxent_BiasFile(SoI, season_char, biasres)
# 
# SoI<-c("Humpback Whale")
# season_char<-"Autumn"
# biasres<-'2.5km'
# SDM_Maxent_BiasFile(SoI, season_char, biasres)
# 
# SoI<-c("Humpback Whale")
# season_char<-"Autumn"
# biasres<-'1km'
# SDM_Maxent_BiasFile(SoI, season_char, biasres)
# 
# #############################################################################################
# #############################################################################################
# 
SoI<-c("Minke Whale")
season_char<-"Spring"
biasres<-'5km' # I don't think this actually used, but the code needs it to set up the data
SDM_Maxent_NoBiasFile(SoI, season_char, biasres)

SoI<-c("Minke Whale")
season_char<-"Spring"
biasres<-'5km'
SDM_Maxent_BiasFile(SoI, season_char, biasres)

SoI<-c("Minke Whale")
season_char<-"Spring"
biasres<-'2.5km'
SDM_Maxent_BiasFile(SoI, season_char, biasres)

SoI<-c("Minke Whale")
season_char<-"Spring"
biasres<-'1km'
SDM_Maxent_BiasFile(SoI, season_char, biasres)
# #############################################################################################

SoI<-c("Minke Whale")
season_char<-"Autumn"
biasres<-'5km' # I don't think this actually used, but the code needs it to set up the data
SDM_Maxent_NoBiasFile(SoI, season_char, biasres)

SoI<-c("Minke Whale")
season_char<-"Autumn"
biasres<-'5km'
SDM_Maxent_BiasFile(SoI, season_char, biasres)

SoI<-c("Minke Whale")
season_char<-"Autumn"
biasres<-'2.5km'
SDM_Maxent_BiasFile(SoI, season_char, biasres)

SoI<-c("Minke Whale")
season_char<-"Autumn"
biasres<-'1km'
SDM_Maxent_BiasFile(SoI, season_char, biasres)
#############################################################################################

# SoI<-c("Pilot Whale")
# season_char<-"Spring"
# biasres<-'5km' # I don't think this actually used, but the code needs it to set up the data
# SDM_Maxent_NoBiasFile(SoI, season_char, biasres)

# SoI<-c("Pilot Whale")
# season_char<-"Spring"
# biasres<-'5km'
# SDM_Maxent_BiasFile(SoI, season_char, biasres)

# SoI<-c("Pilot Whale")
# season_char<-"Spring"
# biasres<-'2.5km'
# SDM_Maxent_BiasFile(SoI, season_char, biasres)

# SoI<-c("Pilot Whale")
# season_char<-"Spring"
# biasres<-'1km'
# SDM_Maxent_BiasFile(SoI, season_char, biasres)
# #############################################################################################

# SoI<-c("Pilot Whale")
# season_char<-"Autumn"
# biasres<-'5km' # I don't think this actually used, but the code needs it to set up the data
# SDM_Maxent_NoBiasFile(SoI, season_char, biasres)

# SoI<-c("Pilot Whale")
# season_char<-"Autumn"
# biasres<-'5km'
# SDM_Maxent_BiasFile(SoI, season_char, biasres)

# SoI<-c("Pilot Whale")
# season_char<-"Autumn"
# biasres<-'2.5km'
# SDM_Maxent_BiasFile(SoI, season_char, biasres)

SoI<-c("Pilot Whale")
season_char<-"Autumn"
biasres<-'1km'
SDM_Maxent_BiasFile(SoI, season_char, biasres)

# #################################################################################

 SoI<-c("Pilot Whale")
 season_char<-"Summer"
 biasres<-'5km' # I don't think this actually used, but the code needs it to set up the data
 SDM_Maxent_NoBiasFile(SoI, season_char, biasres)

 SoI<-c("Pilot Whale")
 season_char<-"Summer"
 biasres<-'5km'
 SDM_Maxent_BiasFile(SoI, season_char, biasres)

 SoI<-c("Pilot Whale")
 season_char<-"Summer"
 biasres<-'2.5km'
 SDM_Maxent_BiasFile(SoI, season_char, biasres)

 SoI<-c("Pilot Whale")
 season_char<-"Summer"
 biasres<-'1km'
 SDM_Maxent_BiasFile(SoI, season_char, biasres)

 #################################################################################

 SoI<-c("Killer Whale")
 season_char<-"Summer"
 biasres<-'5km'
 SDM_Maxent_BiasFile(SoI, season_char, biasres)
 
 SoI<-c("Killer Whale")
 season_char<-"Summer"
 biasres<-'2.5km'
 SDM_Maxent_BiasFile(SoI, season_char, biasres)
 
 SoI<-c("Killer Whale")
 season_char<-"Summer"
 biasres<-'1km'
 SDM_Maxent_BiasFile(SoI, season_char, biasres)
 
 SoI<-c("Killer Whale")
 season_char<-"Summer"
 biasres<-'5km' # I don't think this actually used, but the code needs it to set up the data
 SDM_Maxent_NoBiasFile(SoI, season_char, biasres)
 
 
# ####################################################

# SoI<-c("Sei Whale")
# season_char<-"Autumn"
# biasres<-'5km' # I don't think this actually used, but the code needs it to set up the data
# SDM_Maxent_NoBiasFile(SoI, season_char, biasres)

# SoI<-c("Sei Whale")
# season_char<-"Autumn"
# biasres<-'5km'
# SDM_Maxent_BiasFile(SoI, season_char, biasres)

# SoI<-c("Sei Whale")
# season_char<-"Autumn"
# biasres<-'2.5km'
# SDM_Maxent_BiasFile(SoI, season_char, biasres)

# SoI<-c("Sei Whale")
# season_char<-"Autumn"
# biasres<-'1km'
# SDM_Maxent_BiasFile(SoI, season_char, biasres)
# #############################################################################################

# SoI<-c("Sperm Whale")
# season_char<-"Autumn"
# biasres<-'5km' # I don't think this actually used, but the code needs it to set up the data
# SDM_Maxent_NoBiasFile(SoI, season_char, biasres)

# SoI<-c("Sperm Whale")
# season_char<-"Autumn"
# biasres<-'5km'
# SDM_Maxent_BiasFile(SoI, season_char, biasres)

# SoI<-c("Sperm Whale")
# season_char<-"Autumn"
# biasres<-'2.5km'
# SDM_Maxent_BiasFile(SoI, season_char, biasres)

# SoI<-c("Sperm Whale")
# season_char<-"Autumn"
# biasres<-'1km'
# SDM_Maxent_BiasFile(SoI, season_char, biasres)

# #############################################################################################
# #############################################################################################

# SoI<-c("White-beaked Dolphin")
# season_char<-"Autumn"
# biasres<-'5km' # I don't think this actually used, but the code needs it to set up the data
# SDM_Maxent_NoBiasFile(SoI, season_char, biasres)

# SoI<-c("White-beaked Dolphin")
# season_char<-"Autumn"
# biasres<-'5km'
# SDM_Maxent_BiasFile(SoI, season_char, biasres)

# SoI<-c("White-beaked Dolphin")
# season_char<-"Autumn"
# biasres<-'2.5km'
# SDM_Maxent_BiasFile(SoI, season_char, biasres)

# SoI<-c("White-beaked Dolphin")
# season_char<-"Autumn"
# biasres<-'1km'
# SDM_Maxent_BiasFile(SoI, season_char, biasres)
# ############################################################

# #############################################################################################

# SoI<-c("White-beaked Dolphin")
# season_char<-"Summer"
# biasres<-'5km' # I don't think this actually used, but the code needs it to set up the data
# SDM_Maxent_NoBiasFile(SoI, season_char, biasres)

# SoI<-c("White-beaked Dolphin")
# season_char<-"Summer"
# biasres<-'5km'
# SDM_Maxent_BiasFile(SoI, season_char, biasres)

# SoI<-c("White-beaked Dolphin")
# season_char<-"Summer"
# biasres<-'2.5km'
# SDM_Maxent_BiasFile(SoI, season_char, biasres)

# SoI<-c("White-beaked Dolphin")
# season_char<-"summer"
# biasres<-'1km'
# SDM_Maxent_BiasFile(SoI, season_char, biasres)
# ############################################################