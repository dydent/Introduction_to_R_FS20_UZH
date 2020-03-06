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
#install.packages("corrplot")
library("corrplot")

# Part 4: Create interactive plots

## Correlation plot
file <- "https://github.com/smach/NICAR15data/raw/master/testscores.csv"
testdata <- read.csv(file, stringsAsFactors = FALSE)
ggvis(testdata, ~ pctpoor, ~ score) %>%
  layer_points(size := input_slider(10, 310, label = "Point size"), opacity := input_slider(0, 1, label = "Point opacity")) %>%
  layer_model_predictions(model = "lm", stroke := "red", fill := "red")

# # and for a correlation matrix 
# mycorr <- cor(na.omit(testdata[3:6]))
# col <- colorRampPalette(c("#BB4444", "#EE9988", "#FFFFFF", "#77AADD", "#4477AA"))
# corrplot(mycorr, method = "shade", shade.col = NA, tl.col = "black", tl.srt = 45, col = col(200), addCoef.col = "black")
