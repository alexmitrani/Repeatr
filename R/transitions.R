# Hierarchical Edge Bundling
# https://www.r-graph-gallery.com/hierarchical-edge-bundling.html

# Libraries
library(ggraph)
library(igraph)
library(dplyr)
library(RColorBrewer)

load("~/Documents/GitHub/Repeatr/data/Repeatr1.rda")

mydf1 <- Repeatr1 %>%
  filter(year==2002) %>%
  select(gid,song_number,song)

mydf2 <- mydf1 %>% mutate(song_number = song_number-1)
mydf1 <- mydf1 %>% rename(song1 = song)
mydf2 <- mydf2 %>% rename(song2 = song)
mydf3 <- mydf1 %>% left_join(mydf2)
mydf3 <- mydf3 %>% filter(is.na(song2)==FALSE)
mydf3 <- mydf3 %>% rename(transition_number = song_number)
head(mydf3)

connect <- mydf3 %>%
  select(song1, song2) %>%
  rename(from = song1) %>%
  rename(to = song2) %>%
  mutate(value = runif(nrow(connect)))

load("~/Documents/GitHub/Repeatr/data/songvarslookup.rda")
load("~/Documents/GitHub/Repeatr/data/songidlookup.rda")
songvars <- songvarslookup %>%
  left_join(songidlookup) %>%
  select(releaseid,release,track_number,song) %>%
  arrange(releaseid,track_number) %>%
  rename(from = releaseid) %>%
  rename(to = song) %>%
  select(from, to)

load("~/Documents/GitHub/Repeatr/data/releasesdatalookup.rda")

releases <- releasesdatalookup %>%
  mutate(from = "origin") %>%
  rename(to = releaseid) %>%
  select(from, to)

# create a data frame giving the hierarchical structure of your individuals.
# Origin on top, then groups, then subgroups

hierarchy <- rbind(releases, songvars)

# create a vertices data.frame. One line per object of our hierarchy, giving features of nodes.
vertices  <-  data.frame(
  name = unique(c(as.character(hierarchy$from), as.character(hierarchy$to))) ,
  value = runif(104)
)
# Let's add a column with the group of each name. It will be useful later to color points
vertices$group  <-  hierarchy$from[ match( vertices$name, hierarchy$to ) ]
# The connection object must refer to the ids of the leaves:
from <- match( connect$from, vertices$name)
to <- match( connect$to, vertices$name)

# Create a graph object with the igraph library
mygraph <- graph_from_data_frame( hierarchy, vertices=vertices )
# This is a network object, you visualize it as a network like shown in the network section!

# With igraph:
plot(mygraph, vertex.label="", edge.arrow.size=0, vertex.size=2)

# With ggraph:
ggraph(mygraph, layout = 'dendrogram', circular = FALSE) +
  geom_edge_link() +
  theme_void()

ggraph(mygraph, layout = 'dendrogram', circular = TRUE) +
  geom_edge_diagonal() +
  theme_void()

# plot
ggraph(mygraph, layout = 'dendrogram', circular = TRUE) +
  geom_conn_bundle(data = get_con(from = from, to = to), alpha=0.2, colour="skyblue", tension = 0) +
  geom_node_point(aes(filter = leaf, x = x*1.05, y=y*1.05)) +
  theme_void()

# plot
ggraph(mygraph, layout = 'dendrogram', circular = TRUE) +
  geom_conn_bundle(data = get_con(from = from, to = to), alpha=0.2, colour="skyblue", tension = 0.9) +
  geom_node_point(aes(filter = leaf, x = x*1.05, y=y*1.05)) +
  theme_void()

# Customize Hierarchical Edge Bundling
# https://www.r-graph-gallery.com/310-custom-hierarchical-edge-bundling.html

p <- ggraph(mygraph, layout = 'dendrogram', circular = TRUE) +
  geom_node_point(aes(filter = leaf, x = x*1.05, y=y*1.05)) +
  theme_void()

p +  geom_conn_bundle(data = get_con(from = from, to = to), alpha=0.2, colour="skyblue", width=0.9,
                      tension=1)

# Use the 'value' column of the connection data frame for the color:
p +  geom_conn_bundle(data = get_con(from = from, to = to), aes(colour=value, alpha=value))

# In this case you can change the color palette
p +
  geom_conn_bundle(data = get_con(from = from, to = to), aes(colour=value)) +
  scale_edge_color_continuous(low="white", high="red")
