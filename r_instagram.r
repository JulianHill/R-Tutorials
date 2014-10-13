#Analyze Instagram with R
#Author: Julian Hillebrand

#packages
require(httr)
require(rjson)
require(RCurl)


#Authentication

## getting callback URL
full_url <- oauth_callback()
full_url <- gsub("(.*localhost:[0-9]{1,5}/).*", x=full_url, replacement="\\1")
#message <- paste("Copy and paste into Site URL on Instagram App Settings:", 
 #                full_url, "\nWhen done, press any key to continue...")

invisible(readline(message))

app_name <- "ThinkToStartTest"
client_id <- "7d6f1b8df18f41349ac5ef4be32d1789"
client_secret <- "e0eea8134949438199e102760286efc7"
scope = "basic"



instagram <- oauth_endpoint(
  authorize = "https://api.instagram.com/oauth/authorize",
  access = "https://api.instagram.com/oauth/access_token")  
myapp <- oauth_app(app_name, client_id, client_secret)

#scope <- NULL
ig_oauth <- oauth2.0_token(instagram, myapp,scope="basic",  type = "application/x-www-form-urlencoded",cache=FALSE)  
tmp <- strsplit(toString(names(ig_oauth$credentials)), '"')
token <- tmp[[1]][4]

########################################################

username <- "therock"

#search for the username
user_info <- fromJSON(getURL(paste('https://api.instagram.com/v1/users/search?q=',username,'&access_token=',token,sep="")),unexpected.escape = "keep")

received_profile <- user_info$data[[1]]

if(grepl(received_profile$username,username))
{
  user_id <- received_profile$id
  #Get recent media (20 pictures)
  media <- fromJSON(getURL(paste('https://api.instagram.com/v1/users/',user_id,'/media/recent/?access_token=',token,sep="")))
  
  
  df = data.frame(no = 1:length(media$data))
  
  for(i in 1:length(media$data))
  {
    #comments
    df$comments[i] <-media$data[[i]]$comments$count
    
    #likes:
    df$likes[i] <- media$data[[i]]$likes$count
    
    #date
    df$date[i] <- toString(as.POSIXct(as.numeric(media$data[[i]]$created_time), origin="1970-01-01"))
  }
  
  #Visualization
  
  require(rCharts)
  
  m1 <- mPlot(x = "date", y = c("likes", "comments"), type = "Line", data = df)
  
  
}else
{
  print("Error: User not found!")
}
