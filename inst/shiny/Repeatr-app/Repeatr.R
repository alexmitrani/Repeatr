
# devtools::install_github("alexmitrani/Repeatr", build_opts = c("--no-resave-data", "--no-manual"))

library(Repeatr)

yearInput_shows_choices <- c("All", sort(unique((othervariables$year))))

# User Interface ----------------------------------------------------------

ui <- fluidPage(

  h1("Repeatr"),
  tags$div(
    "Exploring the ",
    tags$a(href="https://www.dischord.com/fugazi_live_series", "Fugazi Live Series"),
    tags$br(),
    tags$br()
  ),

  mainPanel(

    # Output
    tabsetPanel(type = "tabs",

                tabPanel("Shows",

                         fluidPage(
                           h3("Shows"),

                           h4("Choose a year, a tour, a country, a city, or a range of dates."),
                           h6("The list of cities is restricted to cases where the coordinates of the venues have been checked and updated."),


                           selectInput("yearInput_shows", "year:", choices = yearInput_shows_choices),
                           selectInput("tourInput_shows", "tour:", choices = NULL),
                           selectInput("countryInput_shows", "country:", choices = NULL),
                           selectInput("cityInput_shows", "city:", choices = NULL),


                           # Slider control

                           fluidRow(
                             column(6,
                                    sliderInput("dateInput_shows", "Range of dates:", min=as.Date("1987-09-03"), max=as.Date("2002-11-04"),
                                                value=c(as.Date("1987-09-03"), as.Date("2002-11-04")), timeFormat = "%F"))
                           ),

                           h4("Select a show on the map to get further details."),
                           h6("The locations are approximate."),

                           fluidRow(


                             leafletOutput("mymap", height = 500, width = 500)


                           ),

                           tags$br(),
                           h4("The table below gives details for the selected shows."),
                           tags$br(),

                           fluidRow(

                             # Create a new row for the table.
                             DT::dataTableOutput("data")

                           )

                         )

                ),

                tabPanel("Tours",

                         fluidPage(
                           h3("Tours"),


                           # Create a new Row in the UI for selectInputs
                           fluidRow(
                             column(4,
                                    selectInput("startyear",
                                                "Start year:",
                                                c("All",
                                                  sort(unique((toursdata$startyear)))))
                             )

                           ),

                           # Create a new row for the table.
                           DT::dataTableOutput("toursdatatable")

                         )

                ),


                tabPanel("Venues",

                         fluidPage(
                           h3("Venues"),


                           # Create a new Row in the UI for selectInputs
                           fluidRow(
                             column(4,
                                    selectInput("city",
                                                "City:",
                                                c("All",
                                                  sort(unique((venuesdata$city)))))
                             ),
                             column(4,
                                    selectInput("country",
                                                "Country:",
                                                c("All",
                                                  sort(unique(venuesdata$country))))
                             )

                           ),

                           # Create a new row for the table.
                           DT::dataTableOutput("venuesdatatable")

                         )

                ),

                tabPanel("Songs",

                         fluidPage(
                           h3("Songs"),

                           h4("Choose one or more releases, a selection of songs, or a range of dates."),

                           h6("The output will be limited to a maximum of 20 songs."),

                           # Release and song selection controls

                           fluidRow(
                             column(12,
                                    selectizeInput("releaseInput", "Release",
                                                   choices = c(unique(cumulative_song_counts$release)),
                                                   selected=NULL, multiple =TRUE),
                                    uiOutput("menuOptions"))


                           ),

                           # Slider control

                           fluidRow(
                             column(12,
                                    sliderInput("dateInput", "Range of dates:", min=as.Date("1987-09-03"), max=as.Date("2002-11-04"),
                                                value=c(as.Date("1987-09-03"), as.Date("2002-11-04")), timeFormat = "%F"))
                           ),

                           # Graph

                           fluidRow(
                             column(12,
                                    plotlyOutput("performance_count_plot")
                             )
                           ),

                           tags$br(),
                           h4("The table below shows the number of times each song was performed in the specified period."),
                           tags$br(),


                           fluidRow(
                             column(12,
                                    DT::dataTableOutput("songsdatatable")
                             )
                           )

                         )

                ),


                tabPanel("Transitions",

                         fluidPage(
                           h3("Transitions"),

                           # Create a new Row in the UI for selectInputs
                           fluidRow(
                             column(4,
                                    selectInput(inputId = "year_transitions",
                                                label = "Year:",
                                                choices = c("All",
                                                            sort(unique((toursdata$startyear)))),
                                                selected = "1987")
                             )

                           ),

                           # Slider control

                           fluidRow(
                             column(12,
                                    sliderInput("dateInput_transitions", "Range of dates:", min=as.Date("1987-09-03"), max=as.Date("2002-11-04"),
                                                value=c(as.Date("1987-09-03"), as.Date("2002-11-04")), timeFormat = "%F"))
                           ),

                           # Graph

                           fluidRow(
                             column(12,
                                    plotlyOutput("transitions_heatmap")
                             )
                           ),

                           h4("The table below shows the number of times each transition featured in the specified period."),


                           fluidRow(
                             column(12,
                                    DT::dataTableOutput("transitionsdatatable")
                             )
                           ),

                         )

                )


    ),

    tags$div(
      tags$br(),
      "Visit the ",
      tags$a(href="https://alexmitrani.github.io/Repeatr/", "Repeatr website"),
      " for further information.",
      tags$br(),
      tags$br()
    )

  )

)


