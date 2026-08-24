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
#> [1] 952
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

| songid | title                        | launchdate | count |
|-------:|:-----------------------------|:-----------|------:|
|     91 | waiting room                 | 1987-09-03 |   675 |
|     68 | reclamation                  | 1990-05-05 |   612 |
|      9 | blueprint                    | 1989-09-23 |   608 |
|     53 | long division                | 1989-04-09 |   523 |
|     55 | merchandise                  | 1987-09-03 |   495 |
|     54 | margin walker                | 1988-07-28 |   467 |
|     75 | sieve-fisted find            | 1989-03-24 |   435 |
|     70 | repeater                     | 1989-07-19 |   427 |
|     88 | turnover                     | 1989-04-09 |   416 |
|     37 | give me the cure             | 1988-03-30 |   401 |
|      2 | and the same                 | 1987-09-26 |   397 |
|     89 | two beats off                | 1989-05-03 |   392 |
|     64 | promises                     | 1988-10-31 |   386 |
|     82 | suggestion                   | 1987-12-03 |   373 |
|     69 | rend it                      | 1991-12-08 |   354 |
|     77 | song \#1                     | 1987-09-03 |   353 |
|     74 | shut the door                | 1989-03-24 |   342 |
|      6 | bad mouth                    | 1987-10-16 |   312 |
|      7 | bed for the scraping         | 1994-11-20 |   310 |
|     28 | facet squared                | 1991-08-12 |   307 |
|     81 | styrofoam                    | 1989-07-19 |   294 |
|     71 | reprovisional                | 1988-12-29 |   284 |
|     23 | do you like me               | 1994-11-20 |   282 |
|     27 | exit only                    | 1990-07-06 |   282 |
|     44 | instrument                   | 1992-01-25 |   282 |
|     39 | great cop                    | 1991-12-08 |   277 |
|     66 | public witness program       | 1993-02-05 |   273 |
|     73 | runaway return               | 1990-02-11 |   273 |
|     84 | target                       | 1994-08-15 |   267 |
|     76 | smallpox champion            | 1992-10-23 |   265 |
|     83 | sweet and low                | 1992-05-15 |   254 |
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
|     78 | stacks                       | 1991-02-15 |   156 |
|     22 | dear justice letter          | 1991-01-02 |   152 |
|     67 | recap modotti                | 1997-05-01 |   151 |
|     38 | glueman                      | 1988-05-07 |   148 |
|     92 | walken’s syndrome            | 1992-10-23 |   147 |
|     11 | break-in                     | 1987-10-16 |   146 |
|      5 | back to base                 | 1994-11-20 |   142 |
|     62 | place position               | 1996-08-15 |   140 |
|     47 | last chance for a slow dance | 1991-07-28 |   138 |
|     72 | returning the screw          | 1992-10-23 |   138 |
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
|     79 | steady diet                  | 1991-04-12 |    46 |
|     48 | latest disgrace              | 1994-11-20 |    39 |
|     85 | the kill                     | 2001-04-05 |    37 |
|     86 | the word                     | 1987-09-03 |    37 |
|     90 | version                      | 1994-08-27 |    36 |
|     25 | epic problem                 | 2000-08-07 |    34 |
|     33 | foreman’s dog                | 1998-05-01 |    34 |
|     41 | guilford fall                | 1996-08-15 |    32 |
|     43 | in defense of humans         | 1987-09-03 |    31 |
|     35 | full disclosure              | 2001-04-05 |    29 |
|      1 | 23 beats off                 | 1992-10-23 |    27 |
|     50 | life and limb                | 2001-06-21 |    24 |
|     21 | combination lock             | 1994-11-27 |    21 |
|     80 | strangelight                 | 2001-04-06 |    19 |
|     87 | turn off your guns           | 1987-09-03 |    17 |
|     65 | provisional                  | 1989-05-03 |    12 |
|     63 | polish                       | 1991-03-06 |     6 |
|     42 | hello morning                | 2001-04-27 |     2 |

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

