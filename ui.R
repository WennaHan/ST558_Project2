library(shiny)
library(shinydashboard)
library(ggplot2)
library(dplyr)
library(DT)

ui <- dashboardPage(
  dashboardHeader(title = "CoinGecko Cryptocurrencies Data Analysis"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("About", tabName = "about", icon = icon("info-circle")),
      menuItem("Data Download", tabName = "data_download", icon = icon("download")),
      menuItem("Data Exploration", tabName = "data_exploration", icon = icon("chart-line"))
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "about",
              h2("About This App"),
              p("This app provides analysis of cryptocurrencies data. The data includes current and historical market data for different cryptocurrencies/coins."),
              p("The purpose of this app is to allow users to download, explore, and visualize cryptocurrencies data."),
              p("Tabs:"),
              p("1. About: Describes the app and data source."),
              p("2. Data Download: Allows users to query, view, subset, and download the data."),
              p("3. Data Exploration: Allows users to explore and visualize the data with various options.")
      ),
      tabItem(tabName = "data_download",
              sidebarLayout(
                sidebarPanel(
                  dateInput("start_date", "Start Date", value = Sys.Date() - 30),
                  dateInput("end_date", "End Date", value = Sys.Date()),
                  actionButton("download_data", "Download Data")
                ),
                mainPanel(
                  DTOutput("data_table"),
                  uiOutput("subset_ui"),
                  downloadButton("download_csv", "Download CSV")
                )
              )
      ),
      tabItem(tabName = "data_exploration",
              sidebarLayout(
                sidebarPanel(
                  selectInput("plot_var", "Variable to Plot", choices = c("Price", "Volume")),
                  selectInput("summary_type", "Summary Type", choices = c("Mean", "Median", "Sum")),
                  actionButton("plot_data", "Generate Plot")
                ),
                mainPanel(
                  plotOutput("data_plot"),
                  verbatimTextOutput("summary_output")
                )
              )
      )
    )
  )
)