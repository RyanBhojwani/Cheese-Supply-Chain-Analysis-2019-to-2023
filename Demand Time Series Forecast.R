# Load required libraries (tidyverse includes readr, ggplot2, dplyr, etc.)
library(tidyverse)
library(tsibble)
library(fpp3)
library(lubridate)
library(fable)
library(forecast)

# Function to prepare data for a specific retailer
prepare_retailer_data <- function(data, retailer_id) {
  retailer_data <- data %>%
    filter(retailer_id == !!retailer_id) %>%
    group_by(WEEK_BEGIN_DATE) %>%
    summarize(avg_y = mean(SUB.QTY)) %>%
    mutate(key = row_number()) %>%
    as_tsibble(key = key, index = WEEK_BEGIN_DATE, regular = TRUE) %>%
    filter_index("2018-12-31" ~ "2023-07-10")
  
  return(retailer_data)
}

# Function to perform seasonal decomposition
perform_decomposition <- function(ts_data) {
  decomp <- decompose(ts_data, "multiplicative")
  plot(decomp)
  
  # Create boxplot of seasonal decomposition
  boxplot(ts_data ~ cycle(ts_data), 
          xlab='Week', 
          ylab="Cheese Demand (1000's)", 
          main="Weekly Seasonal Patterns")
}

# MAPE calculation function
mape <- function(actual, pred){
  mape_val <- mean(abs((actual - pred) / actual)) * 100
  return(mape_val)
}

# Function to run forecasting models and return results
run_forecasting_models <- function(data, iterations=10) {
  mape_naive <- numeric(iterations)
  mape_stlf <- numeric(iterations)
  mape_arima <- numeric(iterations)
  mape_tbats <- numeric(iterations)
  
  for (i in 1:iterations) {
    # Create Training and Test Data Sets
    train_indices <- sample(seq_len(nrow(data)), size = floor(0.8 * nrow(data)))
    tot_train <- data[train_indices, ]
    tot_test <- data[-train_indices, ]
    ts_training <- ts(tot_train$avg_y, frequency = 52)
    
    # Naive Method
    naive_model <- naive(ts_training, h = 47)
    tot_test$naive <- naive_model$mean
    mape_naive[i] <- mape(tot_test$avg_y, tot_test$naive)
    
    # STLF Method
    stlf_model <- stlf(ts_training)
    forecast_stlf <- forecast(stlf_model, h = 47)
    tot_test$stlf <- forecast_stlf$mean
    mape_stlf[i] <- mape(tot_test$avg_y, tot_test$stlf)
    
    # ARIMA Method
    arima_model <- auto.arima(ts_training)
    forecast_arima <- forecast(arima_model, h = 47)
    tot_test$arima <- forecast_arima$mean
    mape_arima[i] <- mape(tot_test$avg_y, tot_test$arima)
    
    # TBATS Method
    tbats_model <- tbats(ts_training)
    forecast_tbats <- forecast(tbats_model, h = 47)
    tot_test$tbats <- forecast_tbats$mean
    mape_tbats[i] <- mape(tot_test$avg_y, tot_test$tbats)
  }
  
  return(list(
    naive = mape_naive,
    stlf = mape_stlf,
    arima = mape_arima,
    tbats = mape_tbats
  ))
}

# Function to analyze and plot model results
analyze_results <- function(results) {
  # Compare means
  means <- c(
    mean(results$naive),
    mean(results$stlf),
    mean(results$arima),
    mean(results$tbats)
  )
  names(means) <- c("Naive", "STLF", "ARIMA", "TBATS")
  
  # Compare standard deviations
  sds <- c(
    sd(results$naive),
    sd(results$stlf),
    sd(results$arima),
    sd(results$tbats)
  )
  names(sds) <- c("Naive", "STLF", "ARIMA", "TBATS")
  
  # Print results
  cat("\nMean MAPE for each model:\n")
  print(means)
  cat("\nStandard Deviation of MAPE for each model:\n")
  print(sds)
  
  # Plot histograms
  par(mfrow = c(2, 2))
  hist(results$naive, main = "Naive MAPE Distribution")
  hist(results$stlf, main = "STLF MAPE Distribution")
  hist(results$arima, main = "ARIMA MAPE Distribution")
  hist(results$tbats, main = "TBATS MAPE Distribution")
  par(mfrow = c(1, 1))
}

# Function to generate and plot final forecast
generate_forecast <- function(data, retailer_id) {
  ts_data <- ts(data$avg_y, frequency = 52)
  
  # Generate forecast using the best model (TBATS in this case)
  best_model <- tbats(ts_data)
  best_forecast <- forecast(best_model, h = 52)
  
  # Plot forecast
  forecast_plot <- autoplot(best_forecast, colour = "black", range.bars = TRUE) + 
    theme_bw() + 
    ggtitle(paste("Weekly Forecast Demand for Cream Cheese for Retailer", retailer_id)) + 
    ylab("Demand")
  
  print(forecast_plot)
}

# Main function to run the entire analysis
main <- function(retailer_id, iterations = 10) {
  # Set seed for reproducibility
  set.seed(1)
  
  # Read data
  data <- tryCatch({
    read.csv("ody_cheese2.csv")  # Ensure the file is available
  }, error = function(e) {
    stop("Error reading the CSV file. Please check the file path.")
  })
  data$WEEK_BEGIN_DATE <- ymd(data$WEEK_BEGIN_DATE)
  
  # Prepare data for the specified retailer
  cat(paste("\nPreparing data for retailer", retailer_id, "...\n"))
  retailer_data <- prepare_retailer_data(data, retailer_id)
  
  # Create time series object
  ts_data <- ts(retailer_data$avg_y, frequency = 52)
  
  # Perform decomposition
  cat("\nPerforming seasonal decomposition...\n")
  perform_decomposition(ts_data)
  
  # Run forecasting models
  cat(paste("\nRunning forecasting models with", iterations, "iterations...\n"))
  results <- run_forecasting_models(retailer_data, iterations)
  
  # Analyze results
  cat("\nAnalyzing results...\n")
  analyze_results(results)
  
  # Generate final forecast
  cat("\nGenerating final forecast...\n")
  generate_forecast(retailer_data, retailer_id)
}

# Run Forecasts for multiple retailers
main(retailer_id = 2)  # Run analysis for retailer 2
main(retailer_id = 3)  # Run analysis for retailer 3
main(retailer_id = 4)  # Run analysis for retailer 4
main(retailer_id = 5)  # Run analysis for retailer 5

