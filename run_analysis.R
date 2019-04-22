library(dplyr)

filename <- "Coursera_DS3_Final.zip"

# Checking if archieve already exists.
if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL, filename, method="curl")
}  

# Checking if folder exists
if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename) 
}
#Assign data frames 
features<- read.table("UCI HAR Dataset/features.txt", col.names = c("n", "functions"))
activity<- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "labels"))
subject_test<- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = c("subjects"))
x_test<-read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test<- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train<- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subjects")
x_train<- read.table("UCI HAR Dataset/train/x_train.txt", col.names = features$functions)
y_train<- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")

#Merge the training and test sets to create one dataset
X<- rbind(x_train, x_test)
Y<- rbind(y_train, y_test)
subject<- rbind(subject_train, subject_test)
Merged_Data <- cbind(subject, Y, X)
#View(Merged_Data)

#Extracts only the measurements on the mean and standard deviation for each measurement
TidyData <- Merged_Data %>% select(subjects, code, contains("mean"), contains("std"))

#Uses descriptive activity names to name the activities in the data set
TidyData$code <- activity[TidyData$code, 2]

#Label data set variables with descriptive names
names(TidyData)[2] = "activity"
names(TidyData)<-gsub("Acc", "Accelerometer", names(TidyData))
names(TidyData)<-gsub("Gyro", "Gyroscope", names(TidyData))
names(TidyData)<-gsub("BodyBody", "Body", names(TidyData))
names(TidyData)<-gsub("Mag", "Magnitude", names(TidyData))
names(TidyData)<-gsub("^t", "Time", names(TidyData))
names(TidyData)<-gsub("^f", "Frequency", names(TidyData))
names(TidyData)<-gsub("tBody", "TimeBody", names(TidyData))
names(TidyData)<-gsub("-mean()", "Mean", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("-std()", "STD", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("-freq()", "Frequency", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("angle", "Angle", names(TidyData))
names(TidyData)<-gsub("gravity", "Gravity", names(TidyData))


finalData <- TidyData %>%
  group_by(subjects, activity) %>%
  summarise_all(funs(mean))
write.table(finalData, "finalData.txt", row.name=FALSE)
#Check
str(finalData)
finalData