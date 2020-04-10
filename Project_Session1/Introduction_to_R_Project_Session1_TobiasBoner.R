# SHORTCUTS #
# --- comment out: ctr shf c ---

### INTRODUCTION TO R ###
### Project Session 1 ###
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


#####################   TASK 1   ################################

###########   1 a)   ##############

# read in files
ind <- fread("industries.csv", header = TRUE) # header= TRUE so first row is assigned as header
prod <- fread("products.csv")

# print files
prod
ind

# # merge files with left outer join to loose no data
# # only columns "Seller" and "Industry" are needed
# data <- merge(prod, ind[, c("Seller", "Industry")], by="Seller", all.x = TRUE)

# merge data with full outer join to loose no data at all
# only columns "Seller" and "Industry" are needed
full_data <- merge(prod, ind[, c("Seller", "Industry")], by="Seller", all = TRUE)

# print data frames
# data
full_data

# check information for data 
# str(data)
str(full_data)

###########   1 b)   ##############

# to still see missing values you can do a full outer join of the two data frames



#####################   TASK 2  ################################

###########   2.1   ##############

# graphical overview
hist(full_data[ ,Sales_Opportunity_in_Mio])
plot(density(full_data[, Sales_Opportunity_in_Mio]))

# numeric overview
summary(full_data)
density(full_data[, Sales_Opportunity_in_Mio])


###########   2.2   ##############

# aggregate nr of prodcuts per industry
full_data[, nr_prod := .N , by= Industry]

# print data
full_data

# plot data 
# barplot(height=full_data$nr_prod, names=data$Industry)
ggplot(full_data, aes(Industry, nr_prod)) + geom_point()

# -> Trading industry sells the most products

###########   2.3   ##############

# polt additional dimension of Status in color
ggplot(full_data, aes(Industry, nr_prod, color = Status)) + geom_point()



#####################   TASK 3  ################################


###########   3.1   ##############

# create binary columns for correlation between Competitors and Status
full_data$bin_compet <- ifelse(full_data$Competitors == "Yes", 1,
                               ifelse(full_data$Competitors =="No",0,-1))

full_data$bin_win <- ifelse(full_data$Status == "Won", 1,
                            ifelse(full_data$Status =="Lost",0,-1))

# print data
full_data

# compute correlation
cor(full_data$bin_compet==1,full_data$bin_win==1)

#  -> Interpreation of Corrleation = -0.4066365
## --> negative correlation between Competitors and Status which means if you have no competitors you have higher chance to win


###########   3.2   ##############

my_function <- function(data){
  # only rows which have won
  data <- data[Status=="Won"]
  # get sum by seller
  sum_by_seller <- data[, sum(Sales_Opportunity_in_Mio), by=Seller]
  # sort descdending by seller
  # --> not done
  # return table
  return(sum_by_seller)
}

# call function
my_function(full_data)

