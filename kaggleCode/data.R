library(readr)
library(xgboost)

set.seed(1122)

cat("reading the train and test data\n")
train <- read_csv("E:/kaggle/springleaf/train.csv")
test  <- read_csv("E:/kaggle/springleaf/test.csv")


feature.names <- names(train)[2:ncol(train)-1]
cat("assuming text variables are categorical & replacing them with numeric ids\n")
for (f in feature.names) {
  if (class(train[[f]])=="character") {
    levels <- unique(c(train[[f]], test[[f]]))
    train[[f]] <- as.integer(factor(train[[f]], levels=levels))
    test[[f]]  <- as.integer(factor(test[[f]],  levels=levels))
  }
#对numric数据进行标准化
#if (class(train[[f]])=="numeric"){
#	train[[f]]=scale(train[[f]],center=TRUE)
#	test[[f]]=scale(test[[f]],center=TRUE)
#	}
}

cat("replacing missing values with -1\n")
train[is.na(train)] <- -1
test[is.na(test)]   <- -1

#采样训练数据
#cat("sampling train to get around 8GB memory limitations\n")
#ind   <- sample(nrow(train), 70000)
#train <- train[ind, ]
#ind   <- sample(rep(1:2, 35000))

write_csv(train,"E:/kaggle/springleaf/train1.csv")
write_csv(test,"E:/kaggle/springleaf/test1.csv")