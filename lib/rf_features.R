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
sift_features <- read.csv('~/Desktop/ADS/Fall2017-project3-fall2017-project3-grp9/data/training_set/sift_train.csv', header = T)[,-1]
color_features <- read.csv('~/Desktop/ADS/Fall2017-project3-fall2017-project3-grp9/data/color_features.csv', header = T)[,-1]
all_features <- cbind(sift_features, color_features)
all_labels = unlist(read.csv('~/Desktop/ADS/Fall2017-project3-fall2017-project3-grp9/data/training_set/label_train.csv', header = T)[,2])

all_imputed <- rfImpute(all_features, as.factor(all_labels), ntree = 70)

set.seed(90)
alln <- nrow(all_imputed)
allindex <- sample(alln, alln*0.75)
alltrain_features <- all_imputed[allindex,-1]
alltrain_labels <- as.factor(all_imputed[allindex,1])

alltest_features <- all_imputed[-allindex,-1]
alltest_labels <- as.factor(all_imputed[-allindex,1])

#train_imputed <- rfImpute(alltrain_features, as.factor(alltrain_labels), ntree = 70)
#test_imputed <- rfImpute(alltest_features, as.factor(alltest_labels), ntree = 70)

### CV ###
K = 5
m <- length(alltrain_labels)
m.fold <- floor(m/K)
s <- sample(rep(1:K, c(rep(m.fold, K-1), m-(K-1)*m.fold))) 
cv.error <- rep(NA, K)

for (i in 1:K){
  train.data <- alltrain_features[s != i,]
  train.label <- alltrain_labels[s != i]
  test.data <- alltrain_features[s == i,]
  test.label <- alltrain_labels[s == i]
  
  fit <- tuneRF(train.data, as.factor(train.label), ntree = 70, doBest = T)
  pred <- predict(fit, test.data)
  cv.error[i] <- mean(pred != test.label)
}

# Visualize CV
# ggplot(data = data.frame(cv.error)) + geom_point(aes(x = 1:10, y = cv.error))

best <- which.min(cv.error)

system.time(rf.train <- tuneRF(alltrain_features[s != best,], as.factor(alltrain_labels[s != best]), ntreeTry = 70, doBest = T))

#system.time(rf.tree <- randomForest(x=alltrain_features[s != best,], y=as.factor(alltrain_labels[s != best]), mtry = 70))
#rf.tree$err.rate[, "OOB"]

# Training error
train_pred <- predict(rf.train, alltrain_features)
train_error <- mean(train_pred != alltrain_labels)
train_error

# Test error
test_pred <- predict(rf.train, alltest_features)
test_error <- mean(test_pred != alltest_labels)
test_error

save(rf.train, file = "~/Desktop/ADS/Fall2017-project3-fall2017-project3-grp9/lib/RF/rftrain.RData")
