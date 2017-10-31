library(caret)
library(e1071)
library(klaR)
X.train <- read.csv('/Users/ninashao/Desktop/Fall2017-project3-fall2017-project3-grp9-master 2/data/training_set/sift_train.csv', header = T)
# dim(X.train)
X.train<-X.train[,-1]
y.train <- unlist(read.csv('/Users/ninashao/Desktop/Fall2017-project3-fall2017-project3-grp9-master 2/data/training_set/label_train.csv', header = T)[,2])
x_cols<-nearZeroVar(X.train, names = TRUE, freqCut = 2, uniqueCut = 20)
ix <- which(colnames(X.train) %in% x_cols)
x.train.small<-X.train[,-ix]
train <- data.frame(lapply(x.train.small,as.numeric)) #convert to numeric. factors are integer fields anyway behind the scenes.
train <- data.frame(lapply(X.train,as.numeric)) #convert to numeric. factors are integer fields anyway behind the scenes.
# train <- as.matrix(train[-length(train)])
color<-read.csv("/Users/ninashao/Desktop/Fall2017-project3-fall2017-project3-grp9-master 2/data/training_set/color_features.csv",header = T)
color<-color[,-1]
train<-cbind(train,color)
n <- nrow(train)
index <- sample(n, n*0.75)
data_train <- as.matrix(train)
train_data <- data_train[index,]
test_data <- data_train[-index,]
train_label <- matrix(y.train[index])
test_label <- matrix(y.train[-index])
model_temp<-train(train_data, as.factor(train_label), method="naive_bayes",trControl=trainControl(method='cv',number=10))

pred_test<-predict(model_temp, test_data,type = "raw" )
test_error<-sum(pred_test != test_label)/nrow(test_data)
test_error
