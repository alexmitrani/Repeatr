# Fugazi song preferences, ranked by estimated intercept (implied preference)

Produced by
[`Repeatr_5`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_5.md)
from the per-song intercept terms of
[`results_ml_Repeatr4`](https://alexmitrani.github.io/Repeatr/reference/results_ml_Repeatr4.md)
(the omitted reference song - whichever has the smallest `alt` in
[`altlookup`](https://alexmitrani.github.io/Repeatr/reference/altlookup.md) -
is added back in with an estimate of 0), ranked from most to least
preferred.

## Usage

``` r
fugazi_song_preferences
```

## Format

dataframe with one row for each song, ranked by estimated preference.

- rank_rating:

  Rank of the song by estimated preference, 1 = most preferred

- songid:

  numeric id for each song

- song:

  The name of the song

- Estimate:

  The estimated intercept for this song (0 for the omitted reference
  song)

- z-value:

  The z-value of the estimate (NA for the omitted reference song)

## Provenance

Derived-modeled. Produced by
[`Repeatr_5`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_5.md)
from `results_ml_Repeatr4`.

## Examples

``` r
fugazi_song_preferences
#>    rank_rating songid                         song    Estimate    z-value
#> 1            1      7         bed for the scraping  3.60868862 17.7473206
#> 2            2     68                  reclamation  3.60412379 18.0365751
#> 3            3     10                        break  3.56122317 16.7066562
#> 4            4     23               do you like me  3.43463369 16.8314134
#> 5            5     20             closed captioned  3.31997356 15.3773712
#> 6            6     17                      cashout  3.24037193 13.2097176
#> 7            7     62               place position  3.19785928 14.7669130
#> 8            8     91                 waiting room  3.15160718 15.3019763
#> 9            9     84                       target  3.13753660 15.3977028
#> 10          10     67                recap modotti  3.11613742 14.3701092
#> 11          11     59                     number 5  3.01907229 13.3709669
#> 12          12      9                    blueprint  2.99125046 14.9161528
#> 13          13     75            sieve-fisted find  2.95314154 14.5113535
#> 14          14     69                      rend it  2.89891512 14.4723545
#> 15          15     55                  merchandise  2.89530578 13.9756657
#> 16          16      4                  arpeggiator  2.85967839 13.2512392
#> 17          17     54                margin walker  2.81570081 13.7793466
#> 18          18     28                facet squared  2.76691008 13.7084453
#> 19          19     88                     turnover  2.75759231 13.5405387
#> 20          20      8                birthday pony  2.75266308 13.3192153
#> 21          21     60                           oh  2.74084983 11.8203565
#> 22          22     53                long division  2.71513040 13.4041460
#> 23          23      3                     argument  2.70962458 11.3806705
#> 24          24     66       public witness program  2.69613300 13.3488556
#> 25          25     85                     the kill  2.61508600  9.6423459
#> 26          26     29                           fd  2.60550767 11.8205662
#> 27          27     76            smallpox champion  2.58093193 12.7655862
#> 28          28     34               forensic scene  2.56703127 12.4244316
#> 29          29     16                       by you  2.54263661 12.4989675
#> 30          30      2                 and the same  2.53141417 12.1476531
#> 31          31     31            five corporations  2.52138368 11.4459728
#> 32          32     44                   instrument  2.49374795 12.3402397
#> 33          33     50                life and limb  2.49272683  8.3604923
#> 34          34     32                 floating boy  2.45670421 11.0865822
#> 35          35     35              full disclosure  2.45520499  8.6192480
#> 36          36     77                      song #1  2.43590849 11.6584575
#> 37          37     37             give me the cure  2.40549652 11.6485470
#> 38          38     89                two beats off  2.40181315 11.7814558
#> 39          39     39                    great cop  2.40125655 11.8759698
#> 40          40     26                 ex-spectator  2.40037500  9.5736906
#> 41          41     70                     repeater  2.33943393 11.5476366
#> 42          42     82                   suggestion  2.31575980 11.1646430
#> 43          43     58                  no surprise  2.27980022 10.1946959
#> 44          44     25                 epic problem  2.25541902  8.2456870
#> 45          45      6                    bad mouth  2.25075748 10.7552364
#> 46          46     64                     promises  2.20693064 10.7689369
#> 47          47      5                 back to base  2.19875828 10.3564868
#> 48          48     74                shut the door  2.18436969 10.6553701
#> 49          49     27                    exit only  2.17373592 10.6643155
#> 50          50     81                    styrofoam  2.16629615 10.5588062
#> 51          51     83                sweet and low  2.12174588 10.4682680
#> 52          52     57                    nightshop  2.06925487  8.0939269
#> 53          53     73               runaway return  2.01730520  9.8414339
#> 54          54     13                bulldog front  1.94177674  9.2843087
#> 55          55     24                  downed city  1.91298660  8.8604672
#> 56          56     92            walken's syndrome  1.88873395  9.0160740
#> 57          57     15                  burning too  1.88119579  8.9863433
#> 58          58     14                      burning  1.87855310  8.9095708
#> 59          59     71                reprovisional  1.86454931  9.0188331
#> 60          60     18                   cassavetes  1.83525002  8.8555996
#> 61          61     30              fell, destroyed  1.82805804  8.6552143
#> 62          62     52         long distance runner  1.81273029  8.3825481
#> 63          63     72          returning the screw  1.77094652  8.4115932
#> 64          64     61                  pink frosty  1.76754624  7.6343068
#> 65          65     49                  latin roots  1.76031236  8.4708514
#> 66          66     40                        greed  1.74416965  8.3011711
#> 67          67     80                 strangelight  1.70529589  5.4185020
#> 68          68     22          dear justice letter  1.59846980  7.5989853
#> 69          69     78                       stacks  1.55497314  7.4073981
#> 70          70     19             caustic acrostic  1.54308729  6.4116237
#> 71          71     51                     lockdown  1.52223635  7.1103687
#> 72          72     12                   brendan #1  1.50692872  7.1035642
#> 73          73     47 last chance for a slow dance  1.47278294  6.9740537
#> 74          74     46                         kyeo  1.38733121  6.4531617
#> 75          75     56              nice new outfit  1.31047716  6.1058090
#> 76          76     11                     break-in  1.23585742  5.6720477
#> 77          77     33                foreman's dog  1.20932253  4.5345895
#> 78          78     65                  provisional  1.18047718  3.1435445
#> 79          79     38                      glueman  1.14179434  5.2796981
#> 80          80     45                       joe #1  1.13659629  5.1699528
#> 81          81     41                guilford fall  1.07070568  4.0218200
#> 82          82     36                    furniture  0.94596427  4.2226754
#> 83          83     48              latest disgrace  0.73390729  2.9092202
#> 84          84     90                      version  0.55787539  2.1796928
#> 85          85     79                  steady diet  0.30553019  1.2545455
#> 86          86     21             combination lock  0.07192753  0.2458331
#> 87          87      1                 23 beats off  0.00000000         NA
#> 88          88     86                     the word -0.30788459 -1.1674949
#> 89          89     42                hello morning -0.40598183 -0.5490568
#> 90          90     43         in defense of humans -0.40620964 -1.5017400
#> 91          91     87           turn off your guns -1.02160744 -3.2351004
#> 92          92     63                       polish -1.83762086 -4.0656032
```
