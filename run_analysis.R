### Course project for the Getting data and cleaning course:Coursera-John Hopkins University

### Author: Sagnik Das

### Loading the required packages


library(data.table)
library(reshape2)

### Reading the data into R using the fread() command:

### Activity labels and features:

activitylabels<- fread("C:\\Users\\das90\\OneDrive\\Coursera courses\\John Hopkins\\R Codes and Files\\Data-Science-Course-Data-processing\\Project\\getdata_projectfiles_UCI HAR Dataset\\UCI HAR Dataset\\activity_labels.txt")
features<- fread(file.path("C:\\Users\\das90\\OneDrive\\Coursera courses\\John Hopkins\\R Codes and Files\\Data-Science-Course-Data-processing\\Project\\getdata_projectfiles_UCI HAR Dataset\\UCI HAR Dataset\\features.txt"), col.names = c("index", "featureNames"))

featuresWanted <- grep("(mean|std)\\(\\)", features[, featureNames])
measurements <- features[featuresWanted, featureNames]
measurements <- gsub('[()]', '', measurements)


### Reading the train datasets:


train<- fread(file.path("C:\\Users\\das90\\OneDrive\\Coursera courses\\John Hopkins\\R Codes and Files\\Data-Science-Course-Data-processing\\Project\\getdata_projectfiles_UCI HAR Dataset\\UCI HAR Dataset\\train\\X_train.txt"))[, featuresWanted, with = FALSE]
data.table::setnames(train, colnames(train), measurements)

trainActivities<- fread(file.path("C:\\Users\\das90\\OneDrive\\Coursera courses\\John Hopkins\\R Codes and Files\\Data-Science-Course-Data-processing\\Project\\getdata_projectfiles_UCI HAR Dataset\\UCI HAR Dataset\\train\\y_train.txt"), col.names = c("Activity"))
trainSubjects<- fread(file.path("C:\\Users\\das90\\OneDrive\\Coursera courses\\John Hopkins\\R Codes and Files\\Data-Science-Course-Data-processing\\Project\\getdata_projectfiles_UCI HAR Dataset\\UCI HAR Dataset\\train\\subject_train.txt"), col.names = c("SubjectNum"))

traindata<- cbind(trainActivities,trainSubjects,train)


### Reading the test datasets:

test<- fread(file.path("C:\\Users\\das90\\OneDrive\\Coursera courses\\John Hopkins\\R Codes and Files\\Data-Science-Course-Data-processing\\Project\\getdata_projectfiles_UCI HAR Dataset\\UCI HAR Dataset\\test\\X_test.txt"))[,featuresWanted, with = F]
data.table::setnames(test,colnames(test), measurements)
testActivities<- fread(file.path("C:\\Users\\das90\\OneDrive\\Coursera courses\\John Hopkins\\R Codes and Files\\Data-Science-Course-Data-processing\\Project\\getdata_projectfiles_UCI HAR Dataset\\UCI HAR Dataset\\test\\y_test.txt"), col.names = c("Activity"))
testSubjects<- fread(file.path("C:\\Users\\das90\\OneDrive\\Coursera courses\\John Hopkins\\R Codes and Files\\Data-Science-Course-Data-processing\\Project\\getdata_projectfiles_UCI HAR Dataset\\UCI HAR Dataset\\test\\subject_test.txt"), col.names = c("SubjectNum"))

testdata<- cbind(testActivities,testSubjects,test)


### Merging the train and test datasets

completedata<- rbind(traindata,testdata)


### Analyzing the merged dataset:

str(completedata)
names(completedata)

### Naming the activity names with the descriptive activity names in the dataset

completedata[["Activity"]] <- factor(completedata[, Activity]
                                     , levels = activitylabels[["classLabels"]]
                                     , labels = activitylabels[["activityName"]])

completedata[["SubjectNum"]] <- as.factor(completedata[, SubjectNum])
completedata <- reshape2::melt(data = completedata, id = c("SubjectNum", "Activity"))
completedata <- reshape2::dcast(data = completedata, SubjectNum + Activity ~ variable, fun.aggregate = mean)

data.table::fwrite(x = completedata, file = "TidyData.txt", quote = FALSE)