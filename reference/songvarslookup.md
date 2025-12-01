# Fugazi songs data

Song data from the Fugazi discography pages on Wikipedia. The variables
attributing lead vocals are simplifications in some cases where lead
vocals were shared.

## Usage

``` r
songvarslookup
```

## Format

dataframe with one row for each song in the Fugazi discography, except
those which never appear in the Fugazi Live Series data.

- songid:

  numeric id for each song

- releaseid:

  numeric id in ascending chronological order

- track_number:

  The track number for the song on the release

- instrumental:

  Indicates whether or not the piece is an instrumental

- vocals_picciotto:

  indicates whether or not Guy Picciotto sang lead vocals on this track

- vocals_mackaye:

  indicates whether or not Ian Mackaye sang lead vocals on this track

- vocals_lally:

  indicates whether or not Joe Lally sang lead vocals on this track

- duration_seconds:

  The duration of the song in seconds

## Source

https://web.archive.org/web/20201112000517/http://en.wikipedia.org/wiki/Fugazi_discography

## Examples

``` r
  songvarslookup
#>    rank_length releaseid track_number                         song songid
#> 1            1         6            6                 23 beats off      1
#> 2           43         2            2                 and the same      2
#> 3           13         9           11                     argument      3
#> 4           12         8           10                  arpeggiator      4
#> 5           93         7           11                 back to base      5
#> 6           76         1            3                    bad mouth      6
#> 7           70         7            2         bed for the scraping      7
#> 8           56         7            4                birthday pony      8
#> 9           28         4            5                    blueprint      9
#> 10          84         8            1                        break     10
#> 11          94         3            3                     break-in     11
#> 12          78         4            3                   brendan #1     12
#> 13          67         1            2                bulldog front     13
#> 14          75         1            4                      burning     14
#> 15          71         2            3                  burning too     15
#> 16           5         7            8                       by you     16
#> 17          14         9            2                      cashout     17
#> 18          79         6            8                   cassavetes     18
#> 19          90         8            6             caustic acrostic     19
#> 20           6         8            7             closed captioned     20
#> 21          58         7            6             combination lock     21
#> 22          44         5           10          dear justice letter     22
#> 23          50         7            1               do you like me     23
#> 24          68         7           12                  downed city     24
#> 25          25         9            4                 epic problem     25
#> 26          53         5            1                    exit only     27
#> 27          17         9            9                 ex-spectator     26
#> 28          74         6            1                facet squared     28
#> 29          35         8           13                           fd     29
#> 30          31         7            7              fell, destroyed     30
#> 31          81         8            5            five corporations     31
#> 32           3         8            8                 floating boy     32
#> 33          16         8            9                foreman's dog     33
#> 34          59         7            5               forensic scene     34
#> 35          27         9            3              full disclosure     35
#> 36          39        10            1                    furniture     36
#> 37          63         1            5             give me the cure     37
#> 38          15         1            7                      glueman     38
#> 39          91         6            9                    great cop     39
#> 40          92         4            7                        greed     40
#> 41          65         8           11                guilford fall     41
#> 42          88        10            3                hello morning     42
#> 43          72        11           10         in defense of humans     43
#> 44          33         6           11                   instrument     44
#> 45          60         3            2                       joe #1     45
#> 46          64         5           11                         kyeo     46
#> 47           9         6           12 last chance for a slow dance     47
#> 48          40         7            3              latest disgrace     48
#> 49          51         5            5                  latin roots     49
#> 50          54         9            5                life and limb     50
#> 51          86         2            5                     lockdown     51
#> 52          18         7           13         long distance runner     52
#> 53          85         5            7                long division     53
#> 54          80         2            1                margin walker     54
#> 55          62         4            4                  merchandise     55
#> 56          45         5            3              nice new outfit     56
#> 57          22         9           10                    nightshop     57
#> 58          20         8            4                  no surprise     58
#> 59          55        10            2                     number 5     59
#> 60          11         9            8                           oh     60
#> 61          21         8           12                  pink frosty     61
#> 62          73         8            2               place position     62
#> 63          37         5            9                       polish     63
#> 64          87        13            1               preprovisional     64
#> 65          23         2            6                     promises     65
#> 66          83         2            4                  provisional     66
#> 67          89         6            2       public witness program     67
#> 68          29         8            3                recap modotti     68
#> 69          47         5            2                  reclamation     69
#> 70          30         6            5                      rend it     70
#> 71          61         4            2                     repeater     71
#> 72          82         4           10                reprovisional     72
#> 73          52         6            3          returning the screw     73
#> 74          26         5            8               runaway return     74
#> 75           7         4           11                shut the door     75
#> 76          46         4            6            sieve-fisted find     76
#> 77          24         6            4            smallpox champion     77
#> 78          66         3            1                      song #1     78
#> 79          57         5            4                       stacks     79
#> 80          36         5            6                  steady diet     80
#> 81           2         9            7                 strangelight     81
#> 82          77         4            9                    styrofoam     82
#> 83           8         1            6                   suggestion     83
#> 84          38         6            7                sweet and low     84
#> 85          41         7           10                       target     85
#> 86           4         9            6                     the kill     86
#> 87          10        11            5                     the word     87
#> 88          34        11            8           turn off your guns     88
#> 89          19         4            1                     turnover     89
#> 90          42         4            8                two beats off     90
#> 91          48         7            9                      version     91
#> 92          69         1            1                 waiting room     92
#> 93          49         6           10            walken's syndrome     93
#> 94          32        13            2                   world beat     94
#>    instrumental vocals_picciotto vocals_mackaye vocals_lally duration_seconds
#> 1             0                0              1            0              401
#> 2             0                0              1            0              207
#> 3             0                0              1            0              267
#> 4             1                0              0            0              268
#> 5             0                0              1            0              105
#> 6             0                0              1            0              155
#> 7             0                0              1            0              170
#> 8             0                0              1            0              188
#> 9             0                1              0            0              232
#> 10            0                0              1            0              132
#> 11            0                1              0            0               92
#> 12            1                0              0            0              152
#> 13            0                1              0            0              173
#> 14            0                1              0            0              159
#> 15            0                0              1            0              170
#> 16            0                0              0            1              311
#> 17            0                0              1            0              264
#> 18            0                1              0            0              150
#> 19            0                1              0            0              121
#> 20            0                0              1            0              292
#> 21            1                0              0            0              186
#> 22            0                1              0            0              207
#> 23            0                1              0            0              196
#> 24            0                1              0            0              173
#> 25            0                0              1            0              239
#> 26            0                1              0            0              191
#> 27            0                0              1            0              258
#> 28            0                0              1            0              162
#> 29            0                0              1            0              222
#> 30            0                1              0            0              226
#> 31            0                0              1            0              149
#> 32            0                1              0            0              345
#> 33            0                1              0            0              261
#> 34            0                1              0            0              185
#> 35            0                1              0            0              233
#> 36            0                0              1            0              215
#> 37            0                1              0            0              178
#> 38            0                1              0            0              263
#> 39            0                0              1            0              112
#> 40            0                0              1            0              107
#> 41            0                1              0            0              177
#> 42            0                1              0            0              126
#> 43            0                0              1            0              167
#> 44            0                0              1            0              223
#> 45            1                0              0            0              181
#> 46            0                0              1            0              178
#> 47            0                1              0            0              278
#> 48            0                1              0            0              214
#> 49            0                1              0            0              193
#> 50            0                1              0            0              189
#> 51            0                1              0            0              130
#> 52            0                0              1            0              257
#> 53            0                0              1            0              132
#> 54            0                1              0            0              150
#> 55            0                0              1            0              179
#> 56            0                1              0            0              206
#> 57            0                1              0            0              242
#> 58            0                1              0            0              252
#> 59            1                0              0            0              189
#> 60            0                1              0            0              269
#> 61            0                0              1            0              249
#> 62            0                1              0            0              165
#> 63            0                0              1            0              218
#> 64            0                1              0            0              130
#> 65            0                0              1            0              242
#> 66            0                1              0            0              137
#> 67            0                1              0            0              124
#> 68            0                0              0            1              230
#> 69            0                0              1            0              201
#> 70            0                1              0            0              228
#> 71            0                0              1            0              181
#> 72            0                1              0            0              138
#> 73            0                0              1            0              193
#> 74            0                1              0            0              238
#> 75            0                0              1            0              289
#> 76            0                1              0            0              204
#> 77            0                1              0            0              241
#> 78            0                0              1            0              174
#> 79            0                0              1            0              188
#> 80            1                0              0            0              222
#> 81            0                1              0            0              353
#> 82            0                0              1            0              154
#> 83            0                0              1            0              284
#> 84            1                0              0            0              216
#> 85            0                1              0            0              212
#> 86            0                0              0            1              327
#> 87            0                0              1            0              278
#> 88            0                0              1            0              223
#> 89            0                1              0            0              256
#> 90            0                1              0            0              208
#> 91            1                0              0            0              200
#> 92            0                0              1            0              173
#> 93            0                1              0            0              198
#> 94            1                0              0            0              226
```
