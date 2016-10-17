test_subject <- read.table("./test/subject_test.txt", col.names = "volunteer")
test_activity <- read.table("./test/y_test.txt", col.names = "activity")
test_raw <- read.table("./test/X_test.txt")
variableNames <- read.table("./features.txt")
names(test_raw) <- variableNames$V2
test_raw_mean <- test_raw[, grepl("mean()", colnames(test_raw), fixed = TRUE)]
test_raw_std <- test_raw[, grepl("std()", colnames(test_raw), fixed = TRUE)]
test_extract <- cbind(test_raw_mean, test_raw_std)
test_all <- cbind(test_subject, test_activity, test_extract)
test_all$activity <- factor(test_all$activity, levels = c(1,2,3,4,5,6), labels = c("walking", "walking_upstairs", "walking_downstairs", "sitting", "standing", "laying"))
train_subject <- read.table("./train/subject_train.txt", col.names = "volunteer")
train_activity <- read.table("./train/y_train.txt", col.names = "activity")
train_raw <- read.table("./train/X_train.txt")
variableNames <- read.table("./features.txt")
names(train_raw) <- variableNames$V2
train_raw_mean <- train_raw[, grepl("mean()", colnames(train_raw), fixed = TRUE)]
train_raw_std <- train_raw[, grepl("std()", colnames(train_raw), fixed = TRUE)]
train_extract <- cbind(train_raw_mean, train_raw_std)
train_all <- cbind(train_subject, train_activity, train_extract)
train_all$activity <- factor(train_all$activity, levels = c(1,2,3,4,5,6), labels = c("walking", "walking_upstairs", "walking_downstairs", "sitting", "standing", "laying"))
combined <- merge(test_all, train_all, all = TRUE)
melted <- melt(combined, id.vars = c("volunteer", "activity"))
summary <- ddply(melted, .(volunteer, activity, variable), summarise, mean = mean(value))
write.table(summary, "averages_summary.txt", row.name=FALSE)
remove("melted","test_activity","test_all","test_extract","test_raw", "test_raw_mean","test_raw_std","test_subject","train_activity", "train_all","train_extract","train_raw","train_raw_mean","train_raw_std","train_subject","variableNames")
