# SHORTCUTS #
# --- comment out: ctr shf c ---

### INTRODUCTION TO R ###
### Day 2 ###

### install packages ###
# install.packages("data.table", version='1.0')
install.packages("data.table")
install.packages("lubridate")
install.packages("RSQLite")

### load packages ### 
# activate / reload a package - have to activate package before every session
library(data.table)
library(lubridate)
library(RSQLite)

# get documentation of package
help.search("install.packages")

# get list of installed packages
installed.packages()

### removing a package ###
# remove.packages("data.table")
# remove.packages("lubridatate")

# get you working directory 
getwd()

# set your working directory
# setwd("C:/Users/tobia/OneDrive/Dokumente/CODE/UZH/R_Introduction")

# list all csv files in directory
list.files(path = "C:/Users/tobia/OneDrive/Dokumente/CODE/UZH/R_Introduction/Day2/Ex6", pattern="*.csv")

# open database connection
con <- dbConnect(drv = RSQLite::SQLite(), dbname = "database.sqlite")

# get available tables
dbListTables(conn = con)

###########################################################################################
###########################################################################################


demo <- fread("C:/Users/tobia/OneDrive/Dokumente/CODE/UZH/R_Introduction/Day2/Ex5/demographics.csv")

trans <- fread("C:/Users/tobia/OneDrive/Dokumente/CODE/UZH/R_Introduction/Day2/Ex5/transactions.csv")



trans[, list(x=sum(PurchAmount)), by="Customer"]


dbGetQuery(con,"SELECT *
           FROM trans;") # Show all data
dbGetQuery(con,"SELECT  Count(Customer DISTINCT)
           FROM demo;") # Show all data
