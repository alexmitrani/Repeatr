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
#> [1] 902
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
|     92 | waiting room                 | 1987-09-03 |   633 |
|     69 | reclamation                  | 1990-05-05 |   594 |
|      9 | blueprint                    | 1989-11-25 |   584 |
|     53 | long division                | 1989-04-09 |   498 |
|     55 | merchandise                  | 1987-09-03 |   477 |
|     54 | margin walker                | 1988-08-01 |   430 |
|     76 | sieve-fisted find            | 1989-03-24 |   418 |
|     71 | repeater                     | 1989-07-20 |   410 |
|     89 | turnover                     | 1989-04-09 |   395 |
|     65 | promises                     | 1988-10-15 |   380 |
|      2 | and the same                 | 1987-09-26 |   376 |
|     90 | two beats off                | 1989-05-03 |   371 |
|     37 | give me the cure             | 1988-03-30 |   369 |
|     70 | rend it                      | 1991-12-08 |   346 |
|     83 | suggestion                   | 1987-12-03 |   340 |
|     75 | shut the door                | 1989-03-24 |   323 |
|     78 | song \#1                     | 1987-09-03 |   322 |
|      7 | bed for the scraping         | 1994-11-20 |   299 |
|     28 | facet squared                | 1991-08-12 |   299 |
|     82 | styrofoam                    | 1990-05-17 |   287 |
|      6 | bad mouth                    | 1987-10-16 |   280 |
|     72 | reprovisional                | 1988-12-29 |   276 |
|     27 | exit only                    | 1990-07-06 |   275 |
|     23 | do you like me               | 1994-11-20 |   272 |
|     44 | instrument                   | 1992-01-25 |   272 |
|     39 | great cop                    | 1991-12-08 |   268 |
|     74 | runaway return               | 1990-02-11 |   265 |
|     67 | public witness program       | 1993-02-05 |   264 |
|     85 | target                       | 1994-08-15 |   260 |
|     77 | smallpox champion            | 1992-10-23 |   253 |
|     84 | sweet and low                | 1992-05-15 |   249 |
|     16 | by you                       | 1993-04-24 |   233 |
|     13 | bulldog front                | 1988-06-15 |   226 |
|     15 | burning too                  | 1988-08-01 |   215 |
|     14 | burning                      | 1988-02-06 |   214 |
|     34 | forensic scene               | 1994-08-19 |   201 |
|      8 | birthday pony                | 1994-08-15 |   199 |
|     40 | greed                        | 1989-03-24 |   188 |
|     49 | latin roots                  | 1990-10-01 |   182 |
|     46 | kyeo                         | 1987-10-07 |   173 |
|     10 | break                        | 1996-08-15 |   172 |
|     18 | cassavetes                   | 1991-07-28 |   171 |
|     51 | lockdown                     | 1987-12-03 |   165 |
|     20 | closed captioned             | 1997-06-18 |   159 |
|     12 | brendan \#1                  | 1989-03-24 |   158 |
|      4 | arpeggiator                  | 1997-05-02 |   154 |
|     79 | stacks                       | 1991-02-15 |   153 |
|     22 | dear justice letter          | 1991-01-02 |   148 |
|     68 | recap modotti                | 1997-05-03 |   141 |
|     93 | walken’s syndrome            | 1992-10-23 |   141 |
|     30 | fell, destroyed              | 1993-08-16 |   137 |
|      5 | back to base                 | 1994-11-20 |   136 |
|     47 | last chance for a slow dance | 1991-07-28 |   136 |
|     11 | break-in                     | 1987-10-16 |   134 |
|     73 | returning the screw          | 1992-10-23 |   134 |
|     38 | glueman                      | 1988-05-12 |   133 |
|     62 | place position               | 1996-08-15 |   133 |
|     45 | joe \#1                      | 1987-09-03 |   132 |
|     29 | fd                           | 1997-05-02 |   115 |
|     56 | nice new outfit              | 1991-02-20 |   115 |
|     52 | long distance runner         | 1994-11-27 |   113 |
|     24 | downed city                  | 1994-11-20 |   111 |
|     59 | number 5                     | 1998-11-21 |   110 |
|     31 | five corporations            | 1996-08-15 |   109 |
|     32 | floating boy                 | 1996-10-16 |   106 |
|     36 | furniture                    | 1987-09-03 |    94 |
|     58 | no surprise                  | 1996-09-29 |    89 |
|     60 | oh                           | 1998-11-29 |    80 |
|     61 | pink frosty                  | 1996-03-20 |    67 |
|      3 | argument                     | 1999-08-26 |    66 |
|     17 | cashout                      | 2000-09-30 |    62 |
|     19 | caustic acrostic             | 1996-01-30 |    51 |
|     80 | steady diet                  | 1991-04-12 |    46 |
|     26 | ex-spectator                 | 1999-08-26 |    45 |
|     57 | nightshop                    | 1999-08-26 |    44 |
|     48 | latest disgrace              | 1994-11-20 |    39 |
|     86 | the kill                     | 2001-04-05 |    35 |
|     91 | version                      | 1994-08-27 |    34 |
|     33 | foreman’s dog                | 1998-05-01 |    33 |
|     25 | epic problem                 | 2000-10-01 |    32 |
|     41 | guilford fall                | 1996-08-15 |    32 |
|     87 | the word                     | 1987-09-03 |    31 |
|      1 | 23 beats off                 | 1992-10-23 |    26 |
|     35 | full disclosure              | 2001-04-05 |    26 |
|     43 | in defense of humans         | 1987-09-03 |    25 |
|     21 | combination lock             | 1994-11-27 |    21 |
|     50 | life and limb                | 2001-06-21 |    21 |
|     81 | strangelight                 | 2001-04-06 |    19 |
|     88 | turn off your guns           | 1987-09-03 |    15 |
|     66 | provisional                  | 1988-11-14 |     8 |
|     63 | polish                       | 1991-03-06 |     6 |
|     64 | preprovisional               | 1988-10-31 |     6 |
|     42 | hello morning                | 2001-04-27 |     2 |
|     94 | world beat                   | 1996-01-30 |     2 |

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
|     17 | cashout                      | 2000-09-30 |     62 |           66 | 0.9393939 |
|     20 | closed captioned             | 1997-06-18 |    159 |          199 | 0.7989950 |
|      7 | bed for the scraping         | 1994-11-20 |    299 |          377 | 0.7931034 |
|     59 | number 5                     | 1998-11-21 |    110 |          145 | 0.7586207 |
|     10 | break                        | 1996-08-15 |    172 |          229 | 0.7510917 |
|     69 | reclamation                  | 1990-05-05 |    594 |          795 | 0.7471698 |
|      4 | arpeggiator                  | 1997-05-02 |    154 |          208 | 0.7403846 |
|     23 | do you like me               | 1994-11-20 |    272 |          377 | 0.7214854 |
|      9 | blueprint                    | 1989-11-25 |    584 |          826 | 0.7070218 |
|     92 | waiting room                 | 1987-09-03 |    633 |          900 | 0.7033333 |
|     68 | recap modotti                | 1997-05-03 |    141 |          207 | 0.6811594 |
|     85 | target                       | 1994-08-15 |    260 |          385 | 0.6753247 |
|      3 | argument                     | 1999-08-26 |     66 |          101 | 0.6534653 |
|     86 | the kill                     | 2001-04-05 |     35 |           58 | 0.6034483 |
|     70 | rend it                      | 1991-12-08 |    346 |          585 | 0.5914530 |
|     53 | long division                | 1989-04-09 |    498 |          848 | 0.5872642 |
|     60 | oh                           | 1998-11-29 |     80 |          137 | 0.5839416 |
|     62 | place position               | 1996-08-15 |    133 |          229 | 0.5807860 |
|     29 | fd                           | 1997-05-02 |    115 |          208 | 0.5528846 |
|     55 | merchandise                  | 1987-09-03 |    477 |          900 | 0.5300000 |
|     34 | forensic scene               | 1994-08-19 |    201 |          383 | 0.5248042 |
|      8 | birthday pony                | 1994-08-15 |    199 |          385 | 0.5168831 |
|     67 | public witness program       | 1993-02-05 |    264 |          513 | 0.5146199 |
|     54 | margin walker                | 1988-08-01 |    430 |          872 | 0.4931193 |
|     25 | epic problem                 | 2000-10-01 |     32 |           65 | 0.4923077 |
|     77 | smallpox champion            | 1992-10-23 |    253 |          516 | 0.4903101 |
|     76 | sieve-fisted find            | 1989-03-24 |    418 |          853 | 0.4900352 |
|     71 | repeater                     | 1989-07-20 |    410 |          838 | 0.4892601 |
|     16 | by you                       | 1993-04-24 |    233 |          477 | 0.4884696 |
|     28 | facet squared                | 1991-08-12 |    299 |          621 | 0.4814815 |
|     50 | life and limb                | 2001-06-21 |     21 |           44 | 0.4772727 |
|     31 | five corporations            | 1996-08-15 |    109 |          229 | 0.4759825 |
|     32 | floating boy                 | 1996-10-16 |    106 |          227 | 0.4669604 |
|     44 | instrument                   | 1992-01-25 |    272 |          583 | 0.4665523 |
|     89 | turnover                     | 1989-04-09 |    395 |          848 | 0.4658019 |
|     39 | great cop                    | 1991-12-08 |    268 |          585 | 0.4581197 |
|     35 | full disclosure              | 2001-04-05 |     26 |           58 | 0.4482759 |
|     26 | ex-spectator                 | 1999-08-26 |     45 |          101 | 0.4455446 |
|     84 | sweet and low                | 1992-05-15 |    249 |          563 | 0.4422735 |
|     90 | two beats off                | 1989-05-03 |    371 |          846 | 0.4385343 |
|     65 | promises                     | 1988-10-15 |    380 |          869 | 0.4372842 |
|     57 | nightshop                    | 1999-08-26 |     44 |          101 | 0.4356436 |
|      2 | and the same                 | 1987-09-26 |    376 |          899 | 0.4182425 |
|     37 | give me the cure             | 1988-03-30 |    369 |          887 | 0.4160090 |
|     58 | no surprise                  | 1996-09-29 |     89 |          228 | 0.3903509 |
|     83 | suggestion                   | 1987-12-03 |    340 |          895 | 0.3798883 |
|     75 | shut the door                | 1989-03-24 |    323 |          853 | 0.3786635 |
|     27 | exit only                    | 1990-07-06 |    275 |          755 | 0.3642384 |
|     82 | styrofoam                    | 1990-05-17 |    287 |          788 | 0.3642132 |
|      5 | back to base                 | 1994-11-20 |    136 |          377 | 0.3607427 |
|     78 | song \#1                     | 1987-09-03 |    322 |          900 | 0.3577778 |
|     81 | strangelight                 | 2001-04-06 |     19 |           57 | 0.3333333 |
|     74 | runaway return               | 1990-02-11 |    265 |          817 | 0.3243574 |
|     72 | reprovisional                | 1988-12-29 |    276 |          854 | 0.3231850 |
|      6 | bad mouth                    | 1987-10-16 |    280 |          897 | 0.3121516 |
|     30 | fell, destroyed              | 1993-08-16 |    137 |          449 | 0.3051225 |
|     52 | long distance runner         | 1994-11-27 |    113 |          376 | 0.3005319 |
|     24 | downed city                  | 1994-11-20 |    111 |          377 | 0.2944297 |
|     93 | walken’s syndrome            | 1992-10-23 |    141 |          516 | 0.2732558 |
|     18 | cassavetes                   | 1991-07-28 |    171 |          632 | 0.2705696 |
|     61 | pink frosty                  | 1996-03-20 |     67 |          251 | 0.2669323 |
|     73 | returning the screw          | 1992-10-23 |    134 |          516 | 0.2596899 |
|     13 | bulldog front                | 1988-06-15 |    226 |          876 | 0.2579909 |
|     49 | latin roots                  | 1990-10-01 |    182 |          729 | 0.2496571 |
|     15 | burning too                  | 1988-08-01 |    215 |          872 | 0.2465596 |
|     14 | burning                      | 1988-02-06 |    214 |          890 | 0.2404494 |
|     79 | stacks                       | 1991-02-15 |    153 |          691 | 0.2214182 |
|     40 | greed                        | 1989-03-24 |    188 |          853 | 0.2203986 |
|     47 | last chance for a slow dance | 1991-07-28 |    136 |          632 | 0.2151899 |
|     22 | dear justice letter          | 1991-01-02 |    148 |          694 | 0.2132565 |
|     19 | caustic acrostic             | 1996-01-30 |     51 |          254 | 0.2007874 |
|     46 | kyeo                         | 1987-10-07 |    173 |          898 | 0.1926503 |
|     33 | foreman’s dog                | 1998-05-01 |     33 |          176 | 0.1875000 |
|     12 | brendan \#1                  | 1989-03-24 |    158 |          853 | 0.1852286 |
|     51 | lockdown                     | 1987-12-03 |    165 |          895 | 0.1843575 |
|     56 | nice new outfit              | 1991-02-20 |    115 |          690 | 0.1666667 |
|     38 | glueman                      | 1988-05-12 |    133 |          884 | 0.1504525 |
|     11 | break-in                     | 1987-10-16 |    134 |          897 | 0.1493868 |
|     45 | joe \#1                      | 1987-09-03 |    132 |          900 | 0.1466667 |
|     41 | guilford fall                | 1996-08-15 |     32 |          229 | 0.1397380 |
|     36 | furniture                    | 1987-09-03 |     94 |          900 | 0.1044444 |
|     48 | latest disgrace              | 1994-11-20 |     39 |          377 | 0.1034483 |
|     91 | version                      | 1994-08-27 |     34 |          378 | 0.0899471 |
|     80 | steady diet                  | 1991-04-12 |     46 |          673 | 0.0683507 |
|     21 | combination lock             | 1994-11-27 |     21 |          376 | 0.0558511 |
|      1 | 23 beats off                 | 1992-10-23 |     26 |          516 | 0.0503876 |
|     42 | hello morning                | 2001-04-27 |      2 |           45 | 0.0444444 |
|     87 | the word                     | 1987-09-03 |     31 |          900 | 0.0344444 |
|     43 | in defense of humans         | 1987-09-03 |     25 |          900 | 0.0277778 |
|     88 | turn off your guns           | 1987-09-03 |     15 |          900 | 0.0166667 |
|     66 | provisional                  | 1988-11-14 |      8 |          863 | 0.0092700 |
|     63 | polish                       | 1991-03-06 |      6 |          685 | 0.0087591 |
|     94 | world beat                   | 1996-01-30 |      2 |          254 | 0.0078740 |
|     64 | preprovisional               | 1988-10-31 |      6 |          866 | 0.0069284 |

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
#> [1] 23280
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

