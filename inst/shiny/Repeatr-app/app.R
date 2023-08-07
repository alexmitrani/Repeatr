
# devtools::install_github("alexmitrani/Repeatr", build_opts = c("--no-resave-data", "--no-manual"))

library(Repeatr)

# theme -------------------------------------------------------------------

my_theme <- bs_theme(bootswatch = "darkly",
                     base_font = font_google("Inconsolata"),
                     version = 5)

thematic_shiny(font = "auto")

# pre-processing ----------------------------------------------------------

timestamptext <- paste0("Made with Repeatr version ", packageVersion("Repeatr"), ", updated ", packageDate("Repeatr"), ".")

year_tour_release <- Repeatr1 %>%
  select(year, gid, release) %>%
  group_by(year, gid, release) %>%
  filter(is.na(release)==FALSE) %>%
  summarize(count = n()) %>%
  ungroup() %>%
  left_join(othervariables) %>%
  select(year, gid, release, tour, count)


# user interface ----------------------------------------------------------

ui <- fluidPage(

  theme = my_theme,

  tags$head(includeHTML(("google-analytics.html"))),

  tags$style(type = "text/css", "html, body {width:100%; height:100%}"),

  h1("Repeatr-app"),

    tags$div(
      "Exploring the ",
      tags$a(href="https://www.dischord.com/fugazi_live_series", "Fugazi Live Series"),
      tags$br()
    ),


    mainPanel(

      tags$div(
        print(timestamptext),
        tags$br(),
        tags$a(href="https://alexmitrani.github.io/Repeatr/articles/Repeatr-app.html", "Repeatr-app documentation"),
        tags$br(),
        tags$br(),
      ),

      # Output
      tabsetPanel(type = "tabs",


# when -------------------------------------------------------------------

tabPanel("when",


         fluidPage(

           fluidRow(
             column(6,
                    selectizeInput("yearInput_shows", "years:",
                                   sort(unique(othervariables$year)),
                                   selected=NULL, multiple =TRUE)),
             column(6, uiOutput("menuOptions_tours"))

           ),

           tabsetPanel(type = "tabs",

           # shows -------------------------------------------------------------------

           tabPanel("shows",


                    fluidPage(

                      tags$br(),

                      h4("Selection"),
                      tags$br(),


                      fluidRow(

                        column(6, uiOutput("menuOptions_countries")),
                        column(6, uiOutput("menuOptions_cities"))

                      ),

                      h4("Map"),
                      tags$br(),

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
                                             value=c(as.Date("1987-09-03")), timeFormat = "%F", width = "100%", animate = TRUE))

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

                      h4("Data table"),
                      tags$br(),


                      fluidRow(

                        tags$br(),

                        column(12,

                               # Create a new row for the table.
                               DT::dataTableOutput("showsdatatable")

                        )

                      )

                    )

           ),


           # attendance -------------------------------------------------------------------


           tabPanel("attendance",

                    fluidPage(

                      tags$br(),

                      # Graph

                      h4("Graph"),
                      tags$br(),

                      fluidRow(
                        column(12,
                               plotlyOutput("attendance_count_plot")
                        )
                      ),

                      tags$br(),

                      h4("Data table"),
                      tags$br(),

                      # Create a new row for the table.
                      DT::dataTableOutput("toursdatatable")

                    )

           ),


           # xray -------------------------------------------------------------------


           tabPanel("xray",

                    fluidPage(

                      tags$br(),

                      h4("Selection"),
                      tags$br(),

                      fluidRow(
                        column(6,
                               selectizeInput("xrayGraph_choice", "graph:",
                                              c("releases", "unreleased", "other"),
                                              selected="releases", multiple =FALSE)),
                        column(6,
                               selectizeInput("xrayGraph_units", "units:",
                                              c("tracks", "minutes"),
                                              selected="minutes", multiple =FALSE))

                      ),

                      tags$br(),

                      # Graph

                      h4("Graph"),
                      tags$br(),

                      fluidRow(
                        column(12,
                               plotlyOutput("xray_plot")
                        )
                      ),

                      tags$br(),

                      h4("Data table"),
                      tags$br(),

                      fluidRow(
                        column(12,
                               # Create a new row for the table.
                               DT::dataTableOutput("xraydatatable"))
                      )

                    )

           ),

           # renditions -------------------------------------------------------------------


           tabPanel("renditions",

                    fluidPage(

                      tags$br(),

                      h4("Selection"),
                      tags$br(),

                      # Release and song selection controls

                      fluidRow(
                        column(6,
                               uiOutput("releaseOptions")),
                        column(6,
                               uiOutput("menuOptions")
                        )

                      ),

                      # Graph

                      h4("Graph"),
                      tags$br(),

                      fluidRow(
                        column(12,
                               plotlyOutput("performance_count_plot")
                        )
                      ),

                      tags$br(),

                      h4("Data table"),
                      tags$br(),

                      fluidRow(
                        column(12,
                               DT::dataTableOutput("songsdatatable")
                        )
                      )

                    )

           ),

           # matrix -------------------------------------------------------------


           tabPanel("matrix",

                    fluidPage(

                      # Graph

                      h4("Graph"),
                      tags$br(),

                      fluidRow(
                        column(12,
                               plotlyOutput("transitions_heatmap")
                        )
                      ),

                      tags$br(),

                      h4("Data table"),
                      tags$br(),

                      fluidRow(
                        column(12,
                               DT::dataTableOutput("transitionsdatatable")
                        )
                      )

                    )

           )




# end of 'when' tabset -----------------------------------------------------




           )

         )

),



# releases -------------------------------------------------------------------



                  tabPanel("releases",

                           fluidPage(

                             tags$br(),

                             h4("Selection"),
                             tags$br(),

                             fluidRow(
                               column(6,
                                      selectizeInput("Input_releases", "release:",
                                                     releases_menu_list$release,
                                                     selected=NULL, multiple =TRUE)
                                      ),
                               column(6,
                                      selectizeInput("Input_releases_var", "variable:",
                                                     c("count", "intensity", "rating"),
                                                     selected="rating", multiple =FALSE)
                                      )

                             ),

                             tags$br(),

                             # Graph

                             h4("Graph"),
                             tags$br(),

                             fluidRow(
                               column(12,
                                      plotlyOutput("releases_plot",
                                                   width = "100%",
                                                   height = "700px")
                               )
                             ),

                             tags$br(),

                             h4("Data table"),
                             tags$br(),

                             fluidRow(
                               column(12,
                                      DT::dataTableOutput("releasesdatatable")
                               )
                             )

                           )

                  ),


# transition -------------------------------------------------------------

                  tabPanel("transition",

                           fluidPage(

                             tags$br(),

                             h4("Transition"),
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

                             h4("Data table"),
                             tags$br(),

                             fluidRow(
                               column(12,
                                      DT::dataTableOutput("transitions_shows_datatable")
                               )
                             )

                           )

                  ),





# duration -------------------------------------------------------------

                  tabPanel("duration",

                           fluidPage(

                             tags$br(),

                             h4("Selection"),
                             tags$br(),

                             # Create a new Row in the UI for selectInputs
                             fluidRow(
                               column(12,
                                      selectizeInput("duration_song", "songs:",
                                                     sort(unique((songidlookup$song))),
                                                     selected=NULL, multiple =TRUE))
                             ),


                             tags$br(),

                             h4("Data table"),
                             tags$br(),

                             fluidRow(
                               column(12,
                                      DT::dataTableOutput("duration_shows_datatable")
                               )
                             )

                           )

                  ),

# variation -------------------------------------------------------------------


                  tabPanel("variation",

                           fluidPage(

                             tags$br(),

                             h4("Selection"),
                             tags$br(),

                             fluidRow(
                               column(6,
                                      selectizeInput("variation_releaseInput", "release",
                                                     choices = c(unique(cumulative_duration_counts$release)),
                                                     selected="fugazi", multiple =TRUE)),
                               column(6,
                                      uiOutput("variation_songInput")
                               )

                             ),

                             # Graph

                             h4("Graph"),
                             tags$br(),

                             fluidRow(
                               column(12,
                                      plotlyOutput("variation_count_plot")
                               )
                             ),

                             tags$br(),

                             h4("Data table"),
                             tags$br(),

                             fluidRow(
                               column(12,
                                      DT::dataTableOutput("variationdatatable")
                               )
                             )

                           )

                  ),


# search ------------------------------------------------------------------

                  tabPanel("search",

                           fluidPage(

                             tags$br(),

                             h4("Selection of songs"),
                             tags$br(),

                             # Create a new Row in the UI for selectInputs
                             fluidRow(
                               column(12,
                                      selectizeInput("search_songs", "songs:",
                                                     sort(unique((songidlookup$song))),
                                                     selected=NULL, multiple =TRUE))
                             ),


                             tags$br(),

                             h4("Data table"),
                             tags$br(),

                             fluidRow(
                               column(12,
                                      DT::dataTableOutput("search_shows_datatable")
                               )
                             )

                           )

                  ),

# end -------------------------------------------------------------

      )

      ),

        tags$div(
          tags$br(),
          "Contact the developer on ",
          tags$a(rel="me", href="https://mastodon.online/@alex_mitrani_es", "Mastodon"),
          tags$br()
        )

    )





