# Sara Todorovic
# Introduction to Open Data Science, Week 4
# Preparation data for week 5, metadata: http://hdr.undp.org/en/content/human-development-index-hdi

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
