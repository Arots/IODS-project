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
