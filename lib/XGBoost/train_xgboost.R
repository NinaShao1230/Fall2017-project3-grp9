

library("xgboost")

img_labels<-read.csv("~/Desktop/training_set/label_train.csv")
colnames(img_labels)=c("Image","labels")
img_labels[,2]<-ifelse(img_labels[,2]==2,1,0)

features<-read.csv("~/Desktop/training_set/sift_train.csv")
color<-read.csv("~/Desktop/[ADS]Advanced Data Science/Fall2017-project3-fall2017-project3-grp9/data/color_features.csv",as.is = F)
orb<-read.csv("~/Desktop/[ADS]Advanced Data Science/Fall2017-project3-fall2017-project3-grp9/data/orb_df_tidyver.csv",as.is = F)

features_sift_color<-cbind(features,color[,-1])
features_sift_color_orb<-cbind(features,color[,-1],orb[,-1])


##############  select params ##################### 

##### making train n test data ####
set.seed(90)
train_index<-sample(1:3000,2500)

train_data<-features_sift_color[train_index,]
test_data<-features_sift_color[-train_index,]

train_labels<-img_labels[train_index,2]
test_labels<-img_labels[-train_index,2]

train_mat <- data.matrix(train_data[,-1],rownames.force = NA)
train.D <- xgb.DMatrix(data=train_mat,label=train_labels,missing = NaN)
watchlist <- list(train_mat=train.D)


#### tone xbg model ####
param_df<-data.frame(matrix(NA,0,3))
colnames(param_df)<-c("depth","eta","error")
i=0
for(depth in 2:10){
  for(e in seq(0.04,0.1,0.02)){
    i=i+1
    parameters <- list ( objective        = "binary:logistic",
                         booser              = "gbtree",
                         eta                 = 0.05,
                         max_depth           = 6,
                         subsample           = 0.5,
                         gamma = 0
    )
    
    crossvalid <- xgb.cv( params             = parameters,
                          data                = train.D,
                          nrounds             = 500,
                          verbose             = 1,
                          watchlist           = watchlist,
                          maximize            = F,
                          nfold               = 5,
                          early_stopping_rounds    = 15,
                          print_every_n       = 1
    )
    
    train.model <- xgb.train( params              = parameters,
                              data                = train.D,
                              nrounds             = crossvalid$best_iteration, 
                              verbose             = 1,
                              watchlist           = watchlist,
                              maximize            = F
    )
    
    test_mat <- data.matrix(test_data,rownames.force = NA)
    result <- predict (train.model,test_mat)
    
    result<-as.numeric(result > 0.5)
    mean(result!=test_labels)
    param_df<-rbind(param_df,c(depth,e,mean(result!=test_labels)))
    
  }
}

##############  select models ##################### 
train_xgb<-function(data_train,depth,e){
  
  parameters <- list ( objective        = "binary:logistic",
                       booser              = "gbtree",
                       eta                 = e,
                       max_depth           = depth,
                       subsample           = 0.5,
                       gamma = 0
  )
  
  crossvalid <- xgb.cv( params             = parameters,
                        data                = data_train,
                        nrounds             = 500,
                        verbose             = 1,
                        watchlist           = watchlist,
                        maximize            = F,
                        nfold               = 5,
                        early_stopping_rounds    = 15,
                        print_every_n       = 1
  )
  
  crossvalid$best_iteration
  start=Sys.time()
  train_model <- xgb.train( params              = parameters,
                            data                = data_train,
                            nrounds             = crossvalid$best_iteration, 
                            verbose             = 1,
                            watchlist           = watchlist,
                            maximize            = FALSE
  )
  tm=Sys.time()-start
  testmodel <- data.matrix(test_data,rownames.force = NA)
  result <- predict (train_model,testmodel)
  
  result<-as.numeric(result > 0.5)
  err<-mean(result!=test_labels)
  
  return(list(err=err,model=train_model,iter=crossvalid$best_iteration,time=tm))
}

####### making train/test data #####
set.seed(90)
train_index<-sample(1:3000,floor(nrow(img_labels)*0.75))

train_data<-features_sift_color_orb[train_index,]
test_data<-features_sift_color_orb[-train_index,]

train_labels<-img_labels[train_index,2]
test_labels<-img_labels[-train_index,2]

train_mat <- data.matrix(train_data[,-1],rownames.force = NA)
train.D <- xgb.DMatrix(data=train_mat,label=train_labels,missing = NaN)
watchlist <- list(train_mat=train.D)


############# First
temp1<-train_xgb(train.D,2,.09)
temp1$err
temp1$time
temp1$iter
xgb_2_09<-temp1
save(xgb_2_09,train_index,file="~/Desktop/xgb_2_09.RData")

############# Second (worse)
temp2<-train_xgb(train.D,8,.07)
temp2$err
temp2$time
temp2$iter
save(temp2,file="~/Desktop/xgb_8_07.RData")


