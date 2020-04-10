# SHORTCUTS #
# --- comment out: ctr shf c ---

### INTRODUCTION TO R ###
### Day 1 ###

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


###########################################################################################
###########################################################################################


# read in file
fread("transactions.csv")

# write file
fwrite(transaction_data, "myNewFile.csv")

# list all csv files in directory
list.files(pattern="*.csv")

# get you working directory 
getwd()

# set your working directory
setwd("C:/Users/tobia/OneDrive/Dokumente/CODE/UZH/R_Introduction")

# use variable
transaction_data = fread("transactions.csv")

# print data
transaction_data
print(transaction_data)

# print specific row / column
transaction_data[1, TransID]

# first data entries
head(transaction_data, n=2)

# last data entries
tail(transaction_data, n=11)

# display structure of R object
str(transaction_data)

# transform / format data column
transaction_data[, TransDate:=dmy(TransDate, tz="UTC")]


###########################################################################################
###########################################################################################

# open database connection
con <- dbConnect(drv = RSQLite::SQLite(), dbname = "database.sqlite")

# get available tables
dbListTables(conn = con)

# dbt <- dbReadTable(conn = con, name = "transactions")
# str(dbt)
transaction_data[, Customer][10:20]
transaction_data[0]

dbWriteTable(conn = con, name="transactions", value=transaction_data)

dbRemoveTable(conn = con, name="transactions")

transaction_data[1:14, ]
sack <- transaction_data[c(1:3, 5:8)]


nrow(transaction_data)
ncol(transaction_data)
nchar(transaction_data)
length(c(1:19, 5))


transaction_data[order(Cost)]
transaction_data[order(TransDate) & head(1)]

transaction_data[Cost == 5,]
(transaction_data[Cost >10 & TransDate == ymd('2007-03-12'),])
transaction_data[, list(TransDate,Customer)]


xxx <- transaction_data[1:100]
xxx[, list(Customer, TransDate, Quantity)]
yyy <- xxx[PurchAmount >= 100 & PurchAmount <= 200, list(Customer, TransDate)]
yyy[order(TransDate, decreasing = TRUE)]


transaction_data[, sum(Cost), by=Customer]
transaction_data
transaction_data[, list(Sack=sum(Cost)), by=Customer]

xxx <- copy(transaction_data)

xxx[, sack:=sum(PurchAmount), by=list(Customer, TransDate)]
xxx[, count(TransID), by]
