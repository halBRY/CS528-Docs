library(dplyr) 

stars_df <- read.csv("E:/School/UIC/23-24/CS 528/DataProcessing/athyg_v31.csv") 
stars_subset <- subset(stars_df, select = c(hip, dist, absmag, mag, x0, y0, z0, spect, vx, vy, vz) )

# Preserve Sol in data cleaning
stars_subset[1, 1] = "Sol"
stars_subset[1, 9] = 0
stars_subset[1, 10] = 0
stars_subset[1, 11] = 0

# Drop missing data
#stars_cleaned <- na.omit(stars_subset)
#reduced_clean <- stars_subset[!is.na(stars_subset$hip),]

reduced<- stars_subset[!is.na(stars_subset$x0),]
reduced<- reduced[!is.na(reduced$y0),]
reduced<- reduced[!is.na(reduced$z0),]
reduced <- reduced[!is.na(reduced$vx),]
reduced <- reduced[!is.na(reduced$vy),]
reduced <- reduced[!is.na(reduced$vz),]
reduced <- reduced[!is.na(reduced$spect),]
reduced_clean <- reduced[!apply(reduced["spect"] == "", 1, all), ] 

# Clean up
rm(stars_df, stars_subset, stars_cleaned)

# Add missing stars for constellations
reduced_clean[nrow(reduced_clean) + 1,] = c("89341","")

# Move "spect" to the final collumn
reduced_clean <- reduced_clean %>% select(-spect,spect)

# Closest stars first
stars_sorted <- reduced_clean[order(reduced_clean$dist),]

# Write data file for Unity
#write.csv(stars_sorted, "E:/School/UIC/23-24/CS 528/CS528-Project/Assets/Resources/athyg_v31_cleaned.csv") 
#write.csv(stars_sorted, "E:/School/UIC/23-24/CS 528/DataProcessing/athyg_v31_cleaned_just_hip.csv") 

# Add exoplanet data
exoplanets <- read.csv("E:/School/UIC/23-24/CS 528/DataProcessing/exoplanets_reduced.csv")

# Clean data
exo_cleaned <- exoplanets[!apply(exoplanets["hip_name"] == "", 1, all), ] 
exo_cleaned <- distinct(exo_cleaned)

exo_cleaned$hip_name <- substring(exo_cleaned$hip_name, 4)
exo_cleaned$hip_name <- gsub("[^0-9.-]", "", exo_cleaned$hip_name)

exo_cleaned <- exo_cleaned %>% rename(hip = hip_name)

# Add exoplanet number to star data
stars_with_exo <- left_join(stars_sorted, distinct(exo_cleaned))

# Move "spect" to the final collumn
stars_with_exo <- stars_with_exo %>% select(-spect,spect)

# Write data file for Unity
write.csv(stars_with_exo, "E:/School/UIC/23-24/CS 528/CS528-Project/Assets/Resources/athyg_v31_cleaned_exo_all_stars.csv")
