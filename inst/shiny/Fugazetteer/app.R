
# devtools::install_github("alexmitrani/Repeatr", build_opts = c("--no-resave-data", "--no-manual"))

library(Repeatr)

# theme -------------------------------------------------------------------

my_theme <- bs_theme(bootswatch = "darkly",
                     base_font = font_google("Inconsolata"),
                     version = 5)

thematic_shiny(font = "auto")

# pre-processing ----------------------------------------------------------

timestamptext <- paste0("Made with Repeatr version ", packageVersion("Repeatr"), ", updated ", packageDate("Repeatr"), ".")

sourcestext = c(timestamptext, "https://alexmitrani.shinyapps.io/Fugazetteer/","https://dischord.com/fugazi_live_series")

datestring <- datestampr()

year_tour_release <- Repeatr1 %>%
  select(year, gid, release) %>%
  group_by(year, gid, release) %>%
  filter(is.na(release)==FALSE) %>%
  summarize(count = n()) %>%
  ungroup() %>%
  left_join(othervariables) %>%
  select(year, gid, release, tour, count)

fls_link_year_tour <- shows_data %>%
  select(fls_link, year, tour)

transitions_data_da <- transitions_data_da %>%
  left_join(fls_link_year_tour)

song_release <- summary %>%
  select(song, release)

duration_data_da <- duration_data_da %>%
  left_join(song_release)

othervariables <- othervariables %>%
  left_join(gid_sound_quality) %>%
  mutate(urls = paste0("https://www.dischord.com/fugazi_live_series/", gid)) %>%
  mutate(fls_link = paste0("<a href='",  urls, "' target='_blank'>", gid, "</a>"))

played_with <- played_with %>%
  select(gid, played_with)

played_with <- othervariables %>%
  left_join(played_with)

played_with <- played_with %>%
  rename(latitude = y, longitude = x) %>%
  mutate(attendance = round(attendance, 0))

played_with <- played_with %>%
  select(fls_link, gid, year, tour, date, venue, city, country, played_with, attendance, sound_quality, latitude, longitude)

year_tour_gid_song <- duration_data_da %>%
  left_join(othervariables) %>%
  select(year, tour, gid, song)

quizdata <- gsheet2tbl('https://docs.google.com/spreadsheets/d/1-QGRAxeGRNBnx2ao7FXUjcK77uTfZ-_XnN3M7mqqjMc')

# number of players to include in the highscores table
max_players <- nrow(quizdata)/2

colnames(quizdata)[47]="name"

quizdata <- quizdata %>%
  mutate(points = as.numeric(substring(Score, 1, regexpr("/", Score)-2)))

quizdata <- quizdata %>%
  mutate(total = as.numeric(substring(Score, regexpr("/", Score)+2)))

quizdata <- quizdata %>%
  mutate(score = round(100*round(points/total, 3),1)) %>%
  arrange(desc(points))

quizdata <- quizdata %>%
  mutate(name = ifelse(is.na(name)==FALSE, name, "Anon.")) %>%
  mutate(include = ifelse(row_number()<=max_players, 1, 0)) %>%
  filter(include == 1)

quizdata <- quizdata %>%
  rename(timestamp = Timestamp, percentage = score) %>%
  select(name, timestamp, points, total, percentage)

discography <- Repeatr::summary %>%
  select(song, release)

song_duration_seconds <- Repeatr::songvarslookup %>%
  select(song, duration_seconds)

releases_data_input <- Repeatr::releases_data_input %>%
  left_join(song_tempo_bpm_data) %>%
  left_join(song_duration_seconds) %>%
  arrange(desc(releaseid), desc(track_number)) %>%
  mutate(minutes = round(duration_seconds/60, 3)) %>%
  mutate(song = factor(song, levels=unique(song)))

release_tempo_bpm_minutes <- releases_data_input %>%
  mutate(tempo_bpm_minutes = tempo_bpm*minutes) %>%
  group_by(release) %>%
  summarise(tempo_bpm_minutes = sum(tempo_bpm_minutes),
            minutes = sum(minutes)) %>%
  ungroup() %>%
  mutate(tempo_bpm = round(tempo_bpm_minutes/minutes, 3)) %>%
  mutate(release = as.character(release)) %>%
  mutate(minutes = round(minutes, 3)) %>%
  select(release, tempo_bpm, minutes)

discography_tempo_bpm <- release_tempo_bpm_minutes %>%
  mutate(tempo_bpm_minutes = tempo_bpm*minutes) %>%
  group_by() %>%
  summarise(tempo_bpm_minutes = sum(tempo_bpm_minutes), minutes = sum(minutes)) %>%
  ungroup() %>%
  mutate(tempo_bpm = round(tempo_bpm_minutes/minutes, 3)) %>%
  select(tempo_bpm)

releases_summary <- Repeatr::releases_summary %>%
  left_join(release_tempo_bpm_minutes)

gid_tempo_bpm_minutes <- duration_data_da %>%
  left_join(song_tempo_bpm_data) %>%
  mutate(tempo_bpm_minutes = tempo_bpm*minutes) %>%
  filter(is.na(minutes)==FALSE) %>%
  group_by(gid) %>%
  summarise(tempo_bpm_minutes = sum(tempo_bpm_minutes),
            minutes = sum(minutes)) %>%
  ungroup() %>%
  mutate(tempo_bpm = round(tempo_bpm_minutes/minutes, 3)) %>%
  select(gid, tempo_bpm, minutes)

shows_tempo_bpm <- gid_tempo_bpm_minutes %>%
  mutate(tempo_bpm_minutes = tempo_bpm*minutes) %>%
  group_by() %>%
  summarise(tempo_bpm_minutes = sum(tempo_bpm_minutes), minutes = sum(minutes)) %>%
  ungroup() %>%
  mutate(tempo_bpm = round(tempo_bpm_minutes/minutes, 3)) %>%
  select(tempo_bpm)

gid_tempo_bpm <- gid_tempo_bpm_minutes %>%
  select(gid, tempo_bpm)

shows_data <- Repeatr::shows_data %>%
  left_join(gid_tempo_bpm)

played_with_flat <- played_with %>%
  group_by(gid) %>%
  summarise(played_with = str_flatten(played_with, ", "))

today_data <- shows_data %>%
  left_join(fls_tags_show) %>%
  left_join(played_with_flat) %>%
  mutate(where_played = ifelse(is.na(album)==FALSE, substring(album, 10),
                               paste0(venue, ", ", city,", ", country))) %>%
  select(date, where_played, gid, fls_link, played_with, attendance, minutes, sound_quality)

# user interface ----------------------------------------------------------

