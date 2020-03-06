#########################################################################################
# Copyright (c) 2016. All rights reserved.  See the file LICENSE for
# license terms.
#########################################################################################

# File: E4_R_ggplots_E3.R
# Proj: R Workshop
# Desc: A non-technical introduction to R, 
#       Exercises Part 4, Exercise 3 (1)
# From: http://www.computerworld.com/article/2893271/business-intelligence/5-data-
#       visualizations-in-5-minutes-each-in-5-lines-or-less-of-r.html
# and:  http://blog.revolutionanalytics.com/2016/08/five-great-charts-in-5-lines-of-r-code-each.html
# Date: 2016/09/01
#########################################################################################


# Install and load required packages ####
#install.packages("devtools") 
library("devtools") 
#devtools::install_github("rstudio/leaflet") 
#install.packages("leaflet")
library("leaflet") 
#install.packages("quantmod") 
library("quantmod")
#install.packages("TTR") 
library("TTR")
#install.packages("dygraphs") 
library("dygraphs")
#install.packages("ggvis")
library("ggvis")

## Part 1:Plot all Starbucks locations using OpenStreetMap ####
download.file("https://opendata.socrata.com/api/views/ddym-zvjk/rows.csv?accessType=DOWNLOAD", "starbucks.csv", method = "curl")
starbucks <- read.csv("starbucks.csv") 

leaflet() %>% addTiles() %>% setView(-84.3847, 33.7613, zoom = 16) %>%
  addMarkers(data = starbucks, lat = ~ Latitude, lng = ~ Longitude, popup = starbucks$Name)

# Additionally:
# Use Oerlikon coordinates: no Starbucks data availible
leaflet() %>% addTiles() %>% setView(8.544459, 47.410281, zoom = 16) %>% 
  addMarkers(data = starbucks, lat = ~ Latitude, lng = ~ Longitude, popup = starbucks$Name)