| rank_rating | songid | song                         |   Estimate |    z-value |
|------------:|-------:|:-----------------------------|-----------:|-----------:|
|           1 |     10 | break                        |  3.6151309 | 16.6149760 |
|           2 |      7 | bed for the scraping         |  3.6132708 | 17.4354500 |
|           3 |     69 | reclamation                  |  3.5928734 | 17.6389784 |
|           4 |     23 | do you like me               |  3.4384435 | 16.5323445 |
|           5 |     20 | closed captioned             |  3.3332829 | 15.1087393 |
|           6 |     17 | cashout                      |  3.3219397 | 13.1021613 |
|           7 |     62 | place position               |  3.2284656 | 14.5986343 |
|           8 |     92 | waiting room                 |  3.1528596 | 14.9893938 |
|           9 |     85 | target                       |  3.1522621 | 15.1840506 |
|          10 |     68 | recap modotti                |  3.1322854 | 14.1235711 |
|          11 |     59 | number 5                     |  3.0227345 | 13.0589993 |
|          12 |      9 | blueprint                    |  3.0136458 | 14.7683753 |
|          13 |     76 | sieve-fisted find            |  2.9638769 | 14.2762975 |
|          14 |     55 | merchandise                  |  2.9579034 | 13.9887751 |
|          15 |     70 | rend it                      |  2.9307233 | 14.3643152 |
|          16 |      4 | arpeggiator                  |  2.8769889 | 13.0497540 |
|          17 |      8 | birthday pony                |  2.7843413 | 13.2304591 |
|          18 |     28 | facet squared                |  2.7812830 | 13.5277056 |
|          19 |     54 | margin walker                |  2.7807233 | 13.3239780 |
|          20 |     89 | turnover                     |  2.7520394 | 13.2424418 |
|          21 |     53 | long division                |  2.7064274 | 13.0951452 |
|          22 |     67 | public witness program       |  2.7001402 | 13.1214187 |
|          23 |      3 | argument                     |  2.6976917 | 10.9563104 |
|          24 |     60 | oh                           |  2.6808937 | 11.2149156 |
|          25 |     86 | the kill                     |  2.6648060 |  9.5871521 |
|          26 |     29 | fd                           |  2.6162995 | 11.6136202 |
|          27 |     34 | forensic scene               |  2.6080878 | 12.4033604 |
|          28 |     16 | by you                       |  2.5793459 | 12.4574970 |
|          29 |     77 | smallpox champion            |  2.5674365 | 12.4542531 |
|          30 |     31 | five corporations            |  2.5599379 | 11.3953052 |
|          31 |      2 | and the same                 |  2.5470885 | 11.9690939 |
|          32 |     32 | floating boy                 |  2.5350336 | 11.2458226 |
|          33 |     44 | instrument                   |  2.5012510 | 12.1464337 |
|          34 |     50 | life and limb                |  2.4112048 |  7.7422559 |
|          35 |     39 | great cop                    |  2.4106031 | 11.7012988 |
|          36 |     78 | song \#1                     |  2.3951887 | 11.2108337 |
|          37 |     37 | give me the cure             |  2.3843146 | 11.2974018 |
|          38 |     90 | two beats off                |  2.3827643 | 11.4523925 |
|          39 |     26 | ex-spectator                 |  2.3681516 |  9.0955783 |
|          40 |     35 | full disclosure              |  2.3611212 |  7.9244607 |
|          41 |     71 | repeater                     |  2.3311568 | 11.2820890 |
|          42 |     25 | epic problem                 |  2.3195059 |  8.2603483 |
|          43 |     82 | styrofoam                    |  2.2764726 | 10.9591809 |
|          44 |     83 | suggestion                   |  2.2722860 | 10.7145833 |
|          45 |     58 | no surprise                  |  2.2666353 |  9.8883853 |
|          46 |     65 | promises                     |  2.2545649 | 10.7843545 |
|          47 |      5 | back to base                 |  2.2011881 | 10.1678255 |
|          48 |      6 | bad mouth                    |  2.1873359 | 10.2145383 |
|          49 |     27 | exit only                    |  2.1731676 | 10.4641283 |
|          50 |     75 | shut the door                |  2.1671432 | 10.3554887 |
|          51 |     57 | nightshop                    |  2.1616521 |  8.2716626 |
|          52 |     84 | sweet and low                |  2.1421206 | 10.3799135 |
|          53 |     74 | runaway return               |  2.0130082 |  9.6354315 |
|          54 |     24 | downed city                  |  1.9052989 |  8.6529808 |
|          55 |     13 | bulldog front                |  1.8992168 |  8.8755212 |
|          56 |     30 | fell, destroyed              |  1.8904206 |  8.8200245 |
|          57 |     93 | walken’s syndrome            |  1.8861810 |  8.8328817 |
|          58 |     72 | reprovisional                |  1.8805356 |  8.9193094 |
|          59 |     52 | long distance runner         |  1.8486327 |  8.4095765 |
|          60 |     81 | strangelight                 |  1.8242021 |  5.7338584 |
|          61 |     15 | burning too                  |  1.8215669 |  8.5020613 |
|          62 |     18 | cassavetes                   |  1.8201967 |  8.6109538 |
|          63 |     61 | pink frosty                  |  1.8066725 |  7.6620996 |
|          64 |     14 | burning                      |  1.8013983 |  8.3358598 |
|          65 |     73 | returning the screw          |  1.7811400 |  8.3074786 |
|          66 |     49 | latin roots                  |  1.7608370 |  8.3176852 |
|          67 |     40 | greed                        |  1.7271599 |  8.0502161 |
|          68 |     22 | dear justice letter          |  1.6086562 |  7.5093759 |
|          69 |     19 | caustic acrostic             |  1.5749119 |  6.4180914 |
|          70 |     79 | stacks                       |  1.5714261 |  7.3543751 |
|          71 |     47 | last chance for a slow dance |  1.4995064 |  6.9805344 |
|          72 |     12 | brendan \#1                  |  1.4703437 |  6.7793896 |
|          73 |     51 | lockdown                     |  1.4685222 |  6.6895343 |
|          74 |     46 | kyeo                         |  1.4059058 |  6.4009275 |
|          75 |     56 | nice new outfit              |  1.3095043 |  5.9881733 |
|          76 |     33 | foreman’s dog                |  1.2630294 |  4.6491262 |
|          77 |     11 | break-in                     |  1.2197548 |  5.4668722 |
|          78 |     45 | joe \#1                      |  1.1729447 |  5.2280109 |
|          79 |     41 | guilford fall                |  1.1498609 |  4.2708032 |
|          80 |     38 | glueman                      |  1.0976805 |  4.9506273 |
|          81 |     36 | furniture                    |  0.8682549 |  3.7616061 |
|          82 |     48 | latest disgrace              |  0.7790864 |  3.0530077 |
|          83 |     66 | provisional                  |  0.5551207 |  1.3531239 |
|          84 |     91 | version                      |  0.5451926 |  2.0813508 |
|          85 |     80 | steady diet                  |  0.3469293 |  1.4073716 |
|          86 |     21 | combination lock             |  0.1140464 |  0.3864588 |
|          87 |      1 | 23 beats off                 |  0.0000000 |         NA |
|          88 |     42 | hello morning                | -0.2863910 | -0.3865418 |
|          89 |     87 | the word                     | -0.4329009 | -1.5582092 |
|          90 |     43 | in defense of humans         | -0.5602311 | -1.9489160 |
|          91 |     88 | turn off your guns           | -1.0811282 | -3.2703801 |
|          92 |     94 | world beat                   | -1.7996925 | -2.4477619 |
|          93 |     63 | polish                       | -1.8009262 | -3.9702490 |
|          94 |     64 | preprovisional               | -2.0608606 | -4.5226576 |

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

