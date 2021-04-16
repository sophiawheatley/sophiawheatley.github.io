rm(list=ls())

pacman::p_load(ggplot2, dplyr, fpc)

# clust_data <- data.frame(X= runif(10, 0, 1), Y= runif(10, 0, 1))
# save.image(file = "clustering_blog.RData")
load("clustering_blog.RData")

#palette posted on https://stackoverflow.com/questions/57153428/r-plot-color-combinations-that-are-colorblind-accessible
color_blind_palette <- c("#88CCEE", "#CC6677", "#DDCC77", "#117733", "#332288", "#AA4499", 
                                                    "#44AA99", "#999933", "#882255", "#661100", "#6699CC", "#888888")

clust_data_gg <- clust_data %>% mutate(n = c(1:10))
ggplot(clust_data_gg, aes(x=X, y= Y,color=as.factor(n)))+
  geom_point(show.legend = FALSE)+
  theme_bw()+
  geom_text(aes(X,Y,label=n), show.legend = F, position = position_nudge(x = 0.03))+
  scale_fill_manual(values=color_blind_palette[1:nrow(clust_data_gg)])+
  coord_fixed()

#calculate distance matrix
#manual way

dist_matrix <- matrix(nrow=10, ncol=10)
for (i in 1:10){
  for (j in 1:10){
    if (i > j){
      dist_val <- sqrt((clust_data$X[i] - clust_data$X[j])**2 + (clust_data$Y[i] - clust_data$Y[j])**2)
      dist_matrix[i,j] <- dist_val
    }
  }
}

#dist() function
dist_matrix_2 <- dist(clust_data[,-3], method="euclidean",diag=F)

#clustering using average linkage

#average linkage  
average_linkage <- function(mat, datapoint) {
  min_dist <- min(mat, na.rm = TRUE) #find smallest distance value 
  min_index <- which(mat==min_dist, arr.ind=TRUE)[1,] #get row and col indices
  min_row <- index[["row"]]
  min_col <- index[["col"]]
  comp_pair_1 <- if(is.na((mat[min_row,datapoint]))) {(mat[datapoint, min_row])} else {mat[min_row,datapoint]}
  comp_pair_2 <- if(is.na((mat[min_col,datapoint]))) {(mat[datapoint, min_col])} else {mat[min_col,datapoint]}
  new_val <- (comp_pair_1  + comp_pair_2) / 2 #calculate average linkage
  cluster_name <- c(paste0(min_row, "_", min_col))
  return(c(cluster_name, new_val))
}

updated_matrix <- data.frame()
for (i in 1:10){
      cluster <- average_linkage(dist_matrix, i)
      updated_matrix <- rbind(updated_matrix, cluster)
}
updated_matrix <- na.omit(updated_matrix)
updated_matrix <- rename(updated_matrix, 'cluster' = 'X.8_5.', 'distance' = "X.1.0857792211224.")
updated_matrix$distance <- lapply(lapply(updated_matrix[,2], as.numeric),round, 4)

##hclust()
tree <- hclust(as.dist(dist_matrix), method = "average")
dend_plot <- as.dendrogram(tree)
plot(dend_plot)
rect.hclust(tree, k = 2, border=color_blind_palette[1:2]) # draw rectangles

# explain how hclust works 
tree$height #the distance values in increasing order, with the minimum value first being the first cluster
tree$merge  #the clusters starting with those closest together by means of average linkage and furthest way
# positive values indicate the clusters and negative values the data points themselves 
# we can compare the simple scatterplot with our dendrogram and see the correspondence between the data points and our clusters
# points 5 & 8 which are close together form a cluster


#choose number of clusters, bear in mind this is a small dataset with random samples
ch_index_list <- c()
dunn_index_list <- c()
for (n_clust in 2:10){
  tree_cut<-cutree(hclust(as.dist(dist_matrix), method="average"), k=n_clust)
  cluster_stats<-cluster.stats(d=as.dist(dist_matrix), tree_cut, silhouette=T, sepindex=T)
  ch_index_list[n_clust] <- cluster_stats$ch
  dunn_index_list[n_clust] <- cluster_stats$dunn2
}

plot(ch_index_list, xlab="k (number of clusters)", ylab = "Calinski and Harabasz Index")
lines(ch_index_list, col="black")
max(ch_index_list,na.rm = T)
plot(dunn_index_list, xlab="k (number of clusters)", ylab = "Dunn Index")
lines(dunn_index_list, col="black")

#choose 'best' number of clusters and cut tree 
k_value=2
cutree(tree, k=k_value)
plot(tree, cex=0.6) # plot tree
rect.hclust(tree, k=k_value, border=color_blind_palette[1:k_value])
