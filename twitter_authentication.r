# https://dev.twitter.com/ 




require(twitteR)
 
reqURL <- "https://api.twitter.com/oauth/request_token"
 
accessURL <- "http://api.twitter.com/oauth/access_token"
 
authURL <- "http://api.twitter.com/oauth/authorize"
 
consumerKey <- "CONSUMER_KEY"
 
consumerSecret <- "CONSUMER_SECRET"
 
twitCred <- OAuthFactory$new(consumerKey=consumerKey,consumerSecret=consumerSecret,requestURL=reqURL,accessURL=accessURL,authURL=authURL)
 
download.file(url="http://curl.haxx.se/ca/cacert.pem", destfile="cacert.pem")
 
twitCred$handshake(cainfo="cacert.pem")
 
registerTwitterOAuth(twitCred)