# server -----------------------------------------------------


server <- function(input, output, session) {

  session$onSessionEnded(stopApp)


# when --------------------------------------------------------------------


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

# shows -------------------------------------------------------------------


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

    menudata <- shows_data

    if (is.null(input$yearInput_shows)==FALSE) {
      menudata <- menudata %>%
        filter(year %in% input$yearInput_shows) %>%
        arrange(city)

    }

    if (is.null(input$tourInput_shows)==FALSE) {
      menudata <- menudata %>%
        filter(tour %in% input$tourInput_shows) %>%
        arrange(city)

    }

    if (is.null(input$countryInput_shows)==FALSE) {
      menudata <- menudata %>%
        filter(country %in% input$countryInput_shows) %>%
        arrange(city)

    }

    selectizeInput("cityInput_shows", "cities:",
                   choices = c(unique(menudata$city)), multiple =TRUE)

  })

  observeEvent(input$visit, {
    date1 <- as.Date(min(shows_data3()$date)-7)
    date2 <- as.Date(max(shows_data3()$date))
    freezeReactiveValue(input, "dateInput_shows")
    updateSliderInput(session,"dateInput_shows", "timeline:", min=date1, max=date2,
                      value=date1-7, timeFormat = "%F")
    freezeReactiveValue(input, "weeks")
    updateNumericInput(session, "weeks", "period (weeks):", 1,
                       min = 1, max = 792)
    freezeReactiveValue(input, "step_days")
    updateNumericInput(session, "step_days", "step (days):", 1,
                       min = 1, max = 5542)
  })

  observeEvent(input$step_b, {
    date1 <- as.Date(min(shows_data3()$date)-7)
    date2 <- as.Date(max(shows_data3()$date))
    date3 <- as.Date(input$dateInput_shows[1] - input$step_days)
    freezeReactiveValue(input, "dateInput_shows")
    updateSliderInput(session,"dateInput_shows", "timeline:", min=date1, max=date2,
                      value=date3, timeFormat = "%F")
  })

  observeEvent(input$step_f, {
    date1 <- as.Date(min(shows_data3()$date)-7)
    date2 <- as.Date(max(shows_data3()$date))
    date3 <- as.Date(input$dateInput_shows[1] + input$step_days)
    freezeReactiveValue(input, "dateInput_shows")
    updateSliderInput(session,"dateInput_shows", "timeline:", min=date1, max=date2,
                      value=date3, timeFormat = "%F")
  })

  observeEvent(input$home, {
    date1 <- as.Date(min(shows_data3()$date))
    freezeReactiveValue(input, "dateInput_shows")
    updateSliderInput(session,"dateInput_shows", "timeline:", min=as.Date("1987-09-03"), max=as.Date("2002-11-04"),
                      value=date1-7, timeFormat = "%F")
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

    mydf <- shows_data %>%
      filter(date >= date1 &
               date <= date2)

    if (is.null(input$yearInput_shows)==FALSE) {
      mydf <- mydf %>%
        filter(year %in% input$yearInput_shows)

    }

    if (is.null(input$tourInput_shows)==FALSE) {
      mydf <- mydf %>%
        filter(tour %in% input$tourInput_shows)

    }

    if (is.null(input$countryInput_shows)==FALSE) {
      mydf <- mydf %>%
        filter(country %in% input$countryInput_shows)

    }

    if (is.null(input$cityInput_shows)==FALSE) {
      mydf <- mydf %>%
        filter(city %in% input$cityInput_shows)

    }

    mydf

  })

  shows_data3 <- reactive({


    if (is.null(input$yearInput_shows)==FALSE) {
      mydf <- shows_data %>%
        filter(year %in% input$yearInput_shows)

    }

    if (is.null(input$tourInput_shows)==FALSE) {
      mydf <- mydf %>%
        filter(tour %in% input$tourInput_shows)

    }

    if (is.null(input$countryInput_shows)==FALSE) {
      mydf <- mydf %>%
        filter(country %in% input$countryInput_shows)

    }

    if (is.null(input$cityInput_shows)==FALSE) {
      mydf <- mydf %>%
        filter(city %in% input$cityInput_shows)

    }

    mydf

  })

  # map

  output$mymap <- renderLeaflet({
    df <- shows_data

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
      addScaleBar()

    m

  })

  observe({

    myx <- nrow(shows_data2())

    df <- shows_data2() %>%
      mutate(daten = as.numeric(date)) %>%
             mutate(mycolour = myx - (daten - max(daten)))


    mypalette <- get_brewer_pal("Reds", contrast=c(0.5, 1.0))

    colorData <- factor(df$mycolour)
    pal <- colorFactor(palette = mypalette, levels = levels(colorData), reverse = FALSE)

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


    leafletProxy("mymap", data = df) %>%
      fitBounds(lng1 = min_longitude, lat1 = min_latitude, lng2 = max_longitude, lat2 = max_latitude) %>%
      clearShapes() %>%
      htmlwidgets::onRender("function(el, x) {
        L.control.zoom({ position: 'bottomleft' }).addTo(this)
      }") %>%
      addCircles(
        data = df,
        radius = sqrt((df$attendance)/pi),
        color = ~pal(colorData),
        fillColor = ~pal(colorData),
        fillOpacity = 0.5,
        popup = paste0(
          "<strong>Date: </strong>", df$date, "<br>",
          "<strong>Venue: </strong>", df$venue, "<br>",
          "<strong>City: </strong>", df$city, "<br>",
          "<strong>Attendance: </strong>", df$attendance, "<br>",
          "<strong>Coordinates: </strong>", paste0(df$latitude, ", ", df$longitude)
        )
      )

  })

  output$showsdatatable <- DT::renderDataTable(DT::datatable({

    data <- shows_data2() %>%
      select(fls_link, date, venue, city, country, attendance, minutes, sound_quality) %>%
      arrange(date)},
    escape = c(-2),
    style = "bootstrap"))

