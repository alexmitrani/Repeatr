
# devtools::install_github("alexmitrani/Repeatr")

library(shiny)
library(Repeatr)
library(DT)
library(lubridate)


# Define UI for app  ----
ui <- fluidPage(

  # App title ----
  h1("Repeatr"),
  tags$div(
    "Exploring the ",
    tags$a(href="https://www.dischord.com/fugazi_live_series", "Fugazi Live Series"),
    tags$br(),
    tags$br()
  ),


    # Main panel for displaying outputs ----
    mainPanel(



      # Output
      tabsetPanel(type = "tabs",

                  tabPanel("Songs",

                           fluidPage(
                             h3("Songs"),

                             h4("Choose one or more releases and/or a selection of songs."),

                             h4("The output will be limited to a maximum of 20 songs."),

                             # Release and song selection controls

                             fluidRow(
                               column(12,
                                      selectizeInput("releaseInput", "Release",
                                                     choices = c(unique(cumulative_song_counts$release)),
                                                     selected=NULL, multiple =TRUE),
                                      uiOutput("menuOptions"))


                             ),

                             # Graph

                             fluidRow(
                               column(12,
                                        plotlyOutput("performance_count_plot")
                                      )
                               ),

                             # Slider control

                            h4("The start and end dates can be modified to focus on a specific period."),

                            fluidRow(
                               column(12,
                                      sliderInput("dateInput", "Date", min=as.Date("1987-09-03"), max=as.Date("2002-11-04"),
                                                  value=c(as.Date("1987-09-03"), as.Date("2002-11-04")), timeFormat = "%F"))
                             ),

                            h4("The table below shows the number of times each song was performed in the specified period."),


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

                               # Slider control

                               h4("The start and end dates can be modified to focus on a specific period."),

                               fluidRow(
                                 column(12,
                                        sliderInput("dateInput_transitions", "Date", min=as.Date("1987-09-03"), max=as.Date("2002-11-04"),
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
                               ),
                               column(4,
                                      selectInput("endyear",
                                                  "End year:",
                                                  c("All",
                                                    sort(unique(toursdata$endyear))))
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

                  tabPanel("Shows",

                           fluidPage(
                             h3("Shows"),

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
                               )
                               ),

                             # Slider control

                             h4("The start and end dates can be modified to focus on a specific period."),

                             fluidRow(
                               column(12,
                                      sliderInput("dateInput_shows", "Date", min=as.Date("1987-09-03"), max=as.Date("2002-11-04"),
                                                  value=c(as.Date("1987-09-03"), as.Date("2002-11-04")), timeFormat = "%F"))
                             ),

                             # Create a new row for the table.
                             DT::dataTableOutput("showsdatatable")

                           )

                          )

      )

    )

    )



# Define server logic
server <- function(input, output) {

  max_songs <- 20

  # Songs dynamic UI

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

  # Graph of cumulative song counts

  output$performance_count_plot <- renderPlotly({

    p <- ggplot(songs_data3(), aes(date, count, color = song)) +
      geom_line() +
      theme_bw() +
      xlab("Date") +
      ylab("Performances") +
      ggtitle("Cumulative number of performances over time")

    plotly::ggplotly(p)

  })

  # Generate a table of song counts between dates

  output$songsdatatable <- DT::renderDataTable(DT::datatable({
    data <- songs_data3() %>%
      group_by(release, song) %>%
      summarize(count = max(count) - min(count)) %>%
      ungroup() %>%
      arrange(desc(count))
  }))

  # Generate a table of transitions data

  transitions_data <- reactive({

    mydf1 <- Repeatr1 %>%
      select(gid,date,song_number,song) %>%
      rename(song1 = song)

    mydf2 <- Repeatr1 %>%
      select(gid,date,song_number,song) %>%
      mutate(song_number = song_number-1) %>%
      rename(song2 = song)

    mydf3 <- mydf1 %>%
      left_join(mydf2) %>%
      filter(is.na(song2)==FALSE) %>%
      rename(transition_number = song_number) %>%
      filter(date >= input$dateInput_transitions[1] &
             date <= input$dateInput_transitions[2])

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


  # Generate a table of transitions between dates

  output$transitionsdatatable <- DT::renderDataTable(DT::datatable({

    data <- transitions_data()

    data

  }))

  # Heatmap of transitions

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

  # Generate a table of tours data

  output$toursdatatable <- DT::renderDataTable(DT::datatable({
    data <- toursdata  %>%
      filter(tour!="Unknown") %>%
      rename(duration_days = duration) %>%
      arrange(start)

    if (input$startyear != "All") {
      data <- data[data$startyear == input$startyear,]
    }
    if (input$endyear != "All") {
      data <- data[data$endyear == input$endyear,]
    }

    data <- data %>%
      select(-startyear, -endyear) %>%
      rename(mean_attendance = meanattendance)

    data
  }))

  # Generate a table of venues data

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

  # Generate a table with basic data about each show

  shows_data <- othervariables %>%
    filter(is.na(attendance)==FALSE) %>%
    mutate(attendance = as.integer(attendance)) %>%
    mutate(date = as.Date(date, "%d-%m-%Y")) %>%
    mutate(year = lubridate::year(date)) %>%
    select(flsid, year, date, venue, city, country, attendance, doorprice) %>%
    rename(door_price = doorprice,
           fls_id = flsid)

  shows_data <- shows_data %>%
    mutate(country = ifelse(fls_id=="FLS0970", "USA", country),
           city = ifelse(fls_id=="FLS0970", "San Francisco", city))

  output$showsdatatable <- DT::renderDataTable(DT::datatable({
    data <- shows_data  %>%
      arrange(date)
    if (input$yearInput_shows != "All") {
      data <- data[data$year == input$yearInput_shows,]
    }
    if (input$countryInput_shows != "All") {
      data <- data[data$country == input$countryInput_shows,]
    }

    data <- data %>%
      filter(date >= input$dateInput_shows[1] &
               date <= input$dateInput_shows[2])

    data

  }))


}


shinyApp(ui = ui, server = server)


#

