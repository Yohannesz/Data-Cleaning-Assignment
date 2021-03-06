library(plyr)
# The Zipped file is unzipped in ay working directory. The next step is to load data
activity_labels<-read.table("activity_labels.txt")
features<-read.table("features.txt")
subject_test<-read.table("subject_test.txt")
X_test<-read.table("X_test.txt")
y_test<-read.table("y_test.txt")
subject_train<-read.table("./train/subject_train.txt")
X_train<-read.table("./train/X_train.txt")
y_train<-read.table("./train/y_train.txt")

# 1. Merges the training and test sets to create one data set.

X<-rbind(X_train,X_test)
subject<-rbind(subject_train,subject_test)
y<-rbind(y_train,y_test)

# 2. Use descriptive activity names to name activities in data set and 
# appropriately label the data sets with descriptive variable names
names(y)<-c("Activity_ID")
names(subject)<-c("Subject_ID")
colnames<-gsub("[^[:alnum:] ]", "", features[,2])
names(X)<-colnames
names(activity_labels)<-c("Activity_ID","Activity")

# Select columns name with means and std and then Extract name of columns with means and std
extractIndexCols <- grep("-mean\\(\\)|-std\\(\\)", features[,2])
colsName_meanstd<-features[,2] [extractIndexCols] 

# Extract only the the measurements of mean and std  from data set using colsName_meanstd

data.meanstd<-X[,colsName_meanstd]

#merge activity lables and y by the ID variable

Activity<-join(y,activity_labels,by="Activity_ID")

# Combine Activity data and mean and standard deviation data ino a single data set
data.combined<-cbind(subject,Activity=Activity$Activity,data.meanstd)

#Create a second independent tidy data set that contains the 
#average of each variable for each activity and each subject
data_Mean<-aggregate(.~Activity+Subject_ID,data.combined,FUN=mean)
data_Mean<-data_Mean[c(2,1,3:ncol(data_Mean))]

write.table(data_Mean, "data_Mean.txt")
