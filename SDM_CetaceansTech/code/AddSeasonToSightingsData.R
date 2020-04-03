sightings <- read.csv("C:/Users/KONRADC/Desktop/SDMs_Angelia/Data/CetaceanData/Correct_data/MarMammSightings.csv")

sightings$Season <- ""

winter <- which(sightings$Month == 12 | sightings$Month == 1 | sightings$Month == 2)
spring <- which(sightings$Month == 3 | sightings$Month == 4 | sightings$Month == 5)
summer <- which(sightings$Month == 6 | sightings$Month == 7 | sightings$Month == 8)
fall <- which(sightings$Month == 9 | sightings$Month == 10 | sightings$Month == 11)

sightings$Season[winter] <- "winter"
sightings$Season[spring] <- "spring"
sightings$Season[summer] <- "summer"
sightings$Season[fall] <- "fall"

sightings[which(sightings$Season == ""),]  # check if any rows are missing season

write.csv(sightings, "C:/Users/KONRADC/Desktop/SDMs_Angelia/Data/CetaceanData/Correct_data/MarMammSightings_withSeason.csv", row.names = F)
