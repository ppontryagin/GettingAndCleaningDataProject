Steps to clean data
============

# 1. Download and unzip files
# 2. Initialize data arrays 

Read files to variables
xTrainData, xTestData 
yTrainData, yTestData
subjectTrainData, subjectTestData
featuresData, actLabels

# 3.  Combine data
trainDenorm, testDenorm

# 4. Add column names
header <- c("subject", "activity", as.character(featuresData$V2))
colnames(trainDenorm) <- header
colnames(testDenorm) <- header

# 5. Substitue activity type
trainDenorm$activity <- actLabels$V2[match(trainDenorm$activity, actLabels$V1)]
testDenorm$activity <- actLabels$V2[match(testDenorm$activity, actLabels$V1)]

# 6. Select only std, mean
trainDenorm <- trainDenorm[grep("subject|activity|mean|std", names(trainDenorm))]
testDenorm <- testDenorm[grep("subject|activity|mean|std", names(testDenorm))]

##7  Merge the training and the test sets to create one data set.
tidyData <- rbind(testDenorm, trainDenorm)

# Final step ======================
###  Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

colNames2Aggregate <- grep("mean|std", names(tidyData))
aggrData <- aggregate(tidyData[, colNames2Aggregate], list(subject=tidyData$subject, activity=tidyData$activity), mean)

# Write to file!!!
write.table(aggrData, "aggr_data.txt", row.name=FALSE)




## How to run

```
source(file = "run_analysis.R")
```