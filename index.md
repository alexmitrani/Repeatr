# Repeatr

> ["I had a name, but now I'm a number"](https://fugazi.bandcamp.com/track/repeater)

Exploring the [Fugazi Live Series](https://www.dischord.com/fugazi_live_series) metadata. 

## Articles

[Repeatr-app](articles/Repeatr-app.html) provides documentation for the [Repeatr web app](https://alexmitrani.shinyapps.io/Repeatr-app/). 

[Repeatr](articles/Repeatr.html) outlines the process by which song ratings were calculated using the [Fugazi Live Series](https://www.dischord.com/fugazi_live_series) metadata. 

[Songnumberone](articles/Songnumberone.html) presents analysis of the choice of opening songs.  

[94 SONGS](articles/94songs.html) summarises the main results of the data processing and choice modelling as an interactive graph.  The graph  shows ratings, performance counts and launch dates for the 94 songs that were performed live at least twice.  

[Combination Lock](articles/CombinationLock.html) explores Fugazi's use of transitions between songs: which ones they played live, and how often compared to others.  

[Link Tracks](articles/LinkTracks.html) A series of brief explorations of the Fugazi Live Series data.  

[Playlist](articles/Playlist.html) A list of recommended shows - work in progress. 

## Repeatr package for R

The Repeatr package can be installed from RStudio using the following command:

devtools::install_github("alexmitrani/Repeatr", build_opts = c("--no-resave-data", "--no-manual"))

The package gives easy access to the functions, dataframes, and related documentation.

## Repeatr web app

A web app that presents some of the data from the Repeatr package with interactive controls can be found [here](https://alexmitrani.shinyapps.io/Repeatr-app/).

## Acknowledgements

Thanks to [Fugazi](https://www.dischord.com/band/fugazi) for everything. The initial data was provided by Ian James Wright of the [Alphabetical Fugazi podcast](https://the-alphabetical-fugazi.pinecast.co/), who got it from Carni Klirs who did the project [Visualizing the History of Fugazi](https://www.carniklirs.com/project/fugazi). An early version of the coordinates and tour data came from [The D-I-Y Data of Fugazi](https://github.com/mathisonian/diy-data-fugazi) by Matthew Conlen. I completely revised and replaced all of the coordinates with more detailed data on the location of each show, but I am nevertheless grateful for the initial data which got me started. Many thanks to all those who answered my questions about where venues were located many years ago - several of the venues would not be in the right place on the map without you!   

## That is all for now

I hope you have found this interesting. If you have any comments or suggestions please add an issue to the [GitHub repository](https://github.com/alexmitrani/Repeatr/).

Thanks. 



