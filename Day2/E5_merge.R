#########################################################################################
# Copyright (c) 2019. All rights reserved.  See the file LICENSE for
# license terms.
#########################################################################################

# File: merge
# Proj: R Intro
# Desc: A non-technical introduction to R
# Auth: ML, JvO
# Date: 2017
#########################################################################################
rm(list =ls())
# Set working directory ####
setwd("~/Documents/R_intro_2019_Fall/2_5 - Merge/Code")


# Install and load packages ####
#install.packages("data.table")
#install.packages("lubridate")
library(data.table)
library(lubridate)

# Read in data ####
myData <- fread("transactions.csv")
CustData <- fread("demographics.csv")

str(myData)
str(CustData)

# Data preparation
# myData[, TransDate:=dmy(TransDate, tz="UTC")]
CustData[, Birthdate:=dmy(Birthdate, tz="UTC")]
str(CustData)
str(myData)

# Part 1: Inner join ####
# ------------------------------------------------------------------------------

# Task 1: Merge transactions and demographics by Customer using an inner join ####
#         for customers born after 1980.
d.1 <- merge(myData, CustData, by="Customer", all=FALSE)[year(Birthdate) >= 1980,]
d.2 <- merge(myData, CustData[year(Birthdate) >= 1980,], by="Customer", all=FALSE) 
identical(d.1, d.2)


# Part 2: outer join ####
# ------------------------------------------------------------------------------

# Task 1:  Merge transactions and demographics by Customer using an outer join ####
#          for customers that purchased in 2008
myData <- fread("transactions.csv")
CustData <- fread("demographics.csv")
myData[, TransDate:=dmy(TransDate, tz="UTC")]

d.1 <- merge(myData, CustData, by="Customer", all=TRUE)[year(TransDate) == 2008,]
d.2 <- merge(myData[year(TransDate) == 2008], CustData, by="Customer", all=TRUE)
identical(d.1, d.2)
d.2
d.2 <- na.omit(d.2)
identical(d.1, d.2)

# Part 3: Left and right outer joins ####
# ------------------------------------------------------------------------------

# Task 1:  Merge transaction and demographics by Customer using an outer left join ####
myData <- fread("transactions.csv")
CustData <- fread("demographics.csv")
myData[, TransDate:=dmy(TransDate, tz="UTC")]

merge(myData, CustData, by="Customer", all.x=TRUE) # "all=F" defines inner join

# Task 2:  Merge transaction and demographics by Customer using an outer right join ####
merge(myData, CustData, by="Customer", all.y=TRUE)

# Task 3: Merge transaction and demographics by "Customer" and by "TransYear " resp. "JoinYear" using an inner join.
myData[,TransYear := year(TransDate)]
CustData[,JoinYear := year(JoinDate)]

merge(myData, CustData, by.x =c("Customer", "TransYear"), 
      by.y=c("Customer", "JoinYear"), all=FALSE)

# Task 4: data.table merge
myData <- fread("toy_myData.csv")
CustData <- fread("toy_CustData.csv")

setkey(myData, "Customer")
setkey(CustData, "Customer")

b1 <- myData[CustData]
b2 <- CustData[myData]
b3 <- myData[CustData, nomatch = 0]

b <- data.table(setdiff(rbind(b1, b2), b3))
setkey(b, "Customer")
# compare with merge
a <- merge(myData, CustData, all = T)
identical(a,b)




