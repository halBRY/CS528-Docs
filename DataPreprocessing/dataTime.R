library(dplyr) 

#stars1 <- read.csv("E:/School/UIC/23-24/CS 528/ATHYG-Database/data/athyg_v31-1.csv") 
#stars2 <- read.csv("E:/School/UIC/23-24/CS 528/ATHYG-Database/data/athyg_v31-2.csv") 

reduced <- read.csv("E:/School/UIC/23-24/CS 528/ATHYG-Database/data/subsets/athyg_31_reduced_m10.csv")
reduced <- subset(reduced, select = c(hip, dist, absmag, mag, x0, y0, z0, spect, vx, vy, vz) )

# Drop missing data
reduced_xclean <- reduced[!is.na(reduced$x0),]
reduced_yclean <- reduced_xclean[!is.na(reduced_xclean$y0),]
reduced_zclean <- reduced_yclean[!is.na(reduced_yclean$z0),]
reduced_clean <- reduced_zclean[!is.na(reduced_zclean$spect),]
reduced_clean <- reduced_clean[!apply(reduced_clean["spect"] == "", 1, all), ]   

rm(reduced, reduced_xclean, reduced_yclean, reduced_zclean)

# Get only first letter of spectral class
subset_funct <- function(x) substring(x, 1, 1)
crop_spect <- reduced_clean
# crop_spect["spect"] <- lapply(reduced_clean["spect"], subset_funct)

# Save X,Y,Z in "feet"
meters2feet <- function(x) x * 3.28084

stars_feet <- crop_spect
stars_feet["x0_feet"] <-lapply(stars_feet["x0"], meters2feet)
stars_feet["y0_feet"] <-lapply(stars_feet["y0"], meters2feet)
stars_feet["z0_feet"] <-lapply(stars_feet["z0"], meters2feet)

# Add brightness value
lum_df <- stars_feet

# Flip signs (greatest brightness is now positive)
flipSign <- function(x) x * -1
lum_df["lum"] <-lapply(lum_df["mag"], flipSign)

lumMin <- min(lum_df$lum)
lumMax <- max(lum_df$lum)
rescaleLum <- function(x) (x - lumMin) / lumMax 
lum_df["lum"] <-lapply(lum_df["lum"], rescaleLum) 

# Move relevant columns to front for easier access
stars_sorted = lum_df %>% dplyr::select("spect", everything()) 
stars_sorted = stars_sorted %>% dplyr::select("lum", everything()) 
stars_sorted = stars_sorted %>% dplyr::select("mag", everything()) 
stars_sorted = stars_sorted %>% dplyr::select("z0_feet", everything()) 
stars_sorted = stars_sorted %>% dplyr::select("y0_feet", everything()) 
stars_sorted = stars_sorted %>% dplyr::select("x0_feet", everything()) 

# Closest stars first
stars_sorted <- stars_sorted[order(stars_sorted$dist),]
# Write data file for Unity
write.csv(stars_sorted, "E:/School/UIC/23-24/CS 528/CS528-Project/Assets/Data/athyg_v31-1_cleaned.csv") 

# For checking in Unity
nrow(stars_sorted)

unique(stars_sorted$spect)
max(stars_sorted$mag)
min(stars_sorted$mag)
