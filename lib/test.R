######################################################
### Fit the classification model with testing data ###
######################################################

### Author: Yuting Ma
### Project 3
### ADS Spring 2016

test <- function(fit_train, dat_test,par){
  
  ### Fit the classfication model with testing data
  
  ### Input: 
  ###  - the fitted classification model using training data
  ###  -  processed features from testing images 
  ### Output: training model specification
  
  ### load libraries
  library("gbm")
  library("randomForest")
  library("adabag")
  if(par){
      data_withGray=dat_test$Gray
      data_NoGray=dat_test$Nogray
    }else{
      data_withGray=dat_test
      data_NoGray=dat_test
    }
  
  ### baseline(gbm) model
  p_base<-predict(fit_train$base,data_NoGray[,-1],n.trees = 2000)
  p_base<-as.integer(apply(p_base[,,1],1,which.max)-1)
  
  ### random forest
  p_rf<-as.integer(predict(fit_train$RF,data_NoGray[,-1]))
  
  ### adaboost
  p_ada<-predict.boosting(fit_train$adaboost,data_withGray[,-1])
  p_ada<-as.integer(p_ada$class)
 
  
  #### making vote ######
  count_f<-function(vec){
    vec=as.numeric(vec)
    p0<-sum(vec==0)
    p1<-sum(vec==1)
    p2<-sum(vec==2)
    #return(c(p0,p1,p2))
    if(p0==1&p0==p1){
      result=vec[1]
    }else{
      result=which.max(c(p0,p1,p2))-1
    }
    return(result)
  }
  y=apply(pred_df,1,count_f)
  accuracy=mean(p_ada==test_labels)
  
  return(paste(round(accuracy,4)*100,"%"))
}

