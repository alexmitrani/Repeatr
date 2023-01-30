
# devtools::install_github("alexmitrani/Repeatr", build_opts = c("--no-resave-data", "--no-manual"))

library(Repeatr)

# Theme -------------------------------------------------------------------

my_theme <- bs_theme(bootswatch = "darkly",
                     base_font = font_google("Inconsolata"),
                     version = 5)

thematic_shiny(font = "auto")

# pre-processing ----------------------------------------------------------

shows_data <- othervariables %>%
  filter(is.na(attendance)==FALSE) %>%
  filter(is.na(tour)==FALSE) %>%
  mutate(attendance = as.integer(attendance)) %>%
  mutate(date = as.Date(date, "%d-%m-%Y")) %>%
  mutate(year = lubridate::year(date)) %>%
  rename(latitude = y) %>%
  rename(longitude = x) %>%
  select(gid, tour, year, date, venue, city, country, attendance, doorprice, latitude, longitude, checked) %>%
  rename(door_price = doorprice) %>%
  mutate(urls = paste0("https://www.dischord.com/fugazi_live_series/", gid)) %>%
  mutate(fls_link = paste0("<a href='",  urls, "' target='_blank'>", gid, "</a>"))


last_performance_data <- Repeatr1 %>%
  select(date, song)%>%
  group_by(song) %>%
  summarize(last_performance=max(date)) %>%
  ungroup()


xray <- Repeatr1
xray <- xray %>% select(-release)
xray <- xray %>% left_join(releasesdatalookup)

xray <- xray %>%
  mutate(releasedate = as.Date(releasedate, "%d/%m/%Y", origin = "1970-01-01"))

xray <- xray %>%
  mutate(unreleased = ifelse(date<releasedate,1,0))

xray2 <- summary %>%
  select(songid, launchdate)

xray <- xray %>%
  left_join(xray2)

xray <- xray %>%
  mutate(debut = ifelse(date==launchdate,1,0))

xray <- xray %>%
  left_join(last_performance_data)

xray <- xray %>%
  mutate(last_performance=ifelse(date==last_performance,1,0))

xray <- xray %>%
  mutate(song = 1)

xray <- xray %>%
  mutate(fugazi = ifelse(release=="fugazi",1,0),
         margin_walker = ifelse(release=="margin walker",1,0),
         three_songs = ifelse(release=="3 songs",1,0),
         repeater = ifelse(release=="repeater",1,0),
         steady_diet_of_nothing = ifelse(release=="steady diet of nothing",1,0),
         in_on_the_killtaker = ifelse(release=="in on the killtaker",1,0),
         red_medicine = ifelse(release=="red medicine",1,0),
         end_hits = ifelse(release=="end hits",1,0),
         the_argument = ifelse(release=="the argument",1,0),
         furniture = ifelse(release=="furniture",1,0),
         first_demo = ifelse(release=="first demo",1,0))


xray <- xray %>%
  group_by(gid, date) %>%
  summarize(unreleased = sum(unreleased),
            debut = sum(debut),
            farewell = sum(last_performance),
            fugazi = sum(fugazi),
            margin_walker = sum(margin_walker),
            three_songs = sum(three_songs),
            repeater = sum(repeater),
            steady_diet_of_nothing = sum(steady_diet_of_nothing),
            in_on_the_killtaker = sum(in_on_the_killtaker),
            red_medicine = sum(red_medicine),
            end_hits = sum(end_hits),
            the_argument = sum(the_argument),
            furniture = sum(furniture),
            first_demo = sum(first_demo),
            songs = sum(song)) %>%
  arrange(date) %>%
  ungroup()

xray <- xray %>%
  mutate(urls = paste0("https://www.dischord.com/fugazi_live_series/", gid)) %>%
  mutate(fls_link = paste0("<a href='",  urls, "' target='_blank'>", gid, "</a>")) %>%
  select(-gid, -urls)

xray <- xray %>%
  relocate(fls_link, date, songs, unreleased, debut, farewell)

