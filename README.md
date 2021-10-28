# Repeatr

## ["I had a name, but now I'm a number"](https://fugazi.bandcamp.com/track/repeater)

R code for analysis of Fugazi Live Series metadata: https://www.dischord.com/fugazi_live_series

The initial data was provided by Ian James Wright of the Alphabetical Fugazi podcast and was probably extracted from the Fugazi Live Series website with fugotcha: https://github.com/universalhandle/fugotcha

## Song counts

Performance counts were calculated for all the released Fugazi songs that were performed live, using data from 896 shows from FLS0001 up to and including FLS1045. 

These frequency counts do not necessarily measure the band's preferences for the songs, as more recently released songs were available for fewer shows than older songs.  

The results of this analysis, in descending order of performance count, can be viewed here: https://github.com/alexmitrani/Repeatr/blob/main/fugazi_song_counts.csv

## Performance intensity

A slightly more detailed analysis was undertaken by calculating the performance intensity of each song.  

Song performance intensity = number of times a song was played / number of shows at which it was available in the repertoire.  

A song was considered available in the repertoire from the first show it was performed.  

The results of this analysis can be viewed here: https://github.com/alexmitrani/Repeatr/blob/main/fugazi_song_performance_intensity.csv

The "songid" variable indicates the raw frequency ranking of each song, allowing easy comparison between the intensity and frequency measures.  

## Song preferences

The Fugazi Live Series data includes 17297 choices of songs made by the band during their live shows. This data was used to estimate the strength of preference for each of the songs in their live music repertoire. 

Song availability was considered at both repertoire and gig level. Songs were only considered available from the time they were first played, but thereafter they were assumed to be always available. There is some evidence that certain songs were discontinued but this has not been represented here.
> "To the guy who is yelling for Steady Diet, I got bad news for you. Every time before we go out for a tour, we take a week to go through every record that we've done, and we relearn every song and we make sure that we know everything, because we make up the sets as we go, and we relearn everything so we can play anything at anytime... but there's three songs that we have not been able to remember how to play, one of them is Steady Diet, I am sorry to say, the other is Polish, and the other one, I can't remember the name of, but basically, you can call out anything else, but if you call out Steady Diet, you are wasting your breath" - Guy Picciotto 6/27/2001
Source: https://www.dischord.com/fugazi_live_series/minneapolis-mn-usa-62701

Within any given gig, the songs were sorted in the order that they were performed, and once a song had been played it was assumed to be unavailable for the rest of the gig.  

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

The strength of preference for each song was represented using a dummy variable (on/off) for each song, such that the parameters associated with these variables would represent the strength of preference for each song.  The dummy variable for "Waiting Room" was omitted and therefore the preference parameter for this song was zero by definition.  

The results of the choice modelling can be seen here: https://github.com/alexmitrani/Repeatr/blob/main/fugazi_song_choice_model.csv

The parameters related to the age of the songs support the hypothesis that recent material tended to be favoured in the band's choices of songs to be performed. 

The implied preferences for each song can be viewed as a ranked table in descending order of preference here: https://github.com/alexmitrani/Repeatr/blob/main/fugazi_song_preferences.csv

It is hard to say exactly whose preferences are represented by these results. It seems reasonable to assume that they mainly represent the band's preferences, but the preferences of the audience may also have influenced the choice of the songs that were performed, directly or indirectly. 

## ["Do you like me?"](https://fugazi.bandcamp.com/track/do-you-like-me)

The following table shows ratings based on the preferences described in the section above, together with the indicators described in previous sections: performance counts and intensities. The ratings are simply the preferences normalised in such a way that the highest preference has a value of 1 and the lowest a value of 0. This way it will be easy to scale these values for comparison with ratings defined on other intervals. 

