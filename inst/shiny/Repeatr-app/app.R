
# devtools::install_github("alexmitrani/Repeatr", build_opts = c("--no-resave-data", "--no-manual"))

library(Repeatr)

# theme -------------------------------------------------------------------

my_theme <- bs_theme(bootswatch = "darkly",
                     base_font = font_google("Inconsolata"),
                     version = 5)

thematic_shiny(font = "auto")

# pre-processing ----------------------------------------------------------


gid_minutes <- fls_tags_show %>%
  select(gid, seconds) %>%
  mutate(minutes = round(seconds/60, digits = 2)) %>%
  select(-seconds)

gid_song_minutes <- fls_tags %>%
  select(gid, song, seconds) %>%
  mutate(minutes = round(seconds/60, digits = 2)) %>%
  select(-seconds)

shows_data <- othervariables %>%
  filter(is.na(attendance)==FALSE) %>%
  filter(is.na(tour)==FALSE) %>%
  mutate(attendance = as.integer(attendance)) %>%
  mutate(date = as.Date(date, "%d-%m-%Y")) %>%
  mutate(year = lubridate::year(date)) %>%
  rename(latitude = y) %>%
  rename(longitude = x) %>%
  select(gid, tour, year, date, venue, city, country, attendance, doorprice, latitude, longitude) %>%
  rename(door_price = doorprice) %>%
  mutate(urls = paste0("https://www.dischord.com/fugazi_live_series/", gid)) %>%
  mutate(fls_link = paste0("<a href='",  urls, "' target='_blank'>", gid, "</a>")) %>%
  left_join(gid_minutes)

last_performance_data <- Repeatr1 %>%
  filter(tracktype==1) %>%
  select(date, song)%>%
  group_by(song) %>%
  summarize(last_performance=max(date)) %>%
  ungroup()

cumulative_song_counts <- cumulative_song_counts %>%
  mutate(release = tolower(release)) %>%
  left_join(releasesdatalookup) %>%
  select(date, song, release, count, releasedate)

tour_lookup <- othervariables %>% select(gid, tour) %>%
  group_by(gid) %>%
  slice(1) %>%
  ungroup()

releaseid_variable_colour_code <- releasesdatalookup %>%
  select(releaseid, variable, colour_code)

xray <- Repeatr1 %>%
  left_join(tour_lookup)

xray <- xray %>%
  select(-release)

xray <- xray %>%
  left_join(releasesdatalookup)

xray <- xray %>%
  mutate(releasedate = as.Date(releasedate, "%d/%m/%Y", origin = "1970-01-01"))

xray <- xray %>%
  mutate(unreleased = ifelse(tracktype==2 | (tracktype==1 & date<releasedate),1,0))

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
  left_join(gid_song_minutes)

xray <- xray %>%
  mutate(track = 1,
         songtrack = ifelse(tracktype==1, 1, 0))

xray <- xray %>%
  mutate(release = ifelse(is.na(release)==TRUE, "other", release))

xray_tracks <- xray %>%
  mutate(units = "tracks") %>%
  mutate(year = lubridate::year(date)) %>%
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
         first_demo = ifelse(release=="first demo",1,0),
         other = ifelse(release=="other",1,0),
         unreleased = ifelse(unreleased==1,1,0),
         songs = ifelse(songtrack==1,1,0))


xray_tracks <- xray_tracks %>%
  group_by(gid, date, year, tour, units) %>%
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
            other = sum(other),
            unreleased = sum(unreleased),
            songs = sum(songs)) %>%
  arrange(date) %>%
  ungroup()

