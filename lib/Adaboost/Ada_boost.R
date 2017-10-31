

img_labels<-read.csv("~/Desktop/training_set/label_train.csv")
colnames(img_labels)=c("Image","labels")
img_labels[,2]<-ifelse(img_labels[,2]==2,1,0)

features<-read.csv("~/Desktop/training_set/sift_train.csv")
color<-read.csv("~/Desktop/[ADS]Advanced Data Science/Fall2017-project3-fall2017-project3-grp9/data/color_features.csv",as.is = F)
orb<-read.csv("~/Desktop/[ADS]Advanced Data Science/Fall2017-project3-fall2017-project3-grp9/data/orb_df_tidyver.csv",as.is = F)

features_sift_color<-cbind(features,color[,-1])
features_sift_color_orb<-cbind(features,color[,-1],orb[,-1])

set.seed(90)
train_index<-sample(1:3000,floor(nrow(img_labels)*0.75))

train_data<-features_sift_color[train_index,]
test_data<-features_sift_color[-train_index,]

train_labels<-img_labels[train_index,2]
test_labels<-img_labels[-train_index,2]


######## function from ada package #########
library(ada)
begin=Sys.time()
ada.fit<- ada(labels~.,data=train_data[,-1], type = 'discrete',iter=10,verbose = T)
end=Sys.time()
end-begin
##4.34

pred_begin=Sys.time()
ada_predict<-predict(ada.fit,newdata = test_data[,-1])
pred_end=Sys.time()
pred_end-pred_begin
##1.11mins

mean((as.integer(ada_predict)-1)!=test_labels)#0.09

save(ada.fit,train_index,file="~/Desktop/adaboost_model.RData")


######## function from adabag package #########

library("adabag")
train_data$labels<-as.factor(train_labels)
begin=Sys.time()
adabag_fit=boosting(labels~.,train_data[,-1],mfinal=10)
end=Sys.time()
end-begin
#10.82min

pred_begin=Sys.time()
pred_adabag=predict.boosting(adabag_fit,newdata = test_data[,-1])
pred_end=Sys.time()
pred_end-pred_begin
##51 sec
mean(as.integer(pred_adabag$class)!=test_labels)

save(adabag_fit,train_index,file="~/Desktop/adabag_model.RData")
