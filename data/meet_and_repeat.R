# Introduction  to Open Data Science, fall 2018
# Week 6: Longitudinal data / 3.12.2018
# Sara Todorovic

# Loading the datasets in wide form
BPRS <- read.csv("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt", sep = "")
RATS <- read.csv("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt", sep = "")

# Structure, variable names and dimensions
colnames(BPRS) # treatment, subject, and weeks 0 to 8
colnames(RATS) # ID, group, and "WD1", "WD8","WD15", "WD22", "WD29", "WD36", "WD43", "WD44", "WD50", "WD57" and "WD64"
str(BPRS) # 40 obs. of  11 variables, all integers
str(RATS) # 16 obs. of  13 variables, all integers

# Factor treatment & subject
BPRS$treatment <- factor(BPRS$treatment)
BPRS$subject <- factor(BPRS$subject)
RATS$Group <- factor(RATS$Group)
RATS$ID <- factor(RATS$ID)

# Access the packages dplyr and tidyr
library(dplyr)
library(tidyr)

# Converting the data to long form : groups the data to key-value pairs so that the data is grouped by week-variable
BPRSL <-  BPRS %>% gather(key = weeks, value = bprs, -treatment, -subject)
RATSL <- RATS  %>% gather(key = time, value = rats, -Group, -ID)

# Creating variables week and Time to the datasets by extracting first the week number and the 'WD' number (whatever that means)
BPRSL <-  BPRSL %>% mutate(week = as.integer(substr(weeks, 5,5)))
RATSL <- RATSL %>% mutate(Time = as.integer(substr(time, 3,3)))
str(BPRSL)
str(RATSL)
head(BPRSL)
head(RATSL)

# Main difference is that in both datasets, when converting from the wide to long form, 
# is that the data is now grouped by the time variable, and instead of each row representing all results for one observation for all weeks,
# one row represents now only one result per observation at per one week/Time. The variables are also much more readable in the long form, 
# because the names are clear. Long form allows us to study the data from another angle than with the wide formed data. 