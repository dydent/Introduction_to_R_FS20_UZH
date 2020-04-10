# Modu: R - A nontechnical Introduction
# Exercise: Network plots
# Auth: Claudia Wenzel
# Date: 2019/01/09
###################################################################################################

#load libraries
install.packages("data.table")
install.packages("igraph")
install.packages("igraphdata")
install.packages("SOMbrero")
library(data.table)
library(igraph)
library(igraphdata)
library(SOMbrero)

### Excercise 1 ####
#1.
data(UKfaculty)
UKfaculty # is is a directed and weighted network

#2. 
get.adjacency(UKfaculty, attr = "weight")
cbind(get.edgelist(UKfaculty), E(UKfaculty)$weight)
# check entries in matrix and elist
head(cbind(get.edgelist(UKfaculty), E(UKfaculty)$weight))
as.matrix(get.adjacency(UKfaculty, attr = "weight"))[52,57]

### Excercise 2 ####
sub.UK <- induced_subgraph(UKfaculty, V(UKfaculty)[1:20])

#a) undirected and unweighted
plot(as.undirected(sub.UK, mode="collapse"), layout=layout.circle)

#b) directed and unweighted
plot(sub.UK,layout=layout.davidson.harel)

#c) undirected and weighted
plot(as.undirected(sub.UK, mode="collapse"),
                   edge.width = E(sub.UK)$weight, layout= layout.fruchterman.reingold)

#d) directed and weighted
plot(sub.UK, edge.width = E(sub.UK)$weight, layout=layout_with_mds)

### Excercise 3 ####
length(V(UKfaculty))
sub.UK <- induced_subgraph(UKfaculty, V(UKfaculty)[57:81])

# look at the features of the graph
sub.UK
table(V(sub.UK)$Group)

set.seed(5)
plot(sub.UK, 
     vertex.size = degree(sub.UK)*2,
     vertex.shape = ifelse(degree(sub.UK)>4,
                           "circle", "square"),
     vertex.color = V(sub.UK)$Group,
     vertex.label.family = "Helvetica",
     vertex.label.cex = degree(sub.UK)/10,
     vertex.label.color = "black",
     edge.color = ifelse(E(sub.UK)$weight>4,
                         "red", "grey"), 
     edge.arrow.width = 0.75,
     edge.arrow.size = 0.35)
