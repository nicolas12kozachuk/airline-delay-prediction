# Airline Delay Prediction and Analysis

## Project Description

This project analyzes factors contributing to airline delays and implements machine learning models to predict delays. The analysis utilizes the U.S. Department of Transportation’s Airline On-Time Performance dataset. Key objectives include identifying significant predictors of delays and evaluating the performance of various machine learning algorithms.

## Objectives
1. Analyze the impact of different factors (e.g., weather, carrier, time of day) on delays.
2. Build and evaluate machine learning models to predict delays.
3. Provide insights into improving airline efficiency and passenger experience.

## Dataset
- **Source**: U.S. Department of Transportation Airline On-Time Performance data.
- **Features**: Flight date, carrier, origin, destination, departure time, arrival time, delay minutes, etc.
- **Target Variable**: Delay status (binary: delayed or not delayed).

## Machine Learning Models
1. **Logistic Regression**:
   - Evaluates linear relationships between predictors and delay probability.
2. **Random Forest**:
   - Captures non-linear relationships and ranks feature importance.
3. **Convolutional Neural Network (CNN)**:
   - Explored for advanced feature extraction and predictive modeling.

## Results
- **Feature Importance**:
  - Weather conditions and departure time significantly influence delays.
- **Model Performance**:
  - Random Forest achieved the highest accuracy for categorical data.
  - Logistic Regression provided interpretable results but underperformed on non-linear features.
  - CNN struggled due to the limited dataset size and lack of complex spatial features.

## Code Overview

The implementation is provided in `Airline Delay.Rmd` and includes:
1. **Data Preprocessing**:
   - Handles missing values and encodes categorical features.
   - Splits the data into training and testing sets.
2. **Exploratory Data Analysis (EDA)**:
   - Visualizes delay distributions and correlations.
3. **Model Training**:
   - Logistic Regression using `glm`.
   - Random Forest using `randomForest`.
   - CNN using `keras` and `tensorflow`.
4. **Evaluation**:
   - Metrics include accuracy, F1 score, and feature importance.

## Learning Outcomes

This project provided valuable insights into:
- **Predictive Analytics**: Using machine learning to forecast delays.
- **Feature Engineering**: Identifying key predictors of delays.
- **Model Comparison**: Evaluating algorithm strengths and weaknesses.

## References

- U.S. Department of Transportation Airline On-Time Performance Dataset
- R Libraries: `dplyr`, `ggplot2`, `randomForest`, `keras`
