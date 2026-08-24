# Combination Lock

> [“Wait a minute  
> I forgot my
> combination”](https://fugazi.bandcamp.com/track/combination-lock)

## Transitions between songs in the Fugazi Live Series

> “We never used set lists, so the shows were always organically grown,
> there was a flow, and a song like Combination Lock, sometimes it would
> work as an opener… something about it was hard to drop in to it,
> something about it… I don’t know … it just didn’t seem to fit into the
> general movement of the set …” - [Ian Mackaye,
> 12/2/2022](https://open.spotify.com/episode/49dpXoFyQZJSGA2nGmjb9s?si=qN_u9NcfRCutyXVjVnPFZQ)

This article offers a visualisation of the transitions between songs
that Fugazi performed live using metadata from the [Fugazi Live
Series](https://www.dischord.com/fugazi_live_series). For every pair of
songs that are performed in sequence there is a transition from the
first song to the second song. For instance, a show with 20 songs will
have 19 transitions between pairs of songs. After listening to the
Fugazi Live Series for a while, it seems that some transitions were much
more common than others, but it is hard to tell for sure without
listening to the whole series or looking into the data. Let’s have a
quick look at the data and see what we find.

The raw data was processed previously and here we will use data with one
row per song performance from the Repeatr1 dataframe of the
[Repeatr](https://github.com/alexmitrani/Repeatr) package.

## Transition counts

Let’s get the data, limit it to the columns that we will be using, and
have a look at the first few rows.

``` r


mydf1 <- Repeatr1 %>%
  filter(tracktype==1) %>%
  select(gid,song_number,title) %>%
  rename(title1 = title)

print(paste0("There are ", nrow(mydf1), " rows in this dataframe."))
#> [1] "There are 18286 rows in this dataframe."

head(mydf1)
#> # A tibble: 6 × 3
#>   gid                 song_number title1           
#>   <chr>                     <dbl> <chr>            
#> 1 aalst-belgium-92390           2 turnover         
#> 2 aalst-belgium-92390           3 brendan #1       
#> 3 aalst-belgium-92390           4 merchandise      
#> 4 aalst-belgium-92390           5 sieve-fisted find
#> 5 aalst-belgium-92390           6 and the same     
#> 6 aalst-belgium-92390           8 bulldog front
```

In order to look at the transitions between songs, let’s get the list of
songs that were performed at each show and match each song onto the next
song performed at the same show, ignoring any interludes or other
non-song tracks in between. This way we will have one row of data for
each transition between songs.

``` r


mydf3 <- mydf1 %>%
  arrange(gid, song_number) %>%
  group_by(gid) %>%
  mutate(title2 = dplyr::lead(title1)) %>%
  ungroup() %>%
  filter(is.na(title2)==FALSE) %>%
  rename(transition_number = song_number)

print(paste0("There are ", nrow(mydf3), " rows in this dataframe."))
#> [1] "There are 17334 rows in this dataframe."

head(mydf3)
#> # A tibble: 6 × 4
#>   gid                 transition_number title1            title2           
#>   <chr>                           <dbl> <chr>             <chr>            
#> 1 aalst-belgium-92390                 2 turnover          brendan #1       
#> 2 aalst-belgium-92390                 3 brendan #1        merchandise      
#> 3 aalst-belgium-92390                 4 merchandise       sieve-fisted find
#> 4 aalst-belgium-92390                 5 sieve-fisted find and the same     
#> 5 aalst-belgium-92390                 6 and the same      bulldog front    
#> 6 aalst-belgium-92390                 8 bulldog front     burning too
```

There is a simple check to see if the number of rows in this second
dataframe is correct. The number of transitions should be equal to the
number of songs minus one for each show, and the total number of
transitions in the series should be equal to the total number of songs
in the series minus the total number of shows in the series.

``` r


checknumberofshows <- Repeatr1 %>%
  filter(tracktype==1) %>%
  group_by(gid) %>%
  summarise(songs = n()) %>%
  ungroup()

numberofshows <- nrow(checknumberofshows)

print(paste0("There are ", numberofshows, " rows in this dataframe."))
#> [1] "There are 952 rows in this dataframe."

head(checknumberofshows)
#> # A tibble: 6 × 2
#>   gid                          songs
#>   <chr>                        <int>
#> 1 aalst-belgium-92390             16
#> 2 aberdeen-scotland-50499         22
#> 3 adelaide-australia-111193       11
#> 4 adelaide-australia-111296       22
#> 5 adelaide-sa-australia-102291    19
#> 6 akron-oh-usa-62890              18

numberofsongs <- sum(checknumberofshows$songs)

numberoftransitions <- numberofsongs - numberofshows

print(paste0("There are ", numberofsongs, " songs, ", numberofshows, " shows, and ", numberoftransitions, " transitions between songs in the Fugazi Live Series data."  ))
#> [1] "There are 18286 songs, 952 shows, and 17334 transitions between songs in the Fugazi Live Series data."
```

Now let’s summarise the data to count how many times each transition
occurs.

``` r


transitions <- mydf3 %>%
  select(title1, title2) %>%
  rename(from = title1) %>%
  rename(to = title2)

transitions <- transitions %>%
  group_by(from, to) %>%
  summarize(count = n()) %>%
  ungroup()
#> `summarise()` has regrouped the output.
#> ℹ Summaries were computed grouped by from and to.
#> ℹ Output is grouped by from.
#> ℹ Use `summarise(.groups = "drop_last")` to silence this message.
#> ℹ Use `summarise(.by = c(from, to))` for per-operation grouping
#>   (`?dplyr::dplyr_by`) instead.

transitions <- transitions %>%
  arrange(desc(count))

head(transitions)
#> # A tibble: 6 × 3
#>   from              to               count
#>   <chr>             <chr>            <int>
#> 1 long division     blueprint          181
#> 2 suggestion        give me the cure   176
#> 3 repeater          reprovisional      153
#> 4 two beats off     repeater           131
#> 5 sieve-fisted find reclamation        119
#> 6 give me the cure  waiting room       100
```

## Probabilities of transitions between songs given availability of both songs

This already gives us a good idea of what the most common transitions
were. However, it probably gives too much weight to transitions between
older songs and not enough to transitions involving newer songs. In
order to correct for this we need to consider how many shows each
transition was available to be used. This can be done simply using an
availability variable that was calculated previously. The count of
available shows for each song is matched on from a lookup table, and the
number of shows for which each transition was available is assumed to be
the smaller of the two numbers of shows. The frequency count for each
transition is divided by the number of available shows to get a scaled
count that should be comparable across all the transitions. The scaled
counts can be interpreted as probabilities of the given transitions
being played, given the availability of both songs in the band’s
repertoire.

``` r


transitions$title <- transitions$from

mylookup <- fugazi_song_performance_intensity %>%
  select(title, available_rl)

transitions <- transitions %>%
  left_join(mylookup) %>%
  rename(from_available_rl = available_rl)
#> Joining with `by = join_by(title)`

transitions$title <- transitions$to

transitions <- transitions %>%
  left_join(mylookup) %>%
  rename(to_available_rl = available_rl) %>%
  mutate(available_rl = ifelse(from_available_rl < to_available_rl, from_available_rl, to_available_rl)) %>%
  mutate(count_scaled = count/available_rl) %>%
  select(from, to, from_available_rl, to_available_rl, available_rl, count, count_scaled) %>%
  arrange(desc(count_scaled))
#> Joining with `by = join_by(title)`

head(transitions)
#> # A tibble: 6 × 7
#>   from   to    from_available_rl to_available_rl available_rl count count_scaled
#>   <chr>  <chr>             <dbl>           <dbl>        <dbl> <int>        <dbl>
#> 1 long … blue…               889             873          873   181        0.207
#> 2 sugge… give…               947             939          939   176        0.187
#> 3 repea… repr…               876             896          876   153        0.175
#> 4 break  plac…               244             244          244    40        0.164
#> 5 oh     clos…               149             211          149    23        0.154
#> 6 argum… blue…               113             873          113    17        0.150

transitions <- transitions %>%
  select(from, to, count, count_scaled)
```

It is pleasing to see that using the scaled counts of the transitions,
some transitions featuring more recent songs appear in the list of the
top transitions, for instance the transition from “break” to “place
position”. Now we are in a position to get an overview of all the
transitions by graphing the data.

## Transitions between songs

Let’s use a heatmap to give an overview of all of the transitions and
their relative frequencies. The songs on both axes are sorted in order
of the date they were first performed, with the earliest songs close to
the origin.

``` r


launchdateindex_from <- fugazi_song_counts %>%
  arrange(launchdate) %>%
  mutate(launchdateindex_from = row_number()) %>%
  rename(from = title) %>%
  select(from, launchdateindex_from)

launchdateindex_to <- launchdateindex_from %>%
  rename(to = from, launchdateindex_to = launchdateindex_from)

transitions2 <- transitions %>%
  left_join(launchdateindex_from) %>%
  left_join(launchdateindex_to) %>%
  arrange(launchdateindex_from, launchdateindex_to) %>%
  mutate(to = paste0("to_", sprintf("%02d", launchdateindex_to), "_", to)) %>%
  mutate(from = paste0("from_", sprintf("%02d", launchdateindex_from), "_", from)) %>%
  select(from, to, count_scaled)
#> Joining with `by = join_by(from)`
#> Joining with `by = join_by(to)`

heatmapdata <- pivot_wider(transitions2, names_from = to, values_from = count_scaled, names_sort=TRUE)

heatmapdata[is.na(heatmapdata)] <- 0

heatmapdata <- heatmapdata %>%
  arrange(desc(from))
heatmapdata <- data.frame(heatmapdata, row.names = 1)
heatmapdata <- heatmapdata[ , order(names(heatmapdata))]
heatmapdata <- as.matrix(heatmapdata)

heatmaply(
  as.matrix(heatmapdata),
  seriate="none",
  Rowv=FALSE,
  Colv=FALSE,
  show_dendrogram=FALSE,
  plot_method = "plotly"
)
```

The graph shows that Fugazi played a broad selection of transitions
between songs, with a few favourite transitions that were played again
and again. However, the band did not play all the possible transitions.
With 92 songs there are 8372 possible transitions, and in this data
Fugazi played 3109 of those at least once. The Fugazi Live Series data
includes 17334 transitions between songs, with some of them used
repeatedly. The band played enough shows to potentially cover all the
possible transitions. It is likely that some of the possible transitions
just did not seem to work and so were never used.

## Transitions between groups of songs

> “The only methodology we had was that we alternated singing. Once Ian
> was wrapping up his song, I knew that I had to have a song ready to go
> for my thing.” - [Guy Picciotto,
> 25/5/2018](https://www.abc.net.au/doublej/music-reads/features/fugazi-the-past-the-future-and-the-ethos-that-drove-them/10265848)

Finally, let’s have a quick look at the transitions between Fugazi songs
grouped according to the person who sang lead vocals. There are four
groups of songs:

``` r


mysongvarslookup <- songvarslookup %>%
  left_join(songidlookup)
#> Joining with `by = join_by(title)`

mysongvarslookup <- mysongvarslookup %>%
  mutate(vocals = ifelse(vocals_lally==1,"lally",0)) %>%
  mutate(vocals = ifelse(vocals_mackaye==1,"mackaye",vocals)) %>%
  mutate(vocals = ifelse(vocals_picciotto==1,"picciotto",vocals)) %>%
  mutate(vocals = ifelse(instrumental==1,"instrumental",vocals)) %>%
  select(title, vocals)

head(mysongvarslookup)
#>          title       vocals
#> 1 23 beats off      mackaye
#> 2 and the same      mackaye
#> 3     argument      mackaye
#> 4  arpeggiator instrumental
#> 5 back to base      mackaye
#> 6    bad mouth      mackaye

checkvocals <- mysongvarslookup %>%
  group_by(vocals) %>%
  summarise(count = n()) %>%
  ungroup() %>%
  arrange(desc(count)) %>%
  mutate(group = row_number())

checkvocals
#> # A tibble: 4 × 3
#>   vocals       count group
#>   <chr>        <int> <int>
#> 1 picciotto       42     1
#> 2 mackaye         39     2
#> 3 instrumental     8     3
#> 4 lally            3     4
```

Transitions between some of these groups were probably much more common
than others. To look into this, we need to add the information on the
group of each song to the data on transitions between songs.

``` r


mysongvarslookup1 <- mysongvarslookup %>% rename(from = title, from_vocals = vocals)

mysongvarslookup2 <- mysongvarslookup %>% rename(to = title, to_vocals = vocals)

transitions3 <- transitions %>%
  left_join(mysongvarslookup1) %>%
  left_join(mysongvarslookup2) %>%
  select(from, to, from_vocals, to_vocals, count)
#> Joining with `by = join_by(from)`
#> Joining with `by = join_by(to)`

totaltransitions <- sum(transitions$count)

transitions_by_group <- transitions3 %>%
  group_by(from_vocals, to_vocals) %>%
  summarise(count = sum(count)) %>%
  ungroup() %>%
  arrange(desc(count)) %>%
  mutate(proportion = round((count / totaltransitions), digits = 2))
#> `summarise()` has regrouped the output.
#> ℹ Summaries were computed grouped by from_vocals and to_vocals.
#> ℹ Output is grouped by from_vocals.
#> ℹ Use `summarise(.groups = "drop_last")` to silence this message.
#> ℹ Use `summarise(.by = c(from_vocals, to_vocals))` for per-operation grouping
#>   (`?dplyr::dplyr_by`) instead.

transitions_by_group
#> # A tibble: 16 × 4
#>    from_vocals  to_vocals    count proportion
#>    <chr>        <chr>        <int>      <dbl>
#>  1 mackaye      picciotto     6875       0.4 
#>  2 picciotto    mackaye       6804       0.39
#>  3 mackaye      mackaye       1030       0.06
#>  4 picciotto    picciotto      435       0.03
#>  5 mackaye      instrumental   422       0.02
#>  6 instrumental mackaye        413       0.02
#>  7 instrumental picciotto      316       0.02
#>  8 picciotto    instrumental   208       0.01
#>  9 lally        mackaye        201       0.01
#> 10 picciotto    lally          196       0.01
#> 11 lally        picciotto      189       0.01
#> 12 mackaye      lally          189       0.01
#> 13 lally        lally           23       0   
#> 14 instrumental instrumental    14       0   
#> 15 instrumental lally           10       0   
#> 16 lally        instrumental     9       0

mp_proportion <- transitions_by_group %>%
  filter((from_vocals=="mackaye" & to_vocals=="picciotto") | (from_vocals=="picciotto" & to_vocals=="mackaye")) %>%
  summarise(p = sum(count)/totaltransitions) %>%
  pull(p)
```

With four groups of songs there are 16 possible transitions between
these groups and all of these were used in the live shows, although some
more than others. Transitions between Mackaye and Picciotto songs
represent approximately 79% of the cases.

Now let’s do another heatmap, this time grouping the transitions
according to the four groups of songs we just looked into. The
transitions on each axis of the graph will be ordered by the four groups
of songs (Picciotto, Mackaye, Instrumental, and Lally) and within each
group by the launch date of the song (older songs to newer songs).

``` r


transitions4 <- transitions %>%
  left_join(mysongvarslookup1) %>%
  left_join(mysongvarslookup2) %>%
  select(from, to, from_vocals, to_vocals, count_scaled)
#> Joining with `by = join_by(from)`
#> Joining with `by = join_by(to)`

checkvocals_from <- checkvocals %>%
  select(vocals, group) %>%
  rename(from_vocals = vocals, from_group = group)

checkvocals_to <- checkvocals %>%
  select(vocals, group) %>%
  rename(to_vocals = vocals, to_group = group)

launchdateindex_from <- fugazi_song_counts %>%
  arrange(launchdate) %>%
  mutate(launchdateindex_from = row_number()) %>%
  rename(from = title) %>%
  select(from, launchdateindex_from)

launchdateindex_to <- launchdateindex_from %>%
  rename(to = from, launchdateindex_to = launchdateindex_from)

transitions5 <- transitions4 %>%
  left_join(launchdateindex_from) %>%
  left_join(launchdateindex_to) %>%
  left_join(checkvocals_from) %>%
  left_join(checkvocals_to) %>%
  mutate(index_from=from_group*100+launchdateindex_from) %>%
  mutate(index_to=to_group*100+launchdateindex_to) %>%
  arrange(index_from, index_to) %>%
  mutate(to = paste0("to_", sprintf("%03d", index_to), "_", to)) %>%
  mutate(from = paste0("from_", sprintf("%03d", index_from), "_", from)) %>%
  select(from, to, count_scaled)
#> Joining with `by = join_by(from)`
#> Joining with `by = join_by(to)`
#> Joining with `by = join_by(from_vocals)`
#> Joining with `by = join_by(to_vocals)`

heatmapdata <- pivot_wider(transitions5, names_from = to, values_from = count_scaled, names_sort=TRUE)

heatmapdata[is.na(heatmapdata)] <- 0

heatmapdata <- heatmapdata %>%
  arrange(desc(from))
heatmapdata <- data.frame(heatmapdata, row.names = 1)
heatmapdata <- heatmapdata[ , order(names(heatmapdata))]
heatmapdata <- as.matrix(heatmapdata)

heatmaply(
  as.matrix(heatmapdata),
  seriate="none",
  Rowv=FALSE,
  Colv=FALSE,
  show_dendrogram=FALSE,
  plot_method = "plotly"
)
```

The graph shows in a visual way the relative scarcity of some types of
transitions, and the relative abundance of others. It seems that Fugazi
tended to avoid playing consecutive songs from the same group, probably
for practical reasons such as giving each vocalist regular breaks from
singing and keeping the show as dynamic and interesting as possible.

> [No CIA  
> No NSA  
> No satellite  
> Could map our veins](https://fugazi.bandcamp.com/track/no-surprise)

## How to use the graphs

The graphs may appear hard to read at first. Fortunately the graphs are
interactive and are made easier to read by tools for zooming and
panning.

- hover over a point on the graph to see specific details about the
  transition.

When you hover over the graph a toolbar will appear at the top right.
This offers several ways of interacting with the graph:

- camera: download plot as a PNG file

- magnifying glass: zoom in on a specific area by clicking and dragging
  to select the area

- pan: move around

- zoom in and zoom out do just that

- autoscale and reset axes are useful to get the graph back to how it
  was initially, removing any zoom that might have been applied.

Thanks.
