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
list.files(path = "C:/Users/tobia/OneDrive/Dokumente/CODE/UZH/R_Introduction/Day2/Ex5", pattern="*.csv")

###########################################################################################
###########################################################################################

demo <- fread("C:/Users/tobia/OneDrive/Dokumente/CODE/UZH/R_Introduction/Day2/Ex5/demographics.csv")

demo[, Birthdate:=dmy(Birthdate, tz="UTC")]
demo
str(demo)
demo[, JoinDate:=ymd(JoinDate, tz="UTC")]

trans[, TransDate :=dmy(TransDate, tz="UTC")]



trans <- fread("C:/Users/tobia/OneDrive/Dokumente/CODE/UZH/R_Introduction/Day2/Ex5/transactions.csv")

trans
nrow(trans)

custdemo
nrow(custdemo)

str(trans)
str(demo)
# open database connection
con <- dbConnect(drv = RSQLite::SQLite(), dbname = "database.sqlite")

# get available tables
dbListTables(conn = con)

dbWriteTable(conn = con, name="trans", value=transaction_data)

dbWriteTable(conn = con, name="demo", value=transaction_data)

dbListTables(conn = con)

trans[,TransYear := year(TransDate)]
demo[,JoinYear := year(JoinDate)]

# inner join
innerjoin <- merge(demo, trans, by.x = c("Customer", "JoinYear"), by.y = c("Customer", "TransYear"), all = FALSE)
innerjoin
innerjoin[0:20]
str(innerjoin)
innerjoin[is.na(Birthdate)]
nrow(innerjoin[is.na(Birthdate)])
nrow(innerjoin[!is.na(Birthdate)])


# full outerjoin
outerjoin <- merge(custdemo[year(Birthdate) > 1980], trans, by="Customer", all = TRUE)
outerjoin[0:20]
str(outerjoin)
nrow(outerjoin[is.na(Birthdate)])
nrow(outerjoin[!is.na(Birthdate)])


# left outer join x
leftjoin <- merge(custdemo[year(Birthdate) > 1980], trans, by="Customer", all.x = TRUE)
allleftjoin <- merge(custdemo, trans, by="Customer", all.x =TRUE )
leftjoin[0:20]
str(leftjoin)
nrow(leftjoin)
nrow(allleftjoin)
allleftjoin
nrow(leftjoin[is.na(Birthdate)])
nrow(leftjoin[!is.na(Birthdate)])


# right outer join y
rightjoin <- merge(custdemo[year(Birthdate) > 1980], trans, by="Customer", all.y = TRUE)
rightjoin[0:20]
str(rightjoin)
nrow(rightjoin)
nrow(rightjoin[is.na(Birthdate)])
nrow(rightjoin[!is.na(Birthdate)])

demo[trans, on="Customer", nomatch=NA]

trans[demo]