| songid | title                        | launchdate | chosen | available_rl | intensity |
|-------:|:-----------------------------|:-----------|-------:|-------------:|----------:|
|     17 | cashout                      | 2000-06-04 |     67 |           74 | 0.9054054 |
|     20 | closed captioned             | 1997-06-18 |    169 |          211 | 0.8009479 |
|      7 | bed for the scraping         | 1994-11-20 |    310 |          393 | 0.7888041 |
|     59 | number 5                     | 1998-11-21 |    120 |          157 | 0.7643312 |
|     68 | reclamation                  | 1990-05-05 |    612 |          820 | 0.7463415 |
|      4 | arpeggiator                  | 1997-05-02 |    163 |          220 | 0.7409091 |
|     10 | break                        | 1996-08-15 |    179 |          244 | 0.7336066 |
|     23 | do you like me               | 1994-11-20 |    282 |          393 | 0.7175573 |
|     91 | waiting room                 | 1987-09-03 |    675 |          952 | 0.7090336 |
|      9 | blueprint                    | 1989-09-23 |    608 |          873 | 0.6964490 |
|     67 | recap modotti                | 1997-05-01 |    151 |          221 | 0.6832579 |
|      3 | argument                     | 1999-08-26 |     76 |          113 | 0.6725664 |
|     84 | target                       | 1994-08-15 |    267 |          401 | 0.6658354 |
|     60 | oh                           | 1998-11-29 |     91 |          149 | 0.6107383 |
|     85 | the kill                     | 2001-04-05 |     37 |           62 | 0.5967742 |
|     53 | long division                | 1989-04-09 |    523 |          889 | 0.5883015 |
|     69 | rend it                      | 1991-12-08 |    354 |          608 | 0.5822368 |
|     62 | place position               | 1996-08-15 |    140 |          244 | 0.5737705 |
|     29 | fd                           | 1997-05-02 |    122 |          220 | 0.5545455 |
|     55 | merchandise                  | 1987-09-03 |    495 |          952 | 0.5199580 |
|     66 | public witness program       | 1993-02-05 |    273 |          534 | 0.5112360 |
|     50 | life and limb                | 2001-06-21 |     24 |           47 | 0.5106383 |
|     34 | forensic scene               | 1994-08-19 |    203 |          399 | 0.5087719 |
|     54 | margin walker                | 1988-07-28 |    467 |          921 | 0.5070575 |
|      8 | birthday pony                | 1994-08-15 |    203 |          401 | 0.5062344 |
|     76 | smallpox champion            | 1992-10-23 |    265 |          537 | 0.4934823 |
|     70 | repeater                     | 1989-07-19 |    427 |          876 | 0.4874429 |
|     75 | sieve-fisted find            | 1989-03-24 |    435 |          894 | 0.4865772 |
|     28 | facet squared                | 1991-08-12 |    307 |          645 | 0.4759690 |
|     16 | by you                       | 1993-04-24 |    236 |          498 | 0.4738956 |
|     25 | epic problem                 | 2000-08-07 |     34 |           72 | 0.4722222 |
|     88 | turnover                     | 1989-04-09 |    416 |          889 | 0.4679415 |
|     35 | full disclosure              | 2001-04-05 |     29 |           62 | 0.4677419 |
|     44 | instrument                   | 1992-01-25 |    282 |          606 | 0.4653465 |
|     31 | five corporations            | 1996-08-15 |    113 |          244 | 0.4631148 |
|     26 | ex-spectator                 | 1999-08-26 |     52 |          113 | 0.4601770 |
|     39 | great cop                    | 1991-12-08 |    277 |          608 | 0.4555921 |
|     32 | floating boy                 | 1996-10-16 |    107 |          242 | 0.4421488 |
|     89 | two beats off                | 1989-05-03 |    392 |          887 | 0.4419391 |
|     83 | sweet and low                | 1992-05-15 |    254 |          585 | 0.4341880 |
|     37 | give me the cure             | 1988-03-30 |    401 |          939 | 0.4270501 |
|     64 | promises                     | 1988-10-31 |    386 |          911 | 0.4237102 |
|      2 | and the same                 | 1987-09-26 |    397 |          951 | 0.4174553 |
|     57 | nightshop                    | 1999-08-26 |     46 |          113 | 0.4070796 |
|     58 | no surprise                  | 1996-09-29 |     97 |          243 | 0.3991770 |
|     82 | suggestion                   | 1987-12-03 |    373 |          947 | 0.3938754 |
|     74 | shut the door                | 1989-03-24 |    342 |          894 | 0.3825503 |
|     77 | song \#1                     | 1987-09-03 |    353 |          952 | 0.3707983 |
|     27 | exit only                    | 1990-07-06 |    282 |          780 | 0.3615385 |
|      5 | back to base                 | 1994-11-20 |    142 |          393 | 0.3613232 |
|     81 | styrofoam                    | 1989-07-19 |    294 |          876 | 0.3356164 |
|      6 | bad mouth                    | 1987-10-16 |    312 |          949 | 0.3287671 |
|     73 | runaway return               | 1990-02-11 |    273 |          845 | 0.3230769 |
|     71 | reprovisional                | 1988-12-29 |    284 |          896 | 0.3169643 |
|     80 | strangelight                 | 2001-04-06 |     19 |           61 | 0.3114754 |
|     24 | downed city                  | 1994-11-20 |    116 |          393 | 0.2951654 |
|     52 | long distance runner         | 1994-11-27 |    114 |          392 | 0.2908163 |
|     30 | fell, destroyed              | 1993-08-16 |    135 |          467 | 0.2890792 |
|     18 | cassavetes                   | 1991-07-28 |    180 |          656 | 0.2743902 |
|     92 | walken’s syndrome            | 1992-10-23 |    147 |          537 | 0.2737430 |
|     13 | bulldog front                | 1988-06-15 |    249 |          925 | 0.2691892 |
|     61 | pink frosty                  | 1996-03-20 |     69 |          266 | 0.2593985 |
|     15 | burning too                  | 1988-07-28 |    238 |          921 | 0.2584148 |
|     14 | burning                      | 1988-02-06 |    243 |          942 | 0.2579618 |
|     72 | returning the screw          | 1992-10-23 |    138 |          537 | 0.2569832 |
|     49 | latin roots                  | 1990-10-01 |    187 |          753 | 0.2483400 |
|     40 | greed                        | 1989-03-24 |    199 |          894 | 0.2225951 |
|     78 | stacks                       | 1991-02-15 |    156 |          715 | 0.2181818 |
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
|     90 | version                      | 1994-08-27 |     36 |          394 | 0.0913706 |
|     79 | steady diet                  | 1991-04-12 |     46 |          697 | 0.0659971 |
|     21 | combination lock             | 1994-11-27 |     21 |          392 | 0.0535714 |
|      1 | 23 beats off                 | 1992-10-23 |     27 |          537 | 0.0502793 |
|     42 | hello morning                | 2001-04-27 |      2 |           48 | 0.0416667 |
|     86 | the word                     | 1987-09-03 |     37 |          952 | 0.0388655 |
|     43 | in defense of humans         | 1987-09-03 |     31 |          952 | 0.0325630 |
|     87 | turn off your guns           | 1987-09-03 |     17 |          952 | 0.0178571 |
|     65 | provisional                  | 1989-05-03 |     12 |          887 | 0.0135287 |
|     63 | polish                       | 1991-03-06 |      6 |          709 | 0.0084626 |

