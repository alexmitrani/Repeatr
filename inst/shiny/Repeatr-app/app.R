
# devtools::install_github("alexmitrani/Repeatr")

library(shiny)
library(Repeatr)
library(DT)
library(lubridate)


# Define UI for app  ----
ui <- fluidPage(

  # App title ----
  titlePanel("Repeatr"),

    # Main panel for displaying outputs ----
    mainPanel(

      # Output
      tabsetPanel(type = "tabs",

                  tabPanel("Counts",

                           fluidPage(
                             titlePanel("Song Performance Counts"),


                             # Release and song selection controls

                             fluidRow(
                               column(12,
                                      selectizeInput("releaseInput", "Release",
                                                     choices = c("All", unique(cumulative_song_counts$release)),
                                                     selected="Repeater", multiple =FALSE),
                                      uiOutput("menuOptions"))


                             ),

                             # Graph

                             fluidRow(
                               column(12,
                                        plotOutput("performance_count_plot")
                                      )
                               ),

                             # Slider control

                            fluidRow(
                               column(12,
                                      sliderInput("dateInput", "Date", min=as.Date("1987-09-03"), max=as.Date("2002-11-04"),
                                                  value=c(as.Date("1987-09-03"), as.Date("2002-11-04")), timeFormat = "%F"))
                             )

                          )

                  ),

                  tabPanel("Songs",

                           fluidPage(
                             titlePanel("Songs Data"),

                             # Create a new Row in the UI for selectInputs
                             fluidRow(
                               column(4,
                                      selectInput("launchyear",
                                                  "Launch year:",
                                                  c("All",
                                                    sort(unique(as.integer(summary$launchyear)))))
                               ),
                               column(4,
                                      selectInput("releaseyear",
                                                  "Release year:",
                                                  c("All",
                                                    sort(unique(as.integer(summary$releaseyear)))))
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
                             titlePanel("Venues Data"),

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
                             titlePanel("Shows Data"),

                             # Create a new Row in the UI for selectInputs
                             fluidRow(
                               column(4,
                                      selectInput("year",
                                                  "year:",
                                                  c("All",
                                                    sort(unique((attendancedata$year)))))
                               )

                             ),

                             # Create a new row for the table.
                             DT::dataTableOutput("attendancedatatable")

                           )

                          )

      )

    )

    )



# Define server logic
server <- function(input, output) {

  d <- reactive({

    if (input$releaseInput != "All" & is.null(input$songInput)==FALSE) {
      filtered <- cumulative_song_counts %>%
        filter(date >= input$dateInput[1],
               date <= input$dateInput[2],
               release == input$releaseInput,
               song %in% input$songInput)
    } else if (input$releaseInput != "All" & is.null(input$songInput)==TRUE) {
      filtered <- cumulative_song_counts %>%
        filter(date >= input$dateInput[1],
               date <= input$dateInput[2],
               release == input$releaseInput)
    } else if (input$releaseInput == "All" & is.null(input$songInput)==FALSE) {
      filtered <- cumulative_song_counts %>%
        filter(date >= input$dateInput[1],
               date <= input$dateInput[2],
               song %in% input$songInput)
    } else if (input$releaseInput == "All" & is.null(input$songInput)==TRUE) {
      filtered <- cumulative_song_counts %>%
        filter(date >= input$dateInput[1],
               date <= input$dateInput[2])
    }

  })


  # Dynamic UI

  output$menuOptions <- renderUI({

    if (input$releaseInput != "All") {

      menudata <- cumulative_song_counts %>%
        filter(release == input$releaseInput)

    } else {

      menudata <- cumulative_song_counts

    }


    selectizeInput("songInput", "Songs",
                   choices = c(unique(menudata$song)),
                   selected=NULL, multiple =TRUE)

  })

  # Generate a table of songs data

  output$songsdatatable <- DT::renderDataTable(DT::datatable({
    data <- summary
    if (input$launchyear != "All") {
      data <- data[data$launchyear == input$launchyear,]
    }
    if (input$releaseyear != "All") {
      data <- data[data$releaseyear == input$releaseyear,]
    }
    data
  }))

  # Generate a table of transitions data

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

  # Generate a table of venues data

  output$venuesdatatable <- DT::renderDataTable(DT::datatable({
    data <- venuesdata
    if (input$country != "All") {
      data <- data[data$country == input$country,]
    }
    if (input$city != "All") {
      data <- data[data$city == input$city,]
    }
    data
  }))

  # Generate a table with the attendance of each show

  output$attendancedatatable <- DT::renderDataTable(DT::datatable({
    data <- attendancedata
    if (input$year != "All") {
      data <- data[data$year == input$year,]
    }
    data
  }))

  output$performance_count_plot <- renderPlot({

    ggplot(d(), aes(date, count, color = song)) +
      geom_line() +
      theme_bw() +
      xlab("Date") +
      ylab("Performances") +
      ggtitle("Cumulative number of performances over time")
  })

}


shinyApp(ui = ui, server = server)


#

