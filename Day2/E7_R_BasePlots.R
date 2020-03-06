#########################################################################################
# Copyright (c) 2017. All rights reserved.  See the file LICENSE for
# license terms.
#########################################################################################

# File: E3_R_BasePlots.R
# Proj: R Workshop
# Desc: A non-technical introduction to R, 
#       Exercises Part 3
# Auth: ML, JvO
# Date: 2017
#########################################################################################

# Set working directory ####
# setwd("")
setwd("~/Dropbox/R_intro_2020_FS/2_7 - Plots/Code")

# Install and load "data.table ####
#install.packages("data.table")
#install.packages("lubridate")
library(data.table)
library(lubridate)

# Read in data ####
# myData <- fread("transactions.csv")
myData <- fread("transactions.csv",nrows = 10000) # only read in the first 10000 rows

# you can also subset your original data by using 
myData <- myData[1:10000]

# Part 1: Generate plots with base R (1/3) ####
# ------------------------------------------------------------------------------

# Task 1: Create a histogram for the variable Quantity (x)

# check class quantity
class(myData$Quantity)

# if not numeric, change class (re-run check class)
myData[,Quantity := as.numeric(Quantity)]

# create histogram
hist(myData$Quantity) # use either $ or the data.table way (dt[,columnname]) to select a column
#dev.off()

#the breaks are the cut-off points for the bins
hist(myData$Quantity, breaks = 5) # use either $ or the data.table way (dt[,columnname]) to select a column
#dev.off()

# Task 2: Create a scatter plot for the sum of PurchAmount (y) across years for each customer ####
myData[, TransDate:= dmy(TransDate, tz="UTC")]
myData_2 <- myData[, .(PurchSum = sum(PurchAmount)), by=.(Customer, year(TransDate))]
plot(x = myData_2[, year], y = myData_2[,PurchSum])
#dev.off()

# Part 2: Generate plots with base R (2/3) ####
# ------------------------------------------------------------------------------

# Task 1: Format your earlier scatter plots ####
# Example solution for first plot:
plot(x=myData_2[, year], y=myData_2[,PurchSum], xlab="Time in years", ylab="Sum of purchases", 
     main="Sum of Purchases Across Years", pch= 21, bg= rgb(red = 0, green = 0, blue = 1, alpha = 0.5),
     cex=1.5, cex.lab=1.3, cex.main=1.5, cex.axis=1, font.main=2)
#dev.off()

# Part 3: Generate plots with base R (3/3) ####
# ------------------------------------------------------------------------------

#Task 1: Add a legend to your plot ####
plot(x=myData_2[, year], y=myData_2[,PurchSum], xlab="Time in years", ylab="Sum of purchases", 
     main="Sum of purchases across years", pch= 21, bg= rgb(red = 0, green = 0, blue = 1, alpha = 0.5),
     cex=1.5, cex.lab=1.3, cex.main=1.5, cex.axis=1, font.main=2)
legend("topright", "customer revenue", lty= c(0,1), pch= 21, 
       pt.bg= rgb(red = 0, green = 0, blue = 1))

#Task 2: Add a line horizontal to your plot to indicate the aggregated purchase of > 3000 ####
plot(x=myData_2[, year], y=myData_2[,PurchSum], xlab="Time in years", ylab="Sum of purchases", 
     main="Sum of purchases across years", pch= 21, bg= rgb(red = 0, green = 0, blue = 1, alpha = 0.5),
     cex=1.5, cex.lab=1.3, cex.main=1.5, cex.axis=1, font.main=2)
segments(2004,3000,2012,3000, col="darkgreen")

# Alternatively:
abline(h=3000, col= "darkblue", lty=3)

#Task 3: Export your final plot as a pdf using the console ####
pdf("myPlot.pdf") 
# pdf starts the graphics device driver for producing PDF graphics
# alternatively you can use png("myPlot.png") to save it as image
plot(x=myData_2[, year], y=myData_2[,PurchSum], xlab="Time in years", ylab="Sum of purchases", 
     main="Sum of purchases across years", pch= 21, bg= rgb(red = 0, green = 0, blue = 1, alpha = 0.5),
     cex=1.5, cex.lab=1.3, cex.main=1.5, cex.axis=1, font.main=2)
legend("topright", "customer revenue", lty= c(0,1), pch= 21, 
       pt.bg= rgb(red = 0, green = 0, blue = 1))
dev.off() # closes the opened graphic device

#Task 4: Export your final plot as a png using the R Studio Gui ####
plot(x=myData_2[, year], y=myData_2[,PurchSum], xlab="Time in years", ylab="Sum of purchases", 
     main="Sum of purchases across years", pch= 21, bg= rgb(red = 0, green = 0, blue = 1, alpha = 0.5),
     cex=1.5, cex.lab=1.3, cex.main=1.5, cex.axis=1, font.main=2)
legend("topright", "customer revenue", lty= c(0,1), pch= 21, 
       pt.bg= rgb(red = 0, green = 0, blue = 1))

# (1) Use "Export" in your "Plots" window
# (2) Select "Save as image..."
# (3) Select a directory where you want to save your plot
# (4) Give your plot an appropriate name 
# (5) Click "Save"

# Task 5: Plot the histogram of Purchase Amount and the "Cost by Purchase Amount" plot in the same image.
par(mfrow = c(1, 2))
hist(myData[, PurchAmount],xlab="Purchase Amount",main="Histogram Purchase Amount",
     cex=1.5, cex.lab=1.3, cex.main=1.5, cex.axis=1, font.main=2)
plot(x=myData_2[, year], y=myData_2[,PurchSum], xlab="Time in years", ylab="Sum of purchases", 
     main="Sum of purchases across years", pch= 21, bg= rgb(red = 0, green = 0, blue = 1, alpha = 0.5),
     cex=1.5, cex.lab=1.3, cex.main=1.5, cex.axis=1, font.main=2)
# par(mfrow = c(1, 1))