p +
  geom_conn_bundle(data = get_con(from = from, to = to), aes(colour=value)) +
  scale_edge_colour_distiller(palette = "BuPu")

# Color depends of the index: the from and the to are different
p +
  geom_conn_bundle(data = get_con(from = from, to = to), width=1, alpha=0.2, aes(colour=..index..)) +
  scale_edge_colour_distiller(palette = "RdPu") +
  theme(legend.position = "none")

# Basic usual argument
p=ggraph(mygraph, layout = 'dendrogram', circular = TRUE) +
  geom_conn_bundle(data = get_con(from = from, to = to), width=1, alpha=0.2, aes(colour=..index..)) +
  scale_edge_colour_distiller(palette = "RdPu") +
  theme_void() +
  theme(legend.position = "none")

# just a blue uniform color. Note that the x*1.05 allows to make a space between the points and the connection ends
p + geom_node_point(aes(filter = leaf, x = x*1.05, y=y*1.05), colour="skyblue", alpha=0.3, size=3)

# It is good to color the points following their group membership
p + geom_node_point(aes(filter = leaf, x = x*1.05, y=y*1.05, colour=group),   size=3) +
  scale_colour_manual(values= rep( brewer.pal(9,"Paired") , 30))

# And you can adjust the size to whatever variable quite easily!
p +
  geom_node_point(aes(filter = leaf, x = x*1.05, y=y*1.05, colour=group, size=value, alpha=0.2)) +
  scale_colour_manual(values= rep( brewer.pal(9,"Paired") , 30)) +
  scale_size_continuous( range = c(0.1,10) )

# Add labels to Hierarchical Edge Bundling
# https://www.r-graph-gallery.com/311-add-labels-to-hierarchical-edge-bundling.html

#Let's add information concerning the label we are going to add: angle, horizontal adjustement and potential flip
#calculate the ANGLE of the labels
vertices$id <- NA
myleaves <- which(is.na( match(vertices$name, hierarchy$from) ))
nleaves <- length(myleaves)
vertices$id[ myleaves ] <- seq(1:nleaves)
vertices$angle <- 90 - 360 * vertices$id / nleaves

# calculate the alignment of labels: right or left
# If I am on the left part of the plot, my labels have currently an angle < -90
vertices$hjust <- ifelse( vertices$angle < -90, 1, 0)

# flip angle BY to make them readable
vertices$angle <- ifelse(vertices$angle < -90, vertices$angle+180, vertices$angle)

# Create a graph object
mygraph <- igraph::graph_from_data_frame( hierarchy, vertices=vertices )

# The connection object must refer to the ids of the leaves:
from  <-  match( connect$from, vertices$name)
to  <-  match( connect$to, vertices$name)

# Basic usual argument
ggraph(mygraph, layout = 'dendrogram', circular = TRUE) +
  geom_node_point(aes(filter = leaf, x = x*1.05, y=y*1.05)) +
  geom_conn_bundle(data = get_con(from = from, to = to), alpha=0.2, colour="skyblue", width=0.9) +
  geom_node_text(aes(x = x*1.1, y=y*1.1, filter = leaf, label=name, angle = angle, hjust=hjust), size=1.5, alpha=1) +
  theme_void() +
  theme(
    legend.position="none",
    plot.margin=unit(c(0,0,0,0),"cm"),
  ) +
  expand_limits(x = c(-1.2, 1.2), y = c(-1.2, 1.2))

# final figure

ggraph(mygraph, layout = 'dendrogram', circular = TRUE) +
  geom_conn_bundle(data = get_con(from = from, to = to), alpha=0.2, width=0.9, aes(colour=..index..)) +
  scale_edge_colour_distiller(palette = "RdPu") +

  geom_node_text(aes(x = x*1.15, y=y*1.15, filter = leaf, label=name, angle = angle, hjust=hjust, colour=group), size=2, alpha=1) +

  geom_node_point(aes(filter = leaf, x = x*1.07, y=y*1.07, colour=group, size=value, alpha=0.2)) +
  scale_colour_manual(values= rep( brewer.pal(9,"Paired") , 30)) +
  scale_size_continuous( range = c(0.1,10) ) +

  theme_void() +
  theme(
    legend.position="none",
    plot.margin=unit(c(0,0,0,0),"cm"),
  ) +
  expand_limits(x = c(-1.3, 1.3), y = c(-1.3, 1.3))
