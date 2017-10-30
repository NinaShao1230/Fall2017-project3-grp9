library("EBImage")
library("OpenImageR")
# setwd('~/Desktop/ADS/Fall2017-project3-fall2017-project3-grp9/data/')
sift_features = read.csv('../data/training_set/sift_train.csv', header = T)
sift_features = t(sift_features)
sift_labels = unlist(read.csv('../data/training_set/label_train.csv', header = T)[,2])
# save(feature_sift, file="../feature_sift.RData")

# Randomly split the data into training(75%) and test(25%) set
n <- nrow(sift_features)
index <- sample(n, n*0.75)
train_features <- sift_features[index,]
train_labels <- as.factor(sift_labels[index])

test_features <- sift_features[-index,]
test_labels <- as.factor(sift_labels[-index])

################HOG FEATURES#################
img_dir <- "../data/training_set/images/"
dir_names <- list.files(img_dir)

hog_features <- function(img_dir){
  n_files <- length(list.files(img_dir))
  H <- matrix(NA, n_files,54) # why 54?
  
  for(i in 1:n_files){
    img <- readImage(paste0(img_dir, dir_names[i]))
    h <- HOG(img)
    H[i,] <- h
  }
  
  save(H, file="../data/hog_features.csv")
  return(H)
}

hog_features(img_dir)