ui <- fluidPage(

  theme = my_theme,

  tags$head(includeHTML(("google-analytics.html"))),

  tags$style(type = "text/css", "html, body {width:100%; height:100%}"),

  h1("Fugazetteer"),

    tags$div(
      "Exploring the ",
      tags$a(href="https://www.dischord.com/fugazi_live_series", "Fugazi Live Series"),
      tags$br()
    ),


    mainPanel(

      tags$div(
        print(timestamptext),
        tags$br(),
        tags$a(href="https://alexmitrani.github.io/Repeatr/articles/Fugazetteer.html", "Fugazetteer documentation"),
        tags$br(),
        tags$br(),
      ),

      # flow and stock

      tabsetPanel(type = "tabs",


# start and end of 'today' tabset -------------------------------------------------------------------

tabPanel("today",

         # today -------------------------------------------------------------------

         tabPanel("today",


                  fluidPage(

                    tags$br(),

                    tags$div(

                      "Anytime but now",
                      tags$br(),
                      "Anywhere but here",
                      tags$br(),
                      tags$a(href="https://fugazi.bandcamp.com/track/burning-too", "- Burning Too by Fugazi"),
                      tags$br()
                    ),

                    tags$br(),

                    tags$script('
                      $(document).ready(function(){
                      var d = new Date();
                      var target = $("#clientTime");
                      target.val(d.toLocaleString());
                      target.trigger("change");
                      });
                      '),
                    textInput("clientTime", "Today's date (DD/MM/YYYY, HH:MM:SS)", value = ""),

                    tags$br(),

                    fluidRow(

                      textOutput("today")

                    ),


                    fluidRow(

                      textOutput("today_number_shows")

                    ),

                    tags$br(),

                    hr(),

                    conditionalPanel(
                      condition = "output.today_number_shows!='Fugazi played no shows on this day in history.'",

                      fluidRow(

                        tags$br(),

                        column(12,

                               # Create a new row for the table.
                               DT::dataTableOutput("todaydatatable")

                        )

                      ),

                      fluidRow(
                        column(12, style = "margin-top: 29px;", downloadButton("downloadTodayData", ""))
                      ),

                    ),

                  )

         )


),

# start of 'flow' tabset -------------------------------------------------------------------

tabPanel("flow",


         fluidPage(

           tags$br(),

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


                      fluidRow(

                        column(5, uiOutput("menuOptions_countries")),
                        column(5, uiOutput("menuOptions_cities")),
                        column(2, style = "margin-top: 29px;", downloadButton("downloadShowsData", ""))

                      ),

                      hr(),

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

                        conditionalPanel(
                          condition = "input.shows_p_s==1",

                          fluidRow(

                            column(5,
                                   numericInput("weeks", "period_weeks:", 792,
                                                min = 1, max = 792)),

                            column(5,
                                   numericInput("step_days", "step_days:", 1,
                                                min = 1, max = 365)),

                            column(2, checkboxInput("shows_p_s", "show",
                                                    value = FALSE))

                          )

                        ),


                        fluidRow(

                          column(12,

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

                        )

                      ),

                      hr(),
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

           # with -------------------------------------------------------------------

           tabPanel("with",


                    fluidPage(

                      tags$br(),


                      fluidRow(
                        column(5,
                               selectizeInput("with_choice", "show:",
                                              c("summary", "map"),
                                              selected="map", multiple = FALSE)),
                        column(5, uiOutput("menuOptions_bands")),
                        column(2, style = "margin-top: 29px;", downloadButton("downloadWithData", ""))

                      ),

                      hr(),

                      tags$br(),

                      conditionalPanel(
                        condition = "input.with_choice=='summary'",

                        fluidRow(

                          column(12,

                                 uiOutput("played_with_plot_ui", width = "100%")

                          )

                        )

                      ),

                      conditionalPanel(
                        condition = "input.with_choice=='map'",

                        fluidRow(

                          column(12,

                                 leafletOutput("played_with_map"),
                                 plotOutput("played_with_markers", height = "1px")

                          )

                        )

                      ),


                      tags$br(),


                      hr(),
                      tags$br(),


                      fluidRow(

                        tags$br(),

                        column(12,

                               # Create a new row for the table.
                               DT::dataTableOutput("played_with_datatable")

                        )

                      )

                    )

           ),


           # attendance -------------------------------------------------------------------


           tabPanel("attendance",

                    fluidPage(

                      tags$br(),

                      fluidRow(
                        column(10,
                               selectizeInput("AttendanceGraph_choice", "show:",
                                              c("summary", "details"),
                                              selected="summary", multiple =FALSE)),
                        column(2, style = "margin-top: 29px;", downloadButton("downloadAttendanceData", ""))

                      ),

                      hr(),

                      # Graph

                      tags$br(),

                      fluidRow(
                        column(12,
                               plotlyOutput("attendance_count_plot")
                        )
                      ),

                      hr(),
                      tags$br(),

                      # Create a new row for the table.
                      DT::dataTableOutput("toursdatatable")

                    )

           ),


           # xray -------------------------------------------------------------------


           tabPanel("xray",

                    fluidPage(

                      tags$br(),

                      fluidRow(
                        column(5,
                               selectizeInput("xrayGraph_choice", "graph:",
                                              c("releases", "unreleased", "other"),
                                              selected="releases", multiple =FALSE)),
                        column(5,
                               selectizeInput("xrayGraph_units", "units:",
                                              c("tracks", "minutes"),
                                              selected="minutes", multiple =FALSE)),
                        column(2, style = "margin-top: 29px;", downloadButton("downloadXrayData", ""))

                      ),

                      hr(),

                      # Graph

                      fluidRow(
                        column(12,
                               plotlyOutput("xray_plot")
                        )
                      ),

                      hr(),
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

                      # Release and song selection controls

                      fluidRow(
                        column(5,
                               uiOutput("releaseOptions")),
                        column(5,
                               uiOutput("menuOptions")),
                        column(2, style = "margin-top: 29px;", downloadButton("downloadRenditionsData", ""))

                      ),

                      hr(),

                      # Graph

                      fluidRow(
                        column(12,
                               plotlyOutput("performance_count_plot")
                        )
                      ),

                      # max songs control

                      fluidRow(
                        column(12,
                               sliderInput("max_songs_renditions", "max_songs:",
                                           min = 1, max = 100,
                                           value = 10, width = "100%")
                        )
                      ),

                      hr(),
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

                      tags$br(),



                      fluidRow(
                        column(12,
                               div(style="width:100%;height:0;padding-top:100%;position:relative;",
                                   div(style="position: absolute;
                                              top: 0;
                                              left: 0;
                                              width: 100%;
                                              height: 100%;",
                                       plotlyOutput("transitions_heatmap",height="100%")))
                        )
                      ),

                      tags$br(),

                      # max transitions control

                      fluidRow(
                        column(10,
                               sliderInput("max_transitions", "max_transitions:",
                                           min = 10, max = 100,
                                           value = 40, width = "100%")
                        ),
                        column(2, style = "margin-top: 29px;", downloadButton("downloadMatrixData", ""))
                      ),

                      hr(),
                      tags$br(),

                      fluidRow(
                        column(12,
                               DT::dataTableOutput("transitionsdatatable")
                        )
                      )

                    )

           ),

           # transition -------------------------------------------------------------

           tabPanel("transition",

                    fluidPage(

                      tags$br(),

                      # Create a new Row in the UI for selectInputs
                      fluidRow(
                        column(5, uiOutput("menuOptions_searchfrom")),
                        column(5, uiOutput("menuOptions_search")),
                        column(2, style = "margin-top: 29px;", downloadButton("downloadTransitionsData", ""))
                      ),

                      hr(),
                      tags$br(),

                      fluidRow(
                        column(12,
                               DT::dataTableOutput("transitions_shows_datatable")
                        )
                      )

                    )

           ),

           # sets -------------------------------------------------------------

           tabPanel("sets",

                    fluidPage(

                      tags$br(),

                      # Create a new Row in the UI for selectInputs
                      fluidRow(
                        column(10, uiOutput("menuOptions_gid")),
                        # Button
                        column(2, style = "margin-top: 29px;", downloadButton("downloadSetsData", ""))
                      ),

                      conditionalPanel(
                        condition = "input.search_shows!=''",

                        hr(),
                        tags$br(),
                        h3("Summary"),
                        tags$br(),

                        tags$div(
                          textOutput("number_shows", inline = TRUE), " ", textOutput("showorshows", inline = TRUE), " with a total of ",
                          textOutput("number_unique_songs", inline = TRUE), " unique songs."
                        ),

                        tags$br(),

                        fluidRow(
                          column(12,
                                 DT::dataTableOutput("sets_shows_datatable")
                          )
                        ),

                        hr(),
                        tags$br(),
                        h3("Details"),
                        tags$br(),


                        fluidRow(
                          column(12,
                                 DT::dataTableOutput("sets_songs_datatable")
                          )
                        )

                      )

                    )

           ),

           # stacks -------------------------------------------------------------

           tabPanel("stacks",

                    fluidPage(

                      tags$br(),

                      # Create a new Row in the UI for selectInputs
                      fluidRow(
                        column(4, uiOutput("menuOptions_gid_stacks")),
                        column(4, uiOutput("menuOptions_gid_stacks2")),
                        # Button
                        column(2, style = "margin-top: 29px;", downloadButton("downloadStacksData", ""))
                      ),

                      conditionalPanel(
                        condition = "input.search_shows_stacks2!=''",

                        hr(),
                        tags$br(),
                        h3("Summary"),
                        tags$br(),

                        tags$div(
                          textOutput("number_shows_stacks", inline = TRUE), " ", textOutput("showorshows_stacks", inline = TRUE), " with a total of ", textOutput("number_unique_songs_stacks", inline = TRUE), " unique songs."
                        ),

                        tags$br(),

                        fluidRow(
                          column(12,
                                 DT::dataTableOutput("stacks_shows_datatable")
                          )
                        ),

                        hr(),
                        tags$br(),
                        h3("Details"),
                        tags$br(),

                        fluidRow(
                          column(12,
                                 DT::dataTableOutput("stacks_songs_datatable")
                          )
                        )


                      )

                    )

           )



# end of 'flow' tabset -----------------------------------------------------




           )

         )

),

# start of 'stock' tabset -------------------------------------------------------------------

tabPanel("stock",


         fluidPage(

           tags$br(),

           fluidRow(

             column(12,
                    selectizeInput("Input_releases", "releases:",
                                   releases_menu_list$release,
                                   selected=NULL, multiple =TRUE)
             )

           ),

           tabsetPanel(type = "tabs",




# discography -------------------------------------------------------------------



                  tabPanel("discography",

                           fluidPage(

                             tags$br(),


                             fluidRow(

                               column(5,
                                      selectizeInput("Input_releases_var", "variable:",
                                                     c("count", "intensity", "rating", "tempo_bpm", "minutes"),
                                                     selected="rating", multiple =FALSE)
                                      ),
                               column(5,
                                      selectizeInput("legend_position", "legend:",
                                                     c("right", "none"),
                                                     selected="none", multiple =FALSE)),
                               column(2, style = "margin-top: 29px;", downloadButton("downloadDiscographyData", ""))

                             ),

                             hr(),

                             fluidRow(
                               column(12,
                                      uiOutput("releases_plot_ui", width = "100%")
                               )
                             ),

                             hr(),
                             tags$br(),

                             fluidRow(
                               column(12,
                                      DT::dataTableOutput("releasesdatatable")
                               )
                             )

                           )

                  ),

# variation -------------------------------------------------------------------


tabPanel("variation",

         fluidPage(

           tags$br(),

           fluidRow(
             column(10,
                    uiOutput("variation_songInput")
             ),
             column(2, style = "margin-top: 29px;", downloadButton("downloadVariationData", ""))

           ),

           hr(),

           # Graph

           fluidRow(
             column(12,
                    plotlyOutput("variation_count_plot")
             )
           ),

           # max songs control

           fluidRow(
             column(12,
                    sliderInput("max_songs_variation", "max_songs:",
                                min = 1, max = 100,
                                value = 10, width = "100%")
             )
           ),

           hr(),
           tags$br(),

           fluidRow(
             column(12,
                    DT::dataTableOutput("variationdatatable")
             )
           )

         )

),



# duration -------------------------------------------------------------

                  tabPanel("duration",

                           fluidPage(

                             tags$br(),

                             # Create a new Row in the UI for selectInputs
                             fluidRow(
                               column(10, uiOutput("menuOptions_duration_song")),
                               column(2, style = "margin-top: 29px;", downloadButton("downloadDurationData", ""))
                             ),

                             hr(),
                             tags$br(),

                             fluidRow(
                               column(12,
                                      DT::dataTableOutput("duration_shows_datatable")
                               )
                             )

                           )

                  ),



# search ------------------------------------------------------------------

                  tabPanel("search",

                           fluidPage(

                             tags$br(),

                             # Create a new Row in the UI for selectInputs

                             fluidRow(
                               column(10,
                                      uiOutput("menuOptions_search_songs")
                               ),
                               column(2, style = "margin-top: 29px;", downloadButton("downloadSearchData", ""))
                             ),

                             hr(),
                             tags$br(),

                             fluidRow(
                               column(12,
                                      DT::dataTableOutput("search_shows_datatable")
                               )
                             )

                           )

                  )

# end of 'stock' tabset -----------------------------------------------------




           )

         )

),

# start and end of 'quiz' tabset -------------------------------------------------------------------

tabPanel("quiz",

         fluidPage(

           tags$br(),

           tags$div(
             "We'll throw down, we'll throw down",
             tags$br(),
             "You want to figure it out?",
             tags$br(),
             tags$a(href="https://fugazi.bandcamp.com/track/bulldog-front", "- Bulldog Front by Fugazi"),
             tags$br(),
             tags$br(),
             "Test your knowledge with the",
             tags$a(href="https://forms.gle/2qcz2giGXmZqEM9Q6", "Fugazi Live Series Quiz #1"),
             tags$br()
           ),

           tags$br(),

           h3("High Scores"),

           tags$br(),

           fluidRow(

             column(12,
                    DT::dataTableOutput("quiz_datatable")

             )

           )

         )

)

# end -------------------------------------------------------------

      )

      ),

        tags$div(
          tags$br(),
          tags$a(rel="me", href="https://github.com/alexmitrani/Repeatr/", "Repeatr GitHub"),
          tags$br()
        )

    )





