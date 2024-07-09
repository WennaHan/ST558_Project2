# Load necessary libraries
library(httr)      # For making HTTP requests
library(jsonlite)  # For handling JSON data
library(dplyr)     # For data manipulation and summarization
library(tidyr)     # For data tidying
library(knitr)     # For generating reports
library(ggplot2)   # For data visualization
library(reshape)   # For data visualization
library(shiny)     # For app built
library(shinydashboard)
library(ggplot2)
library(DT)

# Define UI for the app
ui <- dashboardPage(
  dashboardHeader(title = "Crypto Market Explorer"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
      menuItem("About", tabName = "about", icon = icon("info-circle")),
      menuItem("Data Download", tabName = "data_download", icon = icon("download")),
      menuItem("Data Exploration", tabName = "data_exploration", icon = icon("chart-bar"))
    )
  ),
  dashboardBody(
    # Body content will be dynamically rendered based on selected tab
    tabItems(
      # Dashboard tab
      tabItem(tabName = "dashboard",
              fluidRow(
                box(
                  title = "Welcome to Crypto Market Explorer",
                  "This dashboard allows you to explore cryptocurrency market data from CoinGecko API.",
                  "Navigate through different tabs to download data or explore trends."
                )
              )
      ),
      
      # About tab
      tabItem(tabName = "about",
              fluidRow(
                box(
                  title = "About Crypto Market Explorer",
                  "Purpose: This app allows users to explore and analyze cryptocurrency market data from CoinGecko API.",
                  "Data Source: CoinGecko API provides comprehensive crypto market data.",
                  "Tabs Purpose:",
                  tags$ul(
                    tags$li("Data Download: Fetch and explore raw cryptocurrency data."),
                    tags$li("Data Exploration: Visualize and summarize cryptocurrency data.")
                  ),
                  tags$img(src = "https://support.coingecko.com/hc/article_attachments/4499575478169", height = 100, width = 100)
                )
              )
      ),
      
      # Data Download tab
      tabItem(tabName = "data_download",
              fluidRow(
                box(
                  title = "Data Download",
                  selectInput("vs_currency", "Select Currency:", choices = c("usd", "eur", "btc"), selected = "usd"),
                  selectInput("order", "Select Order:", choices = c("market_cap_desc", "market_cap_asc", "volume_desc", "volume_asc"), selected = "market_cap_desc"),
                  numericInput("per_page", "Coins per Page:", value = 100, min = 1, max = 250),
                  actionButton("download_data", "Download Data"),
                  hr(),
                  dataTableOutput("downloaded_data")
                )
              )
      ),
      
      # Data Exploration tab
      tabItem(tabName = "data_exploration",
        fluidRow(
          box(
            title = "Data Exploration",
            selectInput("plot_type", "Select Plot Type:", choices = c("histogram", "scatterplot", "boxplot")),
            # Conditional UI for plot types
            conditionalPanel(
              condition = "input.plot_type == 'histogram'",
              selectInput("plot_variable_x", "Select Variable:", choices = c("market_cap", "total_volume", "price_change_percentage_24h"))
            ),
            conditionalPanel(
              condition = "input.plot_type != 'histogram'",
              fluidRow(
                column(6, selectInput("plot_variable_x", "Select X Variable:", choices = c("market_cap", "total_volume", "price_change_percentage_24h"))),
                column(6, selectInput("plot_variable_y", "Select Y Variable:", choices = c("market_cap", "total_volume", "price_change_percentage_24h")))
              )
            ),
            actionButton("plot_button", "Generate Plot"),
            hr(),
            plotOutput("exploration_plot"),
            hr(),
            verbatimTextOutput("summary_text")
          )
        )
      )

    )
  )
)