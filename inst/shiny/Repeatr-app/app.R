
# devtools::install_github("alexmitrani/Repeatr", build_opts = c("--no-resave-data", "--no-manual"))

library(Repeatr)

# pre-processing ----------------------------------------------------------

shows_data <- othervariables %>%
  filter(is.na(attendance)==FALSE) %>%
  filter(is.na(tour)==FALSE) %>%
  mutate(attendance = as.integer(attendance)) %>%
  mutate(date = as.Date(date, "%d-%m-%Y")) %>%
  mutate(year = lubridate::year(date)) %>%
  rename(latitude = y) %>%
  rename(longitude = x) %>%
  select(flsid, tour, year, date, venue, city, country, attendance, doorprice, latitude, longitude, checked) %>%
  rename(door_price = doorprice,
         fls_id = flsid)

# User Interface ----------------------------------------------------------

ui <- fluidPage(

  tags$style(type = "text/css", "html, body {width:100%; height:100%}",
    HTML('
         #buttons {
         display: flex;
         margin-bottom:20px; opacity:1; height:85px;
         align-items: center;
         justify-content: center;
         }
         ')
  ),

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

                             h4("Choose one or more years, tours, countries, cities, and / or a range of dates."),

                             fluidRow(
                               column(12,
                                      selectizeInput("yearInput_shows", "year:",
                                                     sort(unique((othervariables$year))),
                                                     selected=NULL, multiple =TRUE),
                                      uiOutput("menuOptions_tours"),
                                      uiOutput("menuOptions_countries"),
                                      uiOutput("menuOptions_cities"))

                             ),

                             # Controls for slider

                             fluidRow(

                               column(3,
                                      numericInput("days", "days:", 5542,
                                                   min = 7, max = 5542)),

                               column(1,
                                      align="center", id="buttons",
                                      actionButton(
                                        "step_b",
                                        icon("backward")
                                      )
                               ),

                               column(1,
                                      align="center", id="buttons",
                                      actionButton(
                                        "step_f",
                                        icon("forward")
                                      )
                               )

                             ),

                             # Slider control

                             fluidRow(
                               column(12,
                                      sliderInput("dateInput_shows", "Initial date:", min=as.Date("1987-09-03"), max=as.Date("2002-11-04"),
                                                  value=c(as.Date("1987-09-03")), timeFormat = "%F"))
                             ),


                             h4("Select a show on the map to get further details."),
                             h6("The locations are approximate."),

                             fluidRow(


                               leafletOutput("mymap")


                             ),

                             tags$br(),
                             h4("The table below gives details for the selected shows."),
                             tags$br(),

                             fluidRow(

                               # Create a new row for the table.
                               DT::dataTableOutput("showsdatatable")

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

                             h4("Choose one or more releases, a selection of songs, and / or a range of dates."),

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
                               )

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




# Server -----------------------------------------------------


server <- function(input, output, session) {


# Shows -------------------------------------------------------------------

  # selectInput("yearInput_shows", "year:", choices = sort(unique((othervariables$year)))),
  # selectInput("tourInput_shows", "tour:", choices = NULL),
  # selectInput("countryInput_shows", "country:", choices = NULL),
  # selectInput("cityInput_shows", "city:", choices = NULL),
  # tableOutput("citydata"),

  output$menuOptions_tours <- renderUI({

    if (is.null(input$yearInput_shows)==FALSE) {
      menudata <- shows_data %>%
        filter(year %in% input$yearInput_shows) %>%
        arrange(tour)
    } else {
      menudata <- shows_data %>%
        arrange(tour)
    }

    selectizeInput("tourInput_shows", "tours:",
                   choices = c(unique(menudata$tour)), multiple =TRUE)

  })

  output$menuOptions_countries <- renderUI({

    if (is.null(input$yearInput_shows)==FALSE & is.null(input$tourInput_shows)==FALSE) {
      menudata <- shows_data %>%
        filter(year %in% input$yearInput_shows &
                 tour %in% input$tourInput_shows) %>%
        arrange(country)

    } else if (is.null(input$yearInput_shows)==FALSE & is.null(input$tourInput_shows)==TRUE) {
      menudata <- shows_data %>%
        filter(year %in% input$yearInput_shows) %>%
        arrange(country)

    } else if (is.null(input$yearInput_shows)==TRUE & is.null(input$tourInput_shows)==FALSE) {
      menudata <- shows_data %>%
        filter(tour %in% input$tourInput_shows) %>%
        arrange(country)

    } else {
      menudata <- shows_data %>%
        arrange(country)

    }

    selectizeInput("countryInput_shows", "countries:",
                   choices = c(unique(menudata$country)), multiple =TRUE)

  })


  output$menuOptions_cities <- renderUI({

    if (is.null(input$yearInput_shows)==FALSE & is.null(input$tourInput_shows)==FALSE & is.null(input$countryInput_shows)==FALSE) {
      menudata <- shows_data %>%
        filter(year %in% input$yearInput_shows &
                 tour %in% input$tourInput_shows &
                 country %in% input$countryInput_shows) %>%
        arrange(city)

    } else if (is.null(input$yearInput_shows)==FALSE & is.null(input$tourInput_shows)==FALSE & is.null(input$countryInput_shows)==TRUE) {

      menudata <- shows_data %>%
        filter(year %in% input$yearInput_shows &
                 tour %in% input$tourInput_shows) %>%
        arrange(city)


    } else if (is.null(input$yearInput_shows)==FALSE & is.null(input$tourInput_shows)==TRUE & is.null(input$countryInput_shows)==FALSE) {
      menudata <- shows_data %>%
        filter(year %in% input$yearInput_shows &
                 country %in% input$countryInput_shows) %>%
        arrange(city)

    } else if (is.null(input$yearInput_shows)==FALSE & is.null(input$tourInput_shows)==TRUE & is.null(input$countryInput_shows)==TRUE) {
      menudata <- shows_data %>%
        filter(year %in% input$yearInput_shows) %>%
        arrange(city)

    } else if (is.null(input$yearInput_shows)==TRUE & is.null(input$tourInput_shows)==FALSE & is.null(input$countryInput_shows)==FALSE) {
      menudata <- shows_data %>%
        filter(tour %in% input$tourInput_shows &
                 country %in% input$countryInput_shows) %>%
        arrange(city)

    } else if (is.null(input$yearInput_shows)==TRUE & is.null(input$tourInput_shows)==FALSE & is.null(input$countryInput_shows)==TRUE) {
      menudata <- shows_data %>%
        filter(tour %in% input$tourInput_shows) %>%
        arrange(city)

    } else if (is.null(input$yearInput_shows)==TRUE & is.null(input$tourInput_shows)==TRUE & is.null(input$countryInput_shows)==FALSE) {
      menudata <- shows_data %>%
        filter(country %in% input$countryInput_shows) %>%
        arrange(city)

    } else {
      menudata <- shows_data %>%
        arrange(city)

    }

    selectizeInput("cityInput_shows", "cities:",
                   choices = c(unique(menudata$city)), multiple =TRUE)

  })

  observeEvent(input$step_f, {
    date1 <- input$dateInput_shows[1] + input$days
    updateSliderInput(session,"dateInput_shows", "Initial date:", min=as.Date("1987-09-03"), max=as.Date("2002-11-04"),
                value=c(date1), timeFormat = "%F")
  })

  observeEvent(input$step_b, {
    date1 <- input$dateInput_shows[1] - input$days
    updateSliderInput(session,"dateInput_shows", "Initial date:", min=as.Date("1987-09-03"), max=as.Date("2002-11-04"),
                      value=c(date1), timeFormat = "%F")
  })

  shows_data2 <- reactive({

    date1 <- input$dateInput_shows[1]
    date2 <- date1 + input$days

    if (is.null(input$yearInput_shows)==FALSE & is.null(input$tourInput_shows)==FALSE & is.null(input$countryInput_shows)==FALSE & is.null(input$cityInput_shows)==FALSE) {
      mydf <- shows_data %>%
        filter(date >= date1 &
                 date <= date2 &
                 year %in% input$yearInput_shows &
                 tour %in% input$tourInput_shows &
                 country %in% input$countryInput_shows &
                 city %in% input$cityInput_shows)

    } else if (is.null(input$yearInput_shows)==FALSE & is.null(input$tourInput_shows)==FALSE & is.null(input$countryInput_shows)==FALSE & is.null(input$cityInput_shows)==TRUE) {
        mydf <- shows_data %>%
          filter(date >= date1 &
                   date <= date2 &
                   year %in% input$yearInput_shows &
                   tour %in% input$tourInput_shows &
                   country %in% input$countryInput_shows)

    } else if (is.null(input$yearInput_shows)==FALSE & is.null(input$tourInput_shows)==FALSE & is.null(input$countryInput_shows)==TRUE & is.null(input$cityInput_shows)==FALSE) {

      mydf <- shows_data %>%
        filter(date >= date1 &
                 date <= date2 &
                 year %in% input$yearInput_shows &
                 tour %in% input$tourInput_shows &
                 city %in% input$cityInput_shows)

    } else if (is.null(input$yearInput_shows)==FALSE & is.null(input$tourInput_shows)==FALSE & is.null(input$countryInput_shows)==TRUE & is.null(input$cityInput_shows)==TRUE) {

      mydf <- shows_data %>%
        filter(date >= date1 &
                 date <= date2 &
                 year %in% input$yearInput_shows &
                 tour %in% input$tourInput_shows)


    } else if (is.null(input$yearInput_shows)==FALSE & is.null(input$tourInput_shows)==TRUE & is.null(input$countryInput_shows)==FALSE & is.null(input$cityInput_shows)==FALSE) {
      mydf <- shows_data %>%
        filter(date >= date1 &
                 date <= date2 &
                 year %in% input$yearInput_shows &
                 country %in% input$countryInput_shows &
                 city %in% input$cityInput_shows)

    } else if (is.null(input$yearInput_shows)==FALSE & is.null(input$tourInput_shows)==TRUE & is.null(input$countryInput_shows)==FALSE & is.null(input$cityInput_shows)==TRUE) {
      mydf <- shows_data %>%
        filter(date >= date1 &
                 date <= date2 &
                 year %in% input$yearInput_shows &
                 country %in% input$countryInput_shows)

    } else if (is.null(input$yearInput_shows)==FALSE & is.null(input$tourInput_shows)==TRUE & is.null(input$countryInput_shows)==TRUE & is.null(input$cityInput_shows)==FALSE) {
      mydf <- shows_data %>%
        filter(date >= date1 &
                 date <= date2 &
                 year %in% input$yearInput_shows &
                 city %in% input$cityInput_shows)

    } else if (is.null(input$yearInput_shows)==FALSE & is.null(input$tourInput_shows)==TRUE & is.null(input$countryInput_shows)==TRUE & is.null(input$cityInput_shows)==TRUE) {
      mydf <- shows_data %>%
        filter(date >= date1 &
                 date <= date2 &
                 year %in% input$yearInput_shows)

    } else if (is.null(input$yearInput_shows)==TRUE & is.null(input$tourInput_shows)==FALSE & is.null(input$countryInput_shows)==FALSE & is.null(input$cityInput_shows)==FALSE) {
      mydf <- shows_data %>%
        filter(date >= date1 &
                 date <= date2 &
                 tour %in% input$tourInput_shows &
                 country %in% input$countryInput_shows &
                 city %in% input$cityInput_shows)

    } else if (is.null(input$yearInput_shows)==TRUE & is.null(input$tourInput_shows)==FALSE & is.null(input$countryInput_shows)==FALSE & is.null(input$cityInput_shows)==TRUE) {
      mydf <- shows_data %>%
        filter(date >= date1 &
                 date <= date2 &
                 tour %in% input$tourInput_shows &
                 country %in% input$countryInput_shows)

    } else if (is.null(input$yearInput_shows)==TRUE & is.null(input$tourInput_shows)==FALSE & is.null(input$countryInput_shows)==TRUE & is.null(input$cityInput_shows)==FALSE) {
      mydf <- shows_data %>%
        filter(date >= date1 &
                 date <= date2 &
                 tour %in% input$tourInput_shows &
                 city %in% input$cityInput_shows)

    } else if (is.null(input$yearInput_shows)==TRUE & is.null(input$tourInput_shows)==FALSE & is.null(input$countryInput_shows)==TRUE & is.null(input$cityInput_shows)==TRUE) {
      mydf <- shows_data %>%
        filter(date >= date1 &
                 date <= date2 &
                 tour %in% input$tourInput_shows)

    } else if (is.null(input$yearInput_shows)==TRUE & is.null(input$tourInput_shows)==TRUE & is.null(input$countryInput_shows)==FALSE & is.null(input$cityInput_shows)==FALSE) {
      mydf <- shows_data %>%
        filter(date >= date1 &
                 date <= date2 &
                 country %in% input$countryInput_shows &
                 city %in% input$cityInput_shows)

    } else if (is.null(input$yearInput_shows)==TRUE & is.null(input$tourInput_shows)==TRUE & is.null(input$countryInput_shows)==FALSE & is.null(input$cityInput_shows)==TRUE) {
      mydf <- shows_data %>%
        filter(date >= date1 &
                 date <= date2 &
                 country %in% input$countryInput_shows)

    } else if (is.null(input$yearInput_shows)==TRUE & is.null(input$tourInput_shows)==TRUE & is.null(input$countryInput_shows)==TRUE & is.null(input$cityInput_shows)==FALSE){
      mydf <- shows_data %>%
        filter(date >= date1 &
                 date <= date2 &
                 city %in% input$cityInput_shows)

    } else {
      mydf <- shows_data %>%
        filter(date >= date1 &
                 date <= date2)

    }

    mydf

  })

  output$mymap <- renderLeaflet({
    df <- shows_data2()

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

  output$showsdatatable <- DT::renderDataTable(DT::datatable({

    data <- shows_data2()

  }))


# Tours -------------------------------------------------------------------


  output$toursdatatable <- DT::renderDataTable(DT::datatable({
    data <- toursdata  %>%
      filter(tour!="Unknown") %>%
      rename(duration_days = duration) %>%
      arrange(start)

    if (input$startyear != "All") {
      data <- data[data$startyear == input$startyear,]
    }

    data <- data %>%
      select(-startyear, -endyear) %>%
      rename(mean_attendance = meanattendance)

    data
  }))


# Venues ------------------------------------------------------------------



  output$venuesdatatable <- DT::renderDataTable(DT::datatable({
    data <- venuesdata  %>%
      arrange(desc(shows))
    if (input$country != "All") {
      data <- data[data$country == input$country,]
    }
    if (input$city != "All") {
      data <- data[data$city == input$city,]
    }
    data
  }))


# Songs -------------------------------------------------------------------



  max_songs <- 20

  output$menuOptions <- renderUI({

    if (is.null(input$releaseInput)==FALSE) {
      menudata <- cumulative_song_counts %>%
        filter(release %in% input$releaseInput) %>%
        arrange(song)
    } else {
      menudata <- cumulative_song_counts %>%
        arrange(song)
    }

    selectizeInput("songInput", "Songs",
                   choices = c(unique(menudata$song)), multiple =TRUE)

  })

  songs_data <- reactive({

    if (is.null(input$releaseInput)==FALSE & is.null(input$songInput)==FALSE) {
      mydf <- cumulative_song_counts %>%
        filter(date >= input$dateInput[1] &
                 date <= input$dateInput[2] &
                 release %in% input$releaseInput &
                 song %in% input$songInput)

    } else if (is.null(input$releaseInput)==FALSE & is.null(input$songInput)==TRUE) {
      mydf <- cumulative_song_counts %>%
        filter(date >= input$dateInput[1] &
                 date <= input$dateInput[2] &
                 release %in% input$releaseInput)

    } else if (is.null(input$releaseInput)==TRUE & is.null(input$songInput)==FALSE) {
      mydf <- cumulative_song_counts %>%
        filter(date >= input$dateInput[1] &
                 date <= input$dateInput[2] &
                 song %in% input$songInput)

    } else {
      mydf <- cumulative_song_counts %>%
        filter(date >= input$dateInput[1] &
                 date <= input$dateInput[2])

    }

  })

  songs_data2 <- reactive({

    mysongs <- songs_data() %>%
      group_by(song) %>%
      summarize(count = max(count) - min(count)) %>%
      ungroup() %>%
      arrange(desc(count)) %>%
      mutate(index = row_number()) %>%
      select(song, index)

  })

  songs_data3 <- reactive({

    mydf <- songs_data() %>%
      left_join(songs_data2()) %>%
      filter(index<=max_songs)

  })

  output$performance_count_plot <- renderPlotly({

    p <- ggplot(songs_data3(), aes(date, count, color = song)) +
      geom_line() +
      theme_bw() +
      xlab("Date") +
      ylab("Performances") +
      ggtitle("Cumulative number of performances over time")

    plotly::ggplotly(p)

  })

  output$songsdatatable <- DT::renderDataTable(DT::datatable({
    data <- songs_data3() %>%
      group_by(release, song) %>%
      summarize(count = max(count) - min(count)) %>%
      ungroup() %>%
      arrange(desc(count))
  }))


# Transitions -------------------------------------------------------------



  transitions_data <- reactive({

    mydf1 <- Repeatr1 %>%
      select(gid,year,date,song_number,song) %>%
      rename(song1 = song)

    mydf2 <- Repeatr1 %>%
      select(gid,year,date,song_number,song) %>%
      mutate(song_number = song_number-1) %>%
      rename(song2 = song)

    mydf3 <- mydf1 %>%
      left_join(mydf2) %>%
      filter(is.na(song2)==FALSE) %>%
      rename(transition_number = song_number) %>%
      filter(date >= input$dateInput_transitions[1] &
               date <= input$dateInput_transitions[2])

    if (input$year_transitions != "All") {
      mydf3 <- mydf3[mydf3$year == input$year_transitions,]
    }

    mytransitions <- mydf3 %>%
      select(song1, song2) %>%
      rename(from = song1) %>%
      rename(to = song2)

    mytransitions <- mytransitions %>%
      group_by(from, to) %>%
      summarize(count = n()) %>%
      ungroup() %>%
      arrange(desc(count))

    mytransitions

  })

  output$transitionsdatatable <- DT::renderDataTable(DT::datatable({

    data <- transitions_data()

    data

  }))

  output$transitions_heatmap <- renderPlotly({

    heatmapdata <- pivot_wider(transitions_data(), names_from = to, values_from = count, names_sort=TRUE)

    heatmapdata[is.na(heatmapdata)] <- 0

    heatmapdata <- heatmapdata %>%
      arrange(desc(from))
    heatmapdata <- data.frame(heatmapdata, row.names = 1)
    heatmapdata <- heatmapdata[ , order(names(heatmapdata))]
    heatmapdata <- as.matrix(heatmapdata)

    heatmaply(
      as.matrix(heatmapdata),
      seriate="none",
      Rowv=FALSE,
      Colv=FALSE,
      show_dendrogram=FALSE,
      plot_method = "plotly"
    )

  })

}


shinyApp(ui = ui, server = server)


#

