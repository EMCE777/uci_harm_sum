# run_analysis.R
# 1. Merges the training and the test sets to create one data set.

# Obtein activities labels
lab <- read.table(file='./Project_Week4/UCI HAR Dataset/activity_labels.txt')
names(lab) <- c("id_activity","activity")

#Obtein training data
ytrain <- read.table(file='./Project_Week4/UCI HAR Dataset/train/y_train.txt')
xtrain <- read.table(file='./Project_Week4/UCI HAR Dataset/train/X_train.txt')
names(ytrain) <- c("id_activity")

#Obtein test data
ytest <- read.table(file='./Project_Week4/UCI HAR Dataset/test/y_test.txt')
xtest <- read.table(file='./Project_Week4/UCI HAR Dataset/test/X_test.txt')
names(ytest) <- c("id_activity")

#obtein features names
feaNames <- read.table(file='./Project_Week4/UCI HAR Dataset/features.txt')
#obtein subjects
subjTrain <- read.table(file='./Project_Week4/UCI HAR Dataset/train/subject_train.txt')
subjTest <- read.table(file='./Project_Week4/UCI HAR Dataset/test/subject_test.txt')


# to set names for data set
names(xtrain) <- feaNames[,2]
names(xtest) <- feaNames[,2]

# merge activities label and description
actTrain <- merge(lab,ytrain)
actTest <- merge(lab,ytest)

# add activities to data set
xtrain$id_activity <- actTrain$id_activity
xtrain$activity <- actTrain$activity

xtest$id_activity <- actTest$id_activity
xtest$activity <- actTest$activity

# add subject to data set
xtrain$subject <- subjTrain[,1]
xtest$subject <- subjTest[,1]

#add flag source
xtrain$source <- c("train")
xtest$source <- c("test")

#merge data sets
data <- rbind(xtrain,xtest)

# to get cols with mean() or std()
colSelect <- grep(paste(c("mean()","std()","activity","subject"),collapse="|"),names(data))
data <- data[,colSelect]
data$subject <- as.factor(data$subject)

# group by each activity and each subject and after that summarize all columns
res <- data %>% group_by(activity,subject) %>% summarise_if(is.numeric,mean,na.rm =TRUE)

# Write result to a file
write.table(res, file="./Project_Week4/uci_har_sum.txt", row.names = FALSE)