| song                         | chosen | intensity |    rating |
|:-----------------------------|-------:|----------:|----------:|
| break                        |    172 | 0.7510917 | 1.0000000 |
| bed for the scraping         |    299 | 0.7931034 | 0.9996723 |
| reclamation                  |    594 | 0.7471698 | 0.9960787 |
| do you like me               |    272 | 0.7214854 | 0.9688711 |
| closed captioned             |    159 | 0.7989950 | 0.9503438 |
| cashout                      |     62 | 0.9393939 | 0.9483454 |
| place position               |    133 | 0.5807860 | 0.9318771 |
| waiting room                 |    633 | 0.7033333 | 0.9185567 |
| target                       |    260 | 0.6753247 | 0.9184515 |
| recap modotti                |    141 | 0.6811594 | 0.9149320 |
| number 5                     |    110 | 0.7586207 | 0.8956312 |
| blueprint                    |    584 | 0.7070218 | 0.8940300 |
| sieve-fisted find            |    418 | 0.4900352 | 0.8852616 |
| merchandise                  |    477 | 0.5300000 | 0.8842092 |
| rend it                      |    346 | 0.5914530 | 0.8794206 |
| arpeggiator                  |    154 | 0.7403846 | 0.8699537 |
| birthday pony                |    199 | 0.5168831 | 0.8536309 |
| facet squared                |    299 | 0.4814815 | 0.8530921 |
| margin walker                |    430 | 0.4931193 | 0.8529935 |
| turnover                     |    395 | 0.4658019 | 0.8479400 |
| long division                |    498 | 0.5872642 | 0.8399040 |
| public witness program       |    264 | 0.5146199 | 0.8387963 |
| argument                     |     66 | 0.6534653 | 0.8383650 |
| oh                           |     80 | 0.5839416 | 0.8354055 |
| the kill                     |     35 | 0.6034483 | 0.8325711 |
| fd                           |    115 | 0.5528846 | 0.8240252 |
| forensic scene               |    201 | 0.5248042 | 0.8225785 |
| by you                       |    233 | 0.4884696 | 0.8175147 |
| smallpox champion            |    253 | 0.4903101 | 0.8154165 |
| five corporations            |    109 | 0.4759825 | 0.8140954 |
| and the same                 |    376 | 0.4182425 | 0.8118316 |
| floating boy                 |    106 | 0.4669604 | 0.8097077 |
| instrument                   |    272 | 0.4665523 | 0.8037559 |
| life and limb                |     21 | 0.4772727 | 0.7878915 |
| great cop                    |    268 | 0.4581197 | 0.7877855 |
| song \#1                     |    322 | 0.3577778 | 0.7850698 |
| give me the cure             |    369 | 0.4160090 | 0.7831540 |
| two beats off                |    371 | 0.4385343 | 0.7828808 |
| ex-spectator                 |     45 | 0.4455446 | 0.7803063 |
| full disclosure              |     26 | 0.4482759 | 0.7790677 |
| repeater                     |    410 | 0.4892601 | 0.7737886 |
| epic problem                 |     32 | 0.4923077 | 0.7717359 |
| styrofoam                    |    287 | 0.3642132 | 0.7641543 |
| suggestion                   |    340 | 0.3798883 | 0.7634167 |
| no surprise                  |     89 | 0.3903509 | 0.7624211 |
| promises                     |    380 | 0.4372842 | 0.7602946 |
| back to base                 |    136 | 0.3607427 | 0.7508906 |
| bad mouth                    |    280 | 0.3121516 | 0.7484501 |
| exit only                    |    275 | 0.3642384 | 0.7459539 |
| shut the door                |    323 | 0.3786635 | 0.7448926 |
| nightshop                    |     44 | 0.4356436 | 0.7439251 |
| sweet and low                |    249 | 0.4422735 | 0.7404841 |
| runaway return               |    265 | 0.3243574 | 0.7177370 |
| downed city                  |    111 | 0.2944297 | 0.6987606 |
| bulldog front                |    226 | 0.2579909 | 0.6976891 |
| fell, destroyed              |    137 | 0.3051225 | 0.6961394 |
| walken’s syndrome            |    141 | 0.2732558 | 0.6953924 |
| reprovisional                |    276 | 0.3231850 | 0.6943978 |
| long distance runner         |    113 | 0.3005319 | 0.6887772 |
| strangelight                 |     19 | 0.3333333 | 0.6844730 |
| burning too                  |    215 | 0.2465596 | 0.6840087 |
| cassavetes                   |    171 | 0.2705696 | 0.6837673 |
| pink frosty                  |     67 | 0.2669323 | 0.6813846 |
| burning                      |    214 | 0.2404494 | 0.6804554 |
| returning the screw          |    134 | 0.2596899 | 0.6768863 |
| latin roots                  |    182 | 0.2496571 | 0.6733093 |
| greed                        |    188 | 0.2203986 | 0.6673760 |
| dear justice letter          |    148 | 0.2132565 | 0.6464979 |
| caustic acrostic             |     51 | 0.2007874 | 0.6405528 |
| stacks                       |    153 | 0.2214182 | 0.6399387 |
| last chance for a slow dance |    136 | 0.2151899 | 0.6272679 |
| brendan \#1                  |    158 | 0.1852286 | 0.6221300 |
| lockdown                     |    165 | 0.1843575 | 0.6218090 |
| kyeo                         |    173 | 0.1926503 | 0.6107772 |
| nice new outfit              |    115 | 0.1666667 | 0.5937932 |
| foreman’s dog                |     33 | 0.1875000 | 0.5856052 |
| break-in                     |    134 | 0.1493868 | 0.5779810 |
| joe \#1                      |    132 | 0.1466667 | 0.5697340 |
| guilford fall                |     32 | 0.1397380 | 0.5656671 |
| glueman                      |    133 | 0.1504525 | 0.5564739 |
| furniture                    |     94 | 0.1044444 | 0.5160535 |
| latest disgrace              |     39 | 0.1034483 | 0.5003438 |
| provisional                  |      8 | 0.0092700 | 0.4608853 |
| version                      |     34 | 0.0899471 | 0.4591362 |
| steady diet                  |     46 | 0.0683507 | 0.4242061 |
| combination lock             |     21 | 0.0558511 | 0.3831766 |
| 23 beats off                 |     26 | 0.0503876 | 0.3630838 |
| hello morning                |      2 | 0.0444444 | 0.3126273 |
| the word                     |     31 | 0.0344444 | 0.2868150 |
| in defense of humans         |     25 | 0.0277778 | 0.2643819 |
| turn off your guns           |     15 | 0.0166667 | 0.1726099 |
| world beat                   |      2 | 0.0078740 | 0.0460128 |
| polish                       |      6 | 0.0087591 | 0.0457954 |
| preprovisional               |      6 | 0.0069284 | 0.0000000 |

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

