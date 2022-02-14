# Libraries
library(ggraph)
library(igraph)
library(dplyr)

load("~/Documents/GitHub/Repeatr/data/Repeatr1.rda")

mydf1 <- Repeatr1 %>% select(gid,song_number,song)
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
  rename(to = song2)

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
vertices <- data.frame(name = unique(c(as.character(hierarchy$from), as.character(hierarchy$to))) )
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







