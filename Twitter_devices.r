tweets = searchTwitter("Social Media", n=20, cainfo="cacert.pem")

devices <- sapply(tweets, function(x) x$getStatusSource())
 
devices <- gsub("","", devices)
devices <- strsplit(devices, ">")
 
devices <- sapply(devices,function(x) ifelse(length(x) > 1, x[2], x[1]))

pie(table(sources))