xray_minutes <- xray %>%
  mutate(units = "minutes") %>%
  mutate(year = lubridate::year(date)) %>%
  mutate(fugazi = ifelse(release=="fugazi",minutes,0),
         margin_walker = ifelse(release=="margin walker",minutes,0),
         three_songs = ifelse(release=="3 songs",minutes,0),
         repeater = ifelse(release=="repeater",minutes,0),
         steady_diet_of_nothing = ifelse(release=="steady diet of nothing",minutes,0),
         in_on_the_killtaker = ifelse(release=="in on the killtaker",minutes,0),
         red_medicine = ifelse(release=="red medicine",minutes,0),
         end_hits = ifelse(release=="end hits",minutes,0),
         the_argument = ifelse(release=="the argument",minutes,0),
         furniture = ifelse(release=="furniture",minutes,0),
         first_demo = ifelse(release=="first demo",minutes,0),
         other = ifelse(release=="other",minutes,0),
         unreleased = ifelse(unreleased==1,minutes,0),
         songs = ifelse(songtrack==1,minutes,0))


xray_minutes <- xray_minutes %>%
  group_by(gid, date, year, tour, units) %>%
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
            other = sum(other),
            unreleased = sum(unreleased),
            songs = sum(songs)) %>%
  arrange(date) %>%
  ungroup()

xray <- rbind.data.frame(xray_tracks, xray_minutes)

xray <- xray %>%
  mutate(released = songs - unreleased,
         incumbent = songs - debut - farewell)

xray <- xray %>%
  mutate(urls = paste0("https://www.dischord.com/fugazi_live_series/", gid)) %>%
  mutate(fls_link = paste0("<a href='",  urls, "' target='_blank'>", gid, "</a>")) %>%
  select(-gid, -urls)

xray <- xray %>%
  relocate(fls_link, year, tour, date, songs, unreleased, debut, farewell)

transitions_data_da1 <- Repeatr1 %>%
  filter(tracktype==1) %>%
  select(gid,date,song_number,song) %>%
  rename(song1 = song)

transitions_data_da2 <- Repeatr1 %>%
  filter(tracktype==1) %>%
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

show_sequence <- Repeatr1 %>%
  group_by(date) %>%
  summarize(songs = n()) %>%
  ungroup() %>%
  arrange(date) %>%
  mutate(show_num = row_number(),
         last_show = max(show_num))

releases_menu_list <- releasesdatalookup %>%
  arrange(releaseid) %>%
  filter(releaseid>0)

colour_code <- releasesdatalookup %>%
  arrange(releaseid) %>%
  filter(releaseid>0) %>%
  select(releaseid, colour_code)

releases_data_input <- Repeatr1 %>%
  left_join(show_sequence) %>%
  left_join(colour_code) %>%
  group_by(releaseid, release, track_number, song, last_show, colour_code) %>%
  summarize(count = n(),
            date=min(date),
            show_num = min(show_num)) %>%
  ungroup()

releases_data_input <- releases_data_input %>%
  arrange(desc(releaseid), desc(track_number)) %>%
  mutate(song = factor(song, levels=unique(song))) %>%
  mutate(release = factor(release, levels=rev(unique(release)))) %>%
  mutate(shows = last_show-show_num+1,
         rate = round(count / shows, digits=2)) %>%
  filter(releaseid>0)

releases_summary <- releases_data_input %>%
  group_by(releaseid, release, last_show) %>%
  summarize(count = sum(count),
            songs=n(),
            first_debut=min(date),
            last_debut=max(date),
            first_show = min(show_num),
            shows = round(mean(shows), digits=0),
            rate = round(mean(rate), digits = 2)) %>%
  ungroup()

releasesdatalookup <- releasesdatalookup %>%
  select(releaseid, releasedate) %>%
  mutate(releasedate = as.Date(releasedate, "%d/%m/%Y", origin = "1970-01-01"))

releases_summary <- releases_summary %>%
  left_join(releasesdatalookup) %>%
  select(releaseid, release, first_debut, last_debut, releasedate, songs, count, shows, rate) %>%
  rename(release_date = releasedate) %>%
  filter(releaseid>0)

duration_data_da <- Repeatr1 %>%
  filter(tracktype==1) %>%
  select(gid,date, song_number, song) %>%
  mutate(urls = paste0("https://www.dischord.com/fugazi_live_series/", gid)) %>%
  mutate(fls_link = paste0("<a href='",  urls, "' target='_blank'>", gid, "</a>")) %>%
  left_join(gid_song_minutes)

