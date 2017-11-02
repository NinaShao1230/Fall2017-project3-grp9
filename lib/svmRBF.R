library(caret)
library(e1071)

X.train <- read.csv('/Users/ninashao/Desktop/Fall2017-project3-fall2017-project3-grp9-master 2/data/training_set/sift_train.csv', header = T)
X.train<-X.train[,-1]
y.train <- unlist(read.csv('/Users/ninashao/Desktop/Fall2017-project3-fall2017-project3-grp9-master 2/data/training_set/label_train.csv', header = T)[,2])
x_cols<-nearZeroVar(X.train, names = TRUE, freqCut = 2, uniqueCut = 20)
ix <- which(colnames(X.train) %in% x_cols) 
x.train.small<-X.train[,-ix]
train <- data.frame(lapply(x.train.small,as.numeric)) #convert to numeric. factors are integer fields anyway behind the scenes.

### relabel 
label<- matrix(rep(0,3*length(y.train)),nrow=length(y.train),ncol= 3)
train_label<-cbind(label, y.train)
train_label[,1]<-ifelse(train_label[,4]==0,1,0)
train_label[,2]<-ifelse(train_label[,4]==1,1,0)
train_label[,3]<-ifelse(train_label[,4]==2,1,0)
train_label<-train_label[,1:3]

n <- nrow(train)
index <- sample(n, n*0.75)
data_train <- as.matrix(train)
train_data <- data_train[index,]
test_data <- data_train[-index,]
train_label <- train_label[index,]
test_label <- train_label[-index,]
test_true_label<-y.train[-index]

tuneSVM <- function(data, label){
  t=proc.time()
  pca <- prcomp(data,scale = FALSE)
  pca_x <- pca$x[,1:100]
  cv_svmTune<-tune(svm, pca_x, label,
                   kernel="radial", ranges=list(cost=10^(-1:2), gamma=c(.5,1,2)))
  p<-cv_svmTune$best.parameters
  train_time <- (proc.time()-t)[3]
  cat("train_time:",train_time)
  return(p)
}

p <- tuneSVM(data = train_data, label = train_label[,1])
p
cost<-p[,1]
gamma<-p[,2]

trainSVM<-function(data,label,cost,gamma){
  t=proc.time()
  pca <- prcomp(data,scale = FALSE)
  pca_x <- pca$x[,1:100]
  svm <- svm(pca_x,label,kernel="radial",cost = cost, gamma = gamma)
  train_time <- (proc.time()-t)[3]
  cat("train_time:",train_time)
  return(svm)
}
model1<-trainSVM(train_data, train_label[,1],cost, gamma)
model2<-trainSVM(train_data, train_label[,2],cost, gamma)
model3<-trainSVM(train_data, train_label[,3],cost, gamma)

testSVM <- function(data,test_label,model){
  t=proc.time()
  pca_test <- prcomp(data,scale = FALSE)
  pca_x_test <- pca_test$x[,1:100]
  pred_test <- predict(model,pca_x_test)
  # pred_test<- ifelse(pred_test <0.5,0,ifelse(pred_test>1.5,2,1))
  # test_error<-sum(pred_test != test_label)/nrow(test_data)
  test_time <- (proc.time()-t)[3]
  cat("test_time:",test_time)
  return(pred_test)
}

result1 <- testSVM(test_data,test_label[,1],model1)
result2 <- testSVM(test_data,test_label[,2],model2)
result3 <- testSVM(test_data,test_label[,3],model3)
result<-cbind(result1,result2,result3)

col_name<-colnames(result)[apply(result,1,which.max)]
pred_label<-rep(0,nrow(test_data))
pred_label<-ifelse(col_name=="result1",0,pred_label)
pred_label<-ifelse(col_name=="result2",1,pred_label)
pred_label<-ifelse(col_name=="result3",2,pred_label)
test_error<-sum(pred_label != test_true_label)/nrow(test_data)
test_error