The “songid” variable is each song’s stable identity (alphabetical rank
among all classified songs, from `songidlookup`) - it’s a consistent key
for joining `fugazi_song_counts` and `fugazi_song_performance_intensity`
together, not a ranking by frequency or intensity itself.

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
#> [1] 24568
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

| rank_rating | songid | title                        |   Estimate |    z-value |
|------------:|-------:|:-----------------------------|-----------:|-----------:|
|           1 |      7 | bed for the scraping         |  3.6086886 | 17.7473206 |
|           2 |     68 | reclamation                  |  3.6041238 | 18.0365751 |
|           3 |     10 | break                        |  3.5612232 | 16.7066562 |
|           4 |     23 | do you like me               |  3.4346337 | 16.8314134 |
|           5 |     20 | closed captioned             |  3.3199736 | 15.3773712 |
|           6 |     17 | cashout                      |  3.2403719 | 13.2097176 |
|           7 |     62 | place position               |  3.1978593 | 14.7669130 |
|           8 |     91 | waiting room                 |  3.1516072 | 15.3019763 |
|           9 |     84 | target                       |  3.1375366 | 15.3977028 |
|          10 |     67 | recap modotti                |  3.1161374 | 14.3701092 |
|          11 |     59 | number 5                     |  3.0190723 | 13.3709669 |
|          12 |      9 | blueprint                    |  2.9912505 | 14.9161528 |
|          13 |     75 | sieve-fisted find            |  2.9531415 | 14.5113535 |
|          14 |     69 | rend it                      |  2.8989151 | 14.4723545 |
|          15 |     55 | merchandise                  |  2.8953058 | 13.9756657 |
|          16 |      4 | arpeggiator                  |  2.8596784 | 13.2512392 |
|          17 |     54 | margin walker                |  2.8157008 | 13.7793466 |
|          18 |     28 | facet squared                |  2.7669101 | 13.7084453 |
|          19 |     88 | turnover                     |  2.7575923 | 13.5405387 |
|          20 |      8 | birthday pony                |  2.7526631 | 13.3192153 |
|          21 |     60 | oh                           |  2.7408498 | 11.8203565 |
|          22 |     53 | long division                |  2.7151304 | 13.4041460 |
|          23 |      3 | argument                     |  2.7096246 | 11.3806705 |
|          24 |     66 | public witness program       |  2.6961330 | 13.3488556 |
|          25 |     85 | the kill                     |  2.6150860 |  9.6423459 |
|          26 |     29 | fd                           |  2.6055077 | 11.8205662 |
|          27 |     76 | smallpox champion            |  2.5809319 | 12.7655862 |
|          28 |     34 | forensic scene               |  2.5670313 | 12.4244316 |
|          29 |     16 | by you                       |  2.5426366 | 12.4989675 |
|          30 |      2 | and the same                 |  2.5314142 | 12.1476531 |
|          31 |     31 | five corporations            |  2.5213837 | 11.4459728 |
|          32 |     44 | instrument                   |  2.4937480 | 12.3402397 |
|          33 |     50 | life and limb                |  2.4927268 |  8.3604923 |
|          34 |     32 | floating boy                 |  2.4567042 | 11.0865822 |
|          35 |     35 | full disclosure              |  2.4552050 |  8.6192480 |
|          36 |     77 | song \#1                     |  2.4359085 | 11.6584575 |
|          37 |     37 | give me the cure             |  2.4054965 | 11.6485470 |
|          38 |     89 | two beats off                |  2.4018132 | 11.7814558 |
|          39 |     39 | great cop                    |  2.4012566 | 11.8759698 |
|          40 |     26 | ex-spectator                 |  2.4003750 |  9.5736906 |
|          41 |     70 | repeater                     |  2.3394339 | 11.5476366 |
|          42 |     82 | suggestion                   |  2.3157598 | 11.1646430 |
|          43 |     58 | no surprise                  |  2.2798002 | 10.1946959 |
|          44 |     25 | epic problem                 |  2.2554190 |  8.2456870 |
|          45 |      6 | bad mouth                    |  2.2507575 | 10.7552364 |
|          46 |     64 | promises                     |  2.2069306 | 10.7689369 |
|          47 |      5 | back to base                 |  2.1987583 | 10.3564868 |
|          48 |     74 | shut the door                |  2.1843697 | 10.6553701 |
|          49 |     27 | exit only                    |  2.1737359 | 10.6643155 |
|          50 |     81 | styrofoam                    |  2.1662961 | 10.5588062 |
|          51 |     83 | sweet and low                |  2.1217459 | 10.4682680 |
|          52 |     57 | nightshop                    |  2.0692549 |  8.0939269 |
|          53 |     73 | runaway return               |  2.0173052 |  9.8414339 |
|          54 |     13 | bulldog front                |  1.9417767 |  9.2843087 |
|          55 |     24 | downed city                  |  1.9129866 |  8.8604672 |
|          56 |     92 | walken’s syndrome            |  1.8887340 |  9.0160740 |
|          57 |     15 | burning too                  |  1.8811958 |  8.9863433 |
|          58 |     14 | burning                      |  1.8785531 |  8.9095708 |
|          59 |     71 | reprovisional                |  1.8645493 |  9.0188331 |
|          60 |     18 | cassavetes                   |  1.8352500 |  8.8555996 |
|          61 |     30 | fell, destroyed              |  1.8280580 |  8.6552143 |
|          62 |     52 | long distance runner         |  1.8127303 |  8.3825481 |
|          63 |     72 | returning the screw          |  1.7709465 |  8.4115932 |
|          64 |     61 | pink frosty                  |  1.7675462 |  7.6343068 |
|          65 |     49 | latin roots                  |  1.7603124 |  8.4708514 |
|          66 |     40 | greed                        |  1.7441696 |  8.3011711 |
|          67 |     80 | strangelight                 |  1.7052959 |  5.4185020 |
|          68 |     22 | dear justice letter          |  1.5984698 |  7.5989853 |
|          69 |     78 | stacks                       |  1.5549731 |  7.4073981 |
|          70 |     19 | caustic acrostic             |  1.5430873 |  6.4116237 |
|          71 |     51 | lockdown                     |  1.5222364 |  7.1103687 |
|          72 |     12 | brendan \#1                  |  1.5069287 |  7.1035642 |
|          73 |     47 | last chance for a slow dance |  1.4727829 |  6.9740537 |
|          74 |     46 | kyeo                         |  1.3873312 |  6.4531617 |
|          75 |     56 | nice new outfit              |  1.3104772 |  6.1058090 |
|          76 |     11 | break-in                     |  1.2358574 |  5.6720477 |
|          77 |     33 | foreman’s dog                |  1.2093225 |  4.5345895 |
|          78 |     65 | provisional                  |  1.1804772 |  3.1435445 |
|          79 |     38 | glueman                      |  1.1417943 |  5.2796981 |
|          80 |     45 | joe \#1                      |  1.1365963 |  5.1699528 |
|          81 |     41 | guilford fall                |  1.0707057 |  4.0218200 |
|          82 |     36 | furniture                    |  0.9459643 |  4.2226754 |
|          83 |     48 | latest disgrace              |  0.7339073 |  2.9092202 |
|          84 |     90 | version                      |  0.5578754 |  2.1796928 |
|          85 |     79 | steady diet                  |  0.3055302 |  1.2545455 |
|          86 |     21 | combination lock             |  0.0719275 |  0.2458331 |
|          87 |      1 | 23 beats off                 |  0.0000000 |         NA |
|          88 |     86 | the word                     | -0.3078846 | -1.1674949 |
|          89 |     42 | hello morning                | -0.4059818 | -0.5490568 |
|          90 |     43 | in defense of humans         | -0.4062096 | -1.5017400 |
|          91 |     87 | turn off your guns           | -1.0216074 | -3.2351004 |
|          92 |     63 | polish                       | -1.8376209 | -4.0656032 |

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

