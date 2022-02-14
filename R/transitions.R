# Libraries
library(ggraph)
library(igraph)
library(dplyr)
library(RColorBrewer)

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

connect$value <- runif(nrow(connect))

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



