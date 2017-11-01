library("gbm")
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
  best_iter <- gbm.perf(boost.fit, method="cv", cv.folds>1,plot.it = FALSE)
  return(fit=list(fit_gbm,best_iter))
}


################ base on sift #####################
train_data<-features[train_index,]
test_data<-features[-train_index,]

begin<-Sys.time()
base_fit<-train(train_data[,-1],train_labels)
Sys.time()-begin
#35.57 mins

base_fit_predict<-predict(base_fit,test_data[,-1],n.trees = 2000)
base_fit_predict<-apply(base_fit_predict[,,1],1,which.max)-1
result<-mean(base_fit_predict!=test_labels)
#0.21


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

################ base on sift n color n lbp #####################
train_data<-features_sift_color_lbp[train_index,]
test_data<-features_sift_color_lbp[-train_index,]

begin<-Sys.time()
base_fit4<-train(train_data[,-1],train_labels)
Sys.time()-begin
#44.66 mins
base_fit_predict4<-predict(base_fit4,test_data[,-1],n.trees = 2000)
base_fit_predict4<-apply(base_fit_predict4[,,1],1,which.max)-1
result4<-mean(base_fit_predict4!=test_labels)
#0.104


################ base on sift n color n lbp n gray #####################
train_data<-features_sift_color_lbp_gray[train_index,]
test_data<-features_sift_color_lbp_gray[-train_index,]

begin<-Sys.time()
base_fit4<-train(train_data[,-1],train_labels)
Sys.time()-begin
#51 mins
base_fit_predict4<-predict(base_fit4,test_data[,-1],n.trees = 2000)
base_fit_predict<-apply(base_fit_predict[,,1],1,which.max)-1
result4<-mean(base_fit_predict3!=test_labels)
#0.105
base_fit_sift_color_lbp<-base_fit4
save(base_fit_sift_color_lbp,train_labels,file = "data/base_fit_sift_color_lbp.RData")

