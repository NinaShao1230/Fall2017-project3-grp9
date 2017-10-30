library("gbm")
img_labels<-read.csv("~/Desktop/training_set/label_train.csv")
features<-read.csv("~/Desktop/training_set/sift_train.csv")
set.seed(1)
train<-sample(1:3000,2500)
train_data<-features[train,]
test_data<-features[c(1:3000)[-train],]

colnames(img_labels)=c("Image","labels")
img_labels[,2]<-ifelse(img_labels[,2]==2,1,0)
train_labels<-img_labels[train,2]
test_labels<-img_labels[c(1:3000)[-train],2]


train <- function(dat_train, label_train, par=NULL){
  
  if(is.null(par)){
    depth <- 3
  } else {
    depth <- par$depth
  }
  fit_gbm <- gbm.fit(x=dat_train, y=label_train,
                     n.trees=2000,
                     distribution="bernoulli",
                     interaction.depth=depth, 
                     bag.fraction = 0.5,
                     verbose=FALSE)
  return(fit_gbm)
}
begin=Sys.time()

##base on sift 
base_fit<-train(train_data[,-1],train_labels)
Sys.time()-begin#16.70 mins

base_fit_predict<-predict(base_fit,test_data[,-1],n.trees = 2000)
base_fit_predict<-ifelse(base_fit_predict>mean(base_fit_predict),1,0)
sum(base_fit_predict==test_labels)/500
#0.738
