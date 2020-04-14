library(plyr)
MarMamm <- read.csv("data/MarMammSightings_withSeason.csv", header=TRUE, na.strings = "NA", sep=",", as.is=T, strip.white=T)
MarMamm_FGP <- MarMamm[,c('Species', 'Longitude', 'Latitude', 'ID_cgs')]
names(MarMamm_FGP)[names(MarMamm_FGP) == "ID_cgs"] <- "ID"

MarMamm_FGP$ID <- mapvalues(MarMamm_FGP$ID, 
                            from = c("Maritimes_Hilary"), 
                            to = c("DFO_Maritimes"))  

MarMamm_FGP <- MarMamm_FGP[MarMamm_FGP$Species %in% 
                             c('Blue Whale', 'Fin Whale', 'Sei Whale', 'Minke Whale',
                               'Humpback Whale', "Sowerby's Beaked Whale", 'Killer Whale', 'Pilot Whale',
                               'Atlantic White-sided Dolphin', 'Bottlenose Dolphin', 'Common Dolphin', 
                               "Risso's Dolphin", 'Striped Dolphin', 'White-beaked Dolphin',
                               'Harbour Porpoise'), ]


write.csv(MarMamm_FGP, "data/MarMamm_FGP.csv", row.names=FALSE)
