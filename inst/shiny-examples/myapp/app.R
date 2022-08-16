
library(shiny)
library(Repeatr)



# Define UI for app that draws a histogram ----
ui <- fluidPage(

  # App title ----
  titlePanel("Fugazi Live Series show attendance data"),

  # Sidebar layout with input and output definitions ----
  sidebarLayout(

    # Sidebar panel for inputs ----
    sidebarPanel(

      # Input: Slider for the number of bins ----
      sliderInput(inputId = "bins",
                  label = "Number of bins:",
                  min = 1,
                  max = 50,
                  value = 30),

      # Input: Slider for maximum ----
      sliderInput(inputId = "mymax",
                  label = "Censor attendance at:",
                  min = 1,
                  max = 15000,
                  value = 15000)

    ),

    # Main panel for displaying outputs ----
    mainPanel(

      # Output: Tabset w/ plot, summary, and table ----
      tabsetPanel(type = "tabs",
                  tabPanel("Plot", plotOutput(outputId = "distPlot")),
                  tabPanel("Summary", verbatimTextOutput("summary")),
                  tabPanel("Table", tableOutput("table"))
      )

    )
  )
)

# Define server logic required to draw a histogram ----
server <- function(input, output) {

  x <- reactive({
    test <- Repeatr0
    test <- test %>% mutate(attendancedata = nchar(V6))
    test <- test %>% filter(attendancedata>0)
    test <- test %>% mutate(attendance = as.numeric(V6))
    test <- test %>% filter(is.na(attendance)==FALSE)
    test <- test %>% filter(attendance<=input$mymax)
    test <- test %>% select(attendance)
    test <- as.numeric(test$attendance)

  })


  output$distPlot <- renderPlot({

    # What is the total number of people that Fugazi performed for in the shows that are available in the Fugazi Live Series data?
    bins <- seq(min(x()), max(x()), length.out = input$bins + 1)
    hist(x(), breaks = bins, col = "#75AADB", border = "white",
         xlab = "Attendance (people)",
         main = "Histogram of attendance at Fugazi shows")

  })

  # Generate a summary of the data ----
  output$summary <- renderPrint({
    summary(x())
  })

  # Generate an HTML table view of the data ----
  output$table <- renderTable({
    x()
  })

}


shinyApp(ui = ui, server = server)


#

