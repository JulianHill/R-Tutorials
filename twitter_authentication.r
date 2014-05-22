# https://dev.twitter.com/ 




require(twitteR)
 
library(RCurl)
# Set SSL certs globally
options(RCurlOptions = list(cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl")))
 

reqURL <- "https://api.twitter.com/oauth/request_token"
accessURL <- "https://api.twitter.com/oauth/access_token"
authURL <- "https://api.twitter.com/oauth/authorize"
apiKey <- "yourAPIkey"
apiSecret <- "yourAPIsecret"
 
twitCred <- OAuthFactory$new(consumerKey=apiKey,consumerSecret=apiSecret,requestURL=reqURL,accessURL=accessURL,authURL=authURL)
 
twitCred$handshake(cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl"))
 
registerTwitterOAuth(twitCred)