# attendance -------------------------------------------------------------------

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

    if (is.null(input$yearInput_shows)==FALSE) {

      attendancedata <- attendancedata[attendancedata$year %in% input$yearInput_shows,]

    }

    if (is.null(input$tourInput_shows)==FALSE) {

      attendancedata <- attendancedata[attendancedata$tour %in% input$tourInput_shows,]

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


# xray -------------------------------------------------------------------


  xray_data <- reactive({


    if (is.null(input$yearInput_shows)==FALSE) {

      xray_data <- xray %>%
        filter(year %in% input$yearInput_shows)

    } else {

      xray_data <- xray

    }

    if (is.null(input$tourInput_shows)==FALSE) {

      xray_data <- xray_data %>%
        filter(tour %in% input$tourInput_shows)

    } else {

      xray_data <- xray_data

    }

    if(input$xrayGraph_units =="minutes") {

      xray_data <- xray_data %>%
        filter(units=="minutes")

    } else {

      xray_data <- xray_data %>%
        filter(units=="tracks")

    }

    xray_data <- xray_data %>%
      pivot_longer(cols=c(songs, released, unreleased, debut, farewell, incumbent,
                          fugazi, margin_walker, three_songs, repeater, steady_diet_of_nothing,
                          in_on_the_killtaker, red_medicine, end_hits,
                          the_argument, furniture, first_demo, other), names_to="variable", values_to="value") %>%
      left_join(releaseid_variable_colour_code) %>%
      mutate(release = factor(variable, levels=(unique(variable))))

  })

  xray_data2 <- reactive({

    if(input$xrayGraph_choice=="releases") {

      xray_data2 <- xray_data() %>%
        filter(variable!="songs" & variable!="released" & variable!="unreleased" & variable!="debut" & variable!="farewell" & variable!="incumbent" & variable!="other") %>%
        filter(value>0) %>%
        arrange(releaseid)

    } else if(input$xrayGraph_choice=="unreleased") {

      xray_data2 <- xray_data() %>%
        filter(variable=="released" | variable=="unreleased") %>%
        filter(value>0) %>%
        arrange(releaseid)

    } else {

      xray_data2 <- xray_data() %>%
        filter(variable=="songs" | variable=="other") %>%
        filter(value>0) %>%
        arrange(releaseid)

    }

    xray_data2

  })

  output$xray_plot <- renderPlotly({

    colours <- unique(xray_data2()$colour_code)

    xray_plot <- ggplot(xray_data2(), aes(x = date,
                                              y = value,
                                              fill = release)) +
      geom_bar(position="stack", stat="identity") +
      xlab("date") +
      ylab(input$xrayGraph_units) +
      scale_fill_manual(values=colours) +
      scale_y_continuous(expand = expansion(mult = c(0, 0.1)),
                         limits = c(-1, NA),
                         labels = comma) +
      labs(fill='category')

    plotly::ggplotly(xray_plot)

  })

  output$xraydatatable <- DT::renderDataTable(DT::datatable({
    data <- xray_data2()  %>%
      select(-release, -colour_code, -releaseid, -units)  %>%
      pivot_wider(names_from = variable, values_from = value) %>%
      select(-year, -tour) %>%
      arrange(date)

    data$songs <- rowSums(data[sapply(data, is.numeric)], na.rm = TRUE)

    data <- data %>%
      relocate(c(fls_link, date, songs))

    data

  },
  escape = c(-2),
  style = "bootstrap"))

# releases -------------------------------------------------------------------

  releases_data <- reactive({

    if (is.null(input$Input_releases)==FALSE) {
      releases_data <- releases_data_input %>%
        filter(release %in% input$Input_releases) %>%
        arrange(releaseid, track_number)

    } else {

      releases_data <- releases_data_input %>%
        arrange(releaseid, track_number)

    }

    releases_data

  })

  output$releases_plot <- renderPlotly({

    colours <- unique(releases_data()$colour_code)

    if(input$Input_releases_var == "rating") {

        releases_plot <- ggplot(releases_data(), aes(x = song,
                                                   y = rating,
                                                   fill = release)) +
          geom_bar(stat="identity") +
          xlab("track") +
          ylab("rating") +
          scale_fill_manual(values=colours) +
          scale_y_continuous(expand = expansion(mult = c(0, 0.1)),
                             limits = c(0, NA),
                             labels = comma) +
          coord_flip()

    } else if (input$Input_releases_var == "intensity") {

      releases_plot <- ggplot(releases_data(), aes(x = song,
                                                   y = intensity,
                                                   fill = release)) +
        geom_bar(stat="identity") +
        xlab("track") +
        ylab("intensity") +
        scale_fill_manual(values=colours) +
        scale_y_continuous(expand = expansion(mult = c(0, 0.1)),
                           limits = c(0, NA),
                           labels = comma) +
        coord_flip()

    } else {

        releases_plot <- ggplot(releases_data(), aes(x = song,
                                                     y = count,
                                                     fill = release)) +
          geom_bar(stat="identity") +
          xlab("track") +
          ylab("count") +
          scale_fill_manual(values=colours) +
          scale_y_continuous(expand = expansion(mult = c(0, 0.1)),
                             limits = c(0, NA),
                             labels = comma) +
          coord_flip()

      }

      plotly::ggplotly(releases_plot)

  })

  output$releasesdatatable <- DT::renderDataTable(DT::datatable({
    data <- releases_summary %>%
      select(-releaseid)

    data

  },
  style = "bootstrap"))

# renditions -------------------------------------------------------------------

  # no more than one album's worth of shows to be graphed at once
  max_songs <- 13

  output$releaseOptions <- renderUI({

    if (is.null(input$yearInput_shows)==FALSE) {
      menudata <- year_tour_release %>%
        filter(year %in% input$yearInput_shows) %>%
        arrange(release)
    } else {
      menudata <- year_tour_release %>%
        arrange(release)
    }

    if (is.null(input$tourInput_shows)==FALSE) {
      menudata <- menudata %>%
        filter(tour %in% input$tourInput_shows) %>%
        arrange(release)
    } else {
      menudata <- menudata %>%
        arrange(release)
    }

    selectizeInput("releaseInput", "releases",
                   choices = c(unique(menudata$release)), multiple =TRUE)

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

    if (is.null(input$yearInput_shows)==FALSE & is.null(input$tourInput_shows)==FALSE) {
      datedata <- shows_data %>%
        filter(year %in% input$yearInput_shows &
                 tour %in% input$tourInput_shows)

    } else if (is.null(input$yearInput_shows)==FALSE & is.null(input$tourInput_shows)==TRUE) {
      datedata <- shows_data %>%
        filter(year %in% input$yearInput_shows)

    } else if (is.null(input$yearInput_shows)==TRUE & is.null(input$tourInput_shows)==FALSE) {
      datedata <- shows_data %>%
        filter(tour %in% input$tourInput_shows)

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
      group_by(song, releasedate) %>%
      summarize(count = max(count) - min(count),
                from = min(date), to=max(date)) %>%
      ungroup() %>%
      arrange(desc(count)) %>%
      mutate(index = row_number()) %>%
      select(song, index, from, to, releasedate)

    mysongs

  })

  songs_data3 <- reactive({

    mydf <- songs_data() %>%
      left_join(songs_data2()) %>%
      left_join(last_performance_data) %>%
      mutate(to = as.Date(ifelse(last_performance<to, last_performance, to), origin = "1970-01-01")) %>%
      mutate(released = as.Date(releasedate, format = "%d/%m/%Y"))


    mydf

  })

  songs_data4 <- reactive({

    mydf <- songs_data3() %>%
      filter(index<=max_songs)

    mydf

  })

  output$performance_count_plot <- renderPlotly({

    p <- ggplot(songs_data4(), aes(x = date, y = count, color = song)) +
      geom_line() +
      xlab("date") +
      ylab("cumulative renditions")

    plotly::ggplotly(p)

  })


  output$songsdatatable <- DT::renderDataTable(DT::datatable({
    data <- songs_data3() %>%
      group_by(release, song, from, to, released) %>%
      summarize(renditions = max(count) - min(count)) %>%
      ungroup() %>%
      arrange(desc(renditions))
  },
  style = "bootstrap"))


# transition -------------------------------------------------------------

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

    transitions_data_da_results %>%
      arrange(date)

  })


  output$transitions_shows_datatable <- DT::renderDataTable(DT::datatable({

    data <- transitions_shows_data()

    data

  }, escape = c(-2),
  style = "bootstrap"))



