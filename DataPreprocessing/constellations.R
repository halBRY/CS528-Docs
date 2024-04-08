library(dplyr) 
library(tidyverse) 

stars <- read.csv("E:/School/UIC/23-24/CS 528/CS528-Project/Assets/Resources/athyg_v31_cleaned.csv")
shapes <- readLines("E:/School/UIC/23-24/CS 528/DataProcessing/constellationship_zulu.fab")

#shapes <- shapes[-c(89,90)] 

# Create a smaller loop for testing
#shapes <- shapes[c(0,1)]

all_constellations <- list()
counter <- 0
const_num <- 0

# For each constellation, save the (x,y,z) coords for each star as pairs
for(constellation in shapes)
{
  myConstellation <- const_num
  
  #Get all stars from line
  data <- scan(text = constellation[1], what = "")
  
  # Drop name and num pairs for now
  data_stars <- data[-c(0, 1, 2)] 
  
  # For each star...
  for(star in data_stars)
  {
    # Use HIPID to find that star in stars data frame
    #myStar <- stars[stars$hip == star,]
    myStar <- stars[which(stars$hip == star), ] 
    
    #print(myStar)
    
    #myCoords <- myStar[c("x0_feet", "y0_feet", "z0_feet")]
    #print(myCoords)
  
    xCoord <- myStar["x0"]
    yCoord <- myStar["y0"]
    zCoord <- myStar["z0"]
    
    vxCoord <- myStar["vx"]
    vyCoord <- myStar["vy"]
    vzCoord <- myStar["vz"]
    
    myCoords <- c(xCoord, yCoord, zCoord, vxCoord, vyCoord, vzCoord)

    myConstellation <- paste(myConstellation, paste(myCoords, collapse=","), sep=" ") 
    counter <- counter + 1
  }
  const_num <- const_num + 1
  
  all_constellations <- append(all_constellations, myConstellation, after = length(all_constellations))
}

print(counter)

lapply(all_constellations, write, "E:/School/UIC/23-24/CS 528/DataProcessing/constellationship_zulu.txt", append=T, ncolumns=length(all_constellations))
