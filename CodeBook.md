This script (run_analysis.R) transforms the datasets downloaded from “https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip” based on the instructions from the Getting and Cleaning Data Week4 final project. 

The downloaded files contain the data collected from the accelerometers from the Samsung Galaxy S smartphone. To read more on the project, please refer to http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones. There are 8 text files in the downloaded data that are used in this exercise, namely, X_test, y_test, subject_test, X_train, y_train, subject_train, features and activity_labels. Detailed contents in each of the files are as below:   

1) X_test: recorded values from the accelerometer and gyroscope incorporated on the smartphone during the experiments by the volunteers (subjects) that are grouped in the “test” group. There are 561 variables in the data. Detailed information on these variables can be found in “features_info.txt” file in the downloaded data.
2) y_test: activities performed by each of the volunteers in the test group.
3) subject_test: IDs of the volunteers participating in the experiments who are in the test group.
4) X_train: recorded values from the accelerometer and gyroscope incorporated on the smartphone during the experiments by the volunteers (subjects) that are grouped in the “train” group. There are 561 variables in the data.
5) y_train: activities performed by each of the volunteers in the train group.
6) subject_train: IDs of the volunteers participating in the experiments who are in the train group.
7) features: variable names for the 561 variables found in the X_test and X_train files.
8) activity_labels: descriptive labels for the activities of the volunteers performed in the experiments, including 1 WALKING; 2 WALKING_UPSTAIRS; 3 WALKING_DOWNSTAIRS; 4 SITTING; 5 STANDING; 6 LAYING.

Briefly, the script is edited using RStudio. The files are read into data frames using the read.table() function. The data frames are merged together using the cbind() function. Then, a new dataset that contains only the variables containing strings “mean()” or “std()” is formed. Finally, a new dataset with the averaged values for each variable for each activity and each volunteer is formed using the melt() and ddply() functions.The new clean data containing the averaged values is saved in averages_summary.tx, which will be located in the working directory ("./UCI HAR Dataset").


Detailed codes are explained as below:

## Tidy up “test” data
##  Read test subject IDs to a data frame and name the column “volunteer”.
test_subject <- read.table("./test/subject_test.txt", col.names = "volunteer")

##  Read subject activities to a data frame and name the column “activity”.
test_activity <- read.table("./test/y_test.txt", col.names = “activity")

## Read the test data into dataframe
test_raw <- read.table("./test/X_test.txt")

## Read the train data into dataframe
variableNames <- read.table(“./features.txt")

## Rename column names in test_raw with descriptive names
names(test_raw) <- variableNames$V2


## Extract columns that contain string “mean()”
test_raw_mean <- test_raw[, grepl("mean()", colnames(test_raw), fixed = TRUE)]

## Extract columns that contain string “std()”
test_raw_std <- test_raw[, grepl("std()", colnames(test_raw), fixed = TRUE)]

## Combine test_raw_mean and test_raw_std
test_extract <- cbind(test_raw_mean, test_raw_std)

## Combine test_extract with subject and activity columns
test_all <- cbind(test_subject, test_activity, test_extract)

## Uses descriptive activity names to name the activities in the data set
test_all$activity <- factor(test_all$activity, levels = c(1,2,3,4,5,6), labels = c("walking", "walking_upstairs", "walking_downstairs", "sitting", "standing", "laying"))


## Tidy up “train” data
##  Read subject IDs to a data frame and name the column “volunteer”.
train_subject <- read.table("./train/subject_train.txt", col.names = "volunteer")

##  Read subject activities to a data frame and name the column “activity”.
train_activity <- read.table("./train/y_train.txt", col.names = “activity")

## Read the train data into dataframe
train_raw <- read.table("./train/X_train.txt")

## Read the train data into dataframe
variableNames <- read.table(“./features.txt")

## Rename column names in test_raw with descriptive names.
names(train_raw) <- variableNames$V2

## Extract columns that contain string “mean()”.
train_raw_mean <- train_raw[, grepl("mean()", colnames(train_raw), fixed = TRUE)]

## Extract columns that contain string “std()”.
train_raw_std <- train_raw[, grepl("std()", colnames(train_raw), fixed = TRUE)]

## Combine test_raw_mean and test_raw_std.
train_extract <- cbind(train_raw_mean, train_raw_std)

## Combine test_extract with subject and activity columns.
train_all <- cbind(train_subject, train_activity, train_extract)

## Uses descriptive activity names to name the activities in the data set
train_all$activity <- factor(train_all$activity, levels = c(1,2,3,4,5,6), labels = c("walking", "walking_upstairs", "walking_downstairs", "sitting", "standing", “laying"))

## Combine the tidied test and train datasets.
combined <- merge(test_all, train_all, all = TRUE)

## Melt the combined dataset and choose “volunteer” and “activity” as IDs.
melted <- melt(combined, id.vars = c("volunteer", “activity"))


## Calculate mean of each variable for each activity and each subject.
summary <- ddply(melted, .(volunteer, activity, variable), summarise, mean = mean(value))
## write the new dataset in a text file and name it averages_summary.txt
write.table(summary, "averages_summary.txt", row.name=FALSE)

To view the dataset, type: combined. 

# summarised in the “summary” dataset. To view the dataset, type summary

# If you want to view all the objects and dataframes I made during the exercise to get to the final datasets, please delete the last line in the run_analysis.R script.




