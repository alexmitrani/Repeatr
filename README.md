# Repeatr

## ["I had a name, but now I'm a number"](https://fugazi.bandcamp.com/track/repeater)

R code for analysis of Fugazi Live Series metadata: https://www.dischord.com/fugazi_live_series

The initial data was provided by Ian James Wright of the Alphabetical Fugazi podcast and was probably extracted from the Fugazi Live Series website with fugotcha: https://github.com/universalhandle/fugotcha

## Song counts

Performance counts were calculated for all the released Fugazi songs that were performed live, using data from 1048 shows up to and including FLS1045. 

These frequency counts do not necessarily measure the band's preferences for the songs, as more recently released songs were available for fewer shows than older songs.  

The results of this analysis, in descending order of performance count, can be viewed here: https://github.com/alexmitrani/Repeatr/blob/main/fugazi_song_counts.csv

## Performance intensity

A slightly more detailed analysis was undertaken by calculating the performance intensity of each song.  

Song performance intensity = number of times a song was played / number of shows at which it was available in the repertoire.  

A song was considered available in the repertoire from the first show it was performed.  

The results of this analysis can be viewed here: https://github.com/alexmitrani/Repeatr/blob/main/fugazi_song_performance_intensity.csv

The "songid" variable indicates the raw frequency ranking of each song, allowing easy comparison between the intensity and frequency measures.  

## Song preferences

The Fugazi Live Series data includes 17297 choices of songs made by the band during their live shows. This data was used to estimate the band's collective preferences for the songs in their live music repertoire. 

Song availability was considered at both repertoire and gig level, that is songs were only considered available from the time they were first played and within any given gig, once a song had been played it would be considered unavailable for the rest of the gig.  

The age of the songs needs considering because bands generally prioritise new material when they play live and Fugazi was no exception to this. Dummy variables (on/off) were used to represent the age of the songs at the time of each gig, as follows: 

| Age category      | Dummy variable |
| ----------- | ----------- |
| Less than a year old      | (omitted)       |
| More than a year but less than 2 years old   | yearsold_1        |
| More than 2 years but less than 3 years old   | yearsold_2        |
| More than 3 years but less than 4 years old   | yearsold_3        |
| More than 4 years but less than 5 years old   | yearsold_4        |
| More than 5 years but less than 6 years old   | yearsold_5        |
| More than 6 years but less than 7 years old   | yearsold_6        |
| More than 7 years but less than 8 years old   | yearsold_7        |
| More than 8 years old   | yearsold_other        |

The above categories were defined after some experimentation to establish which categories deserved separate representation and which could be grouped together. The "less than a year old" variable was omitted because it is always necessary to omit one of each set of dummy variables in this type of model. An omitted dummy variable has a parameter of zero by definition and provides a reference point for the parameters whose values are estimated.   

The band's collective preference for each song was represented using a dummy variable (on/off) for each song, such that the parameters associated with these variables would represent the strength of preference for each song.  The dummy variable for "Waiting Room" was omitted and therefore the preference parameter for this song was zero by definition.  

The results of the choice modelling can be seen here: https://github.com/alexmitrani/Repeatr/blob/main/fugazi_song_choice_model.csv

The parameters related to the age of the songs support the hypothesis that recent material tended to be favoured in the band's choices of songs to be performed. 

The implied preferences for each song can be viewed as a ranked table in descending order of preference here: https://github.com/alexmitrani/Repeatr/blob/main/fugazi_song_preferences.csv

Thanks. 
