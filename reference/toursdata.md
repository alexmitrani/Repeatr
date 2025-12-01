# Tours data

Tours data

## Usage

``` r
toursdata
```

## Format

dataframe with one row for each tour in the Fugazi Live Series data.

- tour:

  Name of the tour

- start:

  Start date

- end:

  End date

- shows:

  Number of shows

- duration:

  Duration of the tour in days

- attendance:

  Total attendance of all the shows

- meanattendance:

  Average attendance per show

- startyear:

  Year in which the tour started

- endyear:

  Year in which the tour ended

## Source

https://www.dischord.com/fugazi_live_series

## Examples

``` r
  toursdata
#> # A tibble: 76 × 9
#>    tour           start      end        shows duration attendance meanattendance
#>    <chr>          <date>     <date>     <int>    <int>      <int>          <int>
#>  1 1990 Fall Eur… 1990-09-01 1990-11-07    60       67      43409            723
#>  2 1995 Spring/S… 1995-05-04 1995-07-14    59       71      70894           1201
#>  3 1992 Spring E… 1992-05-01 1992-07-11    56       71      55412            989
#>  4 1995 Fall USA… 1995-09-16 1995-11-20    50       65      68903           1378
#>  5 1993 Spring U… 1993-04-02 1993-05-31    48       59      74550           1553
#>  6 1990 Spring/S… 1990-05-02 1990-06-30    43       59      24080            560
#>  7 1988 Fall Eur… 1988-10-14 1988-12-16    39       63       5277            135
#>  8 1993 Fall USA… 1993-08-16 1993-09-29    39       44      58075           1489
#>  9 1991 Spring U… 1991-05-01 1991-06-14    38       44      27273            717
#> 10 1989 Spring U… 1989-04-05 1989-06-16    35       72      11128            317
#> # ℹ 66 more rows
#> # ℹ 2 more variables: startyear <dbl>, endyear <dbl>
```
