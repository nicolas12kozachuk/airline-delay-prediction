#install.packages("Metrics")
#install.packages("MLmetrics")
#install.packages("randomForest")
library(randomForest)
library(rpart)
library(Metrics)
library(MLmetrics)
library(ggplot2)


data <- read.csv("C:/Users/nkoza/OneDrive/Desktop/Airline_Delay_Cause.csv")
set.seed(1237)

data <- na.omit(data)
data <- subset(data, data$arr_delay < 2000)

rfData <- data

rfData$arr_del15_2 <- rfData$arr_del15^.5
rfData$arr_del15_3 <- rfData$arr_del15^5

rfData$carrier_delay <- ifelse(rfData$carrier_delay > 1000, 4, ifelse(rfData$carrier_delay > 500, 3, ifelse(rfData$carrier_delay > 100, 2, ifelse(rfData$carrier_delay > 10, 1, 0))))

rfData$nas_delay <- ifelse(rfData$nas_delay > 1000, 4, ifelse(rfData$nas_delay > 500, 3, ifelse(rfData$nas_delay > 100, 2, ifelse(rfData$nas_delay > 10, 1, 0))))

rfData$weather_delay <- ifelse(rfData$weather_delay > 1000, 4, ifelse(rfData$weather_delay > 500, 3, ifelse(rfData$weather_delay > 100, 2, ifelse(rfData$weather_delay > 10, 1, 0))))

rfData$security_delay <- ifelse(rfData$security_delay > 1000, 4, ifelse(rfData$security_delay > 500, 3, ifelse(rfData$security_delay > 100, 2, ifelse(rfData$security_delay > 10, 1, 0))))

rfData$late_aircraft_delay <- ifelse(rfData$late_aircraft_delay > 1000, 4, ifelse(rfData$late_aircraft_delay > 500, 3, ifelse(rfData$late_aircraft_delay > 100, 2, ifelse(rfData$late_aircraft_delay > 10, 1, 0))))

dt = sort(sample(nrow(rfData), nrow(rfData)*.8))
train<-rfData[dt,]
test<-rfData[-dt,]


tree_model <- randomForest(arr_delay ~ month + carrier + carrier_name + airport + arr_flights + arr_del15 + carrier_ct + weather_ct + nas_ct + late_aircraft_ct + arr_cancelled + arr_del15_2 + arr_del15_3 + carrier_delay + nas_delay + weather_delay + security_delay + late_aircraft_delay, data = train, importance = TRUE, localImp = TRUE, ntree = 100, replace=FALSE)

prediction_model <- predict(tree_model,test,type="response")

included <- ifelse(test$arr_delay != 0,TRUE,FALSE)
test <- subset(test, included==TRUE)
prediction_model <- subset(prediction_model, included==TRUE)

varImpPlot(tree_model)

# Variable Importance Plot with ggplot2
importance_data <- data.frame(Importance = importance(tree_model)[, 1], Variables = rownames(importance(tree_model)))

ggplot(importance_data, aes(x = reorder(Variables, Importance), y = Importance, fill = Importance)) +
  geom_bar(stat = "identity") +
  coord_flip() +
  labs(x = "Variables", y = "Importance", title = "Variable Importance Plot") +
  scale_fill_gradient(low = "blue", high = "red") +
  theme_minimal()

# Variable Importance Plot with ggplot2
importance_data <- data.frame(Importance = importance(tree_model)[, 2], Variables = rownames(importance(tree_model)))

ggplot(importance_data, aes(x = reorder(Variables, Importance), y = Importance, fill = Importance)) +
  geom_bar(stat = "identity") +
  coord_flip() +
  labs(x = "Variables", y = "Importance", title = "Variable Importance Plot") +
  scale_fill_gradient(low = "blue", high = "red") +
  theme_minimal()

# Scatter plot for actual vs predicted values
comparison_data <- data.frame(Actual = test$arr_delay, Predicted = prediction_model)
ggplot(comparison_data, aes(x = Actual, y = Predicted, color = abs(Actual - Predicted))) +
  geom_point(alpha = 0.6) +
  labs(x = "Actual Delays", y = "Predicted Delays", title = "Actual vs Predicted Delays") +
  scale_color_gradient(low = "blue", high = "red") +
  theme_minimal() + 
stat_smooth(method = "lm", se = FALSE, color = "black") +
  geom_text(x = 50, y = 150, label = paste("R^2 =", round(cor(comparison_data$Actual, comparison_data$Predicted)^2, 2)), color = "black")

MAE <- mae(test$arr_delay,prediction_model)
MAPE <- MAPE(prediction_model,test$arr_delay)
r2 <- cor(test$arr_delay,prediction_model)^2
rmse <- rmse(test$arr_delay,prediction_model)

MAE
MAPE
r2
rmse


#vectors to hold accuracy
mape_vec <- numeric(10) 
r2_vec <- numeric(10)
mae_vec <- numeric(10)

#create 10 folds
folds <- cut(seq(1,nrow(rfData)),breaks=10,labels=FALSE)

# go through cross validation for each fold and find performance measures
for(i in 1:10){
  # create test and train from folds
  test_indices <- which(folds == i)
  train <- rfData[-test_indices, ]
  test <- rfData[test_indices, ]
  # create and predict model
 tree_model <- randomForest(arr_delay ~ month + carrier + carrier_name + airport + arr_flights + arr_del15 + carrier_ct + weather_ct + nas_ct + late_aircraft_ct + arr_cancelled + arr_del15_2 + arr_del15_3 + carrier_delay + nas_delay + weather_delay + security_delay + late_aircraft_delay, data = train, importance = TRUE, localImp = TRUE, ntree = 100, replace=FALSE)

prediction_model <- predict(tree_model,test,type="response")

included <- ifelse(test$arr_delay != 0,TRUE,FALSE)
test <- subset(test, included==TRUE)
prediction_model <- subset(prediction_model, included==TRUE)
MAE <- mae(test$arr_delay,prediction_model)
MAPE <- MAPE(prediction_model,test$arr_delay)
R2 <- cor(test$arr_delay,prediction_model)^2
rmse <- rmse(test$arr_delay,prediction_model)
  # add performance measures 
  mae_vec[i] <- MAE
  r2_vec[i] <- R2
  mape_vec[i] <- MAPE
}
# get average performance measures
avg_mae <- mean(mae_vec)
avg_mape <- mean(mape_vec)
avg_r2 <- mean(r2_vec)

# print results
cat("MAE:", round(avg_mae, 4), "\n")
cat("MAPE:", round(avg_mape, 4), "\n")
cat("R^2:", round(avg_r2, 4), "\n")

