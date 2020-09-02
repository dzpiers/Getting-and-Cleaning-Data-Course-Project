# Loading neceassary packages
library(dplyr)
library(data.table)

# Cheking working directory which was set via Version Control
getwd()

# Reading in all the relevant datasets
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")

# Combining the relevant datasets
X <- rbind(x_test, x_train)
Y <- rbind(y_test, y_train)
Subject <- rbind(subject_train, subject_test)
Merged_Data <- cbind(Subject, Y, X)

# Extracting only measurements that contain the mean and standard deviation
Merged_Data <- select(Merged_Data, subject, code, contains("mean"), contains("std"))

# Giving more descriptive names to the activies variable
Merged_Data$code <- sub("1", "Walking", Merged_Data$code)
Merged_Data$code <- sub("2", "Walking Upstairs", Merged_Data$code)
Merged_Data$code <- sub("3", "Walking Downstairs", Merged_Data$code)
Merged_Data$code <- sub("4", "Sitting", Merged_Data$code)
Merged_Data$code <- sub("5", "Standing", Merged_Data$code)
Merged_Data$code <- sub("6", "Lying", Merged_Data$code)

# Checking each variable name for possible improvement
names(Merged_Data)
dim(Merged_Data)

# Giving each variable name a clearer name
names(Merged_Data) <- gsub("^t", "Time", names(Merged_Data))
names(Merged_Data) <- gsub("^f", "Frequency", names(Merged_Data))
names(Merged_Data) <- gsub("Acc", "Accelerometer", names(Merged_Data))
names(Merged_Data) <- gsub("Mag", "Magnitude", names(Merged_Data))
names(Merged_Data) <- gsub("Gyro", "Gyroscope", names(Merged_Data))
names(Merged_Data) <- gsub("mean", "Mean", names(Merged_Data))
names(Merged_Data) <- gsub("std", "Std", names(Merged_Data))
names(Merged_Data) <- gsub("angle", "Angle", names(Merged_Data))
names(Merged_Data) <- gsub("gravity", "Gravity", names(Merged_Data))
names(Merged_Data) <- gsub("BodyBody", "Body", names(Merged_Data))
names(Merged_Data) <- gsub("tBody", "TimeBody", names(Merged_Data))
names(Merged_Data) <- gsub("\\.", "", names(Merged_Data))

# Creating and saving a dataset of the modified data so far
write.table(Merged_Data, "Merged_Data.txt", row.names = FALSE)

# Grouping the dataset by subject and activity to then show the average of each
# subject and activity
as.factor(Merged_Data$code)
Simple_Data <- group_by(Merged_Data, subject, code)
Simple_Data <- summarise_all(Simple_Data, mean)

# Creating and saving this dataset
write.table(Simple_Data, "Simple_Data.txt", row.names = FALSE)
