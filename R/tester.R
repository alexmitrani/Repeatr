
# devtools::install_github("alexmitrani/Repeatr", build_opts = c("--no-resave-data", "--no-manual"))


# pre-processing ----------------------------------------------------------

# data to define list of cities where the coordinates have been 100% checked
othervariables_checked <- othervariables %>%
  group_by(year, tour, country, city) %>%
  summarize(checked_prop = mean(checked)) %>%
  ungroup() %>%
  filter(checked_prop==1)

ui <- fluidPage(

  selectInput("yearInput_shows", "year:", choices = sort(unique((othervariables$year)))),
  selectInput("tourInput_shows", "tour:", choices = NULL),
  selectInput("countryInput_shows", "country:", choices = NULL),
  selectInput("cityInput_shows", "city:", choices = NULL),
  tableOutput("data")

)


server <- function(input, output, session) {

  year_data <- reactive({
    filter(othervariables_checked, year == input$yearInput_shows)
  })
  observeEvent(year_data(), {
    tourInput_choices <- unique(year_data()$tour)
    updateSelectInput(inputId = "tourInput_shows", choices = tourInput_choices)
  })

  tour_data <- reactive({
    req(input$tourInput_shows)
    filter(year_data(), tour == input$tourInput_shows)
  })
  observeEvent(tour_data(), {
    countryInput_choices <- unique(tour_data()$country)
    updateSelectInput(inputId = "countryInput_shows", choices = countryInput_choices)
  })

  country_data <- reactive({
    req(input$countryInput_shows)
    filter(tour_data(), country == input$countryInput_shows)
  })
  observeEvent(country_data(), {
    cityInput_choices <- unique(country_data()$city)
    updateSelectInput(inputId = "cityInput_shows", choices = cityInput_choices)
  })

  output$data <- renderTable({
    req(input$cityInput_shows)
    country_data() %>%
      filter(city == input$cityInput_shows)
  })


}

shinyApp(ui = ui, server = server)

