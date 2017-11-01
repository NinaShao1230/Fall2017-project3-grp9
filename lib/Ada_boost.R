
setwd('~/Desktop/[ADS]Advanced Data Science/Fall2017-project3-fall2017-project3-grp9/')
img_labels<-read.csv("./data/training_set/label_train.csv")
colnames(img_labels)=c("Image","labels")
#img_labels[,2]<-ifelse(img_labels[,2]==2,1,0)

features<-read.csv("./data/training_set/sift_train.csv")
color<-read.csv("./data/color_features.csv",as.is = F)
orb<-read.csv("./data/orb_df_tidyver.csv",as.is = F)
lbp<-read.csv("./data/lbp_feature.csv",as.is = F)
gray<-read.csv("./data/gray_features.csv",as.is = F)[,-1]

features_sift_color<-cbind(features,color[,-1])
features_sift_color_orb<-cbind(features,color[,-1],orb[,-1])
features_sift_color_lbp<-cbind(features,color[,-1],lbp[,-1])
features_sift_color_lbp_gray<-cbind(features,color[,-1],lbp[,-1],gray[,-1])


set.seed(90)
train_index<-sample(1:3000,floor(nrow(img_labels)*0.75))

train_data<-features_sift_color_lbp_gray[train_index,]
train_data$labels<-as.factor(train_labels)
test_data<-features_sift_color_lbp_gray[-train_index,]

train_labels<-img_labels[train_index,2]
test_labels<-img_labels[-train_index,2]



######## function from ada package #########

# library(ada)
# begin=Sys.time()
# ada.fit<- ada(labels~.,data=train_data[,-1], type = 'discrete',iter=50,verbose = T)
# end=Sys.time()
# end-begin
# ##4.34
# 
# pred_begin=Sys.time()
# ada_predict<-predict(ada.fit,newdata = test_data[,-1])
# pred_end=Sys.time()
# pred_end-pred_begin
# ##1.11mins
# 
# mean((as.integer(ada_predict)-1)!=test_labels)#0.09
# 
# save(ada.fit,train_index,file="~/Desktop/ada_model.RData")


######## function from adabag package #########




######## ntree=90 with gray
#err0.0667
#time=50.95

######## ntree=70
library("adabag")
begin=Sys.time()
adabag_fit=boosting(labels~.,train_data[,-1],mfinal=70,coeflearn="Zhu")
end=Sys.time()
end-begin
#48.54448 mins
#39.60549 mins(w/o gray)

pred_begin=Sys.time()
pred_adabag=predict.boosting(adabag_fit,newdata = test_data[,-1])
pred_end=Sys.time()
pred_end-pred_begin
#4.197157 mins
#3.908969 mins(w/o gray)
mean((as.integer(pred_adabag$class))!=test_labels)
#0.07333333
#0.084(w/o gray)
save(adabag_fit,train_index,file="~/Desktop/adabag_model_3c.RData")


######## ntree=50
library("adabag")
begin=Sys.time()
adabag_fit=boosting(labels~.,train_data[,-1],mfinal=50,coeflearn="Zhu")
end=Sys.time()
end-begin
#1.312945 hours

pred_begin=Sys.time()
pred_adabag=predict.boosting(adabag_fit,newdata = test_data[,-1])
pred_end=Sys.time()
pred_end-pred_begin
#4.625609 mins
mean((as.integer(pred_adabag$class))!=test_labels)
#0.0866
save(adabag_fit,train_index,file="~/Desktop/adabag_model_3c.RData")


############ reduced ntree=20
begin=Sys.time()
adabag_fit20=boosting(labels~.,train_data[,-1],mfinal=20,coeflearn="Zhu")
end=Sys.time()
end-begin
#30.51974 mins

pred_begin=Sys.time()
pred_adabag20=predict.boosting(adabag_fit20,newdata = test_data[,-1])
pred_end=Sys.time()
pred_end-pred_begin
##4.625609 mins
mean((as.integer(pred_adabag20$class))!=test_labels)
##0.113
save(adabag_fit20,train_index,file="~/Desktop/adabag_model_20.RData")


############### reduced ntree=30
begin=Sys.time()
adabag_fit30=boosting(labels~.,train_data[,-1],mfinal=30,coeflearn="Zhu")
end=Sys.time()
end-begin
#26.36 mins

pred_begin=Sys.time()
pred_adabag30=predict.boosting(adabag_fit30,newdata = test_data[,-1])
pred_end=Sys.time()
pred_end-pred_begin
##2.79 mins
mean((as.integer(pred_adabag30$class))!=test_labels)
##0.085
save(adabag_fit30,train_index,file="~/Desktop/adabag_model_30.RData")


############## +lbp data 25 trees
train_data<-features_sift_color_lbp[train_index,]
train_data$labels<-as.factor(train_labels)
test_data<-features_sift_color_lbp[-train_index,]

begin=Sys.time()
adabag_fit25=boosting(labels~.,train_data[,-1],mfinal=25,coeflearn="Zhu")
end=Sys.time()
end-begin
#37.89609 mins

pred_begin=Sys.time()
pred_adabag25=predict.boosting(adabag_fit20,newdata = test_data[,-1])
pred_end=Sys.time()
pred_end-pred_begin
##2.182377 mins
mean((as.integer(pred_adabag25$class))!=test_labels)
##0.108

#save(adabag_fit25,train_index,file="~/Desktop/adabag_model_25.RData")

