## 1. Name and short comments

###author: "Otso Aro"

###date: '10/11/2019'
install.packages("dplyr")
library(dplyr)


#and explore the structure and dimensions of the data. Write short code comments describing the output of these explorations.

# Week 2 exercise
## Short comments about the data

"The data seems to be consisting of 60 variables and 183 observations. Most of the variables seem to be likert-scales, having integer values from 1 to 5."

## 2. Reading the file

exerciseData <- read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", sep="\t", header=TRUE)
summary(exerciseData)
str(exerciseData)

## 3. Creating the variables and dataset needed

deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D06",  "D15", "D23", "D31")
surface_questions <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
strategic_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")

# select the columns related to deep learning and create column 'deep' by averaging
deep_columns <- select(exerciseData, one_of(deep_questions))
exerciseData$deep <- rowMeans(deep_columns)

# select the columns related to surface learning and create column 'surf' by averaging
surface_columns <- select(exerciseData, one_of(surface_questions))
exerciseData$surf <- rowMeans(surface_columns)

# select the columns related to strategic learning and create column 'stra' by averaging
strategic_columns <- select(exerciseData, one_of(strategic_questions))
exerciseData$stra <- rowMeans(strategic_columns)

newColumns <- c("gender","Age","Attitude", "deep", "stra", "surf", "Points")

learning2014 <- select(exerciseData, one_of(newColumns))
learningData <- filter(learning2014, Points > 0)
learningData
str(learningData)


## 4. Setting the working directory
write.table(learningData, file = "data/learning2014")

modelData <- read.table('data/learning2014')
str(modelData)











