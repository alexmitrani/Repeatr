# sweepstack runs stacks iteratively over a range of different starting shows.

it returns a dataframe with two columns, "gid" and "shows". gid is the
gig id of the starting show used for the test. shows is the number of
shows included in the resulting stack.

## Usage

``` r
sweepstack(
  number_stacks = NULL,
  exclude_poor_sound_quality = FALSE,
  myduration_data_da = NULL,
  mysummary = NULL,
  myothervariables = NULL,
  mygidsoundquality = NULL
)
```

## Arguments

- number_stacks:

  this is the number of starting shows to test. if not specified all the
  possible starting shows will be tested.

- exclude_poor_sound_quality:

  set this to TRUE to exclude shows with sound quality rated as 'Poor'.

- myduration_data_da:

  optional `duration_data_da` dataframe (as produced by
  [`Repeatr_1()`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_1.md))
  to be used for the pool of shows/songs to sweep over. If omitted the
  currently lazy-loaded default will be used.

- mysummary, myothervariables, mygidsoundquality:

  optional lookup tables passed straight through to
  [`stacks()`](https://alexmitrani.github.io/Repeatr/reference/stacks.md) -
  see there for details. If omitted the currently lazy-loaded defaults
  will be used.

## Value

A list of two data frames: `stack_summary` (`gid`, `shows` - one row per
starting show tested, and the number of shows needed to reach the target
unique-song count) and `stack_details` (`gid_initial`, `gid`, `title` -
the full, deduplicated set of shows and songs behind every stack
tested).

## Details

sweepstack

## Examples

``` r
results <- sweepstack(number_stacks = 10, exclude_poor_sound_quality = TRUE)
#> stack 1
#> stack 2
#> stack 3
#> stack 4
#> stack 5
#> stack 6
#> stack 7
#> stack 8
#> stack 9
#> stack 10
#> 
stack1 <- results[[1]]
stack2 <- results[[2]]
```