knitr::kable(summary %>% select(title, chosen, intensity, rating) %>% arrange(desc(rating)), "pipe")
```

| title                        | chosen | intensity |    rating |
|:-----------------------------|-------:|----------:|----------:|
| bed for the scraping         |    310 | 0.7888041 | 1.0000000 |
| reclamation                  |    612 | 0.7463415 | 0.9991618 |
| break                        |    179 | 0.7336066 | 0.9912848 |
| do you like me               |    282 | 0.7175573 | 0.9680417 |
| closed captioned             |    169 | 0.8009479 | 0.9469889 |
| cashout                      |     67 | 0.9054054 | 0.9323732 |
| place position               |    140 | 0.5737705 | 0.9245674 |
| waiting room                 |    675 | 0.7090336 | 0.9160750 |
| target                       |    267 | 0.6658354 | 0.9134915 |
| recap modotti                |    151 | 0.6832579 | 0.9095624 |
| number 5                     |    120 | 0.7643312 | 0.8917402 |
| blueprint                    |    608 | 0.6964490 | 0.8866318 |
| sieve-fisted find            |    435 | 0.4865772 | 0.8796346 |
| rend it                      |    354 | 0.5822368 | 0.8696781 |
| merchandise                  |    495 | 0.5199580 | 0.8690154 |
| arpeggiator                  |    163 | 0.7409091 | 0.8624738 |
| margin walker                |    467 | 0.5070575 | 0.8543991 |
| facet squared                |    307 | 0.4759690 | 0.8454406 |
| turnover                     |    416 | 0.4679415 | 0.8437297 |
| birthday pony                |    203 | 0.5062344 | 0.8428247 |
| oh                           |     91 | 0.6107383 | 0.8406556 |
| long division                |    523 | 0.5883015 | 0.8359333 |
| argument                     |     76 | 0.6725664 | 0.8349223 |
| public witness program       |    273 | 0.5112360 | 0.8324451 |
| the kill                     |     37 | 0.5967742 | 0.8175641 |
| fd                           |    122 | 0.5545455 | 0.8158054 |
| smallpox champion            |    265 | 0.4934823 | 0.8112930 |
| forensic scene               |    203 | 0.5087719 | 0.8087407 |
| by you                       |    236 | 0.4738956 | 0.8042616 |
| and the same                 |    397 | 0.4174553 | 0.8022010 |
| five corporations            |    113 | 0.4631148 | 0.8003593 |
| instrument                   |    282 | 0.4653465 | 0.7952851 |
| life and limb                |     24 | 0.5106383 | 0.7950976 |
| floating boy                 |    107 | 0.4421488 | 0.7884835 |
| full disclosure              |     29 | 0.4677419 | 0.7882082 |
| song \#1                     |    353 | 0.3707983 | 0.7846652 |
| give me the cure             |    401 | 0.4270501 | 0.7790812 |
| two beats off                |    392 | 0.4419391 | 0.7784049 |
| great cop                    |    277 | 0.4555921 | 0.7783027 |
| ex-spectator                 |     52 | 0.4601770 | 0.7781408 |
| repeater                     |    427 | 0.4874429 | 0.7669514 |
| suggestion                   |    373 | 0.3938754 | 0.7626046 |
| no surprise                  |     97 | 0.3991770 | 0.7560020 |
| epic problem                 |     34 | 0.4722222 | 0.7515254 |
| bad mouth                    |    312 | 0.3287671 | 0.7506695 |
| promises                     |    386 | 0.4237102 | 0.7426224 |
| back to base                 |    142 | 0.3613232 | 0.7411219 |
| shut the door                |    342 | 0.3825503 | 0.7384800 |
| exit only                    |    282 | 0.3615385 | 0.7365275 |
| styrofoam                    |    294 | 0.3356164 | 0.7351615 |
| sweet and low                |    254 | 0.4341880 | 0.7269816 |
| nightshop                    |     46 | 0.4070796 | 0.7173437 |
| runaway return               |    273 | 0.3230769 | 0.7078052 |
| bulldog front                |    249 | 0.2691892 | 0.6939374 |
| downed city                  |    116 | 0.2951654 | 0.6886512 |
| walken’s syndrome            |    147 | 0.2737430 | 0.6841981 |
| burning too                  |    238 | 0.2584148 | 0.6828141 |
| burning                      |    243 | 0.2579618 | 0.6823288 |
| reprovisional                |    284 | 0.3169643 | 0.6797576 |
| cassavetes                   |    180 | 0.2743902 | 0.6743779 |
| fell, destroyed              |    135 | 0.2890792 | 0.6730574 |
| long distance runner         |    114 | 0.2908163 | 0.6702431 |
| returning the screw          |    138 | 0.2569832 | 0.6625711 |
| pink frosty                  |     69 | 0.2593985 | 0.6619468 |
| latin roots                  |    187 | 0.2483400 | 0.6606186 |
| greed                        |    199 | 0.2225951 | 0.6576546 |
| strangelight                 |     19 | 0.3114754 | 0.6505170 |
| dear justice letter          |    152 | 0.2116992 | 0.6309026 |
| stacks                       |    156 | 0.2181818 | 0.6229161 |
| caustic acrostic             |     53 | 0.1970260 | 0.6207338 |
| lockdown                     |    184 | 0.1942978 | 0.6169053 |
| brendan \#1                  |    170 | 0.1901566 | 0.6140947 |
| last chance for a slow dance |    138 | 0.2103659 | 0.6078251 |
| kyeo                         |    183 | 0.1926316 | 0.5921353 |
| nice new outfit              |    119 | 0.1666667 | 0.5780241 |
| break-in                     |    146 | 0.1538462 | 0.5643231 |
| foreman’s dog                |     34 | 0.1808511 | 0.5594510 |
| provisional                  |     12 | 0.0135287 | 0.5541547 |
| glueman                      |    148 | 0.1582888 | 0.5470521 |
| joe \#1                      |    136 | 0.1428571 | 0.5460977 |
| guilford fall                |     32 | 0.1311475 | 0.5339995 |
| furniture                    |    108 | 0.1134454 | 0.5110957 |
| latest disgrace              |     39 | 0.0992366 | 0.4721598 |
| version                      |     36 | 0.0913706 | 0.4398384 |
| steady diet                  |     46 | 0.0659971 | 0.3935052 |
| combination lock             |     21 | 0.0535714 | 0.3506133 |
| 23 beats off                 |     27 | 0.0502793 | 0.3374066 |
| the word                     |     37 | 0.0388655 | 0.2808758 |
| hello morning                |      2 | 0.0416667 | 0.2628641 |
| in defense of humans         |     31 | 0.0325630 | 0.2628222 |
| turn off your guns           |     17 | 0.0178571 | 0.1498287 |
| polish                       |      6 | 0.0084626 | 0.0000000 |

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
#> Joining with `by = join_by(alt1)`
#> Joining with `by = join_by(alt2)`
mycomparisons <- mycomparisons %>%
  select(title1, title2, mycoef1, mycoef2, mycoefdiff, myz) %>%
  rename(coef1 = mycoef1, coef2 = mycoef2, coefdiff = mycoefdiff, z = myz)
```

