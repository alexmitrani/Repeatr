
library(shiny)
library(Repeatr)


# Define UI for app that draws a histogram ----
ui <- fluidPage(

  # App title ----
  titlePanel("Fugazi Live Series data"),



    # Main panel for displaying outputs ----
    mainPanel(

      # Output: Tabset w/ plot, summary, and table ----
      tabsetPanel(type = "tabs",

                  tabPanel("Songs",

                           tableOutput("songsdatatable")

                          ),

                  tabPanel("Transitions",

                           tableOutput("transitionsdatatable")

                           ),

                  tabPanel("Tours",

                           tableOutput("toursdatatable")

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

# Define server logic required to draw a histogram ----
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
    mutate(lead = releasedate - launchdate) %>%
    arrange(launchdate)

  mysummary$launchdate <- format(mysummary$launchdate,'%d-%m-%Y')
  mysummary$releasedate <- format(mysummary$releasedate,'%d-%m-%Y')

  output$songsdatatable <- renderTable(mysummary)

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
    arrange(desc(count)) %>%
    filter(count>=5)

  output$transitionsdatatable <- renderTable(transitions)

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

  toursdata$start <- format(toursdata$start,'%d-%m-%Y')
  toursdata$end <- format(toursdata$end,'%d-%m-%Y')

  output$toursdatatable <- renderTable(toursdata)

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

