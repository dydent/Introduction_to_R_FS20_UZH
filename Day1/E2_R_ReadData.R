#########################################################################################
# Copyright (c) 2016. All rights reserved.  See the file LICENSE for
# license terms.
#########################################################################################

# File: E2_ReadData_students.R
# Proj: R Workshop
# Desc: A non-technical introduction to R, 
#       Exercises Part 2
# Auth: ML, JvO
# Date: 2017
#########################################################################################

# Part 1: Read and write data ####
# ------------------------------------------------------------------------------

library(data.table)

# Task 1: Set working directory
setwd("")
 
# Task 2: If necessary: Create csv file from the Excel-File ####
# Go to Excel: Save file as ".csv"

# Task 3: Read in the csv-file ####
fread("transactions.csv")

# Make the data available for further use (name it myData) ####
myData <- fread("transactions.csv")


# Part 2: Basic investigation of your data ####
# ------------------------------------------------------------------------------

# Install and load "lubridatate" ####
# install.packages("lubridate")
library(lubridate)

# Task 1: Look at your data provided from the previous exercise####
myData
head(myData)
tail(myData)
View(myData)
summary(myData)
str(myData)

# Task 2: Use the lubridate package to format the TransDate column####
myData[, TransDate:=dmy(TransDate, tz="UTC")]

# Task 3: Use str() to see if the change was made correctly####
str(myData)

# Task 4: Save the data.table object to a csv-file with the name
# "transactions_students_backup.csv".
fwrite(myData, "transactions_students_backup.csv")


# Part 3: Connect to a database ####
# ------------------------------------------------------------------------------

# Install and load RSQLite 
# install.packages("RSQLite")
library(RSQLite)

# Build connection
con <- dbConnect(drv=RSQLite::SQLite(), dbname="database.sqlite")

# Task 1: Find availible tables that are in the database ###
dbListTables(con)

# Task 2: Lists all variables of the table demographics.  ####
dbListFields(con, "demographics")

# Task 3: Store myData in the database and name it myData_copy  ####
dbWriteTable(con, "myData_copy", myData)
dbListTables(con) # Check if table was actually added

# Task 4: Remove myData from the database  ####
dbRemoveTable(con, "myData_copy")	
dbListTables(con) # Check if table was actually removed

#Close connection ####
dbDisconnect(con)