``` r

knitr::kable(mycomparisons, format = "pipe", digits = 3)
```

| title1       | title2        | coef1 | coef2 | coefdiff |     z |
|:-------------|:--------------|------:|------:|---------:|------:|
| waiting room | bulldog front | 3.152 | 1.942 |     1.21 | 15.94 |

A z-statistic of 1.96 or greater indicates a difference that is
statistically significant with 95% confidence. The difference between
‘Bed for the Scraping’ and ‘Reclamation’ is not statistically
significant. In fact, none of the differences between adjacent songs are
statistically significant. However, some of the differences between
songs further apart on the table are significant, as can be seen below.

``` r

songstobecompared <- songstobecompared <- songstobecompared <- summary %>% slice(seq(from=1, to=nrow(summary), by=8))
mycomparisons <- rankr(coeftable = results_ml_Repeatr4, vcovmat = vcovmat_ml_Repeatr4, mysongidlist = songstobecompared)
#> Joining with `by = join_by(alt1)`
#> Joining with `by = join_by(alt2)`
mycomparisons <- mycomparisons %>%
  select(title1, title2, mycoef1, mycoef2, mycoefdiff, myz) %>%
  rename(coef1 = mycoef1, coef2 = mycoef2, coefdiff = mycoefdiff, z = myz)
```

