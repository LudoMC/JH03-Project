## Get Labels for each activity ID
ActivityLabels <- read.table(file="./UCI HAR Dataset/activity_labels.txt",
                             sep=" ",
                             col.names = c("Id","Activity"),
                             stringsAsFactors = FALSE)
## Get Labels for each features ID
FeaturesLabels <- read.table(file="./UCI HAR Dataset/features.txt",
                             sep=" ",
                             col.names = c("Id", "Feature"))

##Training set
#IDs of Activities
TrainLabels <- read.table(file="./UCI HAR Dataset/train/y_train.txt",
                          sep=" ",
                          col.names = c("Activity Id"))
#Main data with column names being features name
TrainSet <- read.table(file="./UCI HAR Dataset/train/X_train.txt",
                       col.names = FeaturesLabels$Feature)
#IDs of Subjects
TrainSubjects <- read.table(file="./UCI HAR Dataset/train/subject_train.txt",
                            col.names = c("Subject Id"))
#Constructing main Train DF
Train <- data.frame(Subject=TrainSubjects$Subject.Id) # Subject ID
Train <- cbind(Train, Activity=as.character(ActivityLabels$Activity[TrainLabels$Activity.Id])) # Activity name
Train <- cbind(Train, TrainSet) # Measures from wearable gadget

##Test set
#IDs of Activities
TestLabels <- read.table(file="./UCI HAR Dataset/test/y_test.txt",
                         sep=" ",
                         col.names = c("Activity Id"))
#Main data with column names being features name
TestSet <- read.table(file="./UCI HAR Dataset/test/X_test.txt",
                      col.names = FeaturesLabels$Feature)
#IDs of Subjects
TestSubjects <- read.table(file="./UCI HAR Dataset/test/subject_test.txt",
                           col.names = c("Subject Id"))
#Constructing main Test DF
Test <- data.frame(Subject=TestSubjects$Subject.Id) # Subject ID
Test <- cbind(Test, Activity=as.character(ActivityLabels$Activity[TestLabels$Activity.Id])) # Activity name
Test <- cbind(Test, TestSet) # Measures from wearable gadget


##Merge Train & Test sets
OneSet <- rbind(Train,Test)

#Keeping only std() and mean() columns + Activity and Subject.Id (last two columns)
colsToKeep <- as.vector(FeaturesLabels$Id[grepl("mean\\(\\)",FeaturesLabels$Feature)])
colsToKeep <- c(colsToKeep, as.vector(FeaturesLabels$Id[grepl("std\\(\\)",FeaturesLabels$Feature)]))
colsToKeep <- colsToKeep + 2
colsToKeep <- c(1, 2, colsToKeep)
library(dplyr)
#Subsetting the global set keeping only the columns selected above
OneSubSet <- select(OneSet, colsToKeep)
OneSubSet$Activity <- as.character(OneSubSet$Activity)

#Construct the (wide) tidy data frame
#One line per subject per activity and 68 columns of the mean of each measure
tidyDF <- subset(OneSubSet, 1==0)
idx <- 0
for(s in min(OneSubSet$Subject):max(OneSubSet$Subject)){ # For each subject
    tmp <- filter(OneSubSet, Subject==s)
    for (a in 1:nrow(ActivityLabels)) { # For each activity for this subject
        tmp.act <- filter(tmp, Activity == ActivityLabels$Activity[[a]])
        idx <- idx + 1
        tidyDF[idx,] <- c(tmp.act$Subject[1], tmp.act$Activity[1], colMeans(tmp.act[3:68]))
    }
}

#Creating the file to be uploaded for the Course project
write.table(tidyDF, file = "./UCI HAR Dataset/TIDY.TXT", sep = " ", quote = FALSE, row.name=FALSE)
