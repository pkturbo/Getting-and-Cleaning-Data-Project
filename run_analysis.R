#  Course Project - Getting & Cleaning Data
#
#  by pkturbo
#
# Step 1: Read in and combine raw data files

library("stringr")
library("reshape2")

setwd("~/Coursera/Cleaning Data/Project")

# read in feature names and labels

features <- read.table("features.txt",colClasses="character")
features <- features$V2
activity_labels <- read.table("activity_labels.txt",colClasses="character")

# read in subject and activity vectors

y_test <- read.table("test/y_test.txt")
subject_test <- read.table("test/subject_test.txt")
X_test <- read.table("test/X_test.txt")

y_train <- read.table("train/y_train.txt")
subject_train <- read.table("train/subject_train.txt")
X_train <- read.table("train/X_train.txt")

# make proper activity column names (this is for Step 3)

n_test <- dim(y_test)[1]; y_label_test <- character(length=n_test)
n_train <- dim(y_train)[1]; y_label_train <- character(length=n_train)
for (i in 1:n_test) { y_label_test[i] <- activity_labels[y_test[i,1],2] }
for (i in 1:n_train) { y_label_train[i] <- activity_labels[y_train[i,1],2] }

# combine data.frames into one big data.frame

test <- cbind(subject_test,y_label_test,X_test)  # combine subject, activity and data
train <- cbind(subject_train,y_label_train,X_train)

colnames(test) <- c("SubjectNo","Activity",features) # this is for Step 4
colnames(train) <- c("SubjectNo","Activity",features)
dt <- rbind(test,train)  # combine test and training sets

# Step 2: Extract measurments on the mean and std deviation

ifmean <- str_detect(features,"mean()")  # find features that contain "mean"
ifstd <- str_detect(features,"std()")  # find features that contain "std"
mean_std <- ifmean | ifstd
new_features <- features[mean_std]
mean_std <- c(TRUE,TRUE,mean_std)  # add first two (subject and activity) headers
dt2 <- dt[,mean_std]  # this is now the reduced data set (mean and std only)

# Step 5: Write out average data

dt_melt <- melt(dt2,id.vars=c("SubjectNo","Activity"))
data_out <- dcast(dt_melt,SubjectNo+Activity ~ variable,mean)
write.table(data_out, file="TidyDataOut.txt", row.names=FALSE)

# fini
