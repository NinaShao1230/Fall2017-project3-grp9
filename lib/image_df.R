install.packages("OpenImageR")
# library(EBImage)
library("OpenImageR")
setwd("/Users/ninashao/Desktop/Fall2017-project3-fall2017-project3-grp9-master 2")
img_labels<-read.csv("/Users/ninashao/Desktop/Fall2017-project3-fall2017-project3-grp9-master 2/data/training_set/label_train.csv",header = T)
img_dir <- "/Users/ninashao/Desktop/Fall2017-project3-fall2017-project3-grp9-master 2/data/image3/"
dir_names <- list.files(img_dir)
n_files <- length(list.files(img_dir))
labels<-img_labels$label..0.for.muffin..1.for.chicken..2.for.dog.

# Set up df
df <- data.frame()

# Set image size. In this case 28x28
img_size <- 28*28

for(i in 1:n_files){
  img <- as.matrix(readImage(paste0(img_dir, dir_names[i])))
  # Get the image as a matrix
  img_matrix <- img@.Data
  # Coerce to a vector
  img_vector <- as.vector(t(img_matrix))
  # Bind rows
  df <- rbind(df,img_vector)
  # Print status info
  print(paste("Done ", i, sep = ""))
}
# dim(df)
df_label<-cbind(labels,df)
write.csv(df_label, file="df_nn.csv", row.names = FALSE)
