# Define server logic
server <- function(input, output, session) {
  # Function to fetch data from CoinGecko API
  get_coin_data <- function(vs_currency = "usd", order = "market_cap_desc", per_page = 100) {
    baseURL <- "https://api.coingecko.com/api/v3/"
    endpoint <- "coins/markets"
    fullURL <- paste0(baseURL, endpoint)
    
    params <- list(
      vs_currency = vs_currency,
      order = order,
      per_page = per_page,
      sparkline = "false"
    )
    
    response <- GET(fullURL, query = params)
    
    if (response$status_code != 200) {
      stop("Failed to fetch data from CoinGecko API")
    }
    
    data <- fromJSON(content(response, as = "text"))
    df <- as.data.frame(data)
    
    return(df)
  }
  
  # Server logic for Data Download tab
  observeEvent(input$download_data, {
    data <- get_coin_data(input$vs_currency, input$order, input$per_page)
    output$downloaded_data <- renderDataTable({
      datatable(data)
    })
    
    # Save subsetted data as CSV
    observeEvent(input$save_data, {
      write.csv(data, "downloaded_data.csv", row.names = FALSE)
    })
  })
  
  # Server logic for Data Exploration tab
  observeEvent(input$plot_button, {
    data <- get_coin_data()  # Example: Fetch data for exploration
    
    output$exploration_plot <- renderPlot({
      plot_data <- switch(input$plot_type,
                          "histogram" = {
                            ggplot(data, aes_string(x = input$plot_variable_x)) +
                              geom_histogram(bins = 30, fill = "blue", color = "black") +
                              ggtitle(paste("Histogram of", input$plot_variable_x))
                          },
                          "scatterplot" = {
                            ggplot(data, aes_string(x = input$plot_variable_x, y = input$plot_variable_y)) +
                              geom_point(color = "blue") +
                              ggtitle(paste("Scatterplot of", input$plot_variable_x, "vs.", input$plot_variable_y))
                          },
                          "boxplot" = {
                            ggplot(data, aes_string(x = input$plot_variable_x, y = input$plot_variable_y)) +
                              geom_boxplot(fill = "blue", color = "black") +
                              ggtitle(paste("Boxplot of", input$plot_variable_x, "vs.", input$plot_variable_y))
                          }
      )
      
      print(plot_data)
    })
    
    output$summary_text <- renderPrint({
      summary_data <- summarise(data, mean = mean(!!sym(input$plot_variable_x), na.rm = TRUE),
                                median = median(!!sym(input$plot_variable_x), na.rm = TRUE),
                                sd = sd(!!sym(input$plot_variable_x), na.rm = TRUE))
      print(summary_data)
    })
  })
}
