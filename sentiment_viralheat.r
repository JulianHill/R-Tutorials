library(twitteR)
library(RCurl)
library(RJSONIO)
library(stringr)

getSentiment <- function (text, key){
library(RCurl);
library(RJSONIO);
 
text <- URLencode(text);
 
#save all the spaces, then get rid of the weird characters that break the API, then convert back the URL-encoded spaces.
text <- str_replace_all(text, "%20", " ");
text <- str_replace_all(text, "%\\d\\d", "");
text <- str_replace_all(text, " ", "%20");
 
if (str_length(text) > 360){
text <- substr(text, 0, 359);
}
 
data <- getURL(paste("https://www.viralheat.com/api/sentiment/review.json?api_key=", key, "&text=",text, sep=""))
 
js <- fromJSON(data, asText=TRUE);
 
# get mood probability
score = js$prob
 
# positive, negative or neutral?
if (js$mood != "positive")
{
if (js$mood == "negative") {
score = -1 * score
} else {
# neutral
score = 0
}
}
 
return(list(mood=js$mood, score=score))
}

clean.text <- function(some_txt)
{
some_txt = gsub("(RT|via)((?:\\b\\W*@\\w+)+)", "", some_txt)
some_txt = gsub("@\\w+", "", some_txt)
some_txt = gsub("[[:punct:]]", "", some_txt)
some_txt = gsub("[[:digit:]]", "", some_txt)
some_txt = gsub("http\\w+", "", some_txt)
some_txt = gsub("[ \t]{2,}", "", some_txt)
some_txt = gsub("^\\s+|\\s+$", "", some_txt)
 
# define "tolower error handling" function
try.tolower = function(x)
{
y = NA
try_error = tryCatch(tolower(x), error=function(e) e)
if (!inherits(try_error, "error"))
y = tolower(x)
return(y)
}
 
some_txt = sapply(some_txt, try.tolower)
some_txt = some_txt[some_txt != ""]
names(some_txt) = NULL
return(some_txt)
}

# harvest tweets
tweets = searchTwitter("iphone5", n=200, lang="en")

tweet_txt = sapply(mc_tweets, function(x) x$getText())
tweet_clean = clean.text(tweet_txt)
mcnum = length(tweet_clean)
tweet_df = data.frame(text=tweet_clean, sentiment=rep("", mcnum), score=1:mcnum, stringsAsFactors=FALSE)

sentiment = rep(0, mcnum)
for (i in 1:mcnum)
{
tmp = getSentiment(tweet_clean[i], "API-KEY")
tweet_df$sentiment[i] = tmp$mood
tweet_df$score[i] = tmp$score
}

tweet_df