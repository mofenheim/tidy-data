#Provide the URL
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

#Download the zip file. 
download.file(url, dest="dataset.zip", mode="wb") 

#Unzip the file
unzip("dataset.zip")

rm(list=ls())

library(plyr)
library(reshape2)

#read in activity labels
activity_labels <- read.table("./dataset/UCI HAR Dataset/activity_labels.txt")

#read in features labels. Will be used as name columns for the values in the y_ files for 
features <- read.table("./dataset/UCI HAR Dataset/features.txt")

#For test read in the X_, Y_, subject files
X_test <- read.table("./dataset/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./dataset/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")



#Rename the column variable names
names(y_test)[1] <- "activity"
names(subject_test)[1] <- "subject"
names(X_test) <- sapply(1:nrow(features), function(x) { names(X_test)[x] <- features[x,2]})

#Bind the subject file and the X_test which contains the activities w/ the signal data
total_test <- cbind(subject_test, y_test, X_test)

#Repeat the same for training
X_train <- read.table("./dataset/UCI HAR Dataset/train/X_train.txt")
y_train<- read.table("./dataset/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")


#Rename the column variable names
names(y_train)[1] <- "activity"
names(subject_train)[1] <- "subject"
names(X_train) <- sapply(1:nrow(features), function(x) { names(X_train)[x] <- features[x,2]})

#Bind the subject file and the X_test which contains the activities w/ the signal data
total_train <- cbind(subject_train, y_train, X_train)

#Row bind the two datasets (Train, Test)
total_dataset <- rbind(total_test, total_train)

#Convert activity column to factor & create labels
total_dataset$activity <- as.factor(total_dataset$activity)
labels <- levels(total_dataset$activity)

#Convert activity labels to character
activity_levels <- as.character(activity_labels$V2)

#Replace activity w/ number to mapped activity
total_dataset$activity <- mapvalues(total_dataset$activity, from = c(labels), to = c(activity_levels))

#columns to be extract (mean & std deviation)
names_dataset <- names(total_dataset)
names_dataset_values <- grep("[M|m]ean|[S|s]td|subject|activity", names(total_dataset))

tidy.data <- total_dataset[,c(names_dataset_values)]

#further clean variables
names_dataset <- names(tidy.data)
#Substitute parentheses and commas out of variable names 
names(tidy.data) <- gsub("\\(|\\)|,","_",names(tidy.data))
names(tidy.data) <- gsub("-|_", "",names(tidy.data))
names(tidy.data) <- gsub("^t", "time",names(tidy.data))
names(tidy.data) <- gsub("^f", "fft",names(tidy.data))
names(tidy.data) <- tolower(names(tidy.data))

#Create the tidy mean data set
tidy.mean.temp <- melt(tidy.data, id.vars=c("subject", "activity"))
tidy.mean <- dcast(tidy.mean.temp, subject + activity ~ variable, fun.aggregate = mean)

write.table(tidy.mean, "./tidymean.txt", sep="\t")

write.table(tidy.data, "./tidydata.txt", sep="\t")

