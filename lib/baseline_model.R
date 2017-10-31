library("gbm")

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

train_labels<-img_labels[train_index,2]
test_labels<-img_labels[-train_index,2]


train <- function(dat_train, label_train, par=NULL){
  
  if(is.null(par)){
    depth <- 3
  } else {
    depth <- par$depth
  }
  fit_gbm <- gbm.fit(x=dat_train, y=label_train,
                     n.trees=2000,
                     distribution="multinomial",
                     interaction.depth=depth, 
                     bag.fraction = 0.5,
                     verbose=FALSE)
  return(fit_gbm)
}


################ base on sift #####################
train_data<-features[train_index,]
test_data<-features[-train_index,]

begin<-Sys.time()
base_fit<-train(train_data[,-1],train_labels)
Sys.time()-begin
#15.79 mins

base_fit_predict<-predict(base_fit,test_data[,-1],n.trees = 2000)
base_fit_predict<-ifelse(base_fit_predict>mean(base_fit_predict),1,0)
result<-mean(base_fit_predict!=test_labels)
#0.29


################ base on sift n color #####################
train_data<-features_sift_color[train_index,]
test_data<-features_sift_color[-train_index,]

begin<-Sys.time()
base_fit2<-train(train_data[,-1],train_labels)
Sys.time()-begin
# 1.655134 hours

base_fit_predict2<-predict(base_fit2,test_data[,-1],n.trees = 2000)
base_fit_predict2<-ifelse(base_fit_predict2>mean(base_fit_predict2),1,0)
result2<-mean(base_fit_predict_222!=test_labels)
#0.105


################ base on sift n color n orb #####################
train_data<-features_sift_color_orb[train_index,]
test_data<-features_sift_color_orb[-train_index,]

begin<-Sys.time()
base_fit3<-train(train_data[,-1],train_labels)
Sys.time()-begin#22.97 mins

base_fit_predict3<-predict(base_fit3,test_data[,-1],n.trees = 2000)
base_fit_predict3<-ifelse(base_fit_predict3>mean(base_fit_predict3),1,0)
result3<-mean(base_fit_predict3!=test_labels)
#0.116

save(train_index,base_fit,base_fit2,base_fit3,file="~/Desktop/baseline_models.RDate")


