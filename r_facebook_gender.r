
require(Rfacebook)
    
    # Change for your need
    page_name <- "forbes"
    number_posts <- 2
    token <- "XXX"
    
    #Get the general page info
    page <- getPage(page_name, token, n = number_posts, feed = FALSE)
   
    
    #Extract the post ids
    posts <- page$id
  
    
    data_frame_gender <- data.frame(post=character(),male=numeric(),female=numeric(),etc=numeric(),likes=numeric(),type=character(),stringsAsFactors=FALSE)
   #process each post and analyze the gender distribution of the likes 
    for(i in 1:length(posts))
    {
      temp <- posts[i]
     
      post <- getPost(temp,token)
      
      data_frame_gender[i,1] <- post$post$message
      data_frame_gender[i,5] <- post$post$likes
      data_frame_gender[i,6] <- post$post$type
      
      gender_frame <- data.frame(gender=character(),stringsAsFactors=FALSE)
      
      for(j in 1:length(post$likes$from_id))
      {
        likes <- post$likes$from_id
        user_id <- likes[j]
        
        user <- getUsers(user_id,token=token)
        
        gender <- user$gender
        
        gender_frame[nrow(gender_frame)+1,] <- gender
        
      }
      
      number_males <- nrow(subset(gender_frame, gender=="male"))
      number_females <- nrow(subset(gender_frame, gender=="female"))
      number_etc <- data_frame_gender[i,5] - (number_males+number_females)
      
      data_frame_gender[i,2] <- number_males
      data_frame_gender[i,3] <- number_females
      data_frame_gender[i,4] <- number_etc
      
    }


    slices <- c(sum(data_frame_gender$male),sum(data_frame_gender$female),sum(data_frame_gender$etc))
   
pct <- round(slices/sum(slices)*100)
    lbls <- names(data_frame_gender[2:4])
    lbls <- paste(lbls, pct) # add percents to labels
    lbls <- paste(lbls,"%",sep="") # ad % to labels
   
    pie(slices, labels = lbls, main="Gender Distribution of all analyzed posts")

    