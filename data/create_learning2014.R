# Sara Todorovic // 7th November 2018 // Week 2 exercise: Regression and model validation

# Reading the data 

data <- read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", sep="\t", header=TRUE)
  
# Dimensions and structure of the data
dim(data) # 186 rows, 60 columns
str(data) # 59 integer rows, one Factor with two levels (F & M)



# Bringing in dplyr library 
library(dplyr)

# Creating an analysis dataset with variables gender, age, attitude, deep, stra, surf and points
# First creating new variables where new values are stored based on the questions in the dataset

# Creating variable 'attitude' by scaling the column 'Attitude' into scale 1-5
data$attitude <- data$Attitude/10

# Creating variables for deep, surface and strategic learning
deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D06",  "D15", "D23", "D31")
surface_questions <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
strategic_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")

# Selecting the columns related to deep learning creating column 'deep' by averaging
deep_columns <- select(data, one_of(deep_questions))
data$deep <- rowMeans(deep_columns)

# Selecting the columns related to surface learning and creating column 'surf' by averaging
surface_columns <- select(data, one_of(surface_questions))
data$surf <- rowMeans(surface_columns)

# Select the columns related to strategic learning and creating column 'stra' by averaging
strategic_columns <- select(data, one_of(strategic_questions))
data$stra <- rowMeans(strategic_columns)

# Changing column names and creating a new dataset with the variables we want to keep

learning2014 <- select(data, one_of(c("gender","Age","attitude", "deep", "stra", "surf", "Points")))

colnames(learning2014) [7] <- "points"
colnames(learning2014) [2] <- "age"

# Select rows where points is greater than zero
learning2014 <- filter(learning2014, points > 0)
dim(learning2014) # 166 rows and 7 columns

View(learning2014)

?write.csv
# Setting IODS-folder as the working directory and saving the script
setwd("~/Documents/GitHub/IODS-project")
write.csv(learning2014, file="~/Documents/GitHub/IODS-project/data/learning2014.csv")

# Checking if it works
read.csv("~/Documents/GitHub/IODS-project/data/learning2014.csv", sep= ",", header=T)
head(learning2014)
str(learning2014)

# Works :D

