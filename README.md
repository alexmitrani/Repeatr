# Repeatr

## "I had a name, but now I'm a number" - Repeater by Fugazi (https://fugazi.bandcamp.com/track/repeater)

R code for analysis of Fugazi Live Series metadata: https://www.dischord.com/fugazi_live_series

The initial data was provided by Ian James Wright of the Alphabetical Fugazi podcast and was probably extracted from the Fugazi Live Series website with fugotcha: https://github.com/universalhandle/fugotcha

## Song counts

The code generates performance counts of all released Fugazi songs, in descending order, based on data from 1048 shows up to and including FLS1045. 

The frequency counts do not necessarily measure the band's preferences for the songs, as more recently released songs were available for fewer shows than older songs.  

The results of this analysis can be viewed here: https://github.com/alexmitrani/Repeatr/blob/main/fugazi_song_counts.csv

## Performance intensity

A slightly more detailed analysis was undertaken by calculating the performance intensity of each song.  

Song performance intensity = number of times a song was played / number of shows at which it was available in the repertoire.  

A song was considered available in the repertoire from the first show it was performed.  

The results of this analysis can be viewed here: https://github.com/alexmitrani/Repeatr/blob/main/fugazi_song_performance_intensity.csv

The "songid" variable indicates the raw frequency ranking of each song, allowing easy comparison between the intensity and frequency measures.  

Thanks. 
