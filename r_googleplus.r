library(RCurl);
library(RJSONIO);
api_key<-"XXX"

   user_id <- "105616015219357887822"
data <- getURL(paste("https://www.googleapis.com/plus/v1/people/",user_id,"/activities/public?key=", api_key, sep=""))
js <- fromJSON(data, asText=TRUE);


df = data.frame(no = 1:length(js$items))
for (i in 1:nrow(df)){
  df$kind[i] = js$items[[i]]$verb
  df$title[i] = js$items[[i]]$title
  df$replies[i] = js$items[[i]]$object$replies$totalItems
  df$plusones[i] = js$items[[i]]$object$plusoners$totalItems
  df$reshares[i] = js$items[[i]]$object$resharers$totalItems
  df$url[i] = js$items[[i]]$object$url
  
}

df_graph = df[,c(1,4,5,6)]


 
 require(ggplot2)
 require(reshape2)

 melted=melt(df_graph,id.vars='no')

ggplot(melted,aes(x=factor(no),y=value,color=factor(variable),group=factor(variable)))+
    geom_line()+xlab('no')+guides(color=guide_legend("metrics"))+
   labs(title="Google+")