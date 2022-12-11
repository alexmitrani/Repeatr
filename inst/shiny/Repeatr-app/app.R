
# devtools::install_github("alexmitrani/Repeatr")

library(shiny)
library(Repeatr)
library(DT)
library(lubridate)
library(leaflet)


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

                             h4("Choose a year, a country, a tour, or a range of dates."),

                             # Create a new Row in the UI for selectInputs
                             fluidRow(
                               column(4,
                                      selectInput("yearInput_shows",
                                                  "year:",
                                                  c("All",
                                                    sort(unique((othervariables$year)))))
                               ),

                               column(4,
                                      selectInput("countryInput_shows",
                                                  "country:",
                                                  c("All",
                                                    sort(unique((othervariables$country)))))
                               ),

                               column(4,
                                      selectInput("tourInput_shows",
                                                  "tour:",
                                                  c("All",
                                                    sort(unique((toursdata$tour)))))
                               )
                             ),

                             # Slider control

                             fluidRow(
                               column(6,
                                      sliderInput("dateInput_shows", "Range of dates:", min=as.Date("1987-09-03"), max=as.Date("2002-11-04"),
                                                  value=c(as.Date("1987-09-03"), as.Date("2002-11-04")), timeFormat = "%F"))
                             ),

                             h4("Select a show on the map to get further details."),

                             fluidRow(


                               leafletOutput("mymap", height = 500, width = 500)


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




# Server -----------------------------------------------------


server <- function(input, output) {


# Shows -------------------------------------------------------------------

  shows_data <- othervariables %>%
    filter(is.na(attendance)==FALSE) %>%
    filter(is.na(tour)==FALSE) %>%
    mutate(attendance = as.integer(attendance)) %>%
    mutate(date = as.Date(date, "%d-%m-%Y")) %>%
    mutate(year = lubridate::year(date)) %>%
    rename(latitude = y) %>%
    rename(longitude = x) %>%
    select(flsid, tour, year, date, venue, city, country, attendance, doorprice, latitude, longitude) %>%
    rename(door_price = doorprice,
           fls_id = flsid)

  shows_data2 <- reactive({

    data <- shows_data  %>%
      arrange(date)
    if (input$yearInput_shows != "All") {
      data <- data[data$year == input$yearInput_shows,]
    }
    if (input$countryInput_shows != "All") {
      data <- data[data$country == input$countryInput_shows,]
    }
    if (input$tourInput_shows != "All") {
      data <- data[data$tour == input$tourInput_shows,]
    }

    data <- data %>%
      filter(date >= input$dateInput_shows[1] &
               date <= input$dateInput_shows[2])

    data

  })

  output$mymap <- renderLeaflet({
    df <- shows_data2()

    margin_value <- 0.2

    ref_latitude <- mean(df$latitude)
    ref_longitude <- mean(df$longitude)

    min_latitude <- min(df$latitude)-margin_value
    min_longitude <- min(df$longitude)-margin_value

    max_latitude <- max(df$latitude)+margin_value
    max_longitude <- max(df$longitude)+margin_value

    m <- leaflet(data = df) %>%
      fitBounds(lng1 = min_longitude, lat1 = min_latitude, lng2 = max_longitude, lat2 = max_latitude) %>%
      addProviderTiles("Esri.WorldStreetMap") %>%
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

