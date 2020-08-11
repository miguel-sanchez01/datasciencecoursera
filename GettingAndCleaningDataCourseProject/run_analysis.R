
# Getting and Cleaning Data Course Project --------------------------------

# Name: Miguel Ángel Sánchez ----------------------------------------------

library(dplyr)

#' 0. Get data.

dw <- 'GettingAndCleaningDataCourseProject/UCI HAR Dataset/'
features <- read.table(paste(dw, 'features.txt', sep = ''))


#' 1. Merges the training and the test sets to create one data set.

# train data
x_train <- read.table(paste(dw, 'train/X_train.txt', sep = ''))
y_train <- read.table(paste(dw, 'train/Y_train.txt', sep = ''))
s_train <- read.table(paste(dw, 'train/subject_train.txt', sep = ''))

data_train <- cbind(s_train, y_train, x_train)

# test data
x_test <- read.table(paste(dw, 'test/X_test.txt', sep = ''))
y_test <- read.table(paste(dw, 'test/Y_test.txt', sep = ''))
s_test <- read.table(paste(dw, 'test/subject_test.txt', sep = ''))

data_test <- cbind(s_test, y_test, x_test)
 
# All data

data_all <- rbind(data_train, data_test)
names(data_all) <- c('subject', 'activity', as.character(features$V2))


#' 2. Extracts only the measurements on the mean and standard deviation for each 
#' measurement.

str_mean_std <- as.character(features$V2)[grep('mean|std', as.character(features$V2))]
data_select <- data_all[, c('subject', 'activity', str_mean_std)]


#' 3. Uses descriptive activity names to name the activities in the data set

activity_labels <- read.table(paste(dw, 'activity_labels.txt', sep = ''))
activity_labels <- as.character(activity_labels$V2)
data_select$activity <- activity_labels[data_select$activity]


#' 4. Appropriately labels the data set with descriptive variable names.

appropriately_labels <- names(data_select)
appropriately_labels <- gsub("[(][)]", "", appropriately_labels)
appropriately_labels <- gsub("^t", "TimeDomain_", appropriately_labels)
appropriately_labels <- gsub("^f", "FrequencyDomain_", appropriately_labels)
appropriately_labels <- gsub("Acc", "Accelerometer", appropriately_labels)
appropriately_labels <- gsub("Gyro", "Gyroscope", appropriately_labels)
appropriately_labels <- gsub("Mag", "Magnitude", appropriately_labels)
appropriately_labels <- gsub("-mean-", "_Mean_", appropriately_labels)
appropriately_labels <- gsub("-std-", "_StandardDesviation_", appropriately_labels)
appropriately_labels <- gsub("-", "_", appropriately_labels)
names(data_select) <- appropriately_labels


#' 5. From the data set in step 4, creates a second, independent tidy data set 
#' with the average of each variable for each activity and each subject.

data_tidy <- data_select %>% 
  group_by(activity, subject) %>% 
  summarise_all(mean)

write.table(x = data_tidy, file = "data_tidy.txt", row.names = FALSE)
