library(RCurl)
library(rjson)

database = "tweetDB"
collection = "Apple"
limit = "100"
db <- paste("http://localhost:28017/",database,"/",collection,"/?limit=",limit,sep = "")

tweets <- fromJSON(getURL(db))

tweet_df = data.frame(text=1:limit)
for (i in 1:limit){
tweet_df$text[i] = tweets$rows[[i]]$tweet_text}
tweet_df