``` r

knitr::kable(mycomparisons, format = "pipe", digits = 3)
```

| title1              | title2              | coef1 |  coef2 | coefdiff |       z |
|:--------------------|:--------------------|------:|-------:|---------:|--------:|
| waiting room        | and the same        | 3.152 |  2.531 |    0.620 |   9.542 |
| and the same        | turnover            | 2.531 |  2.758 |   -0.226 |  -3.056 |
| turnover            | styrofoam           | 2.758 |  2.166 |    0.591 |   7.672 |
| styrofoam           | steady diet         | 2.166 |  0.306 |    1.861 |  11.634 |
| steady diet         | returning the screw | 0.306 |  1.771 |   -1.465 |  -8.527 |
| returning the screw | instrument          | 1.771 |  2.494 |   -0.723 |  -6.877 |
| instrument          | fell, destroyed     | 2.494 |  1.828 |    0.666 |   6.210 |
| fell, destroyed     | place position      | 1.828 |  3.198 |   -1.370 | -10.675 |
| place position      | arpeggiator         | 3.198 |  2.860 |    0.338 |   2.884 |
| arpeggiator         | the kill            | 2.860 |  2.615 |    0.245 |   1.295 |
| the kill            | hello morning       | 2.615 | -0.406 |    3.021 |   4.159 |

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

