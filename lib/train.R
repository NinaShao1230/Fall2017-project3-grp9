


train <- function(dat_train, label_train, par=NULL){
  
  ### load libraries
  library("gbm")
  library("xgboost")
  library("randomForest")
  library("adabag")
  
  if(par){
    data_withGray=dat_train$Gray
    data_NoGray=dat_train$Nogray
  }else{
    data_withGray=dat_train
    data_NoGray=dat_train
  }
  
  ### Train adaboost model
  data_withGray$labels<-as.factor(label_train)
  adabag_fit=boosting(labels~., data_withGray[,-1],mfinal=30,coeflearn="Zhu")
  
  ### Train Random Forest
  rf.train <- tuneRF(data_NoGray[,-1], as.factor(label_train), ntreeTry = 70, doBest = T)
  
  ### Baseline model
  train_base <- function(dat_train, label_train, par=NULL){
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
    #best_iter <- gbm.perf(boost.fit, method="cv", cv.folds>1,plot.it = FALSE)
    return(fit_gbm)
  }
  base_fit<-train_base(data_NoGray[,-1],label_train)
  
  
  return(fit_train=list(RF=rf.train,adaboost=adabag_fit,base=base_fit_sift_color_lbp))
}
