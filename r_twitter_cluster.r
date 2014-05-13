require(rCharts)


user <- getUser("JulianHi")
userFriends <- user$getFriends()
userFollowers <- user$getFollowers()
userNeighbors <- union(userFollowers, userFriends)
userNeighbors.df = twListToDF(userNeighbors)



userNeighbors.df[userNeighbors.df=="0"]<-1


userNeighbors.df$logFollowersCount <-log(userNeighbors.df$followersCount)

userNeighbors.df$logFriendsCount <-log(userNeighbors.df$friendsCount)


kObject.log <- data.frame(userNeighbors.df$logFriendsCount,userNeighbors.df$logFollowersCount)

###elbow
mydata <- kObject.log
wss <- (nrow(mydata)-1)*sum(apply(mydata,2,var))
  for (i in 2:15) wss[i] <- sum(kmeans(mydata,
                                       centers=i)$withinss)
plot(1:15, wss, type="b", xlab="Number of Clusters",
     ylab="Within groups sum of squares")



###k-means

##Create a object containing the vectors to be used in the K-Means


##Run the K Means algorithm, specifying 2 centers
user2Means.log <- kmeans(kObject.log, centers=6, iter.max=10, nstart=100)

##Add the vector of specified clusters back to the original vector as a factor
userNeighbors.df$cluster <- kObject.log$cluster


p2 <- nPlot(logFollowersCount ~ logFriendsCount, group = 'cluster', data = userNeighbors.df, type = 'scatterChart')
p2$xAxis(axisLabel = 'Followers Count')
p2$yAxis(axisLabel = 'Friends Count')
p2$chart(tooltipContent = "#! function(key, x, y, e){ 
               return e.point.screenName + '  Followers: ' + e.point.followersCount  +'   Friends: ' + e.point.friendsCount
} !#")
p2