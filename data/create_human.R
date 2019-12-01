# Data Wrangling 3 - create human

## 2)  Reading the data into local script
hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)
gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = "..")


## 3) Explore the data, read the summaries and structure of the data

dim(hd)
str(hd)
summary(hd)

dim(gii)
str(gii)
summary(gii)

## 4) Rename variable names to more clear and specific ones
library(dplyr)
hd <- hd %>% dplyr::rename(lifeExpectancy = Life.Expectancy.at.Birth, 
                     eduExpectancy = Expected.Years.of.Education, 
                     meanEdu = Mean.Years.of.Education,
                     HIDnum = Human.Development.Index..HDI.,
                     GNICapita = Gross.National.Income..GNI..per.Capita,
                     GNI_HDI = GNI.per.Capita.Rank.Minus.HDI.Rank)

str(hd)

gii <- gii %>% dplyr::rename(GIIndex = Gender.Inequality.Index..GII.,
                             motherMortality = Maternal.Mortality.Ratio,
                             teenMoms = Adolescent.Birth.Rate,
                             parliamentRep = Percent.Representation.in.Parliament,
                             secEduF = Population.with.Secondary.Education..Female.,
                             secEduM = Population.with.Secondary.Education..Male.,
                             workingF = Labour.Force.Participation.Rate..Female.,
                             workingM = Labour.Force.Participation.Rate..Male.
                             )

str(gii)

## 5) Mutate data and create two new variables

gii <- mutate(gii, eduDiff = secEduF / secEduM )
str(gii)

gii <- mutate(gii, workDiff = workingF / workingM)
str(gii)

## 6) Join the two datasets together
join_by = c("Country")

human <- inner_join(hd, gii, by = join_by, suffix = c(".hd", ".gii")) 

str(human)

write.table(human, file = "data/human")

human
# Data wrangling 4
## read the human- data into the file and view its structure


str(human)
"The human - dataset is a combination of girl inequality index and human development index from United Nations. 
It has been joined together using the Country - variable, that was common in both datasets. The dataset rows are countries.
The remaining variables include:
HDI.Rank - Ranking in United Nations human development index.
HIDnum - A numeral rank of human development index rating
lifeExpectancy - Life expectancy in each country
eduExpectancy - Expectancy of educational years in each country per person
meanEdu - The mean of years of education in the population
GNICapita - Gross national income per capita
GNI HDI - GNI rank minus the HDI rank
GII.Rank - Ranking in gender inequality index for a specific country
mother Mortality - ratio of the mortality of mothers
teenMoms - which is the percentage of adolecent mothers in the countries
parliamentRep - The percentage of the parliament representatives that are women in each country
secEduF - percentage of women that attain secondary education
secEduM - percentage of men that attain secondary education
eduDiff - the ratio of women to men in attaining higher education
workDiff - the ratio of women to men as part of the workforce"


## 1) Mutate the GNI variable into a numeric one from a character based value

### access the stringr and tidyr package
library(stringr)
library(tidyr)

str(human)

### remove the commas from GNI and print out a numeric version of it
human$GNICapita <- str_replace(human$GNICapita, pattern=",", replace ="") %>% as.numeric

## 2) Keep only certain columns
str(human)

### columns to keep
keep <- c("Country", "eduDiff", "workDiff", "lifeExpectancy", "eduExpectancy", "GNICapita", "motherMortality", "teenMoms", "parliamentRep")

### select the 'keep' columns
human <- dplyr::select(human, one_of(keep))

## 3) Remove all the rows with missing values

human <- filter(human, complete.cases(human))
str(human)
human


## 4) Remove all the observations that relate to regions instead of countries

tail(human, 10)

### define the last indice we want to keep
last <- nrow(human) - 7

### choose everything until the last 7 observations
human <- human[1:last, ]

str(human)

## 5) Define rownames by the country

### add countries as rownames
rownames(human) <- human$Country

### Remove the country column from the data
human$Country <- NULL
str(human)

### Overwrite old human data
write.table(human, file = "data/human")
str(human)
