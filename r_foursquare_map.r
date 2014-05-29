library(rjson)
library(RCurl)
library(httr)

#Authentication:
require(devtools) #install if necessary (install.packages("devtools")

dev_mode(on=T)

install_github("ThinkToStartR",username="JulianHill")


require(ThinkToStartR)
library(rjson)
require(RCurl)


token <- ThinkToStart("Foursquare_auth",app_name="R_Test",app_id="XXX",app_secret="XXX")


####Get the Data

data <- fromJSON(getURL(paste('https://api.foursquare.com/v2/users/self/venuehistory?oauth_token=',token,'&v=',format(Sys.time(), "%Y%m%d"),sep="")))

response <- data$response
venues <- response$venues$items


no_venues = length(data$response$venues$items)

df = data.frame(no = 1:no_venues)


for (i in 1:nrow(df)){
 
  #Add Name and the location of the Venue
  df$venue_name[i] <- venues[[i]]$venue$name
  df$venue_lat[i] <- venues[[i]]$venue$location$lat
  df$venue_lng[i] <- venues[[i]]$venue$location$lng
  
  ##########################
  #Add the address of the location 
  if(length(venues[[i]]$venue$location$address)>0)
  {
    df$venue_address[i] <- venues[[i]]$venue$location$address
  }
  else{
    df$venue_address[i] <- "No Address Available"
    
  }

  ##########################
  #Add the citiy of the location
  if(length(venues[[i]]$venue$location$city)>0)
  {
    df$venue_city[i] <- venues[[i]]$venue$location$city
  }
  else{
    df$venue_city[i] <- "No City Available"
    
  }
  
  ##########################
  #Add the number of check-ins of the venue
  df$venue_checkinsCount[i] <- venues[[i]]$venue$stats[[1]]
 
  ##########################
  #Add the URL of the URL if defined
 if(length(venues[[i]]$venue$url)>0)
 {
   df$url[i] <- venues[[i]]$venue$url
 }
 else{
   df$url[i] <- NA
   
 }
 
}

 
 mean_lat <- mean(df$venue_lat) # outcome: 50.90956
mean_lon <- mean(df$venue_lng) # outcome: 7.576119

require(rCharts)

map <- Leaflet$new()
map$setView(c(mean_lat, mean_lon), zoom = 5)


for (i in 1:no_venues){
  
  #Get the name and the number of check-ins of the current venue
  name <- df$venue_name[i]
  checkins <- df$venue_checkinsCount[i]
  
  #Add the marker to the map but just add a website link if we have a URL for the venue
  
  #if URL is available
  if(is.na(df$url[i]))
  {  map$marker(c(df$venue_lat[i], df$venue_lng[i]), bindPopup = paste(name,' <br> Checkins: ',checkins,sep=""))
  }
  else
  {
  map$marker(c(df$venue_lat[i], df$venue_lng[i]), bindPopup = paste(name,' <br> Checkins: ',checkins,'<br> <a href="',df$url[i],'" target="_blank">Website</a> ',sep=""))
  }
  
}

map



