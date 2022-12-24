
# devtools::install_github("alexmitrani/Repeatr", build_opts = c("--no-resave-data", "--no-manual"))

library(Repeatr)

ui <- fluidPage(

  selectInput("yearInput_shows", "year:", choices = c("All", sort(unique((othervariables$year))))),
  selectInput("tourInput_shows", "tour:", choices = NULL),
  selectInput("countryInput_shows", "country:", choices = NULL),
  selectInput("cityInput_shows", "city:", choices = NULL),
  tableOutput("data")

)


server <- function(input, output, session) {

  year_data <- reactive({
    if(input$yearInput_shows=="All") {
      othervariables
    } else {
      filter(othervariables, year == input$yearInput_shows)
    }
  })
  observeEvent(year_data(), {
    tourInput_choices <- unique(year_data()$tour)
    updateSelectInput(inputId = "tourInput_shows", choices = c("All", tourInput_choices))
  })

  tour_data <- reactive({
    req(input$tourInput_shows)
    if(input$tourInput_shows=="All") {
      year_data()
    } else {
      filter(year_data(), tour == input$tourInput_shows)
    }

  })
  observeEvent(tour_data(), {
    countryInput_choices <- unique(tour_data()$country)
    updateSelectInput(inputId = "countryInput_shows", choices = c("All", countryInput_choices))
  })

  country_data <- reactive({
    req(input$countryInput_shows)
    if(input$countryInput_shows=="All") {
      tour_data()
    } else {
      filter(tour_data(), country == input$countryInput_shows)
    }
  })
  observeEvent(country_data(), {
    cityInput_choices <- unique(country_data()$city)
    updateSelectInput(inputId = "cityInput_shows", choices = c("All", cityInput_choices))
  })

  output$data <- renderTable({
    req(input$cityInput_shows)
    if(input$cityInput_shows=="All") {
      country_data()
    } else {
      filter(country_data(), city == input$cityInput_shows)
    }
  })


}

shinyApp(ui = ui, server = server)