| songid|song                         |launchdate | chosen shows| available shows| performance intensity|    rating|
|------:|:----------------------------|:----------|------:|------------:|---------:|---------:|
|     18|bed for the scraping         |1994-11-20 |    299|          376| 0.7952128| 1.0000000|
|      2|reclamation                  |1990-05-05 |    594|          793| 0.7490542| 0.9964776|
|     42|break                        |1996-08-15 |    170|          228| 0.7456140| 0.9960931|
|     24|do you like me               |1994-11-20 |    272|          376| 0.7234043| 0.9675560|
|     44|closed captioned             |1997-06-18 |    158|          198| 0.7979798| 0.9466616|
|     71|cashout                      |2000-09-30 |     59|           65| 0.9076923| 0.9379809|
|     56|place position               |1996-08-15 |    133|          228| 0.5833333| 0.9268735|
|     29|target                       |1994-08-15 |    261|          384| 0.6796875| 0.9160465|
|      1|waiting room                 |1987-09-03 |    628|          895| 0.7016760| 0.9129793|
|     49|recap modotti                |1997-05-03 |    141|          206| 0.6844660| 0.9114281|
|     64|number 5                     |1998-11-21 |    109|          144| 0.7569444| 0.8900775|
|      3|blueprint                    |1989-11-25 |    585|          823| 0.7108141| 0.8898510|
|      7|sieve-fisted find            |1989-04-05 |    417|          849| 0.4911661| 0.8799527|
|      5|merchandise                  |1987-09-03 |    474|          895| 0.5296089| 0.8773395|
|     14|rend it                      |1991-12-08 |    347|          583| 0.5951973| 0.8749417|
|     46|arpeggiator                  |1997-05-02 |    154|          207| 0.7439614| 0.8640444|
|     37|birthday pony                |1994-08-15 |    200|          384| 0.5208333| 0.8489271|
|     19|facet squared                |1991-08-12 |    298|          619| 0.4814216| 0.8455313|
|      6|margin walker                |1988-08-01 |    426|          868| 0.4907834| 0.8437293|
|      9|turnover                     |1989-04-09 |    392|          845| 0.4639053| 0.8390819|
|     70|argument                     |1999-08-26 |     66|          100| 0.6600000| 0.8334513|
|      4|long division                |1989-04-09 |    497|          845| 0.5881657| 0.8315490|
|     77|the kill                     |2001-04-05 |     35|           57| 0.6140351| 0.8313177|
|     28|public witness program       |1993-02-05 |    262|          512| 0.5117188| 0.8296761|
|     68|oh                           |1998-11-29 |     78|          136| 0.5735294| 0.8242374|
|     59|fd                           |1997-05-02 |    115|          207| 0.5555556| 0.8161193|
|     36|forensic scene               |1994-08-19 |    201|          382| 0.5261780| 0.8142840|
|     32|by you                       |1993-04-24 |    232|          476| 0.4873950| 0.8079431|
|     63|five corporations            |1996-08-15 |    110|          228| 0.4824561| 0.8069879|
|     30|smallpox champion            |1992-10-23 |    251|          515| 0.4873786| 0.8060508|
|     11|and the same                 |1987-09-26 |    374|          894| 0.4183445| 0.8051818|
|     65|floating boy                 |1996-10-16 |    107|          226| 0.4734513| 0.8025946|
|     25|instrument                   |1992-01-25 |    271|          581| 0.4664372| 0.7942927|
|     26|great cop                    |1991-12-08 |    268|          583| 0.4596913| 0.7782747|
|     73|ex-spectator                 |1999-08-26 |     46|          100| 0.4600000| 0.7768404|
|     17|song #1                      |1987-09-03 |    318|          895| 0.3553073| 0.7727203|
|     87|life and limb                |2001-06-21 |     20|           43| 0.4651163| 0.7718559|
|     12|two beats off                |1989-05-03 |    369|          843| 0.4377224| 0.7716944|
|     13|give me the cure             |1988-03-30 |    365|          882| 0.4138322| 0.7716718|
|     85|full disclosure              |2001-04-05 |     24|           57| 0.4210526| 0.7630049|
|      8|repeater                     |1989-07-20 |    408|          835| 0.4886228| 0.7623773|
|     20|styrofoam                    |1990-05-17 |    288|          786| 0.3664122| 0.7538548|
|     82|epic problem                 |2000-10-01 |     30|           64| 0.4687500| 0.7530387|
|     15|suggestion                   |1987-12-03 |    338|          890| 0.3797753| 0.7520482|
|     67|no surprise                  |1996-09-29 |     89|          227| 0.3920705| 0.7498440|
|     10|promises                     |1988-10-15 |    376|          864| 0.4351852| 0.7483538|
|     52|back to base                 |1994-11-20 |    135|          376| 0.3590426| 0.7372080|
|     22|exit only                    |1990-07-06 |    275|          753| 0.3652058| 0.7343260|
|     21|bad mouth                    |1987-10-16 |    276|          892| 0.3094170| 0.7341205|
|     16|shut the door                |1989-04-05 |    321|          849| 0.3780919| 0.7316100|
|     75|nightshop                    |1999-08-26 |     43|          100| 0.4300000| 0.7284929|
|     31|sweet and low                |1992-05-15 |    247|          562| 0.4395018| 0.7268820|
|     27|runaway return               |1990-02-11 |    264|          815| 0.3239264| 0.7035303|
|     62|downed city                  |1994-11-20 |    111|          376| 0.2952128| 0.6851303|
|     33|bulldog front                |1988-06-15 |    223|          871| 0.2560276| 0.6812220|
|     50|walken's syndrome            |1992-10-23 |    141|          515| 0.2737864| 0.6812211|
|     23|reprovisional                |1988-12-29 |    275|          850| 0.3235294| 0.6797068|
|     54|fell, destroyed              |1993-08-16 |    134|          448| 0.2991071| 0.6773552|
|     88|strangelight                 |2001-04-06 |     19|           56| 0.3392857| 0.6746056|
|     61|long distance runner         |1994-11-27 |    112|          375| 0.2986667| 0.6718096|
|     41|cassavetes                   |1991-07-28 |    171|          630| 0.2714286| 0.6691617|
|     35|burning too                  |1988-08-01 |    212|          868| 0.2442396| 0.6668194|
|     69|pink frosty                  |1996-03-20 |     67|          250| 0.2680000| 0.6648789|
|     34|burning                      |1988-02-06 |    212|          885| 0.2395480| 0.6635368|
|     55|returning the screw          |1992-10-23 |    134|          515| 0.2601942| 0.6616635|
|     39|latin roots                  |1990-10-01 |    181|          727| 0.2489684| 0.6571414|
|     38|greed                        |1989-04-05 |    187|          849| 0.2202591| 0.6501860|
|     48|dear justice letter          |1991-01-02 |    148|          692| 0.2138728| 0.6299151|
|     47|stacks                       |1991-02-15 |    153|          689| 0.2220610| 0.6231801|
|     72|caustic acrostic             |1996-01-30 |     51|          253| 0.2015810| 0.6220693|
|     51|last chance for a slow dance |1991-07-28 |    137|          630| 0.2174603| 0.6113023|
|     43|lockdown                     |1987-12-03 |    162|          890| 0.1820225| 0.6010230|
|     45|brendan #1                   |1989-04-05 |    156|          849| 0.1837456| 0.6007415|
|     40|kyeo                         |1987-10-07 |    173|          893| 0.1937290| 0.5929079|
|     60|nice new outfit              |1991-02-20 |    114|          688| 0.1656977| 0.5727268|
|     79|foreman's dog                |1998-05-01 |     33|          175| 0.1885714| 0.5664755|
|     53|break-in                     |1987-10-16 |    134|          892| 0.1502242| 0.5576295|
|     58|joe #1                       |1987-09-03 |    130|          895| 0.1452514| 0.5493203|
|     80|guilford fall                |1996-08-15 |     32|          228| 0.1403509| 0.5434675|
|     57|glueman                      |1988-05-12 |    132|          879| 0.1501706| 0.5341219|
|     66|furniture                    |1987-09-03 |     93|          895| 0.1039106| 0.4913799|
|     76|latest disgrace              |1994-11-20 |     39|          376| 0.1037234| 0.4759941|
|     78|version                      |1994-08-27 |     34|          377| 0.0901857| 0.4332234|
|     74|steady diet                  |1991-04-12 |     46|          671| 0.0685544| 0.3969106|
|     86|combination lock             |1994-11-27 |     21|          375| 0.0560000| 0.3533454|
|     83|23 beats off                 |1992-10-23 |     26|          515| 0.0504854| 0.3326143|
|     92|hello morning                |2001-04-27 |      2|           44| 0.0454545| 0.2831070|
|     81|the word                     |1987-09-03 |     32|          895| 0.0357542| 0.2597231|
|     84|in defense of humans         |1987-09-03 |     25|          895| 0.0279330| 0.2300088|
|     89|turn off your guns           |1987-09-03 |     15|          895| 0.0167598| 0.1340617|
|     90|provisional                  |1988-11-14 |      8|          859| 0.0093132| 0.0060839|
|     91|polish                       |1991-03-06 |      6|          683| 0.0087848| 0.0000000|