# matrix -------------------------------------------------------------


  transitions_data <- reactive({

    if (is.null(input$yearInput_shows)==FALSE & is.null(input$tourInput_shows)==FALSE) {
      datedata <- shows_data %>%
        filter(year %in% input$yearInput_shows &
                 tour %in% input$tourInput_shows)

    } else if (is.null(input$yearInput_shows)==FALSE & is.null(input$tourInput_shows)==TRUE) {
      datedata <- shows_data %>%
        filter(year %in% input$yearInput_shows)

    } else if (is.null(input$yearInput_shows)==TRUE & is.null(input$tourInput_shows)==FALSE) {
      datedata <- shows_data %>%
        filter(tour %in% input$tourInput_shows)

    } else {
      datedata <- shows_data

    }

    date1 <- as.Date(min(datedata$date))
    date2 <- as.Date(max(datedata$date))

    tourdata <- othervariables %>%
      select(gid, tour)

    mydf1 <- Repeatr1 %>%
      filter(tracktype==1) %>%
      left_join(tourdata) %>%
      select(gid,year,date,song_number,song, tour) %>%
      rename(song1 = song)

    mydf2 <- Repeatr1 %>%
      filter(tracktype==1) %>%
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


# duration -------------------------------------------------------------


  duration_shows_data <- reactive({

    if (is.null(input$duration_song)==FALSE) {
      duration_data_da_results <- duration_data_da %>%
        filter(song %in% input$duration_song)

    } else {

      duration_data_da_results <- duration_data_da

    }

    duration_data_da_results

  })


  output$duration_shows_datatable <- DT::renderDataTable(DT::datatable({

    data <- duration_shows_data() %>%
      select(fls_link, date, song_number, song, minutes) %>%
      arrange(date, song_number)

    data

  }, escape = c(-2),
  style = "bootstrap"))

# variation -------------------------------------------------------------------

  output$variation_songInput <- renderUI({

    if (is.null(input$variation_releaseInput)==FALSE) {
      menudata <- cumulative_duration_counts %>%
        filter(release %in% input$variation_releaseInput) %>%
        arrange(song)
    } else {
      menudata <- cumulative_duration_counts %>%
        arrange(song)
    }

    selectizeInput("variation_songInput", "songs",
                   choices = c(unique(menudata$song)), multiple =TRUE)

  })

  variation_data <- reactive({

    if (is.null(input$variation_releaseInput)==FALSE) {

      mydf <- cumulative_duration_counts %>%
        filter(release %in% input$variation_releaseInput)

    } else {

      mydf <- cumulative_duration_counts

    }

    if (is.null(input$variation_songInput)==FALSE) {

      mydf <- mydf %>%
        filter(song %in% input$variation_songInput)

    } else {

      mydf <- mydf

    }

    mydf

  })


  output$variation_count_plot <- renderPlotly({

    p <- ggplot(variation_data(), aes(x = minutes, y = count, color = song)) +
      geom_line() +
      xlab("minutes") +
      ylab("cumulative renditions")

    plotly::ggplotly(p)

  })

  output$variationdatatable <- DT::renderDataTable(DT::datatable({
    data <- variation_data() %>%
      group_by(song) %>%
      summarize(renditions = max(count)) %>%
      ungroup() %>%
      arrange(desc(renditions)) %>%
      left_join(duration_summary)
  },
  style = "bootstrap"))


# search ------------------------------------------------------------------


  search_shows_data <- reactive({

    if (is.null(input$search_songs)==FALSE) {

      mysearch <- input$search_songs
      mysearch <- as.data.frame(mysearch)
      names(mysearch)[1]<-"song"
      mysearch <- mysearch %>% mutate(hits = 1)
      successcriteria <- nrow(mysearch)

      search_data_da_results <- duration_data_da %>%
        left_join(mysearch) %>%
        left_join(gid_sound_quality)

      search_data_results <- search_data_da_results %>%
        group_by(fls_link, date, sound_quality) %>%
        summarize(hits = sum(hits, na.rm = TRUE)) %>%
        arrange(desc(hits), date) %>%
        ungroup() %>%
        filter(hits==successcriteria)

    } else {

      search_data_results <- duration_data_da %>%
        left_join(gid_sound_quality) %>%
        group_by(fls_link, date, sound_quality) %>%
        summarize(hits = n()) %>%
        arrange(date) %>%
        ungroup()

    }

    search_data_results

  })


  output$search_shows_datatable <- DT::renderDataTable(DT::datatable({

    data <- search_shows_data() %>%
      select(fls_link, date, hits, sound_quality)

    data

  }, escape = c(-2),
  style = "bootstrap"))



# end of server -----------------------------------------------------------


}


# shinyapp ----------------------------------------------------------------



shinyApp(ui = ui, server = server)




#

