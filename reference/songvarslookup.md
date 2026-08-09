# Song discography metadata (Wikipedia)

Song discography metadata (Wikipedia)

## Usage

``` r
songvarslookup
```

## Format

dataframe with one row for each song in the Fugazi discography.

- releaseid:

  numeric id of the release the song appears on, references
  [`releasesdatalookup`](https://alexmitrani.github.io/Repeatr/reference/releasesdatalookup.md)

- track_number:

  The track number for the song on the release

- song:

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
`inst/extdata/releases_songs_durations_wikipedia.csv`. Read by
[`Repeatr_1`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_1.md)
and joined onto the live, classified song set by `song` title text, not
by a hardcoded id column - see
`songid`/[`songidlookup`](https://alexmitrani.github.io/Repeatr/reference/songidlookup.md).
Exported as-is as fugazi.db's `songs` table by
[`export_fugazidb_data`](https://alexmitrani.github.io/Repeatr/reference/export_fugazidb_data.md).

## Examples

``` r
songvarslookup
#>    releaseid track_number                         song instrumental
#> 1          6            6                 23 beats off            0
#> 2          2            2                 and the same            0
#> 3          9           11                     argument            0
#> 4          8           10                  arpeggiator            1
#> 5          7           11                 back to base            0
#> 6          1            3                    bad mouth            0
#> 7          7            2         bed for the scraping            0
#> 8          7            4                birthday pony            0
#> 9          4            5                    blueprint            0
#> 10         8            1                        break            0
#> 11         3            3                     break-in            0
#> 12         4            3                   brendan #1            1
#> 13         1            2                bulldog front            0
#> 14         1            4                      burning            0
#> 15         2            3                  burning too            0
#> 16         7            8                       by you            0
#> 17         9            2                      cashout            0
#> 18         6            8                   cassavetes            0
#> 19         8            6             caustic acrostic            0
#> 20         8            7             closed captioned            0
#> 21         7            6             combination lock            1
#> 22         5           10          dear justice letter            0
#> 23         7            1               do you like me            0
#> 24         7           12                  downed city            0
#> 25         9            4                 epic problem            0
#> 26         5            1                    exit only            0
#> 27         9            9                 ex-spectator            0
#> 28         6            1                facet squared            0
#> 29         8           13                           fd            0
#> 30         7            7              fell, destroyed            0
#> 31         8            5            five corporations            0
#> 32         8            8                 floating boy            0
#> 33         8            9                foreman's dog            0
#> 34         7            5               forensic scene            0
#> 35         9            3              full disclosure            0
#> 36        10            1                    furniture            0
#> 37         1            5             give me the cure            0
#> 38         1            7                      glueman            0
#> 39         6            9                    great cop            0
#> 40         4            7                        greed            0
#> 41         8           11                guilford fall            0
#> 42        10            3                hello morning            0
#> 43        11           10         in defense of humans            0
#> 44         6           11                   instrument            0
#> 45         3            2                       joe #1            1
#> 46         5           11                         kyeo            0
#> 47         6           12 last chance for a slow dance            0
#> 48         7            3              latest disgrace            0
#> 49         5            5                  latin roots            0
#> 50         9            5                life and limb            0
#> 51         2            5                     lockdown            0
#> 52         7           13         long distance runner            0
#> 53         5            7                long division            0
#> 54         2            1                margin walker            0
#> 55         4            4                  merchandise            0
#> 56         5            3              nice new outfit            0
#> 57         9           10                    nightshop            0
#> 58         8            4                  no surprise            0
#> 59        10            2                     number 5            1
#> 60         9            8                           oh            0
#> 61         8           12                  pink frosty            0
#> 62         8            2               place position            0
#> 63         5            9                       polish            0
#> 64         2            6                     promises            0
#> 65         2            4                  provisional            0
#> 66         6            2       public witness program            0
#> 67         8            3                recap modotti            0
#> 68         5            2                  reclamation            0
#> 69         6            5                      rend it            0
#> 70         4            2                     repeater            0
#> 71         4           10                reprovisional            0
#> 72         6            3          returning the screw            0
#> 73         5            8               runaway return            0
#> 74         4           11                shut the door            0
#> 75         4            6            sieve-fisted find            0
#> 76         6            4            smallpox champion            0
#> 77         3            1                      song #1            0
#> 78         5            4                       stacks            0
#> 79         5            6                  steady diet            1
#> 80         9            7                 strangelight            0
#> 81         4            9                    styrofoam            0
#> 82         1            6                   suggestion            0
#> 83         6            7                sweet and low            1
#> 84         7           10                       target            0
#> 85         9            6                     the kill            0
#> 86        11            5                     the word            0
#> 87        11            8           turn off your guns            0
#> 88         4            1                     turnover            0
#> 89         4            8                two beats off            0
#> 90         7            9                      version            1
#> 91         1            1                 waiting room            0
#> 92         6           10            walken's syndrome            0
#>    vocals_picciotto vocals_mackaye vocals_lally duration_seconds
#> 1                 0              1            0              401
#> 2                 0              1            0              207
#> 3                 0              1            0              267
#> 4                 0              0            0              268
#> 5                 0              1            0              105
#> 6                 0              1            0              155
#> 7                 0              1            0              170
#> 8                 0              1            0              188
#> 9                 1              0            0              232
#> 10                0              1            0              132
#> 11                1              0            0               92
#> 12                0              0            0              152
#> 13                1              0            0              173
#> 14                1              0            0              159
#> 15                0              1            0              170
#> 16                0              0            1              311
#> 17                0              1            0              264
#> 18                1              0            0              150
#> 19                1              0            0              121
#> 20                0              1            0              292
#> 21                0              0            0              186
#> 22                1              0            0              207
#> 23                1              0            0              196
#> 24                1              0            0              173
#> 25                0              1            0              239
#> 26                1              0            0              191
#> 27                0              1            0              258
#> 28                0              1            0              162
#> 29                0              1            0              222
#> 30                1              0            0              226
#> 31                0              1            0              149
#> 32                1              0            0              345
#> 33                1              0            0              261
#> 34                1              0            0              185
#> 35                1              0            0              233
#> 36                0              1            0              215
#> 37                1              0            0              178
#> 38                1              0            0              263
#> 39                0              1            0              112
#> 40                0              1            0              107
#> 41                1              0            0              177
#> 42                1              0            0              126
#> 43                0              1            0              167
#> 44                0              1            0              223
#> 45                0              0            0              181
#> 46                0              1            0              178
#> 47                1              0            0              278
#> 48                1              0            0              214
#> 49                1              0            0              193
#> 50                1              0            0              189
#> 51                1              0            0              130
#> 52                0              1            0              257
#> 53                0              1            0              132
#> 54                1              0            0              150
#> 55                0              1            0              179
#> 56                1              0            0              206
#> 57                1              0            0              242
#> 58                1              0            0              252
#> 59                0              0            0              189
#> 60                1              0            0              269
#> 61                0              1            0              249
#> 62                1              0            0              165
#> 63                0              1            0              218
#> 64                0              1            0              242
#> 65                1              0            0              137
#> 66                1              0            0              124
#> 67                0              0            1              230
#> 68                0              1            0              201
#> 69                1              0            0              228
#> 70                0              1            0              181
#> 71                1              0            0              138
#> 72                0              1            0              193
#> 73                1              0            0              238
#> 74                0              1            0              289
#> 75                1              0            0              204
#> 76                1              0            0              241
#> 77                0              1            0              174
#> 78                0              1            0              188
#> 79                0              0            0              222
#> 80                1              0            0              353
#> 81                0              1            0              154
#> 82                0              1            0              284
#> 83                0              0            0              216
#> 84                1              0            0              212
#> 85                0              0            1              327
#> 86                0              1            0              278
#> 87                0              1            0              223
#> 88                1              0            0              256
#> 89                1              0            0              208
#> 90                0              0            0              200
#> 91                0              1            0              173
#> 92                1              0            0              198
```
