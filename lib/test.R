######################################################
### Fit the classification model with testing data ###
######################################################

### Author: Yuting Ma
### Project 3
### ADS Spring 2016
test_baseline<-function(fit_train, dat_test,par){
    
    ### Fit the classfication model with testing data
    
    ### Input: 
    ###  - the fitted classification model using training data
    ###  -  processed features from testing images 
    ### Output: training model specification
    
    ### load libraries
    library("gbm")
    #library("randomForest")
    if(par){
      #data_withGray=dat_test$Gray
      data_NoGray=dat_test$NoGray
    }else{
      #data_withGray=dat_test
      data_NoGray=dat_test
    }
    
    ### baseline(gbm) model
    p_base<-predict(fit_train,data_NoGray[,-1],n.trees = 2000)
    p_base<-as.integer(apply(p_base[,,1],1,which.max)-1)
    cat("Baseline model Accuracy : ", round(mean(p_base==test_labels),4)*100, "% \n")
    return( list(result=p_base,accuracy=round(mean(p_base==test_labels),4)))
    }


test_ada <- function(fit_train,dat_test,par){
  
  if(par){
    data_withGray=dat_test$Gray
  }else{
    data_withGray=dat_test
  }
  
  # ### random forest
  # ##### replace NA values withcolmeans
  # data_NoGray <- as.data.frame(lapply(data_NoGray, function(x) ifelse(is.na(x), mean(x, na.rm = TRUE), x)))
  # p_rf<-as.integer(predict(fit_train$RF,data_NoGray[,-1]))-1
  # cat("Random Forest Accuracy : ", round(mean(p_rf==test_labels),4)*100, "% \n")
  
  library("adabag")
  ### adaboost
  p_ada<-predict.boosting(fit_train,data_withGray[,-1])
  p_ada<-as.integer(p_ada$class)
  cat("Adaboost Accuracy :", round(mean(p_ada==test_labels),4)*100, "% \n")
  
  
  # #### making vote ######
  # pred_df<-data.frame(ada=p_ada,rf=p_rf,base=p_base)
  # count_f<-function(vec){
  #   vec=as.numeric(vec)
  #   p0<-sum(vec==0)
  #   p1<-sum(vec==1)
  #   p2<-sum(vec==2)
  #   #return(c(p0,p1,p2))
  #   if(p0==1&p0==p1){
  #     result=vec[1]
  #   }else{
  #     result=which.max(c(p0,p1,p2))-1
  #   }
  #   return(result)
  # }
  # vote=apply(pred_df,1,count_f)
  # cat("Vote Accuracy :", round(mean(vote==test_labels),4)*100, "% \n")
  
  return(list(result=p_ada,accuracy=round(mean(p_ada==test_labels),4)))
}