The data used in the above table can be found here: https://github.com/alexmitrani/Repeatr/blob/main/summary.csv

## Ratings applied to studio releases and compared to RYM ratings

As a check on whether the song ratings make sense they were used to calculate average ratings for the band's studio releases and these were compared to the average ratings for the same releases at [https://rateyourmusic.com/artist/fugazi](https://web.archive.org/web/20210211085323/https://rateyourmusic.com/artist/fugazi), as at the 11 February 2021.  The results are shown below.   

|release                | releaseid|releasedate | songs_rated|    average rating| rym_rating|
|:----------------------|---------:|:-----------|-----------:|---------:|----------:|
|the argument           |         9|2001-10-11  |          10| 0.7894826|      0.778|
|end hits               |         8|1998-04-27  |          13| 0.7859644|      0.734|
|repeater               |         4|1990-03-20  |          11| 0.7669451|      0.774|
|red medicine           |         7|1995-08-14  |          13| 0.7222171|      0.762|
|fugazi                 |         1|1988-11-19  |           7| 0.7213858|      0.796|
|in on the killtaker    |         6|1993-06-30  |          12| 0.7176343|      0.756|
|3 songs                |         3|1990-01-15  |           3| 0.6265567|      0.656|
|steady diet of nothing |         5|1991-07-15  |          11| 0.6126059|      0.708|
|margin walker          |         2|1989-06-15  |           6| 0.6118652|      0.744|
|furniture              |        10|2001-10-15  |           3| 0.5548548|      0.734|

Although many of the ratings are similar in magnitude, there are clearly some differences. There is more variation in the ratings that have been calculated using the FLS data compared to the RYM ratings, and the lowest FSL ratings are considerably lower than the lowest RYM ratings.   Differences such as these were to be expected.  The FSL ratings were calculated in a consistent way, based largely on the real choices of the band regarding which songs to play at shows, and the band actually played the songs they chose to a live audience!  The RYM ratings were from larger groups of people, not necessarily the same people in each case, who were simply expressing how much they liked or disliked the music, with no restrictions and no consequences.   

## The End

I hope you have found this interesting.  If you want to recreate the analysis, this should be possible by running [Repeatr.R](https://github.com/alexmitrani/Repeatr/blob/main/Repeatr.R) after installing the various libraries that are listed at the top of the file. It is recommended to use a machine with 16 GB RAM or more to run the choice model.

If you have any comments or suggestions please feel to add an issue to this repository.  

Thanks. 
