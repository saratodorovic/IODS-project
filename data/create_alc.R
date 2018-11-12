### Introduction to Open Data Science - fall 2018
# Week 3: Logistic regression
# Sara Todorovic 12 / 11 / 2018
# Data: Student performance dataset at https://archive.ics.uci.edu/ml/datasets/Student+Performance 
# by Paulo Cortez, University of Minho, Guimares, Portugal, http://www3.dsi.uminho.pt/pcortez 

##########

# Reading the data into R: Two questionnaires about students takins math course and portuguese course

# Math-dataset and its structure and dimensions: 395 observations of 33 variables
math <- read.csv("student-mat.csv", header = TRUE, sep=";")
str(math)
dim(math)

# Por-dataset: 649 observations of 33 variables
por <- read.csv("student-por.csv", header = TRUE, sep=";")
str(por)
dim(por)

## Data join: We only want to keep the students who answered the questionnaire in both math and portuguese classes,
# so we join the two datasets with mutual columns 

# Access the dplyr library and ggplot2 library for tools
library(dplyr); library(ggplot2)

# Mutual columns (copied from DataCamp)
join_by <- c("school","sex","age","address","famsize","Pstatus","Medu","Fedu","Mjob","Fjob","reason","nursery","internet")

# Joining the two datasets by the selected identifiers
math_por <- inner_join(math, por, by = join_by)

# Joining the two datasets by the selected identifiers and setting a suffix
math_por <- inner_join(math, por, by = join_by, suffix = c(".math", ".por"))

# New column names
colnames(math_por)

# Glimpse at the data with dplyr glimpse()
glimpse(math_por)

## Combining duplicate answers of the joined data (DataCamp)

# Creating a new data frame with only the joined columns
alc <- select(math_por, one_of(join_by))

# The columns in the datasets which were not used for joining the data
notjoined_columns <- colnames(math)[!colnames(math) %in% join_by]


# Printing out the columns not used for joining
notjoined_columns

# For every column name not used for joining...
for(column_name in notjoined_columns) {
  # select two columns from 'math_por' with the same original name
  two_columns <- select(math_por, starts_with(column_name))
  # select the first column vector of those two columns
  first_column <- select(two_columns, 1)[[1]]
  
  # if that first column vector is numeric...
  if(is.numeric(first_column)) {
    # take a rounded average of each row of the two columns and
    # add the resulting vector to the alc data frame
    alc[column_name] <- round(rowMeans(two_columns))
  } else { # else if it's not numeric...
    # add the first column vector to the alc data frame
    alc[column_name] <- first_column
  }
}

# Glimpse at the new combined data
glimpse(alc)

## Mutations: new variables as mutations of existing ones
# Using 'tidyverse' package tools



## Creating a new column alc_use to the alc dataframe with combined weekday and weekend alcohol consumption

#  Creating a new column into alc dataframe alc_use with mutate functionby combining weekday and weekend alcohol use
alc <- mutate(alc, alc_use = (Dalc + Walc) / 2)
alc['alc_use']

# Creating a plot if alcohol use
g1<-ggplot(data = alc, aes(x = alc_use))
g1

# Define the plot as a bar plot
g1 <- g1 + geom_bar(aes(fill=sex))

# Draw
g1

# Defining a new logical column 'high_use'
alc <- mutate(alc, high_use = alc_use > 2)
alc['high_use']

# Creating a plot of 'high_use'
g2 <- ggplot(data = alc, aes(x = high_use))
g2
# Drawing a bar plot of high_use by sex
g2 <- g2 + geom_bar(aes(fill=sex))+facet_wrap(~sex)

g2

## Glimpsing the joined data
glimpse(alc)
# 382 observations and 35 variables

## Saving the file
write.csv(alc, file="~/Documents/GitHub/IODS-project/data/alc.csv", row.names = F)
