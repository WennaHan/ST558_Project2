# ST558_Project2

## Brief description of the app and its purpose.
Started in 2014, **CoinGecko** is the world's largest independent crypto data aggregator that is integrated with more than 900 crypto exchanges and lists more than 12,000 coins. CoinGecko API offers the most comprehensive and reliable crypto market data through RESTful JSON endpoints. This app allows users to explore and analyze cryptocurrency market data from CoinGecko API. Users will be able to fetch and explore raw cryptocurrency data, as well as visualize and summarize cryptocurrency data.

## A list of packages needed to run the app.
To use the functions for interacting with the CoinGecko API, I used the following packages:

library(httr)           # For making HTTP requests
library(jsonlite)       # For handling JSON data
library(dplyr)          # For data manipulation and summarization
library(tidyr)          # For data tidying
library(knitr)          # For generating reports
library(ggplot2)        # For data visualization
library(reshape)        # For data visualization
library(shiny)          # For app building
library(shinydashboard) # For app building
library(DT)             # For app building

## A line of code that would install all the packages used.
install.packages(c("httr", "jsonlite", "dplyr", "tidyr", "knitr", "ggplot2", "reshape", "shiny", "shinydashboard", "DT"))


## The shiny::runGitHub() code that we can copy and paste into RStudio to run your app.
shiny::runGitHub(repo = "ST558_Project2", username = "WennaHan")
