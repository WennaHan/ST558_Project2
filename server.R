server <- function(input, output, session) {
  data <- reactiveVal()
  
  observeEvent(input$download_data, {
    # For demonstration, we use static data instead of querying an API
    bitcoin_data <- data.frame(
      timestamp = as.POSIXct(c("2024-06-09 10:04:39", "2024-06-09 11:01:52", "2024-06-09 12:08:47", 
                               "2024-06-09 13:05:10", "2024-06-09 14:02:01", "2024-06-09 15:05:09")),
      price = c(69464.55, 69489.02, 69512.59, 69636.45, 69658.47, 69737.13),
      volume = c(11297784379, 11553052271, 11572887602, 11652997674, 8892545791, 11181055188)
    )
    data(bitcoin_data)
  })
  
  output$data_table <- renderDT({
    req(data())
    datatable(data())
  })
  
  output$subset_ui <- renderUI({
    req(data())
    fluidRow(
      column(6, checkboxGroupInput("subset_columns", "Columns to Display", choices = names(data()), selected = names(data()))),
      column(6, sliderInput("subset_rows", "Rows to Display", min = 1, max = nrow(data()), value = c(1, nrow(data()))))
    )
  })
  
  output$download_csv <- downloadHandler(
    filename = function() { "subset_data.csv" },
    content = function(file) {
      write.csv(data()[input$subset_rows[1]:input$subset_rows[2], input$subset_columns], file)
    }
  )
  
  observeEvent(input$plot_data, {
    req(data())
    plot_data <- data()
    if (input$plot_var == "Price") {
      plot_data <- plot_data %>% select(timestamp, price)
    } else {
      plot_data <- plot_data %>% select(timestamp, volume)
    }
    output$data_plot <- renderPlot({
      ggplot(plot_data, aes(x = timestamp, y = plot_data[[input$plot_var]])) +
        geom_line(color = "blue", size = 1) +
        geom_point(color = "red", size = 2) +
        labs(title = paste("Bitcoin", input$plot_var, "Trend"),
             x = "Timestamp",
             y = input$plot_var) +
        theme_minimal()
    })
    output$summary_output <- renderPrint({
      summary_data <- plot_data[[input$plot_var]]
      if (input$summary_type == "Mean") {
        mean(summary_data)
      } else if (input$summary_type == "Median") {
        median(summary_data)
      } else {
        sum(summary_data)
      }
    })
  })
}

shinyApp(ui, server)