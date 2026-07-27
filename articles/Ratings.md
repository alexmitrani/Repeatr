# Ratings

## Introduction

This article outlines the process by which song ratings were calculated
using the [Fugazi Live
Series](https://www.dischord.com/fugazi_live_series) metadata.

## Song counts

Performance counts were calculated for all the released Fugazi songs
that were performed live, using data from … how many shows?

``` r

one_row_per_show <- Repeatr1 %>% group_by(gid) %>% slice(1) %>% ungroup()
nrow(one_row_per_show)
#> [1] 953
```

These frequency counts do not necessarily measure the band’s preferences
for the songs, as more recently released songs were available for fewer
shows than older songs.

The results of this analysis, in descending order of performance count,
are as follows:

``` r

fugazi_song_counts <- fugazi_song_counts %>%
  arrange(desc(count))
knitr::kable(fugazi_song_counts, "pipe")
```

| songid | song                         | launchdate | count |
|-------:|:-----------------------------|:-----------|------:|
|     92 | waiting room                 | 1994-08-27 |   675 |
|     69 | reclamation                  | 1997-05-01 |   612 |
|      9 | blueprint                    | 1989-09-23 |   608 |
|     53 | long division                | 1989-04-09 |   523 |
|     55 | merchandise                  | 1987-09-03 |   495 |
|     54 | margin walker                | 1988-07-28 |   467 |
|     76 | sieve-fisted find            | 1989-03-24 |   435 |
|     71 | repeater                     | 1991-12-08 |   427 |
|     89 | turnover                     | 1987-09-03 |   416 |
|     37 | give me the cure             | 1988-03-30 |   401 |
|      2 | and the same                 | 1987-09-26 |   397 |
|     65 | promises                     | 1988-10-15 |   392 |
|     90 | two beats off                | 1989-04-09 |   392 |
|     83 | suggestion                   | 1989-07-19 |   373 |
|     70 | rend it                      | 1990-05-05 |   354 |
|     78 | song \#1                     | 1992-10-23 |   353 |
|     75 | shut the door                | 1990-02-11 |   342 |
|      6 | bad mouth                    | 1987-10-16 |   312 |
|      7 | bed for the scraping         | 1994-11-20 |   310 |
|     28 | facet squared                | 1991-08-12 |   307 |
|     82 | styrofoam                    | 2001-04-06 |   294 |
|     72 | reprovisional                | 1989-07-19 |   284 |
|     23 | do you like me               | 1994-11-20 |   282 |
|     27 | exit only                    | 1990-07-06 |   282 |
|     44 | instrument                   | 1992-01-25 |   282 |
|     39 | great cop                    | 1991-12-08 |   277 |
|     67 | public witness program       | 1988-11-14 |   273 |
|     74 | runaway return               | 1992-10-23 |   273 |
|     85 | target                       | 1992-05-15 |   267 |
|     77 | smallpox champion            | 1989-03-24 |   265 |
|     84 | sweet and low                | 1987-12-03 |   254 |
|     13 | bulldog front                | 1988-06-15 |   249 |
|     14 | burning                      | 1988-02-06 |   243 |
|     15 | burning too                  | 1988-07-28 |   238 |
|     16 | by you                       | 1993-04-24 |   236 |
|      8 | birthday pony                | 1994-08-15 |   203 |
|     34 | forensic scene               | 1994-08-19 |   203 |
|     40 | greed                        | 1989-03-24 |   199 |
|     49 | latin roots                  | 1990-10-01 |   187 |
|     51 | lockdown                     | 1987-12-03 |   184 |
|     46 | kyeo                         | 1987-10-07 |   183 |
|     18 | cassavetes                   | 1991-07-28 |   180 |
|     10 | break                        | 1996-08-15 |   179 |
|     12 | brendan \#1                  | 1989-03-24 |   170 |
|     20 | closed captioned             | 1997-06-18 |   169 |
|      4 | arpeggiator                  | 1997-05-02 |   163 |
|     79 | stacks                       | 1987-09-03 |   156 |
|     22 | dear justice letter          | 1991-01-02 |   152 |
|     68 | recap modotti                | 1993-02-05 |   151 |
|     38 | glueman                      | 1988-05-07 |   148 |
|     93 | walken’s syndrome            | 1987-09-03 |   147 |
|     11 | break-in                     | 1987-10-16 |   146 |
|      5 | back to base                 | 1994-11-20 |   142 |
|     62 | place position               | 1996-08-15 |   140 |
|     47 | last chance for a slow dance | 1991-07-28 |   138 |
|     73 | returning the screw          | 1988-12-29 |   138 |
|     45 | joe \#1                      | 1987-09-03 |   136 |
|     30 | fell, destroyed              | 1993-08-16 |   135 |
|     29 | fd                           | 1997-05-02 |   122 |
|     59 | number 5                     | 1998-11-21 |   120 |
|     56 | nice new outfit              | 1991-02-20 |   119 |
|     24 | downed city                  | 1994-11-20 |   116 |
|     52 | long distance runner         | 1994-11-27 |   114 |
|     31 | five corporations            | 1996-08-15 |   113 |
|     36 | furniture                    | 1987-09-03 |   108 |
|     32 | floating boy                 | 1996-10-16 |   107 |
|     58 | no surprise                  | 1996-09-29 |    97 |
|     60 | oh                           | 1998-11-29 |    91 |
|      3 | argument                     | 1999-08-26 |    76 |
|     61 | pink frosty                  | 1996-03-20 |    69 |
|     17 | cashout                      | 2000-06-04 |    67 |
|     19 | caustic acrostic             | 1996-01-30 |    53 |
|     26 | ex-spectator                 | 1999-08-26 |    52 |
|     57 | nightshop                    | 1999-08-26 |    46 |
|     80 | steady diet                  | 1991-02-15 |    46 |
|     48 | latest disgrace              | 1994-11-20 |    39 |
|     86 | the kill                     | 1994-08-15 |    37 |
|     87 | the word                     | 2001-04-05 |    37 |
|     91 | version                      | 1989-05-03 |    36 |
|     25 | epic problem                 | 2000-08-07 |    34 |
|     33 | foreman’s dog                | 1998-05-01 |    34 |
|     41 | guilford fall                | 1996-08-15 |    32 |
|     43 | in defense of humans         | 1987-09-03 |    31 |
|     35 | full disclosure              | 2001-04-05 |    29 |
|      1 | 23 beats off                 | 1992-10-23 |    27 |
|     50 | life and limb                | 2001-06-21 |    24 |
|     21 | combination lock             | 1994-11-27 |    21 |
|     81 | strangelight                 | 1991-04-12 |    19 |
|     88 | turn off your guns           | 1987-09-03 |    17 |
|     66 | provisional                  | NA         |    13 |
|     63 | polish                       | 1991-03-06 |     6 |
|     64 | preprovisional               | 1988-10-31 |     6 |
|     42 | hello morning                | 2001-04-27 |     2 |
|     94 | world beat                   | 1992-10-23 |     2 |

## Performance intensity

A slightly more detailed analysis was undertaken by calculating the
performance intensity of each song.

Song performance intensity = number of times a song was played / number
of shows at which it was available in the repertoire.

A song was considered available in the repertoire from the first show it
was performed.

The results of this analysis look like this:

``` r

knitr::kable(fugazi_song_performance_intensity, "pipe")
```

| songid | song                         | launchdate | chosen | available_rl | intensity |
|-------:|:-----------------------------|:-----------|-------:|-------------:|----------:|
|     17 | cashout                      | 2000-06-04 |     67 |           74 | 0.9054054 |
|     20 | closed captioned             | 1997-06-18 |    169 |          211 | 0.8009479 |
|      7 | bed for the scraping         | 1994-11-20 |    310 |          393 | 0.7888041 |
|     59 | number 5                     | 1998-11-21 |    120 |          157 | 0.7643312 |
|     70 | reclamation                  | NA         |    612 |          820 | 0.7463415 |
|      4 | arpeggiator                  | 1997-05-02 |    163 |          220 | 0.7409091 |
|     10 | break                        | 1996-08-15 |    179 |          244 | 0.7336066 |
|     23 | do you like me               | 1994-11-20 |    282 |          393 | 0.7175573 |
|     93 | waiting room                 | NA         |    675 |          952 | 0.7090336 |
|      9 | blueprint                    | 1989-09-23 |    608 |          873 | 0.6964490 |
|     69 | recap modotti                | NA         |    151 |          221 | 0.6832579 |
|      3 | argument                     | 1999-08-26 |     76 |          113 | 0.6725664 |
|     86 | target                       | NA         |    267 |          401 | 0.6658354 |
|     60 | oh                           | 1998-11-29 |     91 |          149 | 0.6107383 |
|     87 | the kill                     | NA         |     37 |           62 | 0.5967742 |
|     53 | long division                | 1989-04-09 |    523 |          889 | 0.5883015 |
|     71 | rend it                      | NA         |    354 |          608 | 0.5822368 |
|     62 | place position               | 1996-08-15 |    140 |          244 | 0.5737705 |
|     29 | fd                           | 1997-05-02 |    122 |          220 | 0.5545455 |
|     55 | merchandise                  | 1987-09-03 |    495 |          952 | 0.5199580 |
|     68 | public witness program       | NA         |    273 |          534 | 0.5112360 |
|     50 | life and limb                | 2001-06-21 |     24 |           47 | 0.5106383 |
|     34 | forensic scene               | 1994-08-19 |    203 |          399 | 0.5087719 |
|     54 | margin walker                | 1988-07-28 |    467 |          921 | 0.5070575 |
|      8 | birthday pony                | 1994-08-15 |    203 |          401 | 0.5062344 |
|     78 | smallpox champion            | NA         |    265 |          537 | 0.4934823 |
|     72 | repeater                     | NA         |    427 |          876 | 0.4874429 |
|     77 | sieve-fisted find            | NA         |    435 |          894 | 0.4865772 |
|     28 | facet squared                | 1991-08-12 |    307 |          645 | 0.4759690 |
|     16 | by you                       | 1993-04-24 |    236 |          498 | 0.4738956 |
|     25 | epic problem                 | 2000-08-07 |     34 |           72 | 0.4722222 |
|     90 | turnover                     | NA         |    416 |          889 | 0.4679415 |
|     35 | full disclosure              | 2001-04-05 |     29 |           62 | 0.4677419 |
|     44 | instrument                   | 1992-01-25 |    282 |          606 | 0.4653465 |
|     31 | five corporations            | 1996-08-15 |    113 |          244 | 0.4631148 |
|     26 | ex-spectator                 | 1999-08-26 |     52 |          113 | 0.4601770 |
|     39 | great cop                    | 1991-12-08 |    277 |          608 | 0.4555921 |
|     32 | floating boy                 | 1996-10-16 |    107 |          242 | 0.4421488 |
|     91 | two beats off                | NA         |    392 |          887 | 0.4419391 |
|     85 | sweet and low                | NA         |    254 |          585 | 0.4341880 |
|     65 | promises                     | 1988-10-15 |    392 |          916 | 0.4279476 |
|     37 | give me the cure             | 1988-03-30 |    401 |          939 | 0.4270501 |
|      2 | and the same                 | 1987-09-26 |    397 |          951 | 0.4174553 |
|     57 | nightshop                    | 1999-08-26 |     46 |          113 | 0.4070796 |
|     58 | no surprise                  | 1996-09-29 |     97 |          243 | 0.3991770 |
|     84 | suggestion                   | NA         |    373 |          947 | 0.3938754 |
|     76 | shut the door                | NA         |    342 |          894 | 0.3825503 |
|     79 | song \#1                     | NA         |    353 |          952 | 0.3707983 |
|     27 | exit only                    | 1990-07-06 |    282 |          780 | 0.3615385 |
|      5 | back to base                 | 1994-11-20 |    142 |          393 | 0.3613232 |
|     83 | styrofoam                    | NA         |    294 |          876 | 0.3356164 |
|      6 | bad mouth                    | 1987-10-16 |    312 |          949 | 0.3287671 |
|     75 | runaway return               | NA         |    273 |          845 | 0.3230769 |
|     73 | reprovisional                | NA         |    284 |          896 | 0.3169643 |
|     82 | strangelight                 | NA         |     19 |           61 | 0.3114754 |
|     24 | downed city                  | 1994-11-20 |    116 |          393 | 0.2951654 |
|     52 | long distance runner         | 1994-11-27 |    114 |          392 | 0.2908163 |
|     30 | fell, destroyed              | 1993-08-16 |    135 |          467 | 0.2890792 |
|     18 | cassavetes                   | 1991-07-28 |    180 |          656 | 0.2743902 |
|     94 | walken’s syndrome            | NA         |    147 |          537 | 0.2737430 |
|     13 | bulldog front                | 1988-06-15 |    249 |          925 | 0.2691892 |
|     61 | pink frosty                  | 1996-03-20 |     69 |          266 | 0.2593985 |
|     15 | burning too                  | 1988-07-28 |    238 |          921 | 0.2584148 |
|     14 | burning                      | 1988-02-06 |    243 |          942 | 0.2579618 |
|     74 | returning the screw          | NA         |    138 |          537 | 0.2569832 |
|     49 | latin roots                  | 1990-10-01 |    187 |          753 | 0.2483400 |
|     40 | greed                        | 1989-03-24 |    199 |          894 | 0.2225951 |
|     80 | stacks                       | NA         |    156 |          715 | 0.2181818 |
|     22 | dear justice letter          | 1991-01-02 |    152 |          718 | 0.2116992 |
|     47 | last chance for a slow dance | 1991-07-28 |    138 |          656 | 0.2103659 |
|     19 | caustic acrostic             | 1996-01-30 |     53 |          269 | 0.1970260 |
|     51 | lockdown                     | 1987-12-03 |    184 |          947 | 0.1942978 |
|     46 | kyeo                         | 1987-10-07 |    183 |          950 | 0.1926316 |
|     12 | brendan \#1                  | 1989-03-24 |    170 |          894 | 0.1901566 |
|     33 | foreman’s dog                | 1998-05-01 |     34 |          188 | 0.1808511 |
|     56 | nice new outfit              | 1991-02-20 |    119 |          714 | 0.1666667 |
|     38 | glueman                      | 1988-05-07 |    148 |          935 | 0.1582888 |
|     11 | break-in                     | 1987-10-16 |    146 |          949 | 0.1538462 |
|     45 | joe \#1                      | 1987-09-03 |    136 |          952 | 0.1428571 |
|     41 | guilford fall                | 1996-08-15 |     32 |          244 | 0.1311475 |
|     36 | furniture                    | 1987-09-03 |    108 |          952 | 0.1134454 |
|     48 | latest disgrace              | 1994-11-20 |     39 |          393 | 0.0992366 |
|     92 | version                      | NA         |     36 |          394 | 0.0913706 |
|     81 | steady diet                  | NA         |     46 |          697 | 0.0659971 |
|     21 | combination lock             | 1994-11-27 |     21 |          392 | 0.0535714 |
|      1 | 23 beats off                 | 1992-10-23 |     27 |          537 | 0.0502793 |
|     42 | hello morning                | 2001-04-27 |      2 |           48 | 0.0416667 |
|     88 | the word                     | NA         |     37 |          952 | 0.0388655 |
|     43 | in defense of humans         | 1987-09-03 |     31 |          952 | 0.0325630 |
|     89 | turn off your guns           | NA         |     17 |          952 | 0.0178571 |
|     67 | provisional                  | NA         |     13 |          907 | 0.0143330 |
|     63 | polish                       | 1991-03-06 |      6 |          709 | 0.0084626 |
|     95 | world beat                   | NA         |      2 |          269 | 0.0074349 |
|     64 | preprovisional               | 1988-10-31 |      6 |          911 | 0.0065862 |
|     66 | promises bit                 | NA         |      0 |            0 |       NaN |

The “songid” variable indicates the raw frequency ranking of each song,
allowing easy comparison between the intensity and frequency measures.

## Song preferences

> “We played without a setlist from the first show to the last show,”
> Picciotto said. “We never had a program for the night before we hit
> the stage. Right before we went on stage we’d get together and decide
> on a song to start with. From then on, we were basically improvising
> the set as we went.” - [Guy Picciotto
> 25/5/2018](https://www.abc.net.au/doublej/music-reads/features/fugazi-the-past-the-future-and-the-ethos-that-drove-them/10265848)

It is only possible to estimate a choice model from the Fugazi Live
Series data because of the way that the songs were chosen quite freely
as each show was performed. If fixed set lists had been used for many
shows this sort of analysis probably would not be possible.

The Fugazi Live Series data includes … how many choices of songs made by
the band during their live shows?

``` r

nrow(Repeatr1)
#> [1] 24578
```

This data was used to estimate the strength of preference for each of
the songs in their live music repertoire.

Song availability was considered at both repertoire and gig level. Songs
were only considered available from the time they were first played, but
thereafter they were assumed to be always available. There is some
evidence that certain songs were discontinued but this has not been
represented here.

> “To the guy who is yelling for Steady Diet, I got bad news for you.
> Every time before we go out for a tour, we take a week to go through
> every record that we’ve done, and we relearn every song and we make
> sure that we know everything, because we make up the sets as we go,
> and we relearn everything so we can play anything at anytime… but
> there’s three songs that we have not been able to remember how to
> play, one of them is Steady Diet, I am sorry to say, the other is
> Polish, and the other one, I can’t remember the name of, but
> basically, you can call out anything else, but if you call out Steady
> Diet, you are wasting your breath” - [Guy Picciotto
> 27/6/2001](https://www.dischord.com/fugazi_live_series/minneapolis-mn-usa-62701)

Within any given gig, the songs were sorted in the order that they were
performed, and once a song had been played it was assumed to be
unavailable for the rest of the gig. Interestingly, there were a few
exceptions to this rule. One was [a 1991 gig in Birmingham,
Alabama](https://www.dischord.com/fugazi_live_series/birmingham-al-usa-52191),
where the show notes comment “Featuring the one-time attempt of our ‘Two
for Tuesday’ gag. No one appeared to notice, so we shelved the idea.” On
that occasion, the song “Greed” was played twice. Another case was [a
1998 gig in Richmond,
Virginia](https://www.dischord.com/fugazi_live_series/richmond-va-usa-51198)
where “Great Cop” was played twice due to a specific situation.

The age of the songs needs considering because bands generally
prioritise new material when they play live and Fugazi was no exception
to this. Dummy variables (on/off) were used to represent the age of the
songs at the time of each gig, as follows:

| Age (years)   | Dummy variable |
|---------------|----------------|
| 0 \< age \< 1 | (omitted)      |
| 1 ≤ age \< 2  | yearsold_1     |
| 2 ≤ age \< 3  | yearsold_2     |
| 3 ≤ age \< 4  | yearsold_3     |
| 4 ≤ age \< 5  | yearsold_4     |
| 5 ≤ age \< 6  | yearsold_5     |
| 6 ≤ age \< 7  | yearsold_6     |
| 7 ≤ age \< 8  | yearsold_7     |
| 8 ≤ age       | yearsold_8     |

The above categories were defined after some experimentation to
establish which categories deserved separate representation and which
could be grouped together. The “less than a year old” variable was
omitted because it is always necessary to omit one of each set of dummy
variables in this type of model. An omitted dummy variable has a
parameter of zero by definition and provides a reference point for the
parameters whose values are estimated.

A dummy variable (on/off) was defined for each song, such that the
corresponding parameters would represent the strength of preference for
playing each song live. The dummy variable for ‘23 Beats Off’ was
omitted and therefore the preference parameter for this song was zero by
definition.  
The formula used for the preferred model was this one:

choice ~ yearsold_1 + yearsold_2 + yearsold_3 + yearsold_4 +
yearsold_5 + yearsold_6 + yearsold_7 + yearsold_8 + song2 + … + song92

The model was fitted by an optimisation process which estimated a
parameter for each of the independent variables, such that the
likelihood of correctly predicting the observed choices would be
maximised.

The parameters related to the age of the songs support the hypothesis
that recent material tended to be favoured in the band’s choices of
songs to be performed.

The implied preferences for each song are shown here in descending order
of preference:

``` r


myresults <- fugazi_song_preferences %>%
  arrange(desc(Estimate))
knitr::kable((myresults), "pipe")
```

| rank_rating | songid | song         | Estimate | z-value |
|------------:|-------:|:-------------|---------:|:--------|
|           1 |      1 | 23 beats off |        0 | NA      |

It is hard to say exactly whose preferences are represented by these
results. It seems reasonable to assume that they mainly represent the
band’s preferences, more often than not Ian MacKaye and Guy Picciotto,
but the preferences of the audience may also have influenced the choice
of the songs that were performed, directly or indirectly.

> “We played without a setlist from the first show to the last show. We
> never had a program for the night before we hit the stage. Right
> before we went on stage we’d get together and decide on a song to
> start with. From then on, we were basically improvising the set as we
> went. That meant, before we went on tour, we had to have these
> insanely long rehearsals where we relearned very piece of music that
> we knew so that everyone was ready. So, every night was completely
> different show. You could pick from over 100 songs. The only
> methodology we had was that we alternated singing. Once Ian was
> wrapping up his song, I knew that I had to have a song ready to go for
> my thing.” - Guy Picciotto, 25/5/2018 Source:
> <https://web.archive.org/web/20201123023401/https://www.abc.net.au/doublej/music-reads/features/fugazi-the-past-the-future-and-the-ethos-that-drove-them/10265848>

## [“Do you like me?”](https://fugazi.bandcamp.com/track/do-you-like-me)

The following table shows ratings based on the preferences described in
the section above, together with the indicators described in previous
sections: performance counts and intensities. The ratings are simply the
preferences normalised in such a way that the highest preference has a
value of 1 and the lowest a value of 0. This way it will be easy to
scale these values for comparison with ratings defined on other
intervals.

``` r

knitr::kable(summary %>% select(song, chosen, intensity, rating) %>% arrange(desc(rating)), "pipe")
```

| song                         | chosen | intensity | rating |
|:-----------------------------|-------:|----------:|-------:|
| bulldog front                |    249 | 0.2691892 |     NA |
| bad mouth                    |    312 | 0.3287671 |     NA |
| burning                      |    243 | 0.2579618 |     NA |
| give me the cure             |    401 | 0.4270501 |     NA |
| glueman                      |    148 | 0.1582888 |     NA |
| margin walker                |    467 | 0.5070575 |     NA |
| and the same                 |    397 | 0.4174553 |     NA |
| burning too                  |    238 | 0.2584148 |     NA |
| lockdown                     |    184 | 0.1942978 |     NA |
| promises                     |    390 | 0.4257642 |     NA |
| joe \#1                      |    136 | 0.1428571 |     NA |
| break-in                     |    146 | 0.1538462 |     NA |
| brendan \#1                  |    170 | 0.1901566 |     NA |
| merchandise                  |    495 | 0.5199580 |     NA |
| blueprint                    |    608 | 0.6964490 |     NA |
| greed                        |    199 | 0.2225951 |     NA |
| exit only                    |    282 | 0.3615385 |     NA |
| nice new outfit              |    119 | 0.1666667 |     NA |
| latin roots                  |    187 | 0.2483400 |     NA |
| long division                |    523 | 0.5883015 |     NA |
| polish                       |      6 | 0.0084626 |     NA |
| dear justice letter          |    152 | 0.2116992 |     NA |
| kyeo                         |    183 | 0.1926316 |     NA |
| facet squared                |    307 | 0.4759690 |     NA |
| 23 beats off                 |     27 | 0.0502793 |    NaN |
| cassavetes                   |    180 | 0.2743902 |     NA |
| great cop                    |    277 | 0.4555921 |     NA |
| instrument                   |    282 | 0.4653465 |     NA |
| last chance for a slow dance |    138 | 0.2103659 |     NA |
| do you like me               |    282 | 0.7175573 |     NA |
| bed for the scraping         |    310 | 0.7888041 |     NA |
| latest disgrace              |     39 | 0.0992366 |     NA |
| birthday pony                |    203 | 0.5062344 |     NA |
| forensic scene               |    203 | 0.5087719 |     NA |
| combination lock             |     21 | 0.0535714 |     NA |
| fell, destroyed              |    135 | 0.2890792 |     NA |
| by you                       |    236 | 0.4738956 |     NA |
| back to base                 |    142 | 0.3613232 |     NA |
| downed city                  |    116 | 0.2951654 |     NA |
| long distance runner         |    114 | 0.2908163 |     NA |
| break                        |    179 | 0.7336066 |     NA |
| place position               |    140 | 0.5737705 |     NA |
| no surprise                  |     97 | 0.3991770 |     NA |
| five corporations            |    113 | 0.4631148 |     NA |
| caustic acrostic             |     53 | 0.1970260 |     NA |
| closed captioned             |    169 | 0.8009479 |     NA |
| floating boy                 |    107 | 0.4421488 |     NA |
| foreman’s dog                |     34 | 0.1808511 |     NA |
| arpeggiator                  |    163 | 0.7409091 |     NA |
| guilford fall                |     32 | 0.1311475 |     NA |
| pink frosty                  |     69 | 0.2593985 |     NA |
| fd                           |    122 | 0.5545455 |     NA |
| cashout                      |     67 | 0.9054054 |     NA |
| full disclosure              |     29 | 0.4677419 |     NA |
| epic problem                 |     34 | 0.4722222 |     NA |
| life and limb                |     24 | 0.5106383 |     NA |
| oh                           |     91 | 0.6107383 |     NA |
| ex-spectator                 |     52 | 0.4601770 |     NA |
| nightshop                    |     46 | 0.4070796 |     NA |
| argument                     |     76 | 0.6725664 |     NA |
| furniture                    |    108 | 0.1134454 |     NA |
| number 5                     |    120 | 0.7643312 |     NA |
| hello morning                |      2 | 0.0416667 |     NA |
| in defense of humans         |     31 | 0.0325630 |     NA |
| preprovisional               |      6 | 0.0065862 |     NA |
| reclamation                  |    612 | 0.7463415 |     NA |
| waiting room                 |    675 | 0.7090336 |     NA |
| recap modotti                |    151 | 0.6832579 |     NA |
| target                       |    267 | 0.6658354 |     NA |
| the kill                     |     37 | 0.5967742 |     NA |
| rend it                      |    354 | 0.5822368 |     NA |
| public witness program       |    273 | 0.5112360 |     NA |
| smallpox champion            |    265 | 0.4934823 |     NA |
| repeater                     |    427 | 0.4874429 |     NA |
| sieve-fisted find            |    435 | 0.4865772 |     NA |
| turnover                     |    416 | 0.4679415 |     NA |
| two beats off                |    392 | 0.4419391 |     NA |
| sweet and low                |    254 | 0.4341880 |     NA |
| suggestion                   |    373 | 0.3938754 |     NA |
| shut the door                |    342 | 0.3825503 |     NA |
| song \#1                     |    353 | 0.3707983 |     NA |
| styrofoam                    |    294 | 0.3356164 |     NA |
| runaway return               |    273 | 0.3230769 |     NA |
| reprovisional                |    284 | 0.3169643 |     NA |
| strangelight                 |     19 | 0.3114754 |     NA |
| walken’s syndrome            |    147 | 0.2737430 |     NA |
| returning the screw          |    138 | 0.2569832 |     NA |
| stacks                       |    156 | 0.2181818 |     NA |
| version                      |     36 | 0.0913706 |     NA |
| steady diet                  |     46 | 0.0659971 |     NA |
| the word                     |     37 | 0.0388655 |     NA |
| turn off your guns           |     17 | 0.0178571 |     NA |
| provisional                  |     13 | 0.0143330 |     NA |
| world beat                   |      2 | 0.0074349 |     NA |
| promises bit                 |      2 | 0.0021906 |     NA |

## Breaking ranks

The rank order of songs derived from the ratings is not very strong.
Some of the differences between the ratings are very small and the
differences between the ratings of adjacent songs in the table turned
out to be insignificant. The rankr function makes it easy to test which
differences between song ratings are significant and which are not. For
instance, do the results really indicate that “Bed for the Scraping” was
preferred over “Reclamation”?

``` r

songstobecompared <- songstobecompared <- summary %>% slice(seq(from=1, to=2, by=1))
mycomparisons <- rankr(coeftable = results_ml_Repeatr4, vcovmat = vcovmat_ml_Repeatr4, mysongidlist = songstobecompared)
#> Joining with `by = join_by(songid1)`
#> Joining with `by = join_by(songid2)`
mycomparisons <- mycomparisons %>%
  select(song1, song2, mycoef1, mycoef2, mycoefdiff, myz) %>%
  rename(coef1 = mycoef1, coef2 = mycoef2, coefdiff = mycoefdiff, z = myz)
```

``` r

knitr::kable(mycomparisons, format = "pipe", digits = 3)
```

| song1 | song2        | coef1 |  coef2 | coefdiff |   z |
|:------|:-------------|------:|-------:|---------:|----:|
| NA    | back to base |    NA | -0.914 |       NA |  NA |

A z-statistic of 1.96 or greater indicates a difference that is
statistically significant with 95% confidence. The difference between
‘Bed for the Scraping’ and ‘Reclamation’ is not statistically
significant. In fact, none of the differences between adjacent songs are
statistically significant. However, some of the differences between
songs further apart on the table are significant, as can be seen below.

``` r

songstobecompared <- songstobecompared <- songstobecompared <- summary %>% slice(seq(from=1, to=92, by=8))
mycomparisons <- rankr(coeftable = results_ml_Repeatr4, vcovmat = vcovmat_ml_Repeatr4, mysongidlist = songstobecompared)
#> Joining with `by = join_by(songid1)`
#> Joining with `by = join_by(songid2)`
mycomparisons <- mycomparisons %>%
  select(song1, song2, mycoef1, mycoef2, mycoefdiff, myz) %>%
  rename(coef1 = mycoef1, coef2 = mycoef2, coefdiff = mycoefdiff, z = myz)
```

``` r

knitr::kable(mycomparisons, format = "pipe", digits = 3)
```

| song1                | song2                |  coef1 |  coef2 | coefdiff |      z |
|:---------------------|:---------------------|-------:|-------:|---------:|-------:|
| NA                   | NA                   |     NA |     NA |       NA |     NA |
| NA                   | NA                   |     NA |     NA |       NA |     NA |
| NA                   | 23 beats off         |     NA |  0.000 |       NA |     NA |
| 23 beats off         | bed for the scraping |  0.000 | -1.265 |    1.265 | 18.333 |
| bed for the scraping | NA                   | -1.265 |     NA |       NA |     NA |
| NA                   | argument             |     NA | -0.422 |       NA |     NA |
| argument             | NA                   | -0.422 |     NA |       NA |     NA |
| NA                   | NA                   |     NA |     NA |       NA |     NA |
| NA                   | NA                   |     NA |     NA |       NA |     NA |
| NA                   | NA                   |     NA |     NA |       NA |     NA |
| NA                   | NA                   |     NA |     NA |       NA |     NA |

So, the ranks should not be interpreted rigidly. Any two of the adjacent
songs in the table could be interchanged and the resulting ranking would
be just as valid.

## Rating releases

The song ratings calculated using the Fugazi Live Series (FLS) data were
used to calculate average ratings for the band’s studio releases. The
results are shown below.

``` r

releases_data <- releases_summary 
knitr::kable(releases_data %>% arrange(desc(rating)), "pipe")
```

| releaseid | release | first_debut | last_debut | release_date | songs | count | shows | intensity | rating |
|---:|:---|:---|:---|:---|---:|---:|---:|---:|---:|
| 1 | fugazi | 1987-10-16 | 1994-08-27 | 1988-11-19 | 7 | 1683 | 852 | 0.2668 | NA |
| 2 | margin walker | 1987-09-26 | 1988-10-21 | 1989-06-15 | 6 | 1678 | 928 | 0.3009 | NA |
| 3 | 3 songs | 1987-09-03 | 1992-10-23 | 1989-12-01 | 3 | 547 | 813 | 0.2631 | NA |
| 4 | repeater | 1987-09-03 | 2001-04-06 | 1990-03-01 | 11 | 3320 | 795 | 0.3816 | NA |
| 5 | steady diet of nothing | 1987-09-03 | 1997-05-01 | 1991-08-01 | 11 | 2250 | 722 | 0.3001 | NA |
| 6 | in on the killtaker | 1987-09-03 | 1992-10-23 | 1993-06-18 | 12 | 3603 | 761 | 0.3828 | NA |
| 7 | red medicine | 1989-05-03 | 1994-11-27 | 1995-05-12 | 13 | 2447 | 461 | 0.4037 | NA |
| 8 | end hits | 1993-02-05 | 1998-05-01 | 1998-04-24 | 13 | 1551 | 260 | 0.4587 | NA |
| 9 | the argument | 1991-04-12 | 2001-06-21 | 2001-10-16 | 10 | 732 | 185 | 0.5219 | NA |
| 10 | furniture | 1987-09-03 | 2001-04-27 | 2001-10-16 | 3 | 230 | 386 | 0.3049 | NA |
| 11 | first demo | 1987-09-03 | 2001-04-05 | 2014-11-18 | 3 | 105 | 655 | 0.2228 | NA |
| 13 | unreleased | 1988-10-31 | 1992-10-23 | NA | 2 | 153 | 725 | 0.1399 | NA |
