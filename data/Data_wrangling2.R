#Otso Aro
# Date: 17.11.2019
# Rscript file for data-wrangling

library(dplyr)
library(ggplot2)

# 3) Read the student math data and portugese class data into r

url = "/Users/Lotta/IODS-project/data/"

# web address for math class data
urlMath <- paste(url, "student-mat.csv", sep = "/")

# read the math class questionaire data into memory
math <- read.table(urlMath, sep = ";", header = TRUE)

# web address for portuguese class data
urlPor <- paste(url, "student-por.csv", sep ="/")

# read the portuguese class questionaire data into memory
por <- read.table(urlPor, sep = ";", header = TRUE)

str(por)
str(math)
### The Math dataset contains 395 observations, while the portugese class data contains 649 observations. The portugese class and math data both have 33 varibles. The variables consist of things such as school, sex and age.

dim(por)
dim(math)

# 4) Joining datasets by columns

# common columns to use as identifiers
join_by <- c("school","sex","age","address","famsize","Pstatus","Medu","Fedu","Mjob","Fjob","reason","nursery","internet")
str(por)
# join the two datasets by the selected identifiers
math_por <- inner_join(math, por, by = join_by, suffix = c(".math", ".por"))

str(math_por)
dim(math_por)

### Now due to the combining of data we have less observations (participants), but more varibles, due to variables that have been combined from both datasets.

# 5) Creating a new dataset with no double values
# create a new data frame with only the joined columns
alc <- select(math_por, one_of(join_by))

# the columns in the datasets which were not used for joining the data
notjoined_columns <- colnames(math)[!colnames(math) %in% join_by]

# print out the columns not used for joining
notjoined_columns

# for every column name not used for joining...
for(column_name in notjoined_columns) {
  # select two columns from 'math_por' with the same original name
  two_columns <- select(math_por, starts_with(column_name))
  # select the first column vector of those two columns
  first_column <- select(two_columns, 1)[[1]]
  
  # if that first column vector is numeric...
  if(is.numeric(first_column) ) {
    # take a rounded average of each row of the two columns and
    # add the resulting vector to the alc data frame
    alc[column_name] <- round(rowMeans(two_columns))
  } else { # else if it's not numeric...
    # add the first column vector to the alc data frame
    alc[column_name] <- first_column
  }
}

str(alc)
dim(alc)

"The number of observations diminished due to the removal of duplicate values and of the variables that were used only in one dataset. We now have 33 variables with 382 observations."

# 6) Creating alcohol use and high alcohol use columns
# define a new column alc_use by combining weekday and weekend alcohol use
alc <- mutate(alc, alc_use = (Dalc + Walc) / 2)

# define a new logical column 'high_use'
alc <- mutate(alc, high_use = alc_use > 2)

# 7) Glimpsing at the dataset and writing it to data-folder
glimpse(alc)

write.table(alc, file = "data/alc")



 