| rid | release_title | first_debut | last_debut | release_date | songs | count | shows | intensity | rating |
|---:|:---|:---|:---|:---|---:|---:|---:|---:|---:|
| 9 | the argument | 1998-11-29 | 2001-06-21 | 2001-10-16 | 10 | 475 | 87 | 0.5415 | 0.7906 |
| 8 | end hits | 1996-01-30 | 1998-05-01 | 1998-04-24 | 13 | 1429 | 235 | 0.4738 | 0.7824 |
| 4 | repeater | 1987-09-03 | 1989-09-23 | 1990-03-01 | 11 | 4062 | 893 | 0.4135 | 0.7681 |
| 1 | fugazi | 1987-09-03 | 1988-06-15 | 1988-11-19 | 7 | 2401 | 940 | 0.3638 | 0.7331 |
| 7 | red medicine | 1993-04-24 | 1994-11-27 | 1995-05-12 | 13 | 2104 | 408 | 0.3955 | 0.7210 |
| 6 | in on the killtaker | 1991-07-28 | 1993-02-05 | 1993-06-18 | 12 | 2642 | 587 | 0.3736 | 0.7188 |
| 2 | margin walker | 1987-09-26 | 1989-05-03 | 1989-06-15 | 6 | 1684 | 922 | 0.3027 | 0.7088 |
| 3 | 3 songs | 1987-09-03 | 1987-10-16 | 1989-12-01 | 3 | 635 | 950 | 0.2227 | 0.6317 |
| 5 | steady diet of nothing | 1987-10-07 | 1991-04-12 | 1991-08-01 | 11 | 2539 | 781 | 0.2847 | 0.6143 |
| 10 | furniture | 1987-09-03 | 2001-04-27 | 2001-10-16 | 3 | 230 | 385 | 0.3065 | 0.5552 |
| 11 | first demo | 1987-09-03 | 1987-09-03 | 2014-11-18 | 3 | 85 | 951 | 0.0298 | 0.2312 |
