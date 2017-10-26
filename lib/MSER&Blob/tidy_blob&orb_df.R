names<-list.files("~/Desktop/training_set/images/")
blob_df<-read.csv("~/Desktop/[ADS]Advanced Data Science/Fall2017-project3-fall2017-project3-grp9/data/blob_df.csv")

library(tibble)
blob_df<-blob_df%>%
  group_by(Image,label)%>%
  summarise(
    count=n()
  )
blob_df1<-data.frame(matrix(0,3000,200))
colnames(blob_df1)<-paste("blob_",1:200,sep="")
rownames(blob_df1)<-names
for(i in 1:21257){
  blob_df1[blob_df$Image[i],blob_df$label[i]+1]<-blob_df$count[i]
}

write.csv(blob_df1,"~/Desktop/[ADS]Advanced Data Science/Fall2017-project3-fall2017-project3-grp9/data/blob_df_tidyver.csv")


orb_df_labeled<-read.csv("~/Desktop/orb_df_labeled.csv")
orb1<-orb_df_labeled%>%
  group_by(Image,label)%>%
  summarise(
    count=n()
  )
tidy_orb<-data.frame(matrix(0,3000,200))
colnames(tidy_orb)<-paste("orb_",1:200,sep="")
rownames(tidy_orb)<-names
for(i in 1:nrow(orb1)){
  tidy_orb[orb1$Image[i],orb1$label[i]+1]<-orb1$count[i]
}
write.csv(tidy_orb,"~/Desktop/[ADS]Advanced Data Science/Fall2017-project3-fall2017-project3-grp9/data/orb_df_tidyver.csv")





