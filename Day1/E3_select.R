#########################################################################################
# Copyright (c) 2020. All rights reserved.  See the file LICENSE for
# license terms.
#########################################################################################
# File: select
# Proj: R Workshop
# Desc: A non-technical introduction to R
# Auth: ML, JvO
#########################################################################################
rm(list = ls())
# Set working directory ####
setwd("~/Documents/R_intro_2020/LE3/Code")

# Install and load packages ####
#install.packages("data.table")
#install.packages("lubridate")
library(data.table)
library(lubridate)

# Read in data ####
myData <- fread("transactions.csv")

# Adjust the format of column "TransDate" to POSIX Date ####
myData[, TransDate:=dmy(TransDate)]
# myData[, TransDate:=dmy(TransDate, tz="UTC")]

# Part 1: Selecting rows ####
# ------------------------------------------------------------------------------

# Task 1: Select rows 10 to 20. ####
myData[10:20,]

# Task 2: Select all purchases from 2010. ####
myData[TransDate > dmy("31.12.2009") & TransDate <= dmy("31.12.2010"),]
myData[TransDate > dmy("31-12-2009") & TransDate <= dmy("31-12-2010"),]
# or:
myData[year(TransDate) == 2010,]


# Task 3: Select purchases made on 19.12.2010 or on 21.12.2010. ####
myData[TransDate == dmy("19.12.2010") | TransDate == dmy("21.12.2010"),]
# or
myData[TransDate %in% c(ymd("2010-12-19"), ymd("2010-12-21"))]

#########
# are they the same?
myData <- fread("transactions.csv")
myData[, TransDate:=dmy(TransDate, tz="UTC")]
myData[TransDate == dmy("19.12.2010", tz="UTC") | TransDate == dmy("21.12.2010", tz="UTC"),]
myData[TransDate %in% c(ymd("2010-12-19",tz="UTC"), ymd("2010-12-21", tz="UTC"))]

myData <- fread("transactions.csv")
myData[, TransDate:=dmy(TransDate, tz = "America/New_York")]
myData[TransDate == dmy("19.12.2010", tz="UTC") | TransDate == dmy("21.12.2010", tz="UTC"),]
myData[TransDate %in% c(ymd("2010-12-19"), ymd("2010-12-21"))]
#########


# Task 4: Select all purchases with quantities between 2 and 5. ####
myData <- fread("transactions.csv")
myData[, TransDate:=dmy(TransDate)]
myData[Quantity >= 2 & Quantity <= 5,]
myData[Quantity %in% c(2:5)]

# Task 5: Select all purchases with purchase amount greater than 1 which were made from 01.01.2009 onwards.
myData[PurchAmount > 1 & year(TransDate) > 2008]

myData[PurchAmount > 1 & TransDate >= dmy("01.01.2009")]

# different output:
myData[PurchAmount > 1 & TransDate >= dmy("01.01.2009", tz="America/New_York")]


# Part 2: Selecting columns ####
# ------------------------------------------------------------------------------

# Task 1: First select rows 1 to 100 ####
myData <- fread("transactions.csv")
myData[, TransDate:=dmy(TransDate)]

myData1 <- myData[1:100,]
myData1

# Task 2: From this, select the following columns: Customer, TransDate, and Quantity ####
myData2_1 <- myData1[,list(Customer, TransDate, Quantity)]
myData2_1

myData2 <- myData[1:100,list(Customer, TransDate, Quantity)]
myData2
identical(myData2, myData2_1)

# Task 3: Select the columns Customer and Cost from all rows with a purchase amount between 100 and 200 ####
myData3 <- myData[PurchAmount > 100 & PurchAmount < 200, list(Customer, Cost)]
myData3
myData[PurchAmount > 100 & PurchAmount < 200, ][, list(Customer, Cost)]



# Part 3: Appending and updating rows and columns ####
# ------------------------------------------------------------------------------

# Task 1: Create a new column calculating the difference between PurchAmount and Cost. Call it Profit ####
rm(list = ls())
myData <- fread("transactions.csv")
myData[, TransDate:=dmy(TransDate)]



myData[, Profit := PurchAmount - Cost]
myData

str(myData)

# rm(list = ls())
# myData <- fread("transactions.csv")
# myData[, TransDate:=dmy(TransDate, tz="UTC")]
# myData$PurchAmount <- as.character(myData$PurchAmount)
# myData$Cost <- as.character(myData$Cost)
# str(myData)
# myData[, Profit := PurchAmount - Cost]

# Task 2: Rename Profit to ProfitChange ####
setnames(myData, "Profit", "ProfitChange")

# Task 3: Delete ProfitChange again ####
myData[, ProfitChange:=NULL]

# or
# myData$ProfitChange <- NULL

# Task 4: Create a copy of myData name it “mydata.toppurchases”. #### 
#         In the new data.table delete all customers with a PurchAmount smaller than 100.

myData <- fread("transactions.csv")
myData[, TransDate:=dmy(TransDate)]


mydata.toppurchases <- copy(myData)
mydata.toppurchases[, difference := PurchAmount-100]
mydata.toppurchases <- mydata.toppurchases[!difference < 0, ]

mydata.toppurchases
myData


# if we dont use copy:
myData <- fread("transactions.csv")
myData[, TransDate:=dmy(TransDate)]


mydata.toppurchases <- myData
mydata.toppurchases[, difference := PurchAmount-100]
mydata.toppurchases <- mydata.toppurchases[!difference < 0, ]

mydata.toppurchases
myData
