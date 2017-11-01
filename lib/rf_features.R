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
train_features <- features3[index,]
train_labels <- as.factor(labels3[index])

test_features <- features3[-index,]
test_labels <- as.factor(labels3[-index])

begin <- Sys.time()
rf.tree3 <- tuneRF(train_features, as.factor(train_labels), ntreeTry = 100, doBest = T)
end <- Sys.time()
end - begin
#1116.943 sec

#system.time(rf.tree3 <- randomForest(x=train_features, y=as.factor(train_labels), mtry = 70, ntree = 100)) 



# Training error
train_pred <- predict(rf.tree3, train_features)
train_error <- mean(train_pred != train_labels)
train_error

# Test error
test_pred <- predict(rf.tree3, test_features)
test_error <- mean(test_pred != test_labels)
test_error
# 0.096

save(rf.tree3, file = "~/Desktop/ADS/Fall2017-project3-fall2017-project3-grp9/data/rf_sift_color_lbp.RData")
