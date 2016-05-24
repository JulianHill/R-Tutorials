# Pinterest

#Analyze Pinterest with R
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

app_name <- "R Test"
client_id <- "XXX"
client_secret <- "XXX"
scope = "read_public"
redirect_uri="https://mywebsite.com/connect/pinterest/"

https://api.pinterest.com/oauth/?
response_type=code&
  redirect_uri=https://mywebsite.com/connect/pinterest/&
  client_id=12345&
  scope=read_public,write_public&
  state=768uyFys

user_info <- fromJSON(getURL(paste("https://api.pinterest.com/oauth?response_type=code&client_id=",client_id,"&scope=",scope,sep="")),unexpected.escape ="keep")

paste("https://api.pinterest.com/oauth?response_type=code&client_id=",client_id,"&scope=",scope,sep="")

pinterest <- oauth_endpoint(
  authorize = "https://api.pinterest.com/oauth",
  access = "https://api.pinterest.com/v1/oauth/token")  

myapp <- oauth_app(app_name, client_id, client_secret)



#scope <- NULL
pi_oauth <- oauth2.0_token(pinterest, myapp,scope=scope,use_oob = TRUE, as_header = TRUE)


fb_ep = oauth_endpoint(token_url, auth_url, access_url)
pi_oauth <- oauth1.0_token(pinterest, myapp)


754c073e2078e098

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
