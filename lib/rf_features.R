library(caret)
library(randomForest)
#setwd('~/Desktop/ADS/Fall2017-project3-fall2017-project3-grp9/data')
sift_features <- read.csv('~/Desktop/ADS/Fall2017-project3-fall2017-project3-grp9/data/training_set/sift_train.csv', header = T)[,-1]
color_features <- read.csv('~/Desktop/ADS/Fall2017-project3-fall2017-project3-grp9/data/color_features.csv', header = T)[,-1]
lbp_features <- read.csv('~/Desktop/ADS/Fall2017-project3-fall2017-project3-grp9/data/lbp_feature.csv', header = T)
features3 <- cbind(sift_features, color_features, lbp_features)
labels3 = unlist(read.csv('~/Desktop/ADS/Fall2017-project3-fall2017-project3-grp9/data/training_set/label_train.csv', header = T)[,2])

# # May be deleted later:
# begin <- Sys.time()
# imputed3 <- rfImpute(features3, as.factor(labels3), ntree = 100, iter = 1)
# end <- Sys.time()
# end - begin

# Data Cleaning/Preprocessing: Replace NAs with ColMean
na_ind <- which(is.na(features3),TRUE)
range(na_ind[,2])
features3[] <- lapply(features3, function(x) ifelse(is.na(x), mean(x, na.rm = TRUE), x))

set.seed(90)
n <- nrow(features3)
index <- sample(n, n*0.75)
train_features <- features3[index,-1]
train_labels <- as.factor(features3[index,1])

test_features <- features3[-index,-1]
test_labels <- as.factor(features3[-index,1])

### CV ###
K = 5
m <- length(train_labels)
m.fold <- floor(m/K)
s <- sample(rep(1:K, c(rep(m.fold, K-1), m-(K-1)*m.fold))) 
cv.error <- rep(NA, K)

for (i in 1:K){
  train.data <- train_features[s != i,]
  train.label <- train_labels[s != i]
  test.data <- train_features[s == i,]
  test.label <- train_labels[s == i]
  
  fit <- tuneRF(train.data, as.factor(train.label), ntree = 100, doBest = T)
  pred <- predict(fit, test.data)
  cv.error[i] <- mean(pred != test.label)
}

# Visualize CV
# ggplot(data = data.frame(cv.error)) + geom_point(aes(x = 1:10, y = cv.error))

error <- mean(cv.error)

system.time(rf.train3 <- tuneRF(train_features[s != best,], as.factor(train_labels[s != best]), ntreeTry = 100, doBest = T))
#1116.943 sec

#system.time(rf.tree3 <- randomForest(x=train_features[s != best,], y=as.factor(train_labels[s != best]), mtry = 70, ntree = 100)) 
# 141.961 sec


# Training error
train_pred <- predict(rf.train3, train_features)
train_error <- mean(train_pred != train_labels)
train_error

# Test error
test_pred <- predict(rf.train3, test_features)
test_error <- mean(test_pred != test_labels)
test_error
# 0.09866667 and train error = 0.01466667
# 0.08933333 rf.tree3 train error = 0 ####overfitting
# 0.1 rf.train3

save(rf.tree3, file = "~/Desktop/ADS/Fall2017-project3-fall2017-project3-grp9/lib/RF/rf_train3.RData")