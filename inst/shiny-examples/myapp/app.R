
library(shiny)
library(Repeatr)
library(DT)
library(lubridate)


# Define UI for app that draws a histogram ----
ui <- fluidPage(

  # App title ----
  titlePanel("Fugazi Live Series data"),

    # Main panel for displaying outputs ----
    mainPanel(

      # Output: Tabset w/ plot, summary, and table ----
      tabsetPanel(type = "tabs",

                  tabPanel("Songs",

                           fluidPage(
                             titlePanel("Songs Data"),

                             # Create a new Row in the UI for selectInputs
                             fluidRow(
                               column(4,
                                      selectInput("launchyear",
                                                  "Launch year:",
                                                  c("All",
                                                    sort(unique(as.integer(mysummary$launchyear)))))
                               ),
                               column(4,
                                      selectInput("releaseyear",
                                                  "Release year:",
                                                  c("All",
                                                    sort(unique(as.integer(mysummary$releaseyear)))))
                               )
                             ),
                             # Create a new row for the table.
                             DT::dataTableOutput("songsdatatable")

                           )

                          ),

                  tabPanel("Transitions",

                             fluidPage(
                               titlePanel("Transitions Data"),

                               # Create a new Row in the UI for selectInputs
                               fluidRow(
                                 column(4,
                                        selectInput("from",
                                                    "From:",
                                                    c("All",
                                                      sort(unique((transitions$from)))))
                                 ),
                                 column(4,
                                        selectInput("to",
                                                    "To:",
                                                    c("All",
                                                      sort(unique(transitions$to))))
                                  )

                                ),

                             # Create a new row for the table.
                             DT::dataTableOutput("transitionsdatatable")

                          )

                  ),

                  tabPanel("Tours",

                           fluidPage(
                             titlePanel("Tours Data"),

                             # Create a new Row in the UI for selectInputs
                             fluidRow(
                               column(4,
                                      selectInput("startyear",
                                                  "From year:",
                                                  c("All",
                                                    sort(unique((toursdata$startyear)))))
                               ),
                               column(4,
                                      selectInput("endyear",
                                                  "To year:",
                                                  c("All",
                                                    sort(unique(toursdata$endyear))))
                               )

                             ),

                             # Create a new row for the table.
                             DT::dataTableOutput("toursdatatable")

                           )

                          ),

                  tabPanel("Shows",

                           tableOutput("attendancedatatable")

                          ),

                  tabPanel("Raw data",

                           tableOutput("rawdatatable")

                           )

      )

    )

  )


# Define server logic
server <- function(input, output) {

  # Generate a table of songs data

  releasedates <- releasesdatalookup %>%
    select(releaseid, releasedate) %>%
    mutate(releasedate = as.Date(releasedate, "%d/%m/%Y"))

  mydf <- songvarslookup %>%
    left_join(releasedates) %>%
    left_join(songidlookup)

  mydf <- mydf %>%
    select(songid, song, releaseid, releasedate) %>%
    arrange(songid)

  mysummary <- Repeatr::summary %>%
    left_join(mydf) %>%
    mutate(launchdate = as.Date(launchdate, "%d/%m/%Y")) %>%
    mutate(lead = releasedate - launchdate) %>%
    arrange(launchdate)

  mysummary$launchyear <- lubridate::year(mysummary$launchdate)
  mysummary$releaseyear <- lubridate::year(mysummary$releasedate)

  mysummary$songid <- as.integer(mysummary$songid)
  mysummary$chosen <- as.integer(mysummary$chosen)
  mysummary$available_rl <- as.integer(mysummary$available_rl)
  mysummary$releaseid <- as.integer(mysummary$releaseid)
  mysummary$lead <- as.integer(mysummary$lead)

  output$songsdatatable <- DT::renderDataTable(DT::datatable({
    data <- mysummary
    if (input$launchyear != "All") {
      data <- data[data$launchyear == input$launchyear,]
    }
    if (input$releaseyear != "All") {
      data <- data[data$releaseyear == input$releaseyear,]
    }
    data
  }))

  # Generate a table of transitions data

  mydf1 <- Repeatr1 %>%
    select(gid,song_number,song) %>%
    rename(song1 = song)

  mydf2 <- Repeatr1 %>%
    select(gid,song_number,song) %>%
    mutate(song_number = song_number-1) %>%
    rename(song2 = song)

  mydf3 <- mydf1 %>%
    left_join(mydf2) %>%
    filter(is.na(song2)==FALSE) %>%
    rename(transition_number = song_number)

  checknumberofshows <- Repeatr1 %>%
    group_by(gid) %>%
    summarise(songs = n()) %>%
    ungroup()

  numberofshows <- nrow(checknumberofshows)

  numberofsongs <- sum(checknumberofshows$songs)

  numberoftransitions <- numberofsongs - numberofshows

  transitions <- mydf3 %>%
    select(song1, song2) %>%
    rename(from = song1) %>%
    rename(to = song2)

  transitions <- transitions %>%
    group_by(from, to) %>%
    summarize(count = n()) %>%
    ungroup()


  transitions <- transitions %>%
    arrange(desc(count))

  output$transitionsdatatable <- DT::renderDataTable(DT::datatable({
    data <- transitions
    if (input$from != "All") {
      data <- data[data$from == input$from,]
    }
    if (input$to != "All") {
      data <- data[data$to == input$to,]
    }
    data
  }))

  # Generate a table of tours data

  medianattendance <- othervariables %>%
    filter(is.na(attendance)==FALSE) %>%
    group_by(tour) %>%
    summarise(medianattendance = median(attendance)) %>%
    ungroup()

  toursdata <- othervariables %>%
    left_join(medianattendance) %>%
    mutate(attendance = ifelse(is.na(attendance)==TRUE,medianattendance,attendance)) %>%
    group_by(tour) %>%
    summarise(start = min(date), end = max(date), shows = n(), durationdays = as.numeric((end - start)), attendance=sum(attendance)) %>%
    ungroup() %>%
    arrange(desc(shows)) %>%
    filter(is.na(tour)==FALSE)

  toursdata <- toursdata %>%
    mutate(meanattendance = as.integer(attendance / shows)) %>%
    arrange(start)

  toursdata <- toursdata %>%
    mutate(start = as.Date(start, "%d-%m-%Y")) %>%
    mutate(end = as.Date(end, "%d-%m-%Y"))

  toursdata$startyear <- lubridate::year(toursdata$start)
  toursdata$endyear <- lubridate::year(toursdata$end)

  toursdata$durationdays <- as.integer(toursdata$durationdays)
  toursdata$attendance <- as.integer(toursdata$attendance)

  output$toursdatatable <- DT::renderDataTable(DT::datatable({
    data <- toursdata
    if (input$startyear != "All") {
      data <- data[data$startyear == input$startyear,]
    }
    if (input$endyear != "All") {
      data <- data[data$endyear == input$endyear,]
    }
    data
  }))

  # Generate a table with the attendance of each show

  attendancedata <- othervariables %>%
    filter(is.na(attendance)==FALSE) %>%
    mutate(attendance = as.integer(attendance)) %>%
    select(date, venue, attendance) %>%
    arrange(-attendance)

  attendancedata$date <- format(attendancedata$date,'%d-%m-%Y')

  output$attendancedatatable <- renderTable(attendancedata)

  # Generate a table of the raw data ----

  output$rawdatatable <- renderTable(Repeatr0)

}


shinyApp(ui = ui, server = server)


#

