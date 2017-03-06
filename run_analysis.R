## Getting and Cleaning Data Course Project
## Francis Brua

## Create one R script called run_analysis.R that does the following:
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive activity names.
## 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

library(RCurl)
library(data.table)
library(dplyr)
library(tidyr)

## Download the Data

FilePath <- "e:/coursera/getting_cleaning_data/assignment"
setwd(FilePath)

Url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

download.file(Url, destfile = "UCI.zip", method = "libcurl" )

unzip(zipfile = "UCI.zip", exdir = "./data")



# Read files and create data tables

# Subject Files
subject_train <- tbl_df(read.table("./data/UCI HAR Dataset/train/subject_train.txt"))
subject_test <- tbl_df(read.table("./data/UCI HAR Dataset/test/subject_test.txt"))

# Activity Files

Y_train <- tbl_df(read.table("./data/UCI HAR Dataset/train/Y_train.txt"))
Y_test <- tbl_df(read.table("./data/UCI HAR Dataset/test/Y_test.txt"))

# data files

X_train <- tbl_df(read.table("./data/UCI HAR Dataset/train/X_train.txt"))
X_test <- tbl_df(read.table("./data/UCI HAR dataset/test/X_test.txt"))

features <- read.table("./data/UCI HAR Dataset/features.txt", header = FALSE)
activity_labels <- read.table("./data/UCI HAR Dataset/activity_labels.txt", header = FALSE)

## Merge training and test sets

dataSubject <- rbind(subject_train, subject_test)
dataActivity <- rbind(Y_train, Y_test)
dataFeatures <- rbind(X_train, X_test)

# Set variable names

names(dataSubject) <- c("Subject")
names(dataActivity) <- c("Activity")
names(dataFeatures) <- features$V2

# Merge all data

subj_act_Data <- cbind(dataSubject, dataActivity)
all_Data <- cbind(dataFeatures, subj_act_Data)

# Extract measurements on the mean and standard deviation for each measurement

MeanStd <- features$V2[grep("mean\\(\\)|std\\(\\)", features$V2)]
FeaturesMeanStd <- c("Subject", "Activity", as.character(MeanStd))

Data <- subset(all_Data, select = FeaturesMeanStd)

# Use Descriptive Activity names to name the activities

Data$Activity <- factor(Data$Activity, labels = activity_labels$V2)

# Label data set with descriptive variable names

names(Data) <- gsub("BodyBody", "Body", names(Data))
names(Data) <- gsub("Acc", "Accelerometer", names(Data))
names(Data) <- gsub("Mag", "Magnitude", names(Data))
names(Data) <- gsub("Gyro", "Gyroscope", names(Data))
names(Data) <- gsub("^t", "time", names(Data))
names(Data) <- gsub("^f", "frequency", names(Data))


# create independent tidy data set with avg of each variable for each activity

tidyDataSet <- aggregate(. ~Subject + Activity, Data, mean)
tidyDataSet <- tidyDataSet[order(tidyDataSet$Subject, tidyDataSet$Activity), ]
write.table(tidyDataSet, file = "tidy_dataset.txt", row.names = FALSE)











