# sweepstack runs stacks iteratively over a range of different starting shows.

it returns a dataframe with two columns, "gid" and "shows". gid is the
gig id of the starting show used for the test. shows is the number of
shows included in the resulting stack.

## Usage

``` r
sweepstack(number_stacks = NULL, exclude_poor_sound_quality = FALSE)
```

## Arguments

- number_stacks:

  this is the number of starting shows to test. if not specified all the
  possible starting shows will be tested.

- exclude_poor_sound_quality:

  set this to TRUE to exclude shows with sound quality rated as 'Poor'.

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
