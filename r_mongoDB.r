# install package to connect through monodb
install.packages("rmongodb")
library(rmongodb)
# connect to MongoDB
mongo = mongo.create(host = "localhost")
mongo.is.connected(mongo)

mongo.get.databases(mongo)

mongo.get.database.collections(mongo, db = "tweetDB2") #”tweetDB” is where twitter data is stored

library(plyr)
## create the empty data frame
df1 = data.frame(stringsAsFactors = FALSE)

## create the namespace
DBNS = "tweetDB2.#analytic"

## create the cursor we will iterate over, basically a select * in SQL
cursor = mongo.find(mongo, DBNS)

## create the counter
i = 1

## iterate over the cursor
while (mongo.cursor.next(cursor)) {
# iterate and grab the next record
tmp = mongo.bson.to.list(mongo.cursor.value(cursor))
# make it a dataframe
tmp.df = as.data.frame(t(unlist(tmp)), stringsAsFactors = F)
# bind to the master dataframe
df1 = rbind.fill(df1, tmp.df)
}

dim(df1)