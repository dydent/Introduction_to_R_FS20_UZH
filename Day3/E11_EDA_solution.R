################################################################################
# Copyright (c) 2013. All rights reserved.  See the file LICENSE for
# license terms.
################################################################################

# File: E11_EDA_solution.R
# Proj: R Workshop
# Desc: A non-technical Introduction to R
#       Exercise 11 - Exploratory Data Analysis
# Auth: Claudia Wenzel
# Date: 2019-08-11

# Input:
# - data: ecommerce-data_stud.csv
#
# Output:

################################################################################

# set working directory
setwd()

# Load packages  - install packages if needed
library(data.table)
library(reshape2)
library(plyr)
library(dplyr)
library(PerformanceAnalytics)
library(ggplot2)
library(gpairs)
library(GGally)
library(lubridate)
library(psych)

############## Part 1##############
#### 1) Read data
ecomm <- fread("ecommerce-data_stud.csv")

#### 2) Inspect dataset 
# dimensions of data
dim(ecomm)

# in console
ecomm

# View whole data set
#View(ecomm)

# get summary
summary(ecomm)

# structure of the dataset
str(ecomm)

### 3) Transform variables
# transform date
ecomm$dateTime <-  dmy(ecomm$dateTime,tz="UTC")

# define columns to change
# single column
ecomm$gender <- factor(ecomm$gender)
# all character variables -> even if levels are not required, factors are easier to handle for, e.g. plotting
changeCols <- colnames(ecomm)[which(as.vector(ecomm[,lapply(.SD, class)][1]) == "character")]
ecomm[,(changeCols):= lapply(.SD, factor), .SDcols = changeCols]
str(ecomm)

### Delete columns with too many missing values
summary(ecomm) 
ecomm[,c("age", "purchasedBefore"):=NULL]
 
#### 4) Correlation matrix
# copy the data to not change the origial structure
ecomm.num <- copy(ecomm)
# change factors to numbers
changeCols <- colnames(ecomm.num)[which(as.vector(ecomm.num[,lapply(.SD, class)][1]) == "factor")]
ecomm.num[,(changeCols):= lapply(.SD, as.numeric), .SDcols = changeCols]
str(ecomm.num)
# look at the correlations
cor(ecomm.num[,-c(1:4)], use="complete.obs")
chart.Correlation(ecomm.num[,-c(1:4)])

############## Part 2 ##############

#### 1) Statistical features of avgAmountSpent
summary(ecomm$avgAmountSpent)
hist(ecomm$avgAmountSpent, breaks=50)
boxplot(ecomm$avgAmountSpent)

# outliers
Q1 <- quantile(ecomm$avgAmountSpent, 0.25)
Q3 <- quantile(ecomm$avgAmountSpent, 0.75)
iqr <-  IQR(ecomm$avgAmountSpent)

# potential outliers
ecomm[avgAmountSpent< Q1 - (1.5 * iqr) | avgAmountSpent> Q3 + (1.5 * iqr)] #18

# critical outliers
ecomm[avgAmountSpent< Q1 - (3 * iqr) | avgAmountSpent> Q3 + (3 * iqr)] #none

# delete potential outliers
ecomm.short <- ecomm[avgAmountSpent>= Q1 - (1.5 * iqr) & avgAmountSpent<= Q3 + (1.5 * iqr)] # always save in new data table

#### 2) Outliers Number of Visits
boxplot(ecomm$behavNumVisits)
hist(ecomm$behavNumVisits)
Q1 <- quantile(ecomm$behavNumVisits, 0.25)
Q3 <- quantile(ecomm$behavNumVisits, 0.75)
iqr <-  IQR(ecomm$behavNumVisits)

# potential outliers
ecomm[behavNumVisits< Q1 - (1.5 * iqr) | behavNumVisits> Q3 + (1.5 * iqr)] #97
# critical outliers
ecomm[behavNumVisits< Q1 - (3 * iqr) | behavNumVisits> Q3 + (3 * iqr)] #37

### outlier definition of 1.5*IQR is for normally distributed data!

#### 2) Transform data 
# look at distribution
hist(ecomm$behavNumVisits)
hist(ecomm$behavNumVisits, breaks = 60)

# transform variable using logarithm, because we observe a right skew
ecomm$behavNumVisitsLog <- log(ecomm$behavNumVisits)
hist(ecomm$behavNumVisitsLog)

# check outliers again
Q1 <- quantile(ecomm$behavNumVisitsLog, 0.25)
Q3 <- quantile(ecomm$behavNumVisitsLog, 0.75)
iqr <-  IQR(ecomm$behavNumVisitsLog)

# potential outliers
ecomm[behavNumVisitsLog< Q1 - (1.5 * iqr) | behavNumVisitsLog> Q3 + (1.5 * iqr)] #4
# critical outliers
ecomm[behavNumVisitsLog< Q1 - (3 * iqr) | behavNumVisitsLog> Q3 + (3 * iqr)] #0


############## Part 3 ##############

#### 1) Look at the distribution across variables
table(ecomm$surveyType, ecomm$gender) # is hard to interpret
prop.table(table(ecomm$surveyType, ecomm$gender)) # better to interpret, but we want to see % across survey type
prop.table(table(ecomm$surveyType, ecomm$gender),1) # now we can see that most surveys at entry and exit are filled by women
prop.table(table(ecomm$surveyType, ecomm$gender),2) # now we can see that women tend to rather take the survey at the exit, men at arrival

### 2) Correlation
cor.test(ecomm$avgAmountSpent, as.numeric(ecomm$gender))
# moderate negative correlation
# result is significant
# hard to interpret, because levels of factors are not ordered in meaningful way
unique(ecomm[order(gender),.(gender, gender.num=as.numeric(gender))])

### 3) Relationship between 2 variables
ggplot(ecomm, aes(y=avgAmountSpent, x=purchaseExpectInNextMonth)) + geom_point() 
# plot a line that displays the quadratic relationship
ggplot(ecomm, aes(y=avgAmountSpent, x=purchaseExpectInNextMonth)) + geom_point() +  
  stat_smooth(method = "lm", formula = y ~ x + I(x^2))

### 4) Relationship beween 3 variables
ggplot(ecomm, aes(y=avgAmountSpent, x=purchaseExpectInNextMonth, color=gender)) + 
  geom_point() + 
  stat_smooth(method = "lm", formula = y ~ x + I(x^2))



