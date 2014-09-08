#Download Data Files:
#data.csv:  http://thinktostart.com/data/data.csv
#names.csv:  http://thinktostart.com/data/names.csv

#Load the two files into R:
dataset <- read.csv("data.csv",header=FALSE,sep=";")
names <- read.csv("names.csv",header=FALSE,sep=";")