transitions_data_da1 <- Repeatr1 %>%
  select(gid,date,song_number,song) %>%
  rename(song1 = song)

transitions_data_da2 <- Repeatr1 %>%
  select(gid,date,song_number,song) %>%
  mutate(song_number = song_number-1) %>%
  rename(song2 = song)

transitions_data_da <- transitions_data_da1 %>%
  left_join(transitions_data_da2) %>%
  filter(is.na(song2)==FALSE) %>%
  rename(transition = song_number) %>%
  mutate(urls = paste0("https://www.dischord.com/fugazi_live_series/", gid)) %>%
  mutate(fls_link = paste0("<a href='",  urls, "' target='_blank'>", gid, "</a>")) %>%
  select(fls_link, date, transition, song1, song2) %>%
  mutate(transition = as.integer(transition))

transitions_data_da$date <- format(transitions_data_da$date,'%Y-%m-%d')

timestamptext <- paste0("Made with Repeatr version ", packageVersion("Repeatr"), ", updated ", packageDate("Repeatr"), ".")

# User Interface ----------------------------------------------------------

ui <- fluidPage(

  theme = my_theme,

  tags$head(includeHTML(("google-analytics.html"))),

  tags$style(type = "text/css", "html, body {width:100%; height:100%}"),

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


# Shows -------------------------------------------------------------------

                  tabPanel("shows",


                           fluidPage(

                             tags$br(),

                             fluidRow(
                               column(6,
                                      selectizeInput("yearInput_shows", "years:",
                                                     sort(unique(othervariables$year)),
                                                     selected=NULL, multiple =TRUE)),
                               column(6, uiOutput("menuOptions_tours"))

                             ),

                           fluidRow(

                             column(6, uiOutput("menuOptions_countries")),
                             column(6, uiOutput("menuOptions_cities"))

                            ),


                           fluidRow(

                             column(12,

                              leafletOutput("mymap")

                             )

                           ),


                           tags$br(),


                              conditionalPanel(
                                condition = "input.cityInput_shows=='' & input.countryInput_shows==''",

                                  fluidRow(

                                    column(12,
                                           sliderInput("dateInput_shows", "timeline:", min=as.Date("1987-09-03"), max=as.Date("2002-11-04"),
                                                       value=c(as.Date("1987-09-03")), timeFormat = "%F", width = "100%"))

                                  ),

                                  fluidRow(

                                    column(2,
                                           numericInput("weeks", "period (weeks):", 792,
                                                        min = 1, max = 792)),

                                    column(2,
                                           numericInput("step_days", "step (days):", 1,
                                                        min = 1, max = 365)),

                                    column(8,

                                             div(style="display: inline-block;vertical-align:top;",column(2, actionButton(
                                               "visit",
                                               icon("location-dot")
                                             ))),
                                             div(style="display: inline-block;vertical-align:top;",column(2, actionButton(
                                               "step_b",
                                               icon("backward")
                                             ))),
                                             div(style="display: inline-block;vertical-align:top;",column(2, actionButton(
                                               "step_f",
                                               icon("forward")
                                             ))),
                                             div(style="display: inline-block;vertical-align:top;",column(2, actionButton(
                                               "home",
                                               icon("house")
                                             )))

                                           )

                                  ),


                             ),


                             fluidRow(

                               tags$br(),

                               column(12,

                                 # Create a new row for the table.
                                 DT::dataTableOutput("showsdatatable")

                               )

                             )

                           )

                  ),


# Tours -------------------------------------------------------------------



                  tabPanel("tours",

                           fluidPage(

                             tags$br(),

                             # Create a new Row in the UI for selectInputs
                             fluidRow(
                               column(12,
                                      selectizeInput("yearInput_tours", "years:",
                                                     sort(unique((toursdata$startyear))),
                                                     selected=NULL, multiple =TRUE)
                               )

                             ),

                             # Graph

                             fluidRow(
                               column(12,
                                      plotlyOutput("attendance_count_plot")
                               )
                             ),

                             tags$br(),

                             # Create a new row for the table.
                             DT::dataTableOutput("toursdatatable")

                           )

                  ),

# Songs -------------------------------------------------------------------


                  tabPanel("songs",

                           fluidPage(

                             tags$br(),

                             fluidRow(
                               column(6,
                                      selectizeInput("yearInput_songs", "years:",
                                                     sort(unique((othervariables$year))),
                                                     selected=NULL, multiple =TRUE)),
                               column(6, uiOutput("menuOptions_tours_songs")

                                      )

                             ),

                             # Release and song selection controls

                             fluidRow(
                               column(6,
                                      selectizeInput("releaseInput", "release",
                                                     choices = c(unique(cumulative_song_counts$release)),
                                                     selected="Fugazi", multiple =TRUE)),
                              column(6,
                                      uiOutput("menuOptions")
                                     )

                             ),

                             # Graph

                             fluidRow(
                               column(12,
                                        plotlyOutput("performance_count_plot")
                                      )
                               ),

                            tags$br(),


                            fluidRow(
                              column(12,
                                     DT::dataTableOutput("songsdatatable")
                                     )
                            )

                          )

                  ),

# Transitions -------------------------------------------------------------


                  tabPanel("transitions",

                             fluidPage(

                               tags$br(),

                               # Create a new Row in the UI for selectInputs
                               fluidRow(
                                 column(6,
                                        selectizeInput("year_transitions", "years:",
                                                       sort(unique((toursdata$startyear))),
                                                       selected="1989", multiple =TRUE)),
                                 column(6, uiOutput("menuOptions_tours_transitions")
                                        )

                               ),

                               # Graph

                               fluidRow(
                                 column(12,
                                        plotlyOutput("transitions_heatmap")
                                 )
                               ),

                               tags$br(),

                               fluidRow(
                                 column(12,
                                        DT::dataTableOutput("transitionsdatatable")
                                 )
                               )

                             )

                           ),

# Search -------------------------------------------------------------

                  tabPanel("search",

                           fluidPage(

                             tags$br(),

                             # Create a new Row in the UI for selectInputs
                             fluidRow(
                               column(6,
                                      selectizeInput("search_from_song", "from:",
                                                     sort(unique((songidlookup$song))),
                                                     selected=NULL, multiple =TRUE)),
                               column(6, uiOutput("menuOptions_search"))
                               ),


                           tags$br(),

                           fluidRow(
                             column(12,
                                    DT::dataTableOutput("transitions_shows_datatable")
                             )
                           )

                          )

                  )


# End section -------------------------------------------------------------

      ),


        tags$div(
          tags$br(),
          print(timestamptext),
          tags$br(),
          " Visit the ",
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



  output$menuOptions_tours <- renderUI({

    if (is.null(input$yearInput_shows)==FALSE) {
      menudata <- shows_data %>%
        filter(year %in% input$yearInput_shows) %>%
        arrange(date)
    } else {
      menudata <- shows_data %>%
        arrange(date)
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

  observeEvent(input$visit, {
    date1 <- as.Date(min(shows_data2()$date))
    freezeReactiveValue(input, "dateInput_shows")
    updateSliderInput(session,"dateInput_shows", "timeline:", min=as.Date("1987-09-03"), max=as.Date("2002-11-04"),
                      value=c(date1), timeFormat = "%F")
    freezeReactiveValue(input, "weeks")
    updateNumericInput(session, "weeks", "period (weeks):", 1,
                       min = 1, max = 792)
    freezeReactiveValue(input, "step_days")
    updateNumericInput(session, "step_days", "step (days):", 1,
                       min = 1, max = 5542)
  })

  observeEvent(input$step_b, {
    date1 <- input$dateInput_shows[1] - input$step_days
    freezeReactiveValue(input, "dateInput_shows")
    updateSliderInput(session,"dateInput_shows", "timeline:", min=as.Date("1987-09-03"), max=as.Date("2002-11-04"),
                      value=c(date1), timeFormat = "%F")
  })

  observeEvent(input$step_f, {
    date1 <- input$dateInput_shows[1] + input$step_days
    freezeReactiveValue(input, "dateInput_shows")
    updateSliderInput(session,"dateInput_shows", "timeline:", min=as.Date("1987-09-03"), max=as.Date("2002-11-04"),
                      value=c(date1), timeFormat = "%F")
  })

  observeEvent(input$home, {
    date1 <- input$dateInput_shows[1] - input$step_days
    freezeReactiveValue(input, "dateInput_shows")
    updateSliderInput(session,"dateInput_shows", "timeline:", min=as.Date("1987-09-03"), max=as.Date("2002-11-04"),
                      value=c(as.Date("1987-09-03")), timeFormat = "%F")
    freezeReactiveValue(input, "weeks")
    updateNumericInput(session, "weeks", "period (weeks):", 792,
                       min = 1, max = 792)
    freezeReactiveValue(input, "step_days")
    updateNumericInput(session, "step_days", "step (days):", 1,
                       min = 1, max = 5542)
  })

  shows_data2 <- reactive({

    date1 <- input$dateInput_shows[1]
    date2 <- date1 + 7*input$weeks

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

  # map

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
    margin_value <- ifelse(diff==0, 0.15, min(0.15*diff, 10))

    min_latitude <- min(df$latitude)-margin_value
    min_longitude <- min(df$longitude)-margin_value

    max_latitude <- max(df$latitude)+margin_value
    max_longitude <- max(df$longitude)+margin_value

    m <- leaflet(data = df, options = leafletOptions(zoomControl = FALSE)) %>%
      htmlwidgets::onRender("function(el, x) {
        L.control.zoom({ position: 'bottomleft' }).addTo(this)
      }") %>%
      fitBounds(lng1 = min_longitude, lat1 = min_latitude, lng2 = max_longitude, lat2 = max_latitude) %>%
      addProviderTiles("OpenStreetMap.Mapnik") %>%
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

    data <- shows_data2() %>%
      mutate(coordinates = paste0(latitude, ", ", longitude)) %>%
      select(fls_link, date, venue, city, country, attendance, coordinates)

  }, escape = c(TRUE, FALSE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE),
  style = "bootstrap"))


# Tours -------------------------------------------------------------------

  attendance_data <- reactive({

    meanattendance <- othervariables %>%
      filter(is.na(attendance)==FALSE) %>%
      group_by(year) %>%
      summarise(meanattendance = mean(attendance)) %>%
      ungroup()

    attendancedata <- othervariables %>%
      filter(is.na(tour)==FALSE) %>%
      left_join(meanattendance) %>%
      mutate(attendance = round(ifelse(is.na(attendance)==TRUE,meanattendance,attendance))) %>%
      select(year, tour, date, attendance) %>%
      arrange(date) %>%
      mutate(cumulative_attendance = cumsum(attendance))

    if (is.null(input$yearInput_tours)==FALSE) {

      attendancedata <- attendancedata[attendancedata$year %in% input$yearInput_tours,]

    }

    attendancedata

  })

  attendance_data2 <- reactive({

    attendancedata2 <- attendance_data() %>%
      group_by(tour) %>%
      filter(is.na(date)==FALSE) %>%
      summarise(start = min(date), end = max(date), shows = n(), duration = as.numeric((end - start)), attendance=sum(attendance), cumulative_attendance = max(cumulative_attendance)) %>%
      ungroup() %>%
      arrange(start)

    attendancedata2

  })

  output$attendance_count_plot <- renderPlotly({

    attendance_plot <- ggplot(attendance_data(), aes(date, cumulative_attendance, color = tour)) +
      geom_point() +
      theme(legend.position="none") +
      xlab("date") +
      ylab("cumulative attendance") +
      scale_y_continuous(labels = comma)

    plotly::ggplotly(attendance_plot)

  })

  output$toursdatatable <- DT::renderDataTable(DT::datatable({
    data <- attendance_data2()  %>%
      filter(tour!="Unknown") %>%
      rename(days = duration) %>%
      arrange(start)

    data

  },
  style = "bootstrap"))


# X-Ray -------------------------------------------------------------------




# Songs -------------------------------------------------------------------

  max_songs <- 100

  output$menuOptions_tours_songs <- renderUI({

    if (is.null(input$yearInput_songs)==FALSE) {
      menudata <- shows_data %>%
        filter(year %in% input$yearInput_songs) %>%
        arrange(date)
    } else {
      menudata <- shows_data %>%
        arrange(date)
    }

    selectizeInput("tourInput_songs", "tours:",
                   choices = c(unique(menudata$tour)), multiple =TRUE)

  })

  output$menuOptions <- renderUI({

    if (is.null(input$releaseInput)==FALSE) {
      menudata <- cumulative_song_counts %>%
        filter(release %in% input$releaseInput) %>%
        arrange(song)
    } else {
      menudata <- cumulative_song_counts %>%
        arrange(song)
    }

    selectizeInput("songInput", "songs",
                   choices = c(unique(menudata$song)), multiple =TRUE)

  })

  songs_data <- reactive({

    if (is.null(input$yearInput_songs)==FALSE & is.null(input$tourInput_songs)==FALSE) {
      datedata <- shows_data %>%
        filter(year %in% input$yearInput_songs &
                 tour %in% input$tourInput_songs)

    } else if (is.null(input$yearInput_songs)==FALSE & is.null(input$tourInput_songs)==TRUE) {
      datedata <- shows_data %>%
        filter(year %in% input$yearInput_songs)

    } else if (is.null(input$yearInput_songs)==TRUE & is.null(input$tourInput_songs)==FALSE) {
      datedata <- shows_data %>%
        filter(tour %in% input$tourInput_songs)

    } else {
      datedata <- shows_data

    }

    date1 <- as.Date(min(datedata$date))
    date2 <- as.Date(max(datedata$date))

    if (is.null(input$releaseInput)==FALSE & is.null(input$songInput)==FALSE) {
      mydf <- cumulative_song_counts %>%
        filter(date >= date1 &
                 date <= date2 &
                 release %in% input$releaseInput &
                 song %in% input$songInput)

    } else if (is.null(input$releaseInput)==FALSE & is.null(input$songInput)==TRUE) {
      mydf <- cumulative_song_counts %>%
        filter(date >= date1 &
                 date <= date2 &
                 release %in% input$releaseInput)

    } else if (is.null(input$releaseInput)==TRUE & is.null(input$songInput)==FALSE) {
      mydf <- cumulative_song_counts %>%
        filter(date >= date1 &
                 date <= date2 &
                 song %in% input$songInput)

    } else {
      mydf <- cumulative_song_counts %>%
        filter(date >= date1 &
                 date <= date2)

    }

    mydf

  })

  songs_data2 <- reactive({

    mysongs <- songs_data() %>%
      group_by(song) %>%
      summarize(count = max(count) - min(count), from = min(date), to=max(date)) %>%
      ungroup() %>%
      arrange(desc(count)) %>%
      mutate(index = row_number()) %>%
      select(song, index, from, to)

    mysongs

  })

  songs_data3 <- reactive({

    mydf <- songs_data() %>%
      left_join(songs_data2()) %>%
      filter(index<=max_songs) %>%
      left_join(last_performance_data) %>%
      mutate(to = as.Date(ifelse(last_performance<to, last_performance, to), origin = "1970-01-01"))

    mydf

  })

  output$performance_count_plot <- renderPlotly({

    p <- ggplot(songs_data3(), aes(date, count, color = song)) +
      geom_line() +
      xlab("date") +
      ylab("cumulative performances")

    plotly::ggplotly(p)

  })

  output$songsdatatable <- DT::renderDataTable(DT::datatable({
    data <- songs_data3() %>%
      group_by(release, song, from, to) %>%
      summarize(count = max(count) - min(count)) %>%
      ungroup() %>%
      arrange(desc(count))
  },
  style = "bootstrap"))


# Transitions -------------------------------------------------------------


  output$menuOptions_tours_transitions <- renderUI({

    if (is.null(input$year_transitions)==FALSE) {
      menudata <- shows_data %>%
        filter(year %in% input$year_transitions) %>%
        arrange(date)
    } else {
      menudata <- shows_data %>%
        arrange(date)
    }

    selectizeInput("tourInput_transitions", "tours:",
                   choices = c(unique(menudata$tour)), multiple =TRUE)

  })


  transitions_data <- reactive({

    if (is.null(input$year_transitions)==FALSE & is.null(input$tourInput_transitions)==FALSE) {
      datedata <- shows_data %>%
        filter(year %in% input$year_transitions &
                 tour %in% input$tourInput_transitions)

    } else if (is.null(input$year_transitions)==FALSE & is.null(input$tourInput_transitions)==TRUE) {
      datedata <- shows_data %>%
        filter(year %in% input$year_transitions)

    } else if (is.null(input$year_transitions)==TRUE & is.null(input$tourInput_transitions)==FALSE) {
      datedata <- shows_data %>%
        filter(tour %in% input$tourInput_transitions)

    } else {
      datedata <- shows_data

    }

    date1 <- as.Date(min(datedata$date))
    date2 <- as.Date(max(datedata$date))

    tourdata <- othervariables %>%
      select(gid, tour)

    mydf1 <- Repeatr1 %>%
      left_join(tourdata) %>%
      select(gid,year,date,song_number,song, tour) %>%
      rename(song1 = song)

    mydf2 <- Repeatr1 %>%
      select(gid,year,date,song_number,song) %>%
      mutate(song_number = song_number-1) %>%
      rename(song2 = song)

    mydf3 <- mydf1 %>%
      left_join(mydf2) %>%
      filter(is.na(song2)==FALSE) %>%
      rename(transition_number = song_number) %>%
      filter(date >= date1 &
               date <= date2)


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

  },
  style = "bootstrap"))

  output$transitions_heatmap <- renderPlotly({

    ggplot(transitions_data(), aes(to, from, fill= count)) +
      geom_tile() +
      scale_fill_viridis(discrete=FALSE)

  })

  # Search -------------------------------------------------------------

  output$menuOptions_search <- renderUI({

    if (is.null(input$search_from_song)==FALSE) {
      searchmenudata <- transitions_data_da %>%
        filter(song1 %in% input$search_from_song) %>%
        arrange(song2)
    } else {
      searchmenudata <- transitions_data_da %>%
        arrange(song2)
    }

    selectizeInput("searchInput_to_song", "to:",
                   choices = c(unique(searchmenudata$song2)), multiple =TRUE)

  })

  transitions_shows_data <- reactive({

    if (is.null(input$search_from_song)==FALSE & is.null(input$searchInput_to_song)==FALSE) {
      transitions_data_da_results <- transitions_data_da %>%
        filter(song1 %in% input$search_from_song &
                 song2 %in% input$searchInput_to_song)

    } else if (is.null(input$search_from_song)==FALSE & is.null(input$searchInput_to_song)==TRUE) {
      transitions_data_da_results <- transitions_data_da %>%
        filter(song1 %in% input$search_from_song)

    } else if (is.null(input$search_from_song)==TRUE & is.null(input$searchInput_to_song)==FALSE) {
      transitions_data_da_results <- transitions_data_da %>%
        filter(song2 %in% input$searchInput_to_song)

    } else {

      transitions_data_da_results <- transitions_data_da

    }

    transitions_data_da_results

  })


  output$transitions_shows_datatable <- DT::renderDataTable(DT::datatable({

    data <- transitions_shows_data()

    data

  }, escape = c(TRUE, FALSE, TRUE, TRUE, TRUE, TRUE),
  style = "bootstrap"))


}


# shinyapp ----------------------------------------------------------------



shinyApp(ui = ui, server = server)




#

