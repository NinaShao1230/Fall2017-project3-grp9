library(caret)
library(e1071)

X.train <- read.csv('/Users/ninashao/Desktop/Fall2017-project3-fall2017-project3-grp9-master 2/data/training_set/sift_train.csv', header = T)
X.train<-X.train[,-1]
y.train <- unlist(read.csv('/Users/ninashao/Desktop/Fall2017-project3-fall2017-project3-grp9-master 2/data/training_set/label_train.csv', header = T)[,2])
x_cols<-nearZeroVar(X.train, names = TRUE, freqCut = 2, uniqueCut = 20)
ix <- which(colnames(X.train) %in% x_cols) 
x.train.small<-X.train[,-ix]
train <- data.frame(lapply(x.train.small,as.numeric)) #convert to numeric. factors are integer fields anyway behind the scenes.
# train <- as.matrix(train[-length(train)])

n <- nrow(train)
index <- sample(n, n*0.75)
data_train <- as.matrix(train)
train_data <- data_train[index,]
test_data <- data_train[-index,]
train_label <- matrix(y.train[index])
test_label <- matrix(y.train[-index])


trainSVM <- function(data, label){
  t=proc.time()
  pca <- prcomp(data,scale = FALSE)
  pca_x = pca$x[,1:100]
  cv_svmTune<-tune.svm(pca_x,y=label, sampling = "fix",
                       gamma = 2^c(-8,-4,0,4), cost = 2^c(-8,-4,-2,0),probability = TRUE)
  p<-cv_svmTune$best.parameters
  best.svm <- svm(pca_x,label,cost = p[,2], gamma = p[,1],probability = TRUE)
  train_time <- (proc.time()-t)[3]
  cat("train_time:",train_time)
  return(best.svm)
}

model <- trainSVM(data = train_data, label = train_label)

testSVM <- function(data,test_label){
  t=proc.time()
  pca_test <- prcomp(data,scale = FALSE)
  pca_x_test <- pca_test$x[,1:100]
  pred_test <- predict(model,pca_x_test,probability = TRUE)
  pred_test<- ifelse(pred_test <0.5,0,ifelse(pred_test>1.5,2,1))
  test_error<-sum(pred_test != test_label)/nrow(test_data)
  test_time <- (proc.time()-t)[3]
  cat("test_time:",test_time)
  return(test_error)
}
result <- testSVM(test_data,test_label)
result



