# SHORTCUTS #
# --- comment out: ctr shf c ---

### INTRODUCTION TO R ###
### Day 3 ###

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