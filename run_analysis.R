# 1. Download and unzip files

setwd("c://tmp/r")

if(!file.exists("./data")) {dir.create("./data")}

zipUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
destFile <- "./data/Dataset.zip"
download.file(zipUrl, destFile, method="curl")

unzip(destFile, files = NULL, list = FALSE, overwrite = TRUE,  junkpaths = FALSE, exdir = ".", unzip = "internal", setTimes = FALSE)


# 2 Initialize data arrays 

# Measurements

## Train
xTrainFile <- "UCI HAR Dataset/train/X_train.txt"
xTrainData <- read.table(xTrainFile, sep="")

## Test
xTestFile <- "UCI HAR Dataset/test/X_test.txt"
xTestData <- read.table(xTestFile, sep="")

#Activity type

## Train
yTrainFile <- "UCI HAR Dataset/train/y_train.txt"
yTrainData <- read.table(yTrainFile, sep="\t")

## Test
yTestFile <- "UCI HAR Dataset/test/y_test.txt"
yTestData <- read.table(yTestFile, sep="\t")

#Person id
## Train
subjectTrainFile <- "UCI HAR Dataset/train/subject_train.txt"
subjectTrainData <- read.table(subjectTrainFile, sep="\t")

## Test
subjectTestFile <- "UCI HAR Dataset/test/subject_test.txt"
subjectTestData <- read.table(subjectTestFile, sep="\t")

#Column names
featuresFile <- "UCI HAR Dataset/features.txt"
featuresData <- read.table(featuresFile, sep=" ")

#Activity labels
actLabelFile <- "UCI HAR Dataset/activity_labels.txt"
actLabels <- read.table(actLabelFile, sep="")


# 3.  Label and combine data
## Train data
# Combine datasets
trainDenorm <- cbind(subjectTrainData, yTrainData, xTrainData, deparse.level = 1)

# Add column names
header <- c("subject", "activity", as.character(featuresData$V2))
colnames(trainDenorm) <- header

# substitue activity type
trainDenorm$activity <- actLabels$V2[match(trainDenorm$activity, actLabels$V1)]

#Grep std, mean
trainDenorm <- trainDenorm[grep("subject|activity|mean|std", names(trainDenorm))]
head(trainDenorm)

## Test data
# Combine datasets
testDenorm <- cbind(subjectTestData, yTestData, xTestData, deparse.level = 1)

# Add column names
### 4. Appropriately labels the data set with descriptive variable names. 
header <- c("subject", "activity", as.character(featuresData$V2))
colnames(testDenorm) <- header

# substitue activity type
### 3. Uses descriptive activity names to name the activities in the data set
testDenorm$activity <- actLabels$V2[match(testDenorm$activity, actLabels$V1)]

#Grep std, mean
### 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
testDenorm <- testDenorm[grep("subject|activity|mean|std", names(testDenorm))]
head(testDenorm)

# 4 Combine train and test datasets
### 1. Merge the training and the test sets to create one data set.
tidyData <- rbind(testDenorm, trainDenorm)

#======================
### From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

colNames2Aggregate <- grep("mean|std", names(tidyData))
aggrData <- aggregate(tidyData[, colNames2Aggregate], list(subject=tidyData$subject, activity=tidyData$activity), mean)

write.table(aggrData, "aggr_data.txt", row.name=FALSE)


