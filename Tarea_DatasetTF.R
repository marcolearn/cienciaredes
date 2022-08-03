rm(list = ls()) # clear the workspace again

setwd("C:/Users/marco/OneDrive/Documentos/R")

nodes <- read.csv("./tf_nodos_R.csv", header=T, as.is=T)
links <- read.csv("./tf_edges_R.csv", header=T, as.is=T)

# Examine the data:
head(nodes)
head(links)
nrow(nodes); length(unique(nodes$id))
nrow(links); nrow(unique(links[,c("from", "to")]))

# Collapse multiple links of the same type between the same two nodes
# by summing their weights, using aggregate() by "from", "to", & "type":
# (we don't use "simplify()" here so as not to collapse different link types)
links <- aggregate(links[,3], links[,-3], sum)
links <- links[order(links$from, links$to),]
colnames(links)[4] <- "weight"
rownames(links) <- NULL

# ------~~ Creating igraph objects --------

library(igraph)

net <- graph_from_data_frame(d=links, vertices=nodes, directed=T)

#mostrando los grados
degree(net)

#estadisticas del vertice
V(net)
V(net)$Size
vertex.attributes(net)

#estadisticas de los enlaces
E(net)
E(net)$Weight
edge.attributes(net)

#Represenatacion de la matriz
net[]

# Examine the resulting object:
class(net)
net

# We can look at the nodes, edges, and their attributes:
E(net)
V(net)
E(net)$type
V(net)$media



#Grado de los nodos del grafo
degree(net)
degree_distribution(net)

#Matriz de adyacencia
as_adjacency_matrix(net)

#Distancia promedio
mean_distance(net) 

#Encontrar el nodo con mas alto grado
Stucont_deg<-degree(net,mode=c("All"))
V(net)$degree<-Stucont_deg
V(net)$degree
which.max(Stucont_deg)   #nodo con máximo grado
which.min(Stucont_deg)  #nodo con mínimo grado


#Muestra los grafos conectados y elimina nodos aislados
g <- set.vertex.attribute(net,"id",index=V(net),as.character(1:vcount(net)))
# Selecciona el nodo de interes
nodes.of.interest <- c(631)
# Busca los grafos del nodo de interés
sel.nodes  <- bfs(g ,root = nodes.of.interest ,unreachable = FALSE)$order
# Elimina los nodos aislados
g.sub <- induced.subgraph(g , vids = sel.nodes[!is.na(sel.nodes)])
plot(g.sub, edge.arrow.size=.3, edge.color="orange", vertex.color="gray50", vertex.size=2, vertex.label.color="red", vertex.label.cex=0.2, vertex.label.dist=.2, edge.curved=0.1)


plot(net, edge.arrow.size=.5, vertex.color="green", vertex.size=10,
     vertex.frame.color="gray", vertex.label.color="black",
     vertex.label.cex=1.5, vertex.label.dist=2, edge.curved=0.2)


# Removing loops from the graph:
net
net <- simplify(net, remove.multiple = F, remove.loops = T)
net

plot(net, edge.arrow.size=.5, vertex.color="yellow", vertex.size=15,
     vertex.frame.color="gray", vertex.label.color="black",
     vertex.label.cex=1.5, vertex.label.dist=2, edge.curved=0.2)

# If you need them, you can extract an edge list or a matrix from igraph networks.
as_edgelist(net, names=T)
as_adjacency_matrix(net, attr="weight")

# Or data frames describing nodes and edges:
as_data_frame(net, what="edges")
as_data_frame(net, what="vertices")

# Density <-- Esta parte es importante
# The proportion of present edges from all possible ties.
edge_density(net, loops=F)
ecount(net)/(vcount(net)*(vcount(net)-1)) #for a directed network

# Reciprocity
# The proportion of reciprocated ties (for a directed network).
reciprocity(net)
dyad_census(net) # Mutual, asymmetric, and null node pairs
2*dyad_census(net)$mut/ecount(net) # Calculating reciprocity

# Transitivity
# global - ratio of triangles (direction disregarded) to connected triples
# local - ratio of triangles to connected triples each vertex is part of
transitivity(net, type="global")  # net is treated as an undirected network
transitivity(as.undirected(net, mode="collapse")) # same as above
transitivity(net, type="local")
triad_census(net) # for directed networks

# Diameter (longest geodesic distance)
# Note that edge weights are used by default, unless set to NA.
diameter(net, directed=F, weights=NA)
diameter(net, directed=F)
diam <- get_diameter(net, directed=T)
diam

# Note: vertex sequences asked to behave as a vector produce numeric index of nodes
class(diam)
as.vector(diam)

# Color nodes along the diameter:
vcol <- rep("gray40", vcount(net))
vcol[diam] <- "gold"
ecol <- rep("gray80", ecount(net))
ecol[E(net, path=diam)] <- "orange"
# E(net, path=diam) finds edges along a path, here 'diam'
plot(net, vertex.color=vcol, edge.color=ecol, edge.arrow.mode=0)

# Node degrees
# 'degree' has a mode of 'in' for in-degree, 'out' for out-degree,
# and 'all' or 'total' for total degree.
deg <- degree(net, mode="all")
plot(net, vertex.size=deg*3)
hist(deg, breaks=1:vcount(net)-1, main="Histogram of node degree")

# Degree distribution
deg.dist <- degree_distribution(net, cumulative=T, mode="all")
plot( x=0:max(deg), y=1-deg.dist, pch=19, cex=1.2, col="orange",
      xlab="Degree", ylab="Cumulative Frequency")