# server -----------------------------------------------------


server <- function(input, output, session) {

  session$onSessionEnded(stopApp)

  session$userData$time <- reactive({as.Date(lubridate::dmy_hms(input$clientTime))})


  # today -------------------------------------------------------------------


  today_string <- reactive({

    today <- session$userData$time()
    today_year <- year(today)
    today_month <- month(today)
    today_day <- day(today)
    today_month_day <- today_month*100+today_day
    today_weekday <- weekdays(today)
    month_name <- month.name[today_month]

    suffix <- case_when(today_day==1 ~ "st",
                        today_day==2 ~ "nd",
                        today_day==3 ~ "rd",
                        today_day>3 & today_day <=20  ~ "th",
                        today_day==21 ~ "st",
                        today_day==22 ~ "nd",
                        today_day==23 ~ "rd",
                        today_day>23 & today_day <=30  ~ "th",
                        today_day==31 ~ "st")

    if(is.na(today_day)==FALSE & today_year>2002) {

      today_string <- paste0(today_day, suffix, " of ", month_name, ".")

    } else {

      today_string <- "That is not a valid date."

    }

    today_string

  })

  output$today <- renderText(today_string())

  today_number_shows_string <- reactive({

    today <- session$userData$time()
    today_year <- year(today)
    today_month <- month(today)
    today_day <- day(today)
    today_month_day <- today_month*100+today_day

    if(is.na(today_day)==FALSE & today_year>2002) {

      mydf <- shows_data %>%
        mutate(month_day = month(date)*100+day(date)) %>%
        filter(month_day == today_month_day)

      number_shows <- nrow(mydf)

      if(number_shows==1){

        number_shows_string <- paste0("There was ", number_shows, " Fugazi show on this day in history.")

      } else {

        number_shows_string <- paste0("There were ", number_shows, " Fugazi shows on this day in history.")

      }

      number_shows_string


    } else (

      number_shows_string <- ""

    )

  })

  output$today_number_shows <- renderText(today_number_shows_string())


  today_data2 <- reactive({

    today <- session$userData$time()
    today_year <- year(today)
    today_month <- month(today)
    today_day <- day(today)
    today_month_day <- today_month*100+today_day

    if(is.na(today_day)==FALSE & today_year>2002){

      mydf <- today_data %>%
        mutate(month_day = month(date)*100+day(date)) %>%
        filter(month_day == today_month_day)

      mydf

    }

  })


  today_data3 <- reactive({

    today <- session$userData$time()
    today_year <- year(today)
    today_day <- day(today)

    if(is.na(today_day)==FALSE & today_year>2002){

      mydf <- today_data2() %>%
        mutate(yearsago = today_year - year(date)) %>%
        mutate(day = day(date), dayname = weekdays(date), monthname = format(date, "%B")) %>%
        mutate(suffix = case_when(day==1 ~ "st",
                                  day==2 ~ "nd",
                                  day==3 ~ "rd",
                                  day>3 & day <=20  ~ "th",
                                  day==21 ~ "st",
                                  day==22 ~ "nd",
                                  day==23 ~ "rd",
                                  day>23 & day <=30  ~ "th",
                                  day==31 ~ "st")) %>%
        mutate(datestring = paste0(dayname, " the ", day, suffix, " of ", monthname, " ", year(date))) %>%
        mutate(url = paste0("https://www.dischord.com/fugazi_live_series/", gid)) %>%
        mutate(other_bands = ifelse(is.na(played_with),0,1)) %>%
        mutate(with_who = ifelse(other_bands==1, paste0(" with ", played_with), "")) %>%
        mutate(text = paste0(yearsago, " years ago today, on ", datestring,", Fugazi played ",  where_played, with_who, ". ", url)) %>%
        arrange(date) %>%
        select(text, fls_link, attendance, minutes, sound_quality)


      mydf

    }

  })

  today_data4 <- reactive({

    today <- session$userData$time()
    today_year <- year(today)
    today_day <- day(today)

    if(is.na(today_day)==FALSE & today_year>2002){

      mydf <- today_data3() %>%
        select(-fls_link)

      mydf <- download_table_footer(mydf = mydf, nblankrows = 1, textcolumnname = "sources", rowtext = sourcestext)

      mydf[is.na(mydf)] <- ""

      mydf

    }

  })

  output$todaydatatable <- DT::renderDataTable(DT::datatable({

    data <- today_data3()

  },
  escape = c(-3),
  style = "bootstrap"))

  # Downloadable csv of selected dataset

  output$downloadTodayData <- downloadHandler(
    filename = paste0(datestring, "_Fugazetteer_today.csv"),
    content = function(file) {
      write.csv(today_data4(), file, row.names = FALSE)
    }
  )

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
    updateNumericInput(session, "weeks", "period_weeks:", 1,
                       min = 1, max = 792)
    freezeReactiveValue(input, "step_days")
    updateNumericInput(session, "step_days", "step_days:", 1,
                       min = 1, max = 5542)
    updateCheckboxInput(session, "shows_p_s", value = FALSE)
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
    updateNumericInput(session, "weeks", "period_weeks:", 792,
                       min = 1, max = 792)
    freezeReactiveValue(input, "step_days")
    updateNumericInput(session, "step_days", "step_days:", 1,
                       min = 1, max = 5542)
    updateCheckboxInput(session, "shows_p_s", value = TRUE)
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

    mydf <- shows_data

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


    mypalette <- get_brewer_pal("Reds", contrast=c(0.5, 1.0), plot = FALSE)

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

  shows_data3 <- reactive({

    mydf <- shows_data2() %>%
      mutate(url = paste0("https://www.dischord.com/fugazi_live_series/", gid)) %>%
      select(url, fls_link, date, venue, city, country, attendance, minutes, tempo_bpm, sound_quality) %>%
      arrange(date)

    mydf

  })

  shows_data4 <- reactive({

    mydf <- shows_data3() %>%
      select(-fls_link)

    mydf <- download_table_footer(mydf = mydf, nblankrows = 1, textcolumnname = "sources", rowtext = sourcestext)

    mydf[is.na(mydf)] <- ""

    mydf

  })

  output$showsdatatable <- DT::renderDataTable(DT::datatable({

      data <- shows_data3() %>%
        select(-url)

    },
    escape = c(-2),
    style = "bootstrap"))

  # Downloadable csv of selected dataset

  output$downloadShowsData <- downloadHandler(
    filename = paste0(datestring, "_Fugazetteer_Shows.csv"),
    content = function(file) {
      write.csv(shows_data4(), file, row.names = FALSE)
    }
  )

  # with -------------------------------------------------------------------


  output$menuOptions_bands <- renderUI({

    if (is.null(input$yearInput_shows)==FALSE & is.null(input$tourInput_shows)==FALSE) {
      menudata <- played_with %>%
        filter(year %in% input$yearInput_shows &
                 tour %in% input$tourInput_shows) %>%
        arrange(played_with)

    } else if (is.null(input$yearInput_shows)==FALSE & is.null(input$tourInput_shows)==TRUE) {
      menudata <- played_with %>%
        filter(year %in% input$yearInput_shows) %>%
        arrange(played_with)

    } else if (is.null(input$yearInput_shows)==TRUE & is.null(input$tourInput_shows)==FALSE) {
      menudata <- played_with %>%
        filter(tour %in% input$tourInput_shows) %>%
        arrange(played_with)

    } else {
      menudata <- played_with %>%
        arrange(played_with)

    }

    selectizeInput("bandsInput_with", "bands:",
                   choices = c(unique(menudata$played_with)), multiple =TRUE)

  })


  played_with_data <- reactive({

    mydf <- played_with

    if (is.null(input$yearInput_shows)==FALSE) {
      mydf <- mydf %>%
        filter(year %in% input$yearInput_shows)

    }

    if (is.null(input$tourInput_shows)==FALSE) {
      mydf <- mydf %>%
        filter(tour %in% input$tourInput_shows)

    }

    if (is.null(input$bandsInput_with)==FALSE) {
      mydf <- mydf %>%
        filter(played_with %in% input$bandsInput_with)

    }

    mydf

  })

  played_with_summary_data <- reactive({

    mydf <- played_with_summary

    if (is.null(input$yearInput_shows)==FALSE) {
      mydf <- mydf %>%
        filter(year %in% input$yearInput_shows)

    }

    if (is.null(input$tourInput_shows)==FALSE) {
      mydf <- mydf %>%
        filter(tour %in% input$tourInput_shows)

    }

    if (is.null(input$bandsInput_with)==FALSE) {
      mydf <- mydf %>%
        filter(played_with %in% input$bandsInput_with)

    }

    mydf <- mydf %>%
      filter(is.na(played_with)==FALSE)

    mydf <- mydf %>%
      group_by(played_with) %>%
      summarize(shows = sum(shows)) %>%
      ungroup()

    mydf

  })

  # summary plot

  output$played_with_plot <- renderPlot({

    if (is.null(input$bandsInput_with)==TRUE) {

      mydf <- played_with_summary_data() %>%
        arrange(desc(shows)) %>%
        filter(row_number()<20)

    } else {

      mydf <- played_with_summary_data() %>%
        arrange(desc(shows))

    }

    played_with_plot <- ggplot(mydf, aes(x = reorder(played_with, +shows),
                                                   y = shows,
                                                   fill = played_with)) +
        geom_bar(stat="identity") +
        scale_y_continuous(breaks = function(x) unique(floor(pretty(seq(0, (max(x) + 1) * 1.1))))) +
        xlab("band") +
        ylab("shows") +
        coord_flip() +
        theme(legend.position=input$legend_position) +
        theme(axis.text.x=element_text(size=10)) +
        theme(axis.text.y=element_text(size=10))


    print(played_with_plot)

  })

  with_plotheight <- reactive({

    if (is.null(input$bandsInput_with)==TRUE) {

      with_plotheight = 500

    } else {

      mybands <- input$bandsInput_with
      mybands <- as.data.frame(mybands)
      mybands <- nrow(mybands)

      with_plotheight = 50 + 50*mybands

    }

  })

  output$played_with_plot_ui <- renderUI({
    plotOutput("played_with_plot", height = with_plotheight())
  })

  # map

  output$played_with_map <- renderLeaflet({
    df <- played_with_data()

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

  # markers

  output$played_with_markers <- renderPlot({

    myx <- nrow(played_with_data())

    df <- played_with_data() %>%
      mutate(daten = as.numeric(date)) %>%
      mutate(mycolour = played_with)

    number_bands <- nrow(played_with_data() %>%
                           group_by(played_with) %>%
                           summarize(shows = n()) %>%
                           ungroup()
    )

    if(number_bands==1) {

      mypalette <- get_brewer_pal("Reds", plot = FALSE)

    } else {

      mypalette <- get_brewer_pal("Set1", plot = FALSE)

    }

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

    if (is.null(input$bandsInput_with)==TRUE) {

      leafletProxy("played_with_map", data = df) %>%
        fitBounds(lng1 = min_longitude, lat1 = min_latitude, lng2 = max_longitude, lat2 = max_latitude) %>%
        clearShapes() %>%
        htmlwidgets::onRender("function(el, x) {
        L.control.zoom({ position: 'bottomleft' }).addTo(this)
      }") %>%
        addCircles(
          data = df,
          lng = ~ longitude, lat = ~ latitude,
          radius = sqrt((df$attendance)/pi),
          color = ~pal(colorData),
          fillColor = ~pal(colorData),
          fillOpacity = 0.5,
          popup = paste0(
            "<strong>Date: </strong>", df$date, "<br>",
            "<strong>Venue: </strong>", df$venue, "<br>",
            "<strong>City: </strong>", df$city, "<br>",
            "<strong>Played with: </strong>", df$played_with, "<br>",
            "<strong>Attendance: </strong>", df$attendance, "<br>",
            "<strong>Coordinates: </strong>", paste0(df$latitude, ", ", df$longitude)
          )
        )

    } else {

      leafletProxy("played_with_map", data = df) %>%
        fitBounds(lng1 = min_longitude, lat1 = min_latitude, lng2 = max_longitude, lat2 = max_latitude) %>%
        clearShapes() %>%
        htmlwidgets::onRender("function(el, x) {
        L.control.zoom({ position: 'bottomleft' }).addTo(this)
      }") %>%
        addCircles(
          data = df,
          lng = ~ longitude, lat = ~ latitude,
          radius = sqrt((df$attendance)/pi),
          color = ~pal(colorData),
          fillColor = ~pal(colorData),
          fillOpacity = 0.5,
          popup = paste0(
            "<strong>Date: </strong>", df$date, "<br>",
            "<strong>Venue: </strong>", df$venue, "<br>",
            "<strong>City: </strong>", df$city, "<br>",
            "<strong>Played with: </strong>", df$played_with, "<br>",
            "<strong>Attendance: </strong>", df$attendance, "<br>",
            "<strong>Coordinates: </strong>", paste0(df$latitude, ", ", df$longitude)
          )
        ) %>%
        addLegend("bottomright", pal = pal, values = ~colorData,
                  title = "Played with",
                  opacity = 1
        )

    }


  })

  with_data <- reactive({

    if(input$with_choice=="summary") {

      mydf <- played_with_summary_data() %>%
        select(played_with, shows) %>%
        arrange(desc(shows))

    } else {

      mydf <- played_with_data() %>%
        mutate(url = paste0("https://www.dischord.com/fugazi_live_series/", gid)) %>%
        select(url, fls_link, date, venue, city, country, played_with, attendance, sound_quality) %>%
        arrange(date)

    }

    mydf

  })

  with_data2 <- reactive({

    if(input$with_choice=="summary") {

      mydf <- with_data()

    } else {

      mydf <- with_data() %>%
        select(-url)

    }

    mydf

  })

  with_data3 <- reactive({

    if(input$with_choice=="summary") {

      mydf <- with_data()

    } else {

      mydf <- with_data() %>%
        select(-fls_link)

    }

    mydf <- download_table_footer(mydf = mydf, nblankrows = 1, textcolumnname = "sources", rowtext = sourcestext)

    mydf[is.na(mydf)] <- ""

    mydf

  })

  # datatable


    output$played_with_datatable <- DT::renderDataTable(DT::datatable({

        data <- with_data2()

    },
    escape = c(-2),
    style = "bootstrap"))

    # Downloadable csv of selected dataset

    output$downloadWithData <- downloadHandler(
      filename = paste0(datestring, "_Fugazetteer_With.csv"),
      content = function(file) {
        write.csv(with_data3(), file, row.names = FALSE)
      }
    )





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
      mutate(attendance = round(ifelse(is.na(attendance)==TRUE, meanattendance, attendance))) %>%
      select(fls_link, gid, year, tour, date, attendance, sound_quality) %>%
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

    if (input$AttendanceGraph_choice=="details") {

      attendancedata2 <- attendance_data() %>%
        filter(is.na(date)==FALSE) %>%
        filter(tour!="Unknown") %>%
        arrange(date) %>%
        select(tour, gid, fls_link, date, attendance, sound_quality)

    } else {

      attendancedata2 <- attendance_data() %>%
        group_by(tour) %>%
        filter(is.na(date)==FALSE) %>%
        filter(tour!="Unknown") %>%
        summarise(start = min(date), end = max(date), shows = n(), duration = as.numeric((end - start)), attendance=sum(attendance), cumulative_attendance = max(cumulative_attendance)) %>%
        ungroup() %>%
        rename(days = duration) %>%
        arrange(start)

    }

    attendancedata2

  })

  attendance_data3 <- reactive({

    if (input$AttendanceGraph_choice=="details") {

      mydf <- attendance_data2() %>%
        select(tour, fls_link, date, attendance, sound_quality)

    } else {

      mydf <- attendance_data2()

    }

    mydf

  })

  attendance_data4 <- reactive({

    if (input$AttendanceGraph_choice=="details") {

      mydf <- attendance_data2() %>%
        mutate(url = paste0("https://www.dischord.com/fugazi_live_series/", gid)) %>%
        select(tour, url, date, attendance, sound_quality)

    } else {

      mydf <- attendance_data2()

    }

    mydf <- download_table_footer(mydf = mydf, nblankrows = 1, textcolumnname = "sources", rowtext = sourcestext)

    mydf[is.na(mydf)] <- ""

    mydf

  })

  output$attendance_count_plot <- renderPlotly({

    if (input$AttendanceGraph_choice=="details") {

      attendance_plot <- ggplot(attendance_data(), aes(date, attendance, color = gid)) +
        geom_point() +
        theme(legend.position="none") +
        xlab("date") +
        ylab("attendance") +
        scale_y_continuous(limits = c(0, NA),
                           expand = expansion(mult = c(0, 0.1)), labels = comma)

    } else {

      attendance_plot <- ggplot(attendance_data(), aes(date, cumulative_attendance, color = tour)) +
        geom_point() +
        theme(legend.position="none") +
        xlab("date") +
        ylab("cumulative attendance") +
        scale_y_continuous(labels = comma)

    }

    plotly::ggplotly(attendance_plot)

  })

  output$toursdatatable <- DT::renderDataTable(DT::datatable({
    data <- attendance_data3()

    data

  },
  escape = c(-3),
  style = "bootstrap"))

  # Downloadable csv of selected dataset

  output$downloadAttendanceData <- downloadHandler(
    filename = paste0(datestring, "_Fugazetteer_Attendance.csv"),
    content = function(file) {
      write.csv(attendance_data4(), file, row.names = FALSE)
    }
  )

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

    xray_data <- xray_data %>%
      mutate_if(is.numeric, ~round(., 3))

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

    xray_data2 <- xray_data2 %>%
      mutate_if(is.numeric, ~round(., 3))

    xray_data2

  })

  xray_data3 <- reactive({

    data <- xray_data2()  %>%
      select(-release, -colour_code, -releaseid, -units)  %>%
      pivot_wider(names_from = variable, values_from = value) %>%
      select(-year, -tour) %>%
      arrange(date)

    if(input$xrayGraph_choice!="other") {

      data$songs <- rowSums(data[sapply(data, is.numeric)], na.rm = TRUE)

    }

    data <- data %>%
      mutate_if(is.numeric, ~round(., 3))

    data <- data %>%
      relocate(c(fls_link, date, songs))

    data

  })

  xray_data4 <- reactive({

    mydf <- xray_data3() %>%
      select(-gid, -url)

    mydf

  })

  xray_data5 <- reactive({

    mydf <- xray_data3() %>%
      select(-gid, -fls_link)


    mydf <- download_table_footer(mydf = mydf, nblankrows = 1, textcolumnname = "sources", rowtext = sourcestext)

    mydf[is.na(mydf)] <- ""

    mydf

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


    data <- xray_data4()

  },
  escape = c(-2),
  style = "bootstrap"))

  # Downloadable csv of selected dataset

  output$downloadXrayData <- downloadHandler(
    filename = paste0(datestring, "_Fugazetteer_Xray.csv"),
    content = function(file) {
      write.csv(xray_data5(), file, row.names = FALSE)
    }
  )

  # renditions -------------------------------------------------------------------

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
      summarize(renditions = max(count) - min(count) + 1,
                pcnt_change = (max(count) - min(count) + 1)/(min(count)+1),
                from = min(date),
                to=max(date)) %>%
      ungroup() %>%
      arrange(desc(pcnt_change)) %>%
      mutate(index = row_number()) %>%
      select(song, index, from, to, releasedate, pcnt_change)

    mysongs

  })

  songs_data3 <- reactive({

    mydf <- songs_data() %>%
      left_join(songs_data2()) %>%
      left_join(last_performance_data) %>%
      mutate(to = as.Date(ifelse(last_performance<to, last_performance, to), origin = "1970-01-01")) %>%
      mutate(released = as.Date(releasedate, format = "%d/%m/%Y")) %>%
      filter(index<=input$max_songs_renditions)

    mydf

  })

  songs_data4 <- reactive({

    mydf <- songs_data3() %>%
      group_by(release, song, from, to, released) %>%
      summarize(renditions = max(count) - min(count) + 1) %>%
      ungroup() %>%
      arrange(desc(renditions))

    mydf

  })

  songs_data5 <- reactive({

    mydf <- songs_data4()

    mydf <- download_table_footer(mydf = mydf, nblankrows = 1, textcolumnname = "sources", rowtext = sourcestext)

    mydf[is.na(mydf)] <- ""

    mydf

  })


  output$performance_count_plot <- renderPlotly({

    p <- ggplot(songs_data3(), aes(x = date, y = count, color = song)) +
      geom_line() +
      xlab("date") +
      ylab("cumulative renditions")

    plotly::ggplotly(p)

  })


  output$songsdatatable <- DT::renderDataTable(DT::datatable({

    data <- songs_data4()

  },
  style = "bootstrap"))

  # Downloadable csv of selected dataset

  output$downloadRenditionsData <- downloadHandler(
    filename = paste0(datestring, "_Fugazetteer_Renditions.csv"),
    content = function(file) {
      write.csv(songs_data5(), file, row.names = FALSE)
    }
  )

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
      arrange(desc(count)) %>%
      mutate(index = row_number()) %>%
      filter(index<=input$max_transitions)

    mytransitions <- mytransitions %>%
      select(-index)

    mytransitions

  })

  transitions_data2 <- reactive({

    mydf <- transitions_data()

    mydf <- download_table_footer(mydf = mydf, nblankrows = 1, textcolumnname = "sources", rowtext = sourcestext)

    mydf[is.na(mydf)] <- ""

    mydf

  })

  output$transitions_heatmap <- renderPlotly({

    ggplot(transitions_data(), aes(to, from, fill= count)) +
      geom_tile() +
      scale_fill_viridis(discrete=FALSE) +
      theme(axis.text.x = element_text(angle = 90),
            aspect.ratio=1)

  })

  output$transitionsdatatable <- DT::renderDataTable(DT::datatable({

    data <- transitions_data()

    data

  },
  style = "bootstrap"))

  # Downloadable csv of selected dataset

  output$downloadMatrixData <- downloadHandler(
    filename = paste0(datestring, "_Fugazetteer_Matrix.csv"),
    content = function(file) {
      write.csv(transitions_data2(), file, row.names = FALSE)
    }
  )



  # transition -------------------------------------------------------------

  transitions_shows_data_filtered <- reactive({

    if (is.null(input$yearInput_shows)==FALSE & is.null(input$tourInput_shows)==FALSE) {
      transitions_shows_data_filtered <- transitions_data_da %>%
        filter(year %in% input$yearInput_shows &
                 tour %in% input$tourInput_shows)

    } else if (is.null(input$yearInput_shows)==FALSE & is.null(input$tourInput_shows)==TRUE) {
      transitions_shows_data_filtered <- transitions_data_da %>%
        filter(year %in% input$yearInput_shows)

    } else if (is.null(input$yearInput_shows)==TRUE & is.null(input$tourInput_shows)==FALSE) {
      transitions_shows_data_filtered <- transitions_data_da %>%
        filter(tour %in% input$tourInput_shows)

    } else {
      transitions_shows_data_filtered <- transitions_data_da

    }

    transitions_shows_data_filtered

  })


  output$menuOptions_searchfrom <- renderUI({


    searchmenudata <- transitions_shows_data_filtered() %>%
        arrange(song1)


    selectizeInput("search_from_song", "from:",
                   choices = c(unique(searchmenudata$song1)), multiple =TRUE)

  })

  output$menuOptions_search <- renderUI({

    if (is.null(input$search_from_song)==FALSE) {
      searchmenudata <- transitions_shows_data_filtered() %>%
        filter(song1 %in% input$search_from_song) %>%
        arrange(song2)
    } else {
      searchmenudata <- transitions_shows_data_filtered() %>%
        arrange(song2)
    }

    selectizeInput("searchInput_to_song", "to:",
                   choices = c(unique(searchmenudata$song2)), multiple =TRUE)

  })

  transitions_shows_data <- reactive({

    if (is.null(input$search_from_song)==FALSE & is.null(input$searchInput_to_song)==FALSE) {
      transitions_data_da_results <- transitions_shows_data_filtered() %>%
        filter(song1 %in% input$search_from_song &
                 song2 %in% input$searchInput_to_song)

    } else if (is.null(input$search_from_song)==FALSE & is.null(input$searchInput_to_song)==TRUE) {
      transitions_data_da_results <- transitions_shows_data_filtered() %>%
        filter(song1 %in% input$search_from_song)

    } else if (is.null(input$search_from_song)==TRUE & is.null(input$searchInput_to_song)==FALSE) {
      transitions_data_da_results <- transitions_shows_data_filtered() %>%
        filter(song2 %in% input$searchInput_to_song)

    } else {

      transitions_data_da_results <- transitions_shows_data_filtered()

    }

    transitions_data_da_results %>%
      select(gid, url, fls_link, date, transition, song1, song2) %>%
      arrange(date)

  })

  transitions_shows_data2 <- reactive({

    mydf <- transitions_shows_data() %>%
      select(-gid, -url)

    mydf

  })

  transitions_shows_data3 <- reactive({

    mydf <- transitions_shows_data() %>%
      select(-gid, -fls_link)

    mydf <- download_table_footer(mydf = mydf, nblankrows = 1, textcolumnname = "sources", rowtext = sourcestext)

    mydf[is.na(mydf)] <- ""

    mydf

  })


  output$transitions_shows_datatable <- DT::renderDataTable(DT::datatable({

    data <- transitions_shows_data2()

    data

  }, escape = c(-2),
  style = "bootstrap"))

  # Downloadable csv of selected dataset

  output$downloadTransitionsData <- downloadHandler(
    filename = paste0(datestring, "_Fugazetteer_Transitions.csv"),
    content = function(file) {
      write.csv(transitions_shows_data3(), file, row.names = FALSE)
    }
  )

  # sets -------------------------------------------------------------

  sets_shows_data_filtered <- reactive({

    if (is.null(input$yearInput_shows)==FALSE & is.null(input$tourInput_shows)==FALSE) {
      year_tour_gid_song_filtered <- year_tour_gid_song %>%
        filter(year %in% input$yearInput_shows &
                 tour %in% input$tourInput_shows)

    } else if (is.null(input$yearInput_shows)==FALSE & is.null(input$tourInput_shows)==TRUE) {
      year_tour_gid_song_filtered <- year_tour_gid_song %>%
        filter(year %in% input$yearInput_shows)

    } else if (is.null(input$yearInput_shows)==TRUE & is.null(input$tourInput_shows)==FALSE) {
      year_tour_gid_song_filtered <- year_tour_gid_song %>%
        filter(tour %in% input$tourInput_shows)

    } else {
      year_tour_gid_song_filtered <- year_tour_gid_song

    }

    year_tour_gid_song_filtered

  })


  output$menuOptions_gid <- renderUI({


    searchmenudata <- sets_shows_data_filtered() %>%
      arrange(gid)


    selectizeInput("search_shows", "shows:",
                   choices = c(unique(searchmenudata$gid)), multiple =TRUE,
                   options = list(
                     placeholder = '',
                     onInitialize = I('function() { this.setValue(""); }')
                   ))

  })


  sets_songs_data <- reactive({

    sets <- sets(mydf = year_tour_gid_song, shows = input$search_shows)

    songs <- sets[[1]]

    if(is.null(songs)==FALSE){

      songs <- songs %>%
        arrange(song) %>%
        relocate(shows) %>%
        relocate(song)

    }

    songs

  })

  sets_songs_data2 <- reactive({

    mydf <- sets_songs_data()

    mydf <- download_table_footer(mydf = mydf, nblankrows = 1, textcolumnname = "sources", rowtext = sourcestext)

    mydf[is.na(mydf)] <- ""

    mydf

  })



  output$number_unique_songs <- renderText({
    number_unique_songs <- nrow(sets_songs_data())
    number_unique_songs
  })

  output$number_shows <- renderText({
    number_shows <- length(input$search_shows)
    number_shows
  })

  output$showorshows <- renderText({

    if(length(input$search_shows)>1) {
      showorshows <- "shows"
    } else {
      showorshows <- "show"
    }

  })

  sets_shows_data <- reactive({

    sets <- sets(mydf = year_tour_gid_song, shows = input$search_shows)

    shows <- sets[[2]]

    shows

  })




  output$sets_songs_datatable <- DT::renderDataTable(DT::datatable({


    if(is.null(sets_songs_data())==FALSE) {

      data <- discography %>%
        left_join(sets_songs_data()) %>%
        relocate(shows) %>%
        relocate(release) %>%
        relocate(song) %>%
        replace(is.na(.), 0) %>%
        arrange(desc(shows), release, song)

    } else {

      data <- sets_songs_data()

    }

    data

  },
  style = "bootstrap"))


  output$sets_shows_datatable <- DT::renderDataTable(DT::datatable({

    data <- sets_shows_data()

    data

  },
  style = "bootstrap"))

  # Downloadable csv of selected dataset

  output$downloadSetsData <- downloadHandler(
    filename = paste0(datestring, "_Fugazetteer_Sets.csv"),
    content = function(file) {
      write.csv(sets_songs_data2(), file, row.names = FALSE)
    }
  )



  # stacks -------------------------------------------------------------

  stacks_shows_data_filtered <- reactive({

    if (is.null(input$yearInput_shows)==FALSE & is.null(input$tourInput_shows)==FALSE) {
      year_tour_gid_song_filtered <- year_tour_gid_song %>%
        filter(year %in% input$yearInput_shows &
                 tour %in% input$tourInput_shows)

    } else if (is.null(input$yearInput_shows)==FALSE & is.null(input$tourInput_shows)==TRUE) {
      year_tour_gid_song_filtered <- year_tour_gid_song %>%
        filter(year %in% input$yearInput_shows)

    } else if (is.null(input$yearInput_shows)==TRUE & is.null(input$tourInput_shows)==FALSE) {
      year_tour_gid_song_filtered <- year_tour_gid_song %>%
        filter(tour %in% input$tourInput_shows)

    } else {
      year_tour_gid_song_filtered <- year_tour_gid_song

    }

    year_tour_gid_song_filtered

  })


  output$menuOptions_gid_stacks <- renderUI({


    searchmenudata_stacks <- stacks_shows_data_filtered() %>%
      arrange(gid)


    selectizeInput("search_shows_stacks", "show:",
                   choices = c(unique(searchmenudata_stacks$gid)), multiple =FALSE,
                     options = list(
                       placeholder = '',
                       onInitialize = I('function() { this.setValue(""); }')
                     )
                   )

  })

  stacks_shows_data <- reactive({

    stack_shows <- gid_initial_gid_sound_quality %>%
      filter(gid %in% input$search_shows_stacks)

    stack_shows

  })

  output$menuOptions_gid_stacks2 <- renderUI({


    searchmenudata_stacks2 <- stacks_shows_data() %>%
      arrange(gid_initial)


    selectizeInput("search_shows_stacks2", "stack:",
                   choices = c(unique(searchmenudata_stacks2$gid_initial)), multiple =FALSE,
                   options = list(
                     placeholder = '',
                     onInitialize = I('function() { this.setValue(""); }')
                   )
    )

  })

  stacks_shows_data1 <- reactive({

    stack_shows <- gid_initial_gid_sound_quality %>%
      filter(gid_initial %in% input$search_shows_stacks2)

    stack_shows

  })

  stacks_shows_data2 <- reactive({

    data <- stacks_shows_data1() %>%
      select(gid, sound_quality) %>%
      left_join(othervariables) %>%
      select(gid, date, venue, city, country, sound_quality) %>%
      mutate(url = paste0("https://www.dischord.com/fugazi_live_series/", gid)) %>%
      relocate(url) %>%
      select(url, gid, date, venue, city, country, sound_quality) %>%
      arrange(date)

    data

  })

  stacks_shows_data3 <- reactive({

    data <- stacks_shows_data2() %>%
      select(-gid)

    data

  })

  stacks_shows_data4 <- reactive({

    mydf <- stacks_shows_data3()

    mydf <- download_table_footer(mydf = mydf, nblankrows = 1, textcolumnname = "sources", rowtext = sourcestext)

    mydf[is.na(mydf)] <- ""

    mydf

  })

  stacks_songs_data <- reactive({

    sets <- sets(mydf = year_tour_gid_song, shows = as.character(stacks_shows_data2()$gid))

    songs <- sets[[1]]

    songs

  })

  output$number_shows_stacks <- renderText({
    number_shows <- nrow(stacks_shows_data2())
    number_shows
  })

  output$showorshows_stacks <- renderText({

    if(length(stacks_shows_data2())>1) {
      showorshows <- "shows"
    } else {
      showorshows <- "show"
    }

  })

  output$number_unique_songs_stacks <- renderText({
    number_songs <- nrow(stacks_songs_data())
    number_songs
  })




  output$stacks_shows_datatable <- DT::renderDataTable(DT::datatable({

    data <- stacks_shows_data2() %>%
      mutate(fls_link = paste0("<a href='",  url, "' target='_blank'>", gid, "</a>")) %>%
      relocate(fls_link) %>%
      select(-gid, -url)

    data

  }, escape = c(-2),
  style = "bootstrap"))

  output$stacks_songs_datatable <- DT::renderDataTable(DT::datatable({

    data <- stacks_songs_data() %>%
      relocate(shows) %>%
      relocate(song)

    data

  },
  style = "bootstrap"))

  output$downloadStacksData <- downloadHandler(
    filename = paste0(datestring, "_Fugazetteer_Stacks.csv"),
    content = function(file) {
      write.csv(stacks_shows_data4(), file, row.names = FALSE)
    }
  )



