## Script to merge and clean data
## Libraries
library(dplyr)

###############################################################################################
## Merges the training and the test sets to create one data set.
# Training data
x_train = read.table(file = "train/X_train.txt")
y_train = read.table(file = "train/y_train.txt")
subject_train = read.table(file = "train/subject_train.txt")

# Test data
x_test = read.table(file = "test/X_test.txt")
y_test = read.table(file = "test/y_test.txt")
subject_test = read.table(file = "test/subject_test.txt")

# Merging training set
x_data = rbind(x_train,x_test)
y_data = rbind(y_train,y_test)
subject_data = rbind(subject_train,subject_test)
## Since features have to be extracted and labelled, all data sets will combined as a last step
###############################################################################################
## Extracts only the measurements on the mean and standard deviation for each measurement.
# Names of all the features
features = read.table("features.txt")
# Extracting all indices with mean or std
mean_and_std = grep("-(mean|std)\\(\\)",features[,2])
# Subsetting data based on column number
x_data_mean_std = x_data[,mean_and_std] 

###############################################################################################
## Uses descriptive activity names to name the activities in the data set
# Load activity names
activity_names = read.table(file = "activity_labels.txt")
# Replacing each numerical value by it's activity name found in activity_names
y_data[,1] = as.data.frame(activity_names[y_data[,1],2])

###############################################################################################
## Appropriately labels the data set with descriptive variable names.
# Renaming all the x variable names
colnames(x_data_mean_std) = features[mean_and_std,2]
# Renaming the y column for the activities
colnames(y_data) = "activity"
# Renaming the subject column 
colnames(subject_data) = "subject"
# Combing all the data sets together
final_data = cbind(x_data_mean_std,y_data,subject_data)

###############################################################################################
## From the data set in step 4, creates a second, independent tidy data set with the average of
## each variable for each activity and each subject.
final_data = tbl_df(final_data)
# Groups the data by activity followed by subject then summarizes all columns using the mean function
avg_grouped = final_data %>% group_by(activity,subject) %>% summarize_each(funs(mean))
# Writing the file for output
write.table(x = avg_grouped, file = "averaged_data.txt",row.names = FALSE)
