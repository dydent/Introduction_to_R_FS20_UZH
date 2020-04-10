# SHORTCUTS #
# --- comment out: ctr shf c ---

### INTRODUCTION TO R ###
### Project Session 2 ###
### Tobias Boner 17-707-878 ###


### install packages ###
# install.packages("data.table", version='1.0')
install.packages("data.table")
install.packages("lubridate")
install.packages("ggplot2")
# install.packages("RSQLite")

### load packages ### 
# activate / reload a package - have to activate package before every session
library(data.table)
library(ggplot2)
library(gridExtra)
library(lubridate)
# library(RSQLite)

# get documentation of package
help.search("install.packages")

# get list of installed packages
installed.packages()

### removing a package ###
# remove.packages("data.table")
# remove.packages("lubridatate")


###########################################################################################
###########################################################################################


#####################   Exercise 1   ################################

###########   RFM   ##############

# read in files
trans <- fread("transactions.csv")

# print files
trans

# check
str(trans)

# transform TransDate
trans[, TransDate:=dmy(TransDate, tz="UTC")]

# newest date is 2012-12-09
# select only newest rows
now <- trans[TransDate >= ymd('2012-12-09')]

# compute recency for table now
now[,Recency:= ymd("2020-03-20")-ymd("2012-12-09")]

# compute frequency for table now
now[,Frequency := .N, by = Customer]

# compute monetary value for table now
now[,MV:= sum(PurchAmount),by=Customer]

# create new rfm table
rfm <- now[, list(Customer, Recency, Frequency, MV)]

str(rfm)


#####################   Exercise 2   ################################

# get rfm summary
summary(rfm)

# create plot Recency
rec <- ggplot(rfm, aes(Recency)) + geom_histogram() + ggtitle("Recency Values") +
  xlab("Amount of days") + ylab("Nr of Customers")

# create plot Frequency
frec <- ggplot(rfm, aes(Frequency)) + geom_histogram() +  ggtitle("Frequency Values") +
  xlab("Amount of Purchases") + ylab("Nr of Customers")

# create plot MV
mv <- ggplot(rfm, aes(MV)) + geom_histogram() +  ggtitle("Monetary Values") +
  xlab("Total Value of Purchases") + ylab("Nr of Customers")

# arrange plots
grid.arrange(rec, frec, mv)

