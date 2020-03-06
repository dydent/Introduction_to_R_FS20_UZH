#########################################################################################
# Copyright (c) 2020. All rights reserved.  See the file LICENSE for
# license terms.
#########################################################################################
# File: SQL.R
# Proj: R Workshop
# Desc: A non-technical introduction to R, 
#########################################################################################
#Set working directory ####
setwd("~/Documents/R_intro_2020/LE6/Code")

#Install multiple packages at once ####
library(lubridate)
library(RSQLite)


# Exercise - Part 1 ####

# 1. Open a connection to the database and write the
# dbGetQuery() command to show all the data.
con <- dbConnect(RSQLite::SQLite(), "database.sqlite") # Open the connection

dbListTables(conn = con)

dbGetQuery(con,"SELECT *
           FROM transactions;") # Show all data
dbGetQuery(con,"SELECT *
           FROM demographics;") # Show all data

# 2. Show the IDs of all customers who purchased on 06.06.2012.
# How many customers purchased on that date?
dbGetQuery(con, "SELECT Customer
           FROM transactions
           WHERE TransDate='2012-06-06 00:00';")

dbGetQuery(con, "SELECT DISTINCT Customer
           FROM transactions
           WHERE TransDate='2012-06-06 00:00';")

# 3. Calculate the new variable NetSales, which is the difference between purchase amount
# and cost per transaction. Check your results by taking a look at the whole table.
dbGetQuery(con, "ALTER TABLE transactions
           ADD NetSales;") # Add empty column
dbGetQuery(con, "UPDATE transactions
           SET NetSales = PurchAmount-Cost;") # Set values
dbGetQuery(con,"SELECT *
           FROM transactions 
           LIMIT 3;")

dbDisconnect(con)

# Exercise - Part 2 ####
con <- dbConnect(RSQLite::SQLite(), "database.sqlite") # Open the connection

# 1. Show for each customer the latest transaction date (LatestPurch) as well as the 
# maximum purchase amount per transaction (MaxPurch).
dbGetQuery(con, "SELECT Customer, MAX(TransDate) AS LatestPurch, MAX(PurchAmount) AS MaxPurch
                 FROM transactions
                 GROUP BY Customer;")

dbGetQuery(con, "SELECT Customer, MAX(TransDate) AS LatestPurch, MAX(PurchAmount) AS MaxPurch
           FROM transactions
           GROUP BY Customer
           LIMIT 5;")

# 2. Calculate the average purchase amount (AvgPurch) and average cost (AvgCost) per year.
dbGetQuery(con, "SELECT DATE(TransDate, 'start of year') AS Year, AVG(PurchAmount) AS AvgPurch, AVG(Cost) AS AvgCost
                 FROM transactions
                 GROUP BY DATE(TransDate, 'start of year')")

# transactions <- data.table(dbGetQuery(con,"SELECT * FROM transactions;"))
# transactions[, TransDate:=ymd_hm(TransDate)]
# setkey(transactions, TransDate)
# transactions[, list(AvgPurch = mean(PurchAmount), AvgCost = mean(Cost)), 
#             by = (date = floor_date(TransDate, unit="year"))]

# 3. Write a query for a table that shows the number of transactions (Transactions) and
# the average purchase amount (AvgPurch) per customer per month.
dbGetQuery(con, "SELECT Customer, DATE(TransDate, 'start of month') AS Date, 
                        count(*) AS Transactions, AVG(PurchAmount) AS AvgPurch
                 FROM transactions
                 GROUP BY Customer, DATE(TransDate, 'start of month')
                 LIMIT 5;")

# transactions <- data.table(dbGetQuery(con,"SELECT * FROM transactions;"))
# transactions[, TransDate:=ymd_hm(TransDate)]
# setkey(transactions, Customer, TransDate)
# transactions[1:5, list(Transactions = .N, AvgPurch = mean(PurchAmount)),
#             by = list(Customer, date = floor_date(TransDate, unit="month"))]

dbDisconnect(con)

# Exercise - Part 3 ####

# 1. Join all transactions with the demographic details of the corresponding customers.
# What is the share of female customers in the overall purchase amount?

con <- dbConnect(RSQLite::SQLite(), "database.sqlite") # Open the connection

join_1 <- data.table(dbGetQuery(con, "SELECT * FROM transactions
                     INNER JOIN demographics
                     ON transactions.Customer=demographics.Customer;"))

join_1[Gender=='f',sum(PurchAmount)]/join_1[,sum(PurchAmount)]


dbGetQuery(con, "SELECT SUM(PurchAmount) / (SELECT SUM(PurchAmount) FROM transactions) AS 'ratio'
                     FROM transactions
                     INNER JOIN demographics
                     ON transactions.Customer=demographics.Customer
                     WHERE demographics.Gender = 'f';")


dbGetQuery(con, "SELECT SUM(PurchAmount) / (SELECT SUM(PurchAmount) FROM transactions INNER JOIN demographics
                     ON transactions.Customer=demographics.Customer) AS 'ratio'
                     FROM transactions
                     INNER JOIN demographics
                     ON transactions.Customer=demographics.Customer
                     WHERE demographics.Gender = 'f';")


# 2. Merge the transaction and the demographic data in a way, that the resulting table only shows
# the transactions on the day the customer joined the company.
dbGetQuery(con, "SELECT * FROM transactions
           INNER JOIN demographics
           ON transactions.Customer=demographics.Customer 
           AND TransDate=JoinDate
           LIMIT 5;")

dbDisconnect(con)
