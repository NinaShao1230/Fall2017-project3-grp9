

train_baseline <- function(dat_train, label_train, par){
  library("gbm")
  if(par){
    # data_withGray=dat_test$Gray
    data_NoGray=dat_test$NoGray
  }else{
    # data_withGray=dat_test
    data_NoGray=dat_test
  }
  ##baseline model
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
  return(base_fit)
}




train_ada <- function(dat_train, label_train, depth=30,par){
  if(par){
    data_withGray=dat_test$Gray
    #data_NoGray=dat_test$NoGray
  }else{
    data_withGray=dat_test
    #data_NoGray=dat_test
  }
  
  ### load libraries
  library("adabag")
  
  ### Train adaboost model(25 min)
  data_withGray$labels<-as.factor(label_train)
  adabag_fit=boosting(labels~., data_withGray[,-1],mfinal=depth,coeflearn="Zhu")
  
  # ### Train Random Forest(20 min)
  # ##### replace NA values withcolmeans
  # data_NoGray <- apply(data_NoGray, function(x) ifelse(is.na(x), mean(x, na.rm = TRUE), x))
  # ###tune the Random Forest and produce the best one
  # rf.train <- tuneRF(data_NoGray[,-1], as.factor(label_train), ntreeTry = 70, doBest = T)
  
  
  return(adabag_fit)
}
