library(readr)
library(xgboost)

set.seed(1122)

##读取数据
cat("reading the train and test data\n")
train <- read_csv("/home/yhuang/work/train1.csv")
test  <- read_csv("/home/yhuang/work/test1.csv")


##采样数据训练模型
cat("sampling train to get around 8GB memory limitations\n")
ind   <- sample(nrow(train), 140000)
train <- train[ind, ]
ind   <- sample(rep(1:2, 70000))
feature.names <- names(train)[2:ncol(train)-1]

##参数设置，将8w条数据分为两部分 在训练模型的时候进行交叉验证 
dtrain <- xgb.DMatrix(data.matrix(train[ind==1, feature.names]), label=train$target[ind==1])
cat("sampling validation\n")
dval   <- xgb.DMatrix(data.matrix(train[ind==2, feature.names]), label=train$target[ind==2])
gc()
cat("set parameters\n")
watchlist <- list(eval = dval, train = dtrain)
param <- list(  objective           = "binary:logistic", 
                eta                 = 0.020,
                max_depth           = 14, 
                eval_metric         = "auc"
                )		
clf <- xgb.train(   params              = param,
                    data                = dtrain, 
                    nrounds             = 415, 
                    verbose             = 1, 
                    early.stop.round    = 20,
                    watchlist           = watchlist,
                    maximize            = TRUE)
				
				
				
				
#####模型预测提交				
cat("making predictions in batches due to 8GB memory limitation\n")
submission <- data.frame(ID=test$ID)
submission$target <- NA 
for (rows in split(1:nrow(test), ceiling((1:nrow(test))/10000))) {
    submission[rows, "target"] <- predict(clf, data.matrix(test[rows, feature.names]))
}

cat("saving the submission file\n")
write_csv(submission, "/home/yhuang/work/sub_xgboost.csv")
