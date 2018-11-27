# Sara Todorovic
# Introduction to Open Data Science, Week 4
# Preparation data for week 5, metadata: http://hdr.undp.org/en/content/human-development-index-hdi

# Original data source: http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human1.txt

# NOTE! Week 5 exercise part is after Week 4 section

###############################
# WEEK 4

# Reading the data
hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)
# GII = gender inequality
gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = "..")

# Structure and dimensions
str(hd) # 195 observations, 8 variables
summary(hd)
str(gii) # 195 observations, 8 variables
summary(gii)

# Renaming the variables
names(hd) <- c("HDI.Rank", "Country", "HDI", "Life.Exp", "Edu.Exp", "Edu.Mean", "GNI", "GNI.Minus.Rank")
names(gii) <- c("GII.Rank", "Country", "GII", "Mat.Mor", "Ado.Birth", "Parli.F", "Edu2.F", "Edu2.M", "Labo.F", "Labo.M")

# Creating new variables to the gender equality dataset, ratio of females and males with secondary education, and labor force
gii$Edu2.FM <- round(gii$Edu2.F/gii$Edu2.M, 3)
gii$Labo.FM <- round(gii$Labo.F/gii$Labo.M, 3)
head(gii)

# Merging the two datasets (inner join)
human <- merge(hd, gii, by = "Country")
dim(human) # 195 observations and 19 variables

# Saving the file
write.csv(human, file="~/Documents/GitHub/IODS-project/data/human.csv", row.names = F)

###############################
# WEEK 5


human <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human1.txt", sep = ",")

# Variables include HDI ranking, HDI, Life expectancy, Education expectancy (years), Mean education time, 
# Gross national income, GNI minus ranking, Gender inequality index ranking, GII, Maternal mortality,
# Adolescent birth rate, Females in the parliament, Secondary education for F and M, Labor force participation for F and M
# And ratios of females and males in secondary education and labor force.
str(human)
dim(human) # 195 observations, 19 variables

# Transforming GNI variable to numeric with string manipulation by replacing commas
library(stringr)
human$GNI <- str_replace(human$GNI, pattern=",", replace ="") %>% as.numeric
str(human)

# Excluding unnecessary data and removing NA values
library(dplyr)

keep <- c("Country", "Edu2.FM", "Labo.FM", "Life.Exp", "Edu.Exp", "GNI", "Mat.Mor", "Ado.Birth", "Parli.F")
human <- select(human, one_of(keep))
# Printing the data with completeness indicator showing the rows with complete values (no missing data)
data.frame(human[-1], comp = complete.cases(human))
# Filtering the missing values out of the data
human <- filter(human, complete.cases(human)) # Now 155 observarions, so 40 got filtered
View(human)
# Removing the regions and 'world' from the dataframe and changing country names as rownames
last <- nrow(human) - 7 # Last index
human_ <- human[1:last, ] # choosing all rows up til last index
row.names(human_) <- human_$Country # Adding countries as rownames
human_ <- select(human_, -Country) # Removing country from dataframe, 155 observations and 8 variables

View(human_)
# Overwriting the file
write.csv(human_, file="~/Documents/GitHub/IODS-project/data/human.csv", row.names = TRUE)

