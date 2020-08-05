
install.packages('reshape2')
library(reshape2)

setwd("C:/Users/ ......... /UCI HAR Dataset")  #set to location of /UCI HAR Dataset

#------read in supporting tables------
features <- read.table('features.txt', sep="")

activity_labels <- read.table('activity_labels.txt', sep="")
names(activity_labels) <- c("activity_ID", "activity")


#------read in main data------
subject_train <- read.table('./train/subject_train.txt', sep="")
data_train <- read.table('./train/X_train.txt', sep="")
act_id_train <- read.table('./train/y_train.txt', sep="")

subject_test <- read.table('./test/subject_test.txt', sep="")
data_test <- read.table('./test/X_test.txt', sep="")
act_id_test <- read.table('./test/y_test.txt', sep="")


#============label data (step 4) and merge train and test into one dataset (step 1)============
names(subject_train) <- "subject_ID"
names(data_train) <- features[,2]  #assign descriptive feature names to column
names(act_id_train) <- "activity_ID"
dataset_train <- cbind(subject_train, data_train, act_id_train)

names(subject_test) <- "subject_ID"
names(data_test) <- features[,2]  #assign descriptive feature names to column
names(act_id_test) <- "activity_ID"
dataset_test <- cbind(subject_test, data_test, act_id_test)

dataset_all <- rbind(dataset_train, dataset_test)

#remove tables no longer used to keep things cleaner
rm(subject_train, data_train, act_id_train, subject_test, data_test, act_id_test, dataset_train, dataset_test)


#============extract mean() and std() columns (step 2)============
headers_mean_var <- grep("mean\\(\\)|std\\(\\)", names(dataset_all), value = TRUE)  #get columns of IDs, mean(), and std()
dataset_trim <- dataset_all[,c('subject_ID', 'activity_ID', c(headers_mean_var))]


#============add descriptive activity names (step 3)============
dataset_trim <- merge(dataset_trim, activity_labels, by.x="activity_ID", by.y="activity_ID", all=TRUE )


#============get averages of each column (step 5)============
#I interpreted this as get the averages of mean and std for each subject/activity

dataset_trim$subject_ID <-as.factor(dataset_trim$subject_ID)
dataset_trim$activity_ID <-as.factor(dataset_trim$activity_ID)


dataset_avg <- table(dataset_trim[,c("subject_ID", "activity")])  #get the dataframe started with a dummy count value for each subject/activity
dataset_avg <- melt(dataset_avg, id=c("subject_ID","activity"))  #reshape the dataframe so that subject and activity are both columns
dataset_avg <- subset(dataset_avg, select = -value)  #remove dummy count value column

for (i in 1:ncol(dataset_trim)) {
    if(names(dataset_trim)[i] %in% headers_mean_var){  #if column is a mean or std, then calculate the average
        a <- tapply(dataset_trim[,i], dataset_trim[c("subject_ID","activity")], mean)  #calculate average for column for each subject/activity
        b <- melt(a, id=c("subject_ID","activity"))
        names(b)[names(b) == 'value'] <- names(dataset_trim)[i]  #name the column
        dataset_avg <- merge(dataset_avg, b, by.x=c('subject_ID', 'activity'), by.y=c('subject_ID', 'activity'))  #merge back to dataset
    }
}


#============final tables============
dataset_trim  #contains the detailed data for mean and std columns for each participant/activity
dataset_avg  #contains the average for mean and std columns for each participant/activity


write.table(dataset_trim, 'Data_Detailed.txt', row.name = FALSE)
#write.table(dataset_avg, 'Data_Summarized.txt', row.name = FALSE)

