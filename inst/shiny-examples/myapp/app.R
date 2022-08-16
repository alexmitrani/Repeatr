
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
                  label = "maximum attendance:",
                  min = 1,
                  max = 15000,
                  value = 15000)

    ),

    # Main panel for displaying outputs ----
    mainPanel(

      # Output: Histogram ----
      plotOutput(outputId = "distPlot")

    )
  )
)

# Define server logic required to draw a histogram ----
server <- function(input, output) {

  # Histogram of the Old Faithful Geyser Data ----
  # with requested number of bins
  # This expression that generates a histogram is wrapped in a call
  # to renderPlot to indicate that:
  #
  # 1. It is "reactive" and therefore should be automatically
  #    re-executed when inputs (input$bins) change
  # 2. Its output type is a plot
  output$distPlot <- renderPlot({

    # What is the total number of people that Fugazi performed for in the shows that are available in the Fugazi Live Series data?
    test <- Repeatr0
    test <- test %>% mutate(attendancedata = nchar(V6))
    test <- test %>% filter(attendancedata>0)
    test <- test %>% mutate(attendance = as.numeric(V6))
    test <- test %>% filter(is.na(attendance)==FALSE)
    test <- test %>% filter(attendance<=input$mymax)
    test <- test %>% select(attendance)

    x    <- test$attendance
    bins <- seq(min(x), max(x), length.out = input$bins + 1)

    hist(x, breaks = bins, col = "#75AADB", border = "white",
         xlab = "Attendance (people)",
         main = "Histogram of attendance at Fugazi shows")

  })

}


shinyApp(ui = ui, server = server)


#