server <- function(input, output, session) {

  year_data <- reactive({
    if(input$yearInput_shows=="All") {
      othervariables
    } else {
      othervariables
      filter(othervariables, year == input$yearInput_shows)
    }
  })

  observeEvent(year_data(), {
    tourInput_choices <- c("All", unique(year_data()$tour))
    updateSelectInput(inputId = "tourInput_shows", choices = tourInput_choices)
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
    countryInput_choices <- c("All", unique(tour_data()$country))
    updateSelectInput(inputId = "countryInput_shows", choices = countryInput_choices)
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
    cityInput_choices <- c("All", unique(country_data()$city))
    updateSelectInput(inputId = "cityInput_shows", choices = cityInput_choices)
  })

  city_data <- reactive({
    req(input$cityInput_shows)
    if(input$cityInput_shows=="All") {
      country_data()
    } else {
      filter(country_data(), city == input$cityInput_shows)
    }
  })

  output_data <- reactive({

    city_data()%>%
      filter(is.na(attendance)==FALSE) %>%
      filter(is.na(tour)==FALSE) %>%
      filter(date >= input$dateInput_shows[1] &
               date <= input$dateInput_shows[2]) %>%
      mutate(attendance = as.integer(attendance)) %>%
      mutate(date = as.Date(date, "%d-%m-%Y")) %>%
      mutate(year = lubridate::year(date)) %>%
      rename(latitude = y) %>%
      rename(longitude = x) %>%
      select(flsid, tour, year, date, venue, city, country, attendance, doorprice, latitude, longitude, checked) %>%
      rename(door_price = doorprice,
             fls_id = flsid)

  })

  output$data <- DT::renderDataTable(DT::datatable({

    output_data()

    }
  ))

  output$mymap <- renderLeaflet({
    df <- output_data()

    ref_latitude <- mean(df$latitude)
    ref_longitude <- mean(df$longitude)

    min_latitude_raw <- min(df$latitude)
    min_longitude_raw <- min(df$longitude)

    max_latitude_raw <- max(df$latitude)
    max_longitude_raw <- max(df$longitude)

    diff_longitude <- abs(max_longitude_raw-min_longitude_raw)
    diff_latitude <- abs(max_latitude_raw-min_latitude_raw)

    diff <- mean(diff_longitude, diff_latitude)
    margin_value <- ifelse(diff==0, 0.1, 0.1*diff)

    min_latitude <- min(df$latitude)-margin_value
    min_longitude <- min(df$longitude)-margin_value

    max_latitude <- max(df$latitude)+margin_value
    max_longitude <- max(df$longitude)+margin_value

    m <- leaflet(data = df) %>%
      fitBounds(lng1 = min_longitude, lat1 = min_latitude, lng2 = max_longitude, lat2 = max_latitude) %>%
      addProviderTiles("Esri.WorldStreetMap") %>%
      addScaleBar() %>%
      addCircles(
        data = df,
        radius = sqrt((df$attendance)/pi),
        color = "#F60D1D",
        fillColor = "#F60D1D",
        fillOpacity = 0.5,
        popup = paste0(
          "<strong>Date: </strong>", df$date, "<br>",
          "<strong>Venue: </strong>", df$venue, "<br>",
          "<strong>City: </strong>", df$city, "<br>",
          "<strong>Attendance: </strong>", df$attendance, "<br>"
        )
      )
    m

  })

}

shinyApp(ui = ui, server = server)

