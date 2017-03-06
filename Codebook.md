# Codebook - Getting and Cleaning Data Course Project

## Purpose

Transform data from the Human Activity Recognition Using Smartphones Data Set with the following criteria:

* Merges Training and Test Data sets to one Data Set
* Extracts only the measurements on the mean and standard deviation for each measurements.
* Use descriptive Activity Names
* Apply appropriate labes in the data set with descriptive variable names.
* Create a subset independent tidy data set with the average of each variable for each activity and each subject

## run_analysis.R

### 1. Download Dataset from UCI

FilePath <- "e:/coursera/getting_cleaning_data/assignment"
setwd(FilePath)

Url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

download.file(Url, destfile = "UCI.zip", method = "libcurl" )

unzip(zipfile = "UCI.zip", exdir = "./data")

### 2. Read the Files and Create Data tables from files 

subject_train <- tbl_df(read.table("./data/UCI HAR Dataset/train/subject_train.txt"))
subject_test <- tbl_df(read.table("./data/UCI HAR Dataset/test/subject_test.txt"))

X_train <- tbl_df(read.table("./data/UCI HAR Dataset/train/X_train.txt"))
X_test <- tbl_df(read.table("./data/UCI HAR dataset/test/X_test.txt"))

features <- read.table("./data/UCI HAR Dataset/features.txt", header = FALSE)
activity_labels <- read.table("./data/UCI HAR Dataset/activity_labels.txt", header = FALSE)

### 3.Merge Training and Test Datasets

dataSubject <- rbind(subject_train, subject_test)
dataActivity <- rbind(Y_train, Y_test)
dataFeatures <- rbind(X_train, X_test)

### 4.Set Variable Names for Subject and Activity **

names(dataSubject) <- c("Subject")
names(dataActivity) <- c("Activity")
names(dataFeatures) <- features$V2

### 5.Merge All Data

subj_act_Data <- cbind(dataSubject, dataActivity)
all_Data <- cbind(dataFeatures, subj_act_Data)

### 6.Extract the measurements on the mean and standard deviation for each measurement.

MeanStd <- features$V2[grep("mean\\(\\)|std\\(\\)", features$V2)]
FeaturesMeanStd <- c("Subject", "Activity", as.character(MeanStd))

Data <- subset(all_Data, select = FeaturesMeanStd)

### 7.Use descriptive activity names to name the activities in the data set

Data$Activity <- factor(Data$Activity, labels = activity_labels$V2)

### 8.Labels the data set with descriptive variable names.

names(Data) <- gsub("BodyBody", "Body", names(Data))
names(Data) <- gsub("Acc", "Accelerometer", names(Data))
names(Data) <- gsub("Mag", "Magnitude", names(Data))
names(Data) <- gsub("Gyro", "Gyroscope", names(Data))
names(Data) <- gsub("^t", "time", names(Data))
names(Data) <- gsub("^f", "frequency", names(Data))

### 9. Create independent tidy data set with the average of each variable for each activity and each subject

tidyDataSet <- aggregate(. ~Subject + Activity, Data, mean)
tidyDataSet <- tidyDataSet[order(tidyDataSet$Subject, tidyDataSet$Activity), ]

### 10. Output data to text

write.table(tidyDataSet, file = "tidy_dataset.txt", row.names = FALSE)


# Dataset Information 

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.

** Each Record Contains the following: **

* Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
* Triaxial Angular velocity from the gyroscope. 
* A 561-feature vector with time and frequency domain variables. 
* Its activity label. 
* An identifier of the subject who carried out the experiment.

### Tidy Dataset Variable List

* Subject
* Activity
* timeBodyAccelerometer-mean()-X
* timeBodyAccelerometer-mean()-Y
* timeBodyAccelerometer-mean()-Z
* timeBodyAccelerometer-std()-X
* timeBodyAccelerometer-std()-Y
* timeBodyAccelerometer-std()-Z
* timeGravityAccelerometer-mean()-X
* timeGravityAccelerometer-mean()-Y
* timeGravityAccelerometer-mean()-Z
* timeGravityAccelerometer-std()-X
* timeGravityAccelerometer-std()-Y
* timeGravityAccelerometer-std()-Z
* timeBodyAccelerometerJerk-mean()-X
* timeBodyAccelerometerJerk-mean()-Y
* timeBodyAccelerometerJerk-mean()-Z
* timeBodyAccelerometerJerk-std()-X
* timeBodyAccelerometerJerk-std()-Y
* timeBodyAccelerometerJerk-std()-Z
* timeBodyGyroscope-mean()-X
* timeBodyGyroscope-mean()-Y
* timeBodyGyroscope-mean()-Z
* timeBodyGyroscope-std()-X
* timeBodyGyroscope-std()-Y
* timeBodyGyroscope-std()-Z
* timeBodyGyroscopeJerk-mean()-X
* timeBodyGyroscopeJerk-mean()-Y
* timeBodyGyroscopeJerk-mean()-Z
* timeBodyGyroscopeJerk-std()-X
* timeBodyGyroscopeJerk-std()-Y
* timeBodyGyroscopeJerk-std()-Z
* timeBodyAccelerometerMagnitude-mean()
* timeBodyAccelerometerMagnitude-std()
* timeGravityAccelerometerMagnitude-mean()
* timeGravityAccelerometerMagnitude-std()
* timeBodyAccelerometerJerkMagnitude-mean()
* timeBodyAccelerometerJerkMagnitude-std()
* timeBodyGyroscopeMagnitude-mean()
* timeBodyGyroscopeMagnitude-std()
* timeBodyGyroscopeJerkMagnitude-mean()
* timeBodyGyroscopeJerkMagnitude-std()
* frequencyBodyAccelerometer-mean()-X
* frequencyBodyAccelerometer-mean()-Y
* frequencyBodyAccelerometer-mean()-Z
* frequencyBodyAccelerometer-std()-X
* frequencyBodyAccelerometer-std()-Y
* frequencyBodyAccelerometer-std()-Z
* frequencyBodyAccelerometerJerk-mean()-X
* frequencyBodyAccelerometerJerk-mean()-Y
* frequencyBodyAccelerometerJerk-mean()-Z
* frequencyBodyAccelerometerJerk-std()-X
* frequencyBodyAccelerometerJerk-std()-Y
* frequencyBodyAccelerometerJerk-std()-Z
* frequencyBodyGyroscope-mean()-X
* frequencyBodyGyroscope-mean()-Y
* frequencyBodyGyroscope-mean()-Z
* frequencyBodyGyroscope-std()-X
* frequencyBodyGyroscope-std()-Y
* frequencyBodyGyroscope-std()-Z
* frequencyBodyAccelerometerMagnitude-mean()
* frequencyBodyAccelerometerMagnitude-std()
* frequencyBodyAccelerometerJerkMagnitude-mean()
* frequencyBodyAccelerometerJerkMagnitude-std()
* frequencyBodyGyroscopeMagnitude-mean()
* frequencyBodyGyroscopeMagnitude-std()
* frequencyBodyGyroscopeJerkMagnitude-mean()
* frequencyBodyGyroscopeJerkMagnitude-std()
