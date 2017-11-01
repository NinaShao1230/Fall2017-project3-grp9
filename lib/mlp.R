# install.packages('reticulate')
require(reticulate)
# install.packages('devtools')
# devtools::install_github("rstudio/keras") 
library(keras)
library(tensorflow)
# install_tensorflow()

# install.packages("RSNNS")
library(RSNNS)

setwd("/Users/ninashao/Desktop/Fall2017-project3-fall2017-project3-grp9-master 2")
df<-read.csv("df_nn.csv")

set.seed(90)
train_index<-sample(1:nrow(df),floor(nrow(df)*0.75))
train<-df[train_index,]
test<-df[-train_index,]
train_x <-train[,-1]
train_y <-train[,1]
test_x<-test[,-1]
test_y<-test[,1]

# scale
train_x<-as.matrix(apply(train_x, MARGIN = 2, FUN = function(X) (X - min(X))/diff(range(X))))
test_x<-as.matrix(apply(test_x, MARGIN = 2, FUN = function(X) (X - min(X))/diff(range(X))))

#convert class vectors to binary class matrices
train_y<-to_categorical(train_y,3)
test_y<-to_categorical(test_y,3)


stm = proc.time()
MLP = mlp(train_x, train_y, 
           size = c(7), maxit = 20,
           initFunc = "Randomize_Weights", initFuncParams = c(-0.3, 0.3),
           learnFunc = "Std_Backpropagation", learnFuncParams = c(0.1, 0),
           updateFunc = "Topological_Order", updateFuncParams = c(0),
           hiddenActFunc = "Act_Logistic", shufflePatterns = TRUE, linOut = FALSE)
etm = proc.time()-stm
etm
## (4)Accuracy and time##
predictions_train3 <- predict(MLP3,train_x)
pred_train<-predictions_train3
colnames(pred_train)<-c(0,1,2)
col_name<-colnames(pred_train)[apply(pred_train,1,which.max)]
pred_label_train<-rep(0,nrow(train_x))
pred_label_train<-ifelse(col_name=="0",0,pred_label_train)
pred_label_train<-ifelse(col_name=="1",1,pred_label_train)
pred_label_train<-ifelse(col_name=="2",2,pred_label_train)

# predictions_train = ifelse(predictions_train>0.5,1,0)
TrainAccu = (1-mean(pred_label_train!=train_y))*100
TrainAccu

predictions <- predict(MLP,test_x)
# predictions = ifelse(predictions>0.5,1,0)
colnames(predictions)<-c(0,1,2)
col_name<-colnames(predictions)[apply(predictions,1,which.max)]
pred_label_test<-rep(0,nrow(test_x))
pred_label_test<-ifelse(col_name=="0",0,pred_label_test)
pred_label_test<-ifelse(col_name=="1",1,pred_label_test)
pred_label_test<-ifelse(col_name=="2",2,pred_label_test)
TestAccu = (1-mean(pred_label_test!=test_y))*100
cat(paste("It takes",etm[3],"sec to train.\n",
          "Accuracy on the Train set: ",TrainAccu,"%\n",
          "Accuracy on the Test set: ",TestAccu,"%\n"))


## tune parameter to avoid over-fit
for(i in 25:30 ){
  for(j in 25:30){
    stm = proc.time()
    MLP = mlp(train_x, train_y, 
              size = c(i), maxit = j,
              initFunc = "Randomize_Weights", initFuncParams = c(-0.3, 0.3),
              learnFunc = "Std_Backpropagation", learnFuncParams = c(0.1, 0),
              updateFunc = "Topological_Order", updateFuncParams = c(0),
              hiddenActFunc = "Act_Logistic", shufflePatterns = TRUE, linOut = FALSE)
    etm = proc.time()-stm
   
    predictions_train <- predict(MLP,train_x)
    colnames(predictions_train)<-c(0,1,2)
    col_name<-colnames(predictions_train)[apply(predictions_train,1,which.max)]
    pred_label_train<-rep(0,nrow(train_x))
    pred_label_train<-ifelse(col_name=="0",0,pred_label_train)
    pred_label_train<-ifelse(col_name=="1",1,pred_label_train)
    pred_label_train<-ifelse(col_name=="2",2,pred_label_train)
    
    # predictions_train = ifelse(predictions_train>0.5,1,0)
    TrainAccu = (1-mean(pred_label_train!=train_y))*100
    predictions <- predict(MLP,test_x)
    # predictions = ifelse(predictions>0.5,1,0)
    colnames(predictions)<-c(0,1,2)
    col_name<-colnames(predictions)[apply(predictions,1,which.max)]
    pred_label_test<-rep(0,nrow(test_x))
    pred_label_test<-ifelse(col_name=="0",0,pred_label_test)
    pred_label_test<-ifelse(col_name=="1",1,pred_label_test)
    pred_label_test<-ifelse(col_name=="2",2,pred_label_test)
    TestAccu = (1-mean(pred_label_test!=test_y))*100
    cat(paste("It takes","C(",i,"),iter=",j,":",etm[3],"sec to train.\n",
              "Accuracy on the Train set: ",TrainAccu,"%\n",
              "Accuracy on the Test set: ",TestAccu,"%\n"))
    
  }
}
