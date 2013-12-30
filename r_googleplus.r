library(RCurl);
library(RJSONIO);
api_key<-"XXX"

user_id <- "105616015219357887822"
# Still need to add ssl.verifypeer = FALSE to get a connection :(
# Add a max results parameter in the URL structure to get 100 results (maximum allowed by the API : https://developers.google.com/+/api/)
data <- getURL(paste("https://www.googleapis.com/plus/v1/people/",user_id,"/activities/public?maxResults=100&key=", api_key, sep=""),ssl.verifypeer = FALSE)
js <- fromJSON(data, asText=TRUE);

df = data.frame(no = 1:length(js$items))

for (i in 1:nrow(df)){
  df$kind[i] = js$items[[i]]$verb
  df$title[i] = js$items[[i]]$title
  df$published[i] = js$items[[i]]$published # add publish date to the df
  df$replies[i] = js$items[[i]]$object$replies$totalItems
  df$plusones[i] = js$items[[i]]$object$plusoners$totalItems
  df$reshares[i] = js$items[[i]]$object$resharers$totalItems
  df$url[i] = js$items[[i]]$object$url
  
}

# Export to .csv
filename <- paste("gplus_data_", user_id, sep="") # in case we have more user_ids
write.table(df, file = paste0(filename,".csv"), sep = ",", col.names = NA,
            qmethod = "double")

df_graph = df[,c(1,5,6,7)]


 
require(ggplot2)
require(reshape2)

melted=melt(df_graph,id.vars='no')

ggplot(melted,aes(x=factor(no),y=value,color=factor(variable),group=factor(variable)))+
    geom_line()+xlab('no')+guides(color=guide_legend("metrics"))+
   labs(title="Google+")