| song1        | song2         | coef1 | coef2 | coefdiff |    z |
|:-------------|:--------------|------:|------:|---------:|-----:|
| waiting room | bulldog front | 3.148 | 1.899 |    1.249 | 1.72 |

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

| song1               | song2               | coef1 |  coef2 | coefdiff |       z |
|:--------------------|:--------------------|------:|-------:|---------:|--------:|
| waiting room        | and the same        | 3.148 |  2.545 |    0.603 |   0.836 |
| and the same        | turnover            | 2.545 |  2.751 |   -0.206 |  -0.782 |
| turnover            | styrofoam           | 2.751 |  2.274 |    0.477 |   1.352 |
| styrofoam           | steady diet         | 2.274 |  0.345 |    1.929 |   7.433 |
| steady diet         | returning the screw | 0.345 |  1.781 |   -1.436 |  -6.141 |
| returning the screw | instrument          | 1.781 |  2.500 |   -0.719 |  -4.192 |
| instrument          | fell, destroyed     | 2.500 |  1.891 |    0.609 |   5.104 |
| fell, destroyed     | place position      | 1.891 |  3.231 |   -1.340 | -11.316 |
| place position      | arpeggiator         | 3.231 |  2.880 |    0.351 |   2.709 |
| arpeggiator         | the kill            | 2.880 |  2.668 |    0.212 |   0.902 |
| the kill            | hello morning       | 2.668 | -0.284 |    2.952 |  12.658 |

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