cumulative_duration_counts <- cumulative_duration_counts

duration_summary <- duration_summary

rm(releasesdatalookup, show_sequence)

timestamptext <- paste0("Made with Repeatr version ", packageVersion("Repeatr"), ", updated ", packageDate("Repeatr"), ".")

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


# shows -------------------------------------------------------------------

                  tabPanel("shows",


                           fluidPage(

                             tags$br(),

                             h4("Selection"),
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


# tours -------------------------------------------------------------------


                  tabPanel("tours",

                           fluidPage(

                             tags$br(),

                             h4("Selection"),
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
                                      selectizeInput("yearInput_xray", "years:",
                                                     sort(unique(othervariables$year)),
                                                     selected=1987, multiple =TRUE)),
                               column(6, uiOutput("menuTours_xray"))

                             ),

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
                                                     c("count", "rate"),
                                                     selected="rate", multiple =FALSE)
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

# renditions -------------------------------------------------------------------


                  tabPanel("renditions",

                           fluidPage(

                             tags$br(),

                             h4("Selection"),
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
                                                     selected="fugazi", multiple =TRUE)),
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


# matrix -------------------------------------------------------------


                  tabPanel("matrix",

                             fluidPage(

                               tags$br(),
                               h4("Selection"),
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

                  )


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

# shows -------------------------------------------------------------------



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
      select(fls_link, date, venue, city, country, attendance, minutes) %>%
      arrange(date)},
    escape = c(-2),
    style = "bootstrap"))

# tours -------------------------------------------------------------------

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


# xray -------------------------------------------------------------------


  output$menuTours_xray <- renderUI({

    if (is.null(input$yearInput_xray)==FALSE) {
      menudata <- shows_data %>%
        filter(year %in% input$yearInput_xray) %>%
        arrange(date)
    } else {
      menudata <- shows_data %>%
        arrange(date)
    }

    selectizeInput("tourInput_xray", "tours:",
                   choices = c(unique(menudata$tour)), multiple =TRUE)

  })


  xray_data <- reactive({


    if (is.null(input$yearInput_xray)==FALSE) {

      xray_data <- xray %>%
        filter(year %in% input$yearInput_xray)

    } else {

      xray_data <- xray

    }

    if (is.null(input$tourInput_xray)==FALSE) {

      xray_data <- xray_data %>%
        filter(tour %in% input$tourInput_xray)

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
      select(-year, -tour)

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

    if(input$Input_releases_var == "rate") {

        releases_plot <- ggplot(releases_data(), aes(x = song,
                                                   y = rate,
                                                   fill = release)) +
          geom_bar(stat="identity") +
          xlab("track") +
          ylab("rate") +
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
      group_by(song, releasedate) %>%
      summarize(count = max(count) - min(count), from = min(date), to=max(date)) %>%
      ungroup() %>%
      arrange(desc(count)) %>%
      mutate(index = row_number()) %>%
      select(song, index, from, to, releasedate)

    mysongs

  })

  songs_data3 <- reactive({

    mydf <- songs_data() %>%
      left_join(songs_data2()) %>%
      filter(index<=max_songs) %>%
      left_join(last_performance_data) %>%
      mutate(to = as.Date(ifelse(last_performance<to, last_performance, to), origin = "1970-01-01")) %>%
      mutate(released = as.Date(releasedate, format = "%d/%m/%Y"))

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

    transitions_data_da_results

  })


  output$transitions_shows_datatable <- DT::renderDataTable(DT::datatable({

    data <- transitions_shows_data()

    data

  }, escape = c(-2),
  style = "bootstrap"))



# matrix -------------------------------------------------------------


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
      filter(tracktype==1) %>%
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
      select(fls_link, date, song_number, song, minutes)

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




# end of server -----------------------------------------------------------


}


# shinyapp ----------------------------------------------------------------



shinyApp(ui = ui, server = server)




#

