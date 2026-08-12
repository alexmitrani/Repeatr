# Song discography metadata (Wikipedia)

Song discography metadata (Wikipedia)

## Usage

``` r
songvarslookup
```

## Format

dataframe with one row for each song in the Fugazi discography.

- rid:

  numeric id of the release the song appears on, references
  [`releasesdatalookup`](https://alexmitrani.github.io/Repeatr/reference/releasesdatalookup.md)

- track_number:

  The track number for the song on the release

- title:

  The name of the song

- instrumental:

  Indicates whether or not the piece is an instrumental

- vocals_picciotto:

  indicates whether or not Guy Picciotto sang lead vocals on this track

- vocals_mackaye:

  indicates whether or not Ian Mackaye sang lead vocals on this track

- vocals_lally:

  indicates whether or not Joe Lally sang lead vocals on this track

- duration_seconds:

  duration of the studio recording, in seconds

## Source

https://web.archive.org/web/20201112000517/http://en.wikipedia.org/wiki/Fugazi_discography

## Provenance

Raw-hand-curated, from
`inst/extdata/releases_songs_durations_wikipedia.csv`;
`releaseid`/`song` renamed `rid`/`title` at read time. Read by
[`Repeatr_1`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_1.md)
and joined onto the live, classified song set by `title` text, not by a
hardcoded id column - see
`songid`/[`songidlookup`](https://alexmitrani.github.io/Repeatr/reference/songidlookup.md).
Exported (renamed `track_number`→`release_track`,
`duration_seconds`→`release_duration` converted to a `Period` matching
[`fls_tags`](https://alexmitrani.github.io/Repeatr/reference/fls_tags.md)'s
`duration`) as fugazibase's `songs` table by
[`export_fugazibase_data`](https://alexmitrani.github.io/Repeatr/reference/export_fugazibase_data.md).

## Examples

``` r
songvarslookup
#>    rid track_number                        title instrumental vocals_picciotto
#> 1    6            6                 23 beats off            0                0
#> 2    2            2                 and the same            0                0
#> 3    9           11                     argument            0                0
#> 4    8           10                  arpeggiator            1                0
#> 5    7           11                 back to base            0                0
#> 6    1            3                    bad mouth            0                0
#> 7    7            2         bed for the scraping            0                0
#> 8    7            4                birthday pony            0                0
#> 9    4            5                    blueprint            0                1
#> 10   8            1                        break            0                0
#> 11   3            3                     break-in            0                1
#> 12   4            3                   brendan #1            1                0
#> 13   1            2                bulldog front            0                1
#> 14   1            4                      burning            0                1
#> 15   2            3                  burning too            0                0
#> 16   7            8                       by you            0                0
#> 17   9            2                      cashout            0                0
#> 18   6            8                   cassavetes            0                1
#> 19   8            6             caustic acrostic            0                1
#> 20   8            7             closed captioned            0                0
#> 21   7            6             combination lock            1                0
#> 22   5           10          dear justice letter            0                1
#> 23   7            1               do you like me            0                1
#> 24   7           12                  downed city            0                1
#> 25   9            4                 epic problem            0                0
#> 26   5            1                    exit only            0                1
#> 27   9            9                 ex-spectator            0                0
#> 28   6            1                facet squared            0                0
#> 29   8           13                           fd            0                0
#> 30   7            7              fell, destroyed            0                1
#> 31   8            5            five corporations            0                0
#> 32   8            8                 floating boy            0                1
#> 33   8            9                foreman's dog            0                1
#> 34   7            5               forensic scene            0                1
#> 35   9            3              full disclosure            0                1
#> 36  10            1                    furniture            0                0
#> 37   1            5             give me the cure            0                1
#> 38   1            7                      glueman            0                1
#> 39   6            9                    great cop            0                0
#> 40   4            7                        greed            0                0
#> 41   8           11                guilford fall            0                1
#> 42  10            3                hello morning            0                1
#> 43  11           10         in defense of humans            0                0
#> 44   6           11                   instrument            0                0
#> 45   3            2                       joe #1            1                0
#> 46   5           11                         kyeo            0                0
#> 47   6           12 last chance for a slow dance            0                1
#> 48   7            3              latest disgrace            0                1
#> 49   5            5                  latin roots            0                1
#> 50   9            5                life and limb            0                1
#> 51   2            5                     lockdown            0                1
#> 52   7           13         long distance runner            0                0
#> 53   5            7                long division            0                0
#> 54   2            1                margin walker            0                1
#> 55   4            4                  merchandise            0                0
#> 56   5            3              nice new outfit            0                1
#> 57   9           10                    nightshop            0                1
#> 58   8            4                  no surprise            0                1
#> 59  10            2                     number 5            1                0
#> 60   9            8                           oh            0                1
#> 61   8           12                  pink frosty            0                0
#> 62   8            2               place position            0                1
#> 63   5            9                       polish            0                0
#> 64   2            6                     promises            0                0
#> 65   2            4                  provisional            0                1
#> 66   6            2       public witness program            0                1
#> 67   8            3                recap modotti            0                0
#> 68   5            2                  reclamation            0                0
#> 69   6            5                      rend it            0                1
#> 70   4            2                     repeater            0                0
#> 71   4           10                reprovisional            0                1
#> 72   6            3          returning the screw            0                0
#> 73   5            8               runaway return            0                1
#> 74   4           11                shut the door            0                0
#> 75   4            6            sieve-fisted find            0                1
#> 76   6            4            smallpox champion            0                1
#> 77   3            1                      song #1            0                0
#> 78   5            4                       stacks            0                0
#> 79   5            6                  steady diet            1                0
#> 80   9            7                 strangelight            0                1
#> 81   4            9                    styrofoam            0                0
#> 82   1            6                   suggestion            0                0
#> 83   6            7                sweet and low            1                0
#> 84   7           10                       target            0                1
#> 85   9            6                     the kill            0                0
#> 86  11            5                     the word            0                0
#> 87  11            8           turn off your guns            0                0
#> 88   4            1                     turnover            0                1
#> 89   4            8                two beats off            0                1
#> 90   7            9                      version            1                0
#> 91   1            1                 waiting room            0                0
#> 92   6           10            walken's syndrome            0                1
#>    vocals_mackaye vocals_lally duration_seconds
#> 1               1            0              401
#> 2               1            0              207
#> 3               1            0              267
#> 4               0            0              268
#> 5               1            0              105
#> 6               1            0              155
#> 7               1            0              170
#> 8               1            0              188
#> 9               0            0              232
#> 10              1            0              132
#> 11              0            0               92
#> 12              0            0              152
#> 13              0            0              173
#> 14              0            0              159
#> 15              1            0              170
#> 16              0            1              311
#> 17              1            0              264
#> 18              0            0              150
#> 19              0            0              121
#> 20              1            0              292
#> 21              0            0              186
#> 22              0            0              207
#> 23              0            0              196
#> 24              0            0              173
#> 25              1            0              239
#> 26              0            0              191
#> 27              1            0              258
#> 28              1            0              162
#> 29              1            0              222
#> 30              0            0              226
#> 31              1            0              149
#> 32              0            0              345
#> 33              0            0              261
#> 34              0            0              185
#> 35              0            0              233
#> 36              1            0              215
#> 37              0            0              178
#> 38              0            0              263
#> 39              1            0              112
#> 40              1            0              107
#> 41              0            0              177
#> 42              0            0              126
#> 43              1            0              167
#> 44              1            0              223
#> 45              0            0              181
#> 46              1            0              178
#> 47              0            0              278
#> 48              0            0              214
#> 49              0            0              193
#> 50              0            0              189
#> 51              0            0              130
#> 52              1            0              257
#> 53              1            0              132
#> 54              0            0              150
#> 55              1            0              179
#> 56              0            0              206
#> 57              0            0              242
#> 58              0            0              252
#> 59              0            0              189
#> 60              0            0              269
#> 61              1            0              249
#> 62              0            0              165
#> 63              1            0              218
#> 64              1            0              242
#> 65              0            0              137
#> 66              0            0              124
#> 67              0            1              230
#> 68              1            0              201
#> 69              0            0              228
#> 70              1            0              181
#> 71              0            0              138
#> 72              1            0              193
#> 73              0            0              238
#> 74              1            0              289
#> 75              0            0              204
#> 76              0            0              241
#> 77              1            0              174
#> 78              1            0              188
#> 79              0            0              222
#> 80              0            0              353
#> 81              1            0              154
#> 82              1            0              284
#> 83              0            0              216
#> 84              0            0              212
#> 85              0            1              327
#> 86              1            0              278
#> 87              1            0              223
#> 88              0            0              256
#> 89              0            0              208
#> 90              0            0              200
#> 91              1            0              173
#> 92              0            0              198
```