| releaseid | release                | first_debut | last_debut | release_date | songs | count | shows | intensity | rating |
|----------:|:-----------------------|:------------|:-----------|:-------------|------:|------:|------:|----------:|-------:|
|         9 | the argument           | 1998-11-29  | 2001-06-21 | 2001-10-16   |    10 |   430 |    79 |    0.5412 | 0.8000 |
|         8 | end hits               | 1996-01-30  | 1998-05-01 | 1998-04-24   |    13 |  1361 |   221 |    0.4795 | 0.7961 |
|         4 | repeater               | 1987-09-03  | 1990-05-17 | 1990-03-01   |    11 |  3887 |   846 |    0.4175 | 0.7784 |
|         1 | fugazi                 | 1987-09-03  | 1988-06-15 | 1988-11-19   |     7 |  2195 |   889 |    0.3519 | 0.7357 |
|         7 | red medicine           | 1993-04-24  | 1994-11-27 | 1995-05-12   |    13 |  2055 |   392 |    0.4023 | 0.7352 |
|         6 | in on the killtaker    | 1991-07-28  | 1993-02-05 | 1993-06-18   |    12 |  2559 |   565 |    0.3762 | 0.7305 |
|         2 | margin walker          | 1987-09-26  | 1988-11-14 | 1989-06-15   |     6 |  1574 |   878 |    0.2985 | 0.6989 |
|         3 | 3 songs                | 1987-09-03  | 1987-10-16 | 1989-12-01   |     3 |   588 |   898 |    0.2182 | 0.6445 |
|         5 | steady diet of nothing | 1987-10-07  | 1991-04-12 | 1991-08-01   |    11 |  2455 |   752 |    0.2858 | 0.6305 |
|        10 | furniture              | 1987-09-03  | 2001-04-27 | 2001-10-16   |     3 |   206 |   363 |    0.3025 | 0.5753 |
|        11 | first demo             | 1987-09-03  | 1987-09-03 | 2014-11-18   |     3 |    71 |   899 |    0.0263 | 0.2414 |
|        13 | unreleased             | 1988-10-31  | 1996-01-30 | NA           |     2 |     8 |   560 |    0.0074 | 0.0228 |
