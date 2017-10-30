library(caret)
library(randomForest)
setwd('~/Desktop/ADS/Fall2017-project3-fall2017-project3-grp9/data/training_set')
sift_features = read.csv('./sift_train.csv', header = T)
sift_features = t(sift_features)
sift_labels = unlist(read.csv('./label_train.csv', header = T)[,2])
# save(feature_sift, file="../feature_sift.RData")
# Randomly split the data into training(75%) and test(25%) set
n <- nrow(sift_features)
index <- sample(n, n*0.75)
train_features <- sift_features[index,]
train_labels <- as.factor(sift_labels[index])

test_features <- sift_features[-index,]
test_labels <- as.factor(sift_labels[-index])


##############Random Forest################
RandomForest <- function(){
  img_features = t(sift_features[-1,])
  img_labels = unlist(read.csv("~/Desktop/ADS/Fall2017-project3-fall2017-project3-grp9/data/training_set/label_train.csv", header = T)[,2])
  img_rf = randomForest(x = img_features, y = as.factor(img_labels), mtry = 70, ntree = 1500)
  best_ntree = which.min(img_rf$err.rate[,"OOB"])
  err_rate = c(img_rf$err.rate[100, "OOB"], img_rf$err.rate[500, "OOB"], img_rf$err.rate[1000, "OOB"], img_rf$err.rate[1500, "OOB"])
}

train_RF = function(feature_filename, labels_filename){
  setwd('~/Desktop/ADS/Fall2017-project3-fall2017-project3-grp9/data/training_set')
  t = proc.time()
  img_features = read.csv(feature_filename, header = T)[,-1]
  img_labels = unlist(read.csv(labels_filename, header = T)[,2])
  img_rf = randomForest(x = img_features, y = as.factor(img_labels), mtry = 70, ntree = 500)
  train_time = (proc.time() - t)[3]
  cat("Training time for Random Forest with 500 trees is ", train_time, " seconds \n")
  err_rate = img_rf$err.rate[500, "OOB"]
  cat("Validation Error rate for Random Forest with 500 trees is", err_rate, "\n")
  # filename = "../output/RFFeature.RData"
  write.csv(img_rf, file = "../rf_features.csv")
  return(img_rf)
}

train_RF(feature_filename = "./sift_train.csv", labels_filename = "./label_train.csv")
# Training time for Random Forest with 500 trees is  1099.867  seconds 
# Validation Error rate for Random Forest with 500 trees is 0.227

test_RF = function(rf_object, features_filename)
{
  t = proc.time()
  img_features = t(read.csv(features_filename))
  rf_predict = as.vector(predict(rf_object, img_features, type = "prob"))
  test_time = (proc.time() - t)[3]
  cat("Prediction time for Random Forest with 500 trees is ", test_time, " seconds \n")
  # filename = "../output/RFPredict.csv"
  write.csv(rf_predict, file = "../output/rf_predict.csv")
  return(rf_predict)
}
