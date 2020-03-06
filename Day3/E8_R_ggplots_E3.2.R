#########################################################################################
# Copyright (c) 2016. All rights reserved.  See the file LICENSE for
# license terms.
#########################################################################################

# File: E4_Plots_students.R
# Proj: R Workshop
# Desc: A non-technical introduction to R, 
#       Exercises Part 4, Exercise 3 (2)
# From: http://www.computerworld.com/article/2893271/business-intelligence/5-data-
#       visualizations-in-5-minutes-each-in-5-lines-or-less-of-r.html
# and:  http://blog.revolutionanalytics.com/2016/08/five-great-charts-in-5-lines-of-r-code-each.html
# Date: 2016/09/01
#########################################################################################


# Install and load required packages ####
#install.packages("devtools") 
library("devtools") 
#devtools::install_github("rstudio/leaflet") 
library("leaflet") 
#install.packages("quantmod") 
library("quantmod")
#install.packages("dygraphs") 
library("dygraphs")
#install.packages("ggvis")
library("ggvis")

# Part 2: Plot last 6 months of ABB share price ####
getSymbols("ABB", auto.assign=TRUE) # Tradedata from ABB
barChart(ABB, subset = 'last 6 months')
dev.off()

getSymbols("UBS", auto.assign=TRUE) # Tradedata from UBS
barChart(UBS, subset = 'last 6 months')
dev.off()