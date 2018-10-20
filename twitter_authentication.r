# https://dev.twitter.com/ 

# Install the newest version of the twitteR package from GitHub
install.packages(c("devtools", "rjson", "bit64", "httr"))

#RESTART R session!

library(devtools)
install_github("twitteR", username="geoffjentry")
library(twitteR)

# find your data
require(twitteR)
 

#library(RCurl)
# Set SSL certs globally
#options(RCurlOptions = list(cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl")))
 

reqURL <- "https://api.twitter.com/oauth/request_token"
accessURL <- "https://api.twitter.com/oauth/access_token"
authURL <- "https://api.twitter.com/oauth/authorize"
apiKey <- "yourAPIkey"
apiSecret <- "yourAPIsecret"

# more about https://developer.twitter.com/en.html


setup_twitter_oauth(apiKey, apiSecret)


