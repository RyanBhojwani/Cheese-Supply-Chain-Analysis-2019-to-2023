# Cheese-Supply-Chain-Analysis-2019-to-2023

## Overview

This project analyzes the cheese supply chain during the COVID-19 pandemic. The analysis uses **time series forecasting** to predict demand and **event-based regression analysis** to model the effects of key milestones in the pandemic. The goal is to understand how these milestones influenced the supply chain problems and to forecast future cheese demand. This should allow grocers to better understand events that will afefct their supply and their predicted future demand. The data used for this project is private information.

This project consists of two main parts:

1. **Demand Forecasting:** Using time series analysis to predict future cheese demand.
2. **Event Analysis:** Examining how significant pandemic-related events impacted cheese supply.

---

## Part 1: Demand Forecasting

### Objective
To forecast future cheese demand based on historical shipment data from various retailers. The primary aim is to identify the most accurate forecasting method for predicting future trends in cheese demand during and after the pandemic.

### Methods
- **Data Used:** Weekly cheese shipment quantities from multiple retailers.
- **Seasonal Decomposition:** Performed to understand trends, seasonality, and residual components.
- **Forecasting Models Evaluated:**
  - **Naive Method:** A simple method assuming no changes in demand.
  - **STLF (Seasonal and Trend decomposition using Loess):** A model that accounts for both seasonality and trend components.
  - **ARIMA (Auto-Regressive Integrated Moving Average):** A commonly used method in time series forecasting that models data with autocorrelations.
  - **TBATS (Trend and Seasonal BATS):** A method that handles complex seasonal patterns and trends.

Each model was tested for forecasting a 47-week horizon to predict future shipment quantities.

### Results
The **TBATS model** achieved the best forecasting accuracy, outperforming the Naive, STLF, and ARIMA models in terms of **Mean Absolute Percentage Error (MAPE)**. This model provided the most reliable future predictions based on historical data.

### Conclusion
The TBATS model was the most effective for predicting cheese demand during the pandemic. Its ability to handle complex seasonal trends made it the best fit for our data. The demand for cheese was found to have a somewhat predictable pattern that can inform future supply chain decisions. 

---

## Part 2: Event Analysis of Pandemic Impact on Supply

### Objective
To analyze how specific pandemic-related events (such as lockdowns, government stimulus packages, and vaccine rollouts) impacted cheese supply. This part of the analysis aims to quantify the effect of external events on cheese shipment volumes over time.

### Methods
- **Data Used:** Cheese shipment data combined with key pandemic event milestones.
- **Key Pandemic Events Analyzed:**
  - **Lockdowns:** Initial government restrictions affecting production and supply chains.
  - **Vaccine Distribution:** The start of mass vaccinations and its effect on the reopening of businesses.
  - **Reopening Measures:** Gradual return to normal operations as pandemic restrictions eased.
  - **Non-COVID Related Supply Chain Shocks:** Sudden price changes in cheese inputs and internal issues in cheese producing companies.

A regression analysis was conducted using **dummy variables** for each event milestone, where each event was coded as 1 for the 45 days after the event occurs and 0 otherwise. The goal was to assess the impact of these events on cheese shipment quantities.

### Results
- **Lockdowns:** Events in the early lockdown phase were found to be statistically significant. These events led to a sharp decline in shipments, as production and distribution networks were disrupted.
- **Vaccine Rollouts & Reopening Measures:** Major reopening events were found to statistically significantly increase the percent of cheese delivered.

### Conclusion
The pandemic had a complex impact on cheese supply. Initial disruptions due to lockdowns were followed by a demand surge driven by consumer behavior. As vaccine rollouts and reopening measures took effect, supply chains began recovering, and cheese shipment quantities returned to more stable levels. Understanding these impacts can help suppliers better prepare for future disruptions.

---

## Key Takeaways

1. **Demand Forecasting:** TBATS is the most reliable model for forecasting future cheese demand based on historical data, accounting for complex seasonal patterns and trends.
2. **Supply Chain Events:** External events such as lockdowns and reopenings had significant impacts on the cheese supply chain. Disruptions were followed by recovery as pandemic restrictions eased.

Both parts of this analysis highlight the importance of understanding supply and demand dynamics during significant global disruptions. By forecasting demand and analyzing the effects of major events on supply, businesses can better prepare for future challenges.

---


