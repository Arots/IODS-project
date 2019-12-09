# Needed data packages for wranling
library(dplyr)
library(tidyr)


# 1) Load the datasets and take a look at them

BPRS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt", sep  =" ", header = T)
RATS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt", header = TRUE, sep = '\t')
write.table(BPRS, file = "data/BPRS")
write.table(RATS, file = "data/RATS")

dim(BPRS)
dim(RATS)

str(BPRS)
str(RATS)

summary(BPRS)
summary(RATS)

"The BPRS - dataset consists of 40 observations and 11 variables. It is a dataset that measures 40 male subject.
In the study the subjects were assigned to one or two treatment groups and given a psychiatric rating.
The BPRS variables are:
treatment = treatment groups
subject = each group has id:s from 1 to 20 (both having 20 to cover all 40 observations)
and measurements of each indivial each week."

"The RATS - dataset consist of 16 observations and 13 variables. the Rats - dataset measures the length of rats in a longitutional study.
The RATS - variables are:
ID = indetiifcation value for each specific rat,
Group = Groups for rats,
WD = which are weekdays in the measurements in rat lengths and their growth."


# 2) Convert categorical variables into factors (meaning ID and group)

# Factor treatment & subject
BPRS$treatment <- factor(BPRS$treatment)
BPRS$subject <- factor(BPRS$subject)

# Factor variables ID and Group
RATS$ID <- factor(RATS$ID)
RATS$Group <- factor(RATS$Group)

# 3) Convert the datasets into long form

# Convert to long form
BPRS <-  BPRS %>% gather(key = weeks, value = bprs, -treatment, -subject)

# Convert data to long form
RATS <- RATS %>%
  gather(key = WD, value = Weight, -ID, -Group) %>%
  mutate(Time = as.integer(substr(WD,3, 4)))

# Add the week variable into BPRSL
BPRS <-  BPRS %>% mutate(week = as.integer(substr(weeks,5,5)))

# 4) Take a serious look at the dataset
str(BPRS)
str(RATS)

write.table(BPRS, file = "data/BPRS")
write.table(RATS, file = "data/RATS")

str(BPRS)

"Both datasets have increased in number, due to the fact that they are no longer grouped by just the weekday or week categoies.
We have also added Time and week into the the datasets. The longitutional datasets couldnt be analyzed in the previous datasets.
We couldnt see the linear progression of each individual in the previous datasets, but after transforming them and clearly assigning
them into an ID or treatment, we could do so."