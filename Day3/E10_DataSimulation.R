#########################################################################################
# Copyright (c) 2019. All rights reserved.  See the file LICENSE for
# license terms.
#########################################################################################

# File: DataSimulation
# Proj: R Intro
# Desc: A Non-Technical Introduction to R 
# Auth: ML, JvO
# Date: 2018
#########################################################################################

# Set working directory ####
setwd("~/Documents/R_intro_2019_Fall/2_10 - Data Simulation/Code")

# Load packages ####
library(data.table)
library(lubridate)
library(randomNames)
library(stringr)

# Part 1: Generating vectors and tables ####
# ------------------------------------------------------------------------------

# Task 1: Simulate a dataset with 1000 customers, whose IDs follow the structure a1:a1000. ####
#         Further this dataset should include the months of 2016 for every customer.
Cust_id <- paste("a",1:1000,sep="")
Month <- seq(dmy("01-01-2016"),dmy("31-12-2016"),by="month")

MyTable <- data.table(expand.grid(Cust_id=Cust_id,Month=Month))

# Part 2: Simulate and manipulate strings ####
# ------------------------------------------------------------------------------

# Task 1: Load the file "demographics.csv" and add a column Names
# with the random names package for each customer.
rm(list = ls())
demo <- fread("demographics.csv")
demo
demo$Names <- randomNames(demo[,.N])
demo


# Task 2: Split the column Names into two columns 
customer.names <- data.table(str_split_fixed(demo$Names,",",2))
setnames(customer.names,c("Last_Name","First_Name")) # check ?setnames for "old" and "new" 

?str_split_fixed
# or we can also use str_split with pattern ", " (a whitespace after comma)

# For str_split_fixed, a character matrix with n columns. 
# For str_split, a list of character vectors.

# Part 3: Use distributions to simulate variables
# ------------------------------------------------------------------------------

# Task1
participants <- fread("participants_list.csv")
setnames(participants,c("first","last"))
?setnames
participants[,name := paste(first,last)]
participants

sample(participants$name,1)

# Task 2
sample(participants$name,5,replace = T)

fruits <- c(
  "apples and oranges and pears and bananas",
  "pineapples and mangos and guavas"
)
str(fruits)

(((str_split(fruits, " and "))))

str_split(fruits, " and ", simplify = TRUE)

a <- c('d','dfd','fdfd','dfdf')
str(a)

# Specify n to restrict the number of possible matches
str_split(fruits, " and ", n = 3)
str_split(fruits, " and ", n = 2)
# If n greater than number of pieces, no padding occurs
str_split(fruits, " and ", n = 5)

# Use fixed to return a character matrix
str_split_fixed(fruits, " and ", 3)
str_split_fixed(fruits, " and ", 4)