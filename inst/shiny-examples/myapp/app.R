
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

