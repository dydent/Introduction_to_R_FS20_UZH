#########################################################################################
# Copyright (c) 2020. All rights reserved.  See the file LICENSE for
# license terms.
#########################################################################################
# File: aggregate
# Proj: R Intro
# Desc: A non-technical introduction to R
# Auth: ML, JvO
#########################################################################################
rm(list = ls())
# Set working directory ####
setwd("~/Documents/R_intro_2020/LE4/Code")


# Install and load packages ####
#install.packages("data.table")
#install.packages("lubridate")
library(data.table)
library(lubridate)

# Read in data ####
myData <- fread("transactions.csv")

# Data preparation
myData[, TransDate:=dmy(TransDate)]


# Part 1: Aggregate on datasets ####
# ------------------------------------------------------------------------------

# Task 1: Sum PurchAmount by customer and date ####
myData[, AggDayPurch := sum(PurchAmount), by=list(Customer, TransDate)]
myData  
myData[Customer==172951]


# sort the table for better visualization
setkey(myData, Customer, TransDate)
head(myData, 11)


#myData[,list(AggDayPurch = sum(PurchAmount)), by=list(Customer, TransDate)]

# Task 2: Count number of transactions by customer ####
# myData[,PurchFreq := .N, by=Customer]
# myData

myData[,list(PurchFreq = .N), by=Customer]

#Count the total number of transactions 
myData[, .N]


# Part 2: Advanced aggregating topics ####
# ------------------------------------------------------------------------------
myData <- fread("transactions.csv")
myData[, TransDate:=dmy(TransDate)]

# Task 1: Aggregate the purchase amount (sum) of all transaction per customer on a yearly basis for year 2007 and 2008.

# list
a <- myData[, list(AggPurch=sum(PurchAmount)), by=list(Customer,year=floor_date(TransDate,unit="year"))]
a[year =='2007-01-01' | year == '2008-01-01']
myData[, list(AggPurch=sum(PurchAmount)), by=list(Customer,year=floor_date(TransDate,unit="year"))][year =='2007-01-01' | year == '2008-01-01']

rm(list = ls())
myData <- fread("transactions.csv")
myData[, TransDate:=dmy(TransDate)]
help("year")
a <- myData[, list(AggPurch=sum(PurchAmount)), by=list(Customer,year(TransDate))][year %in% c(2007, 2008)]
b <- myData[year(TransDate) %in% c(2007, 2008)][, list(AggPurch=sum(PurchAmount)), by=list(Customer,year(TransDate))]
identical(a,b)
# 36073

# :=
c <- myData[year(TransDate) == 2007 | year(TransDate) == 2008][, AggPurch := sum(PurchAmount), by=list(Customer,year(TransDate))]
c
c <- unique(c[, list(Customer, year = year(TransDate), AggPurch)])

identical(a, c)


a$AggPurch <- round(a$AggPurch, 2)
c$AggPurch <- round(c$AggPurch, 2)
identical(a, c)


# Task 2: How many customers purchased for more than 50$ in total between 2008 and 2009  ####
rm(list = ls())
myData <- fread("transactions.csv")
myData[, TransDate:=dmy(TransDate)]


myData[year(TransDate) >= 2008 & year(TransDate) <= 2009, list(AggPurch =sum(PurchAmount)), by=Customer][AggPurch > 50][,.N]


# Part 3: Selecting using an aggregating dimension ####
# ------------------------------------------------------------------------------

# Task 1: Add a column to myData with the transaction sequence per customers ####
rm(list = ls())
myData <- fread("transactions.csv")
myData[, TransDate:=dmy(TransDate)]

myData
myData[, relDate := 1:.N, by=Customer]
head(myData, 11)

# Task 2:Create a lead shifted variable for TransDate (by one period) by customer.
rm(list = ls())
myData <- fread("transactions.csv")
myData[, TransDate:=dmy(TransDate)]

setkey(myData, TransDate)

# to visualize the difference
normal <- myData[Customer == 102824][, list(TransDate)]


myData <- fread("transactions.csv")
myData[, TransDate:=dmy(TransDate)]
setkey(myData, TransDate)
myData[, TransDate := shift(TransDate, type="lead"), by=Customer]
lead <- myData[Customer == 102824][, list(TransDate)]

myData <- fread("transactions.csv")
myData[, TransDate:=dmy(TransDate, tz="UTC")]
setkey(myData, TransDate)
myData[, TransDate := shift(TransDate, type="lag"), by=Customer]
lag <- myData[Customer == 102824][, list(TransDate)]

whole <- cbind(normal, lead, lag)
setnames(whole, c("normal", "lead", "lag"))
whole[1:5]

# ?shift -> type

# Task 3:Select everyone's largest purchase / second / thrid /...

# largest:
rm(list = ls())
myData <- fread("transactions.csv")
myData[, TransDate:=dmy(TransDate)]

myData[, list(largest_Purch = max(PurchAmount)), by =Customer]
myData[Customer == 140729]


# second largest
rm(list = ls())
myData <- fread("transactions.csv")
myData[, TransDate:=dmy(TransDate)]


a <- myData[, list(second_largest_Purch = max(PurchAmount[PurchAmount != max(PurchAmount)])), by =Customer]
myData[Customer == 140729]
a[Customer == 140729]

myData[Customer == 149236]
a[Customer == 149236]

# !
myData[Customer == 199997]
a[Customer == 199997]

# other ways: sort or .SD
rm(list = ls())
myData <- fread("transactions.csv")
myData[, TransDate:=dmy(TransDate)]
a <- myData[, sort(PurchAmount, decreasing = T)[2], by = Customer]

setorder(myData, Customer, -PurchAmount)
b <- myData[, PurchAmount[2], by = Customer] 
identical(a, b)


###### add unique
rm(list = ls())
myData <- fread("transactions.csv")
myData[, TransDate:=dmy(TransDate)]

a <- myData[, list(second_largest_Purch = max(PurchAmount[PurchAmount != max(PurchAmount)])), by =Customer]
b <- myData[, list(second_largest_Purch = sort(unique(PurchAmount), decreasing = T)[2]), by = Customer]
a
b
a <- a[second_largest_Purch > 0]
b <- b[second_largest_Purch > 0]
identical(a, b)



rm(list = ls())
myData <- fread("transactions.csv")
myData[, TransDate:=dmy(TransDate)]

a <- myData[, list(second_largest_Purch = max(PurchAmount[PurchAmount != max(PurchAmount)])), by =Customer]
setorder(myData, Customer, -PurchAmount)
b <- myData[, list(second_largest_Purch = unique(PurchAmount)[2]), by = Customer] 
a <- a[second_largest_Purch > 0]
b <- b[second_largest_Purch > 0]

setkey(a, Customer)
a$Customer <- as.numeric(a$Customer)
a$second_largest_Purch <- round(a$second_largest_Purch, 2)
b$Customer <- as.numeric(b$Customer)
b$second_largest_Purch <- round(b$second_largest_Purch, 2)
identical(a, b)
