#########################################################################################
# Copyright (c) 2017. All rights reserved.  See the file LICENSE for
# license terms.
#########################################################################################

# File: E4_R_ggplots.R
# Proj: R Workshop
# Desc: A non-technical introduction to R, 
#       Exercises Part 4
# Auth: ML, JvO
# Date: 2017
#########################################################################################

# Set working directory
# setwd("")
setwd("~/Dropbox/R_intro_2020_FS/2_8 - ggplots/Code")


# Install and load packages
#install.packages("data.table")
library(ggplot2)
library(data.table)
library(lubridate)

# Data preparation
myData <- fread("Day3/transactions.csv")
myData[, TransDate:=dmy(TransDate, tz = "UTC")]

# Take a sample, if desired
myData <- myData[sample(nrow(myData), 10000), ]
myData


# Part 1: ggplot basics ####
# ------------------------------------------------------------------------------

# Task 1: Create a histogram of PurchAmount with ggplot 
ggplot(myData, aes(PurchAmount)) +   geom_histogram() +
  ggtitle("Histogram of Purchase Amount")
dev.off()

# Avoid warning using binwidth, which specifies bin range 
ggplot(myData, aes(PurchAmount)) +   geom_histogram(binwidth = 40) +
  ggtitle("Histogram of Purchase Amount") 
dev.off()

# Task 2: Create a scatter plot with smooth curve for PurchAmount (x) and Cost (y) ####
ggplot(myData, aes(PurchAmount, Cost)) + geom_point() +
  xlab("Purchase Amount") + ylab("Cost") + ggtitle("Cost by Purchase Amount" )
dev.off()

# Add plots next to each other
# Install additional package gridExtra to adjust the layout
#install.packages("gridExtra")
library(gridExtra)

# Store your plots in an object, e.g. a and b
a <- ggplot(myData, aes(PurchAmount)) +   geom_histogram(binwidth = 40) +
  ggtitle("Histogram of Purchase Amount") +
  xlab("Purchase Amount")

# Task 2: Create a scatter plot with smooth curve for PurchAmount (x) and Cost (y) ####
b <- ggplot(myData, aes(PurchAmount, Cost)) + geom_point() +
  xlab("Purchase Amount") + ylab("Cost") + ggtitle("Cost by Purchase Amount" )

# use the grid.arrange command to adjust the layout and ncol to define the number of columns
grid.arrange(a, b, ncol=2)
dev.off()

# Part 2: Color palettes, themes, and style ####
# ------------------------------------------------------------------------------

# Task 1: Download wesanderson color palettes ####
install.packages("wesanderson")
library(wesanderson)

# Download ggthemes ####
install.packages("ggthemes")
library(ggthemes)

# Task 2: Define a third dimension based on the variable Quantity 
#         and use the palette "Cavalcanti1" to illustrate this dimension. 
ggplot(myData, aes(PurchAmount, Cost, color= Quantity)) +   
  geom_point(size=2) + 
  ggtitle("Costs by Purchase Amount") +  
  xlab("Purchase Amount") + ylab("Costs") +
  scale_colour_gradientn(colours= wes_palette("Cavalcanti1")) 
dev.off()

# Part 3: Advance plotting topics ####
# ------------------------------------------------------------------------------

# See extra RCode file
