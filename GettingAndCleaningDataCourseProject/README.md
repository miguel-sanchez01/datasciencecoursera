
=======================================================================

## Getting and Cleaning Data Course Project

=======================================================================

### Get data

The project data was downloaded from the following link: [data_project](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).

#### Human Activity Recognition Using Smartphones Data Set

Human Activity Recognition database built from the recordings of 30 subjects performing activities of daily living (ADL) while carrying a waist-mounted smartphone with embedded inertial sensors.

#### The files to work with are the following:

- 'features.txt': List of all features.
- 'activity_labels.txt': Links the class labels with their activity name.
- 'train/X_train.txt': Training set.
- 'train/y_train.txt': Training labels.
- 'test/X_test.txt': Test set.
- 'test/y_test.txt': Test labels.
- 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 
- 'test/subject_test.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 


### The R script 'run_analysis.R'

0.- Load to R id's and descriptions for features being measured in experiment from file features.txt. <br>
1.- Merges the training and the test sets to create one data set.
  
  __Training data set__ <br>
  The files are loaded 
  
  - train/X_train.txt 
  - train/Y_train.txt 
  - train/subject_train.txt 
  and then they are joined by using the cbind function
  
  __Test data set__ <br>
  The files are loaded 
  
  - test/X_test.txt
  - test/Y_test.txt
  - test/subject_test.txt
  
  and then they are joined by using the cbind function. <br>
  Finally we proceed to gather the data in a single data using the cbind function, additionally we proceed to place appropriate names to the columns of the final data.
  
2.- Extracts only the measurements on the mean and standard deviation for each measurement. <br>
For this literal, we proceed to use the grep function which allows us to extract only the measurements on the mean and standard deviation for each measurement.

3.- Uses descriptive activity names to name the activities in the data set. <br>
To provide descriptive values for the activity labels, the "activity" variable is modified, which is a factor type variable with the levels mentioned in the activity_labels.txt file

4.- Appropriately labels the data set with descriptive variable names. <br>
The following actions were carried out: <br>

- Remove parentheses.
- Replace names beginning with t by TimeDomain_
- Replace names beginning with f by FrequencyDomain_
- Replace Acc by Accelerometer
- Replace Gyro by Gyroscope
- Replace Mag by Magnitude
- Replace -mean- by \_Mean\_
- Replace -std- by \_StandardDesviation\_
- Replace - by _


5.- From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject. <br>
Generate 'Tidy Dataset' that consists of the average (mean) of each variable for each subject and each activity. The result is shown in the file data_tidy.txt.