# discography -------------------------------------------------------------------

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

  releases_summary_filtered <- reactive({

    if (is.null(input$Input_releases)==FALSE) {
      releases_summary_filtered <- releases_summary %>%
        filter(release %in% input$Input_releases)

    } else {

      releases_summary_filtered <- releases_summary

    }

    releases_summary_filtered

  })

  output$releases_plot <- renderPlot({

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
          coord_flip() +
          theme(legend.position=input$legend_position) +
          theme(axis.text.x=element_text(size=10)) +
          theme(axis.text.y=element_text(size=10))

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
        coord_flip() +
        theme(legend.position=input$legend_position) +
        theme(axis.text.x=element_text(size=10)) +
        theme(axis.text.y=element_text(size=10))

    } else if (input$Input_releases_var == "count") {

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
        coord_flip() +
        theme(legend.position=input$legend_position) +
        theme(axis.text.x=element_text(size=10)) +
        theme(axis.text.y=element_text(size=10))

    } else if (input$Input_releases_var == "minutes") {

      releases_plot <- ggplot(releases_data(), aes(x = song,
                                                   y = minutes,
                                                   fill = release)) +
        geom_bar(stat="identity") +
        xlab("track") +
        ylab("minutes") +
        scale_fill_manual(values=colours) +
        scale_y_continuous(expand = expansion(mult = c(0, 0.1)),
                           limits = c(0, NA),
                           labels = comma) +
        coord_flip() +
        theme(legend.position=input$legend_position) +
        theme(axis.text.x=element_text(size=10)) +
        theme(axis.text.y=element_text(size=10))

    } else {

        releases_plot <- ggplot(releases_data(), aes(x = song,
                                                     y = tempo_bpm,
                                                     fill = release)) +
          geom_bar(stat="identity") +
          xlab("track") +
          ylab("tempo_bpm") +
          scale_fill_manual(values=colours) +
          scale_y_continuous(expand = expansion(mult = c(0, 0.1)),
                             limits = c(0, NA),
                             labels = comma) +
          coord_flip() +
          theme(legend.position=input$legend_position) +
          theme(axis.text.x=element_text(size=10)) +
          theme(axis.text.y=element_text(size=10))

    }

    print(releases_plot)

  })

  plotheight <- reactive({

    if (is.null(input$Input_releases)==TRUE) {

      plotheight <- 1000

    } else {

      myreleases <- input$Input_releases
      myreleases <- as.data.frame(myreleases)
      myreleases <- nrow(myreleases)

      plotheight <- 100 + 100*myreleases

    }

  })

  output$releases_plot_ui <- renderUI({
    plotOutput("releases_plot", height = plotheight())
  })

  outputOptions(output, "releases_plot_ui", suspendWhenHidden = FALSE)

  releases_data_table <- reactive({

    if (is.null(input$Input_releases)==FALSE) {

      releases_data_table <- releases_data() %>%
        select(release, track_number, song, date, count, intensity, rating, tempo_bpm, minutes) %>%
        rename(debut = date)

    } else {

      releases_data_table <- releases_summary %>%
        select(-releaseid)

    }

    releases_data_table

  })

  releases_data_table2 <- reactive({

    mydf <- releases_data_table()

    mydf <- download_table_footer(mydf = mydf, nblankrows = 1, textcolumnname = "sources", rowtext = sourcestext)

    mydf[is.na(mydf)] <- ""

    mydf

  })

  output$releasesdatatable <- DT::renderDataTable(DT::datatable({
    data <- releases_data_table()

    data

  },
  style = "bootstrap"))

  output$downloadDiscographyData <- downloadHandler(
    filename = paste0(datestring, "_Fugazetteer_Discography.csv"),
    content = function(file) {
      write.csv(releases_data_table2(), file, row.names = FALSE)
    }
  )


  # variation -------------------------------------------------------------------

  output$variation_songInput <- renderUI({

    if (is.null(input$Input_releases)==FALSE) {
      menudata <- cumulative_duration_counts %>%
        filter(release %in% input$Input_releases) %>%
        arrange(song)
    } else {
      menudata <- cumulative_duration_counts %>%
        arrange(song)
    }

    selectizeInput("variation_songInput", "songs",
                   choices = c(unique(menudata$song)), multiple =TRUE)

  })

  variation_data <- reactive({

    if (is.null(input$Input_releases)==FALSE) {

      mydf <- cumulative_duration_counts %>%
        filter(release %in% input$Input_releases)

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

  variation_data2 <- reactive({

    mydf <- variation_data() %>%
      left_join(duration_summary) %>%
      group_by(song) %>%
      summarize(minutes_sd = mean(minutes_sd)) %>%
      ungroup() %>%
      arrange(desc(minutes_sd)) %>%
      mutate(index = row_number()) %>%
      select(song, index)

    mydf

  })

  variation_data3 <- reactive({

    mydf <- variation_data() %>%
      left_join(variation_data2()) %>%
      filter(index<=input$max_songs_variation)

    mydf

  })

  variation_data4 <- reactive({

    mydf <- variation_data3() %>%
      group_by(song) %>%
      summarize(renditions = max(count)) %>%
      ungroup() %>%
      left_join(duration_summary) %>%
      arrange(desc(minutes_sd))

    mydf

  })

  variation_data5 <- reactive({

    mydf <- variation_data4()

    mydf <- download_table_footer(mydf = mydf, nblankrows = 1, textcolumnname = "sources", rowtext = sourcestext)

    mydf[is.na(mydf)] <- ""

    mydf

  })


  output$variation_count_plot <- renderPlotly({

    p <- ggplot(variation_data3(), aes(x = minutes, y = count, color = song)) +
      geom_line() +
      xlab("minutes") +
      ylab("cumulative renditions")

    plotly::ggplotly(p)

  })



  output$variationdatatable <- DT::renderDataTable(DT::datatable({
    data <- variation_data4()
  },
  style = "bootstrap"))

  output$downloadVariationData <- downloadHandler(
    filename = paste0(datestring, "_Fugazetteer_Variation.csv"),
    content = function(file) {
      write.csv(variation_data5(), file, row.names = FALSE)
    }
  )


# duration -------------------------------------------------------------


  output$menuOptions_duration_song <- renderUI({

    if (is.null(input$Input_releases)==FALSE) {
      menudata <- cumulative_duration_counts %>%
        filter(release %in% input$Input_releases) %>%
        arrange(song)
    } else {
      menudata <- cumulative_duration_counts %>%
        arrange(song)
    }

    selectizeInput("duration_song", "songs",
                   choices = c(unique(menudata$song)), multiple =TRUE)

  })


  duration_shows_data <- reactive({

    if (is.null(input$duration_song)==FALSE) {
      duration_data_da_results <- duration_data_da %>%
        filter(song %in% input$duration_song)

    } else if (is.null(input$Input_releases)==FALSE) {

      duration_data_da_results <- duration_data_da %>%
        filter(release %in% input$Input_releases)

    } else {

      duration_data_da_results <- duration_data_da

    }

    duration_data_da_results

  })

  duration_shows_data2 <- reactive({

    mydf <- duration_shows_data() %>%
      select(fls_link, date, song_number, song, minutes) %>%
      arrange(date, song_number)

    mydf

  })

  duration_shows_data3 <- reactive({

    mydf <- duration_shows_data() %>%
      mutate(url = paste0("https://www.dischord.com/fugazi_live_series/", gid)) %>%
      select(url, date, song_number, song, minutes) %>%
      arrange(date, song_number)

    mydf <- download_table_footer(mydf = mydf, nblankrows = 1, textcolumnname = "sources", rowtext = sourcestext)

    mydf[is.na(mydf)] <- ""

    mydf

  })


  output$duration_shows_datatable <- DT::renderDataTable(DT::datatable({

    data <- duration_shows_data2()

    data

  }, escape = c(-2),
  style = "bootstrap"))

  output$downloadDurationData <- downloadHandler(
    filename = paste0(datestring, "_Fugazetteer_Duration.csv"),
    content = function(file) {
      write.csv(duration_shows_data3(), file, row.names = FALSE)
    }
  )



# search ------------------------------------------------------------------


  output$menuOptions_search_songs <- renderUI({

    if (is.null(input$Input_releases)==FALSE) {
      menudata <- cumulative_duration_counts %>%
        filter(release %in% input$Input_releases) %>%
        arrange(song)
    } else {
      menudata <- cumulative_duration_counts %>%
        arrange(song)
    }

    selectizeInput("search_songs", "songs",
                   choices = c(unique(menudata$song)), multiple =TRUE)

  })

  search_shows_data <- reactive({

    if (is.null(input$search_songs)==FALSE) {

      mysearch <- input$search_songs
      mysearch <- as.data.frame(mysearch)
      names(mysearch)[1]<-"song"
      mysearch <- mysearch %>% mutate(hits = 1)

      search_data_da_results <- duration_data_da %>%
        left_join(mysearch) %>%
        left_join(gid_sound_quality)

      search_data_results <- search_data_da_results %>%
        group_by(gid, fls_link, date, sound_quality) %>%
        summarize(hits = sum(hits, na.rm = TRUE)) %>%
        arrange(desc(hits), date) %>%
        ungroup()

    } else if (is.null(input$Input_releases)==FALSE){

      search_data_results <- duration_data_da %>%
        filter(release %in% input$Input_releases) %>%
        left_join(gid_sound_quality) %>%
        group_by(gid, fls_link, date, sound_quality) %>%
        summarize(hits = n()) %>%
        arrange(desc(hits), date) %>%
        ungroup()

    } else {

      search_data_results <- duration_data_da %>%
        left_join(gid_sound_quality) %>%
        group_by(gid, fls_link, date, sound_quality) %>%
        summarize(hits = n()) %>%
        arrange(desc(hits), date) %>%
        ungroup()

    }

    search_data_results

  })

  search_shows_data2 <- reactive({

    mydf <- search_shows_data() %>%
      mutate(url = paste0("https://www.dischord.com/fugazi_live_series/", gid)) %>%
      select(url, fls_link, date, hits, sound_quality) %>%
      filter(hits>0)

    mydf

  })

  search_shows_data3 <- reactive({

    mydf <- search_shows_data2() %>%
      select(-url)

    mydf

  })

  search_shows_data4 <- reactive({

    mydf <- search_shows_data2() %>%
      select(-fls_link)

    mydf <- download_table_footer(mydf = mydf, nblankrows = 1, textcolumnname = "sources", rowtext = sourcestext)

    mydf[is.na(mydf)] <- ""

    mydf

  })



  output$search_shows_datatable <- DT::renderDataTable(DT::datatable({

    data <- search_shows_data3()

    data

  }, escape = c(-2),
  style = "bootstrap"))

  output$downloadSearchData <- downloadHandler(
    filename = paste0(datestring, "_Fugazetteer_Search.csv"),
    content = function(file) {
      write.csv(search_shows_data4(), file, row.names = FALSE)
    }
  )


# quiz --------------------------------------------------------------------

  quiz_data <- reactive({

    quizdata

  })

  output$quiz_datatable <- DT::renderDataTable(DT::datatable({

    data <- quiz_data()

    data

  }, escape = c(-2),
  style = "bootstrap"))

# end of server -----------------------------------------------------------


}


# shinyapp ----------------------------------------------------------------



shinyApp(ui = ui, server = server)




#

