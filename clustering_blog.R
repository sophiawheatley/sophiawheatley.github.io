clust_data <- data.frame(X= runif(10, 0, 1), Y= runif(10, 0, 1), n=c(1:10))

library(ggplot2)
#palette posted on https://stackoverflow.com/questions/57153428/r-plot-color-combinations-that-are-colorblind-accessible
color_blind_palette <- c("#88CCEE", "#CC6677", "#DDCC77", "#117733", "#332288", "#AA4499", 
                                                    "#44AA99", "#999933", "#882255", "#661100", "#6699CC", "#888888")

ggplot(clust_data, aes(x=X, y= Y,color=as.factor(n)))+
  geom_point(show.legend = FALSE)+
  theme_bw()+
  geom_text(aes(X,Y,label=n), show.legend = F, position = position_nudge(x = 0.025))+
  scale_fill_manual(values=color_blind_palette[1:nrow(clust_data)])

#calculate distance matrix
#manual way

dist_matrix = matrix(nrow=10, ncol=10)
clust_data_loop <- clust_data[,-3]
for (i in 1:10){
  for (j in 1:10){
    dist_val <- sqrt((clust_data$X[i] - clust_data$X[j])**2 + (clust_data$Y[i] - clust_data$Y[j])**2)
    print(dist_val)
    dist_matrix[i,j] <- dist_val
  }
}

#dist() function
dist_matrix_2 <- matrix(dist(clust_data[,-3], method="euclidean",diag=F))

#clustering using average linkage
#find smallest distance value 
min(dist_matrix[dist_matrix > 0])

#get index 
which(dist_matrix==min(dist_matrix[dist_matrix > 0]), arr.ind=TRUE)

#update distance matrix with average linkage
#dist((P5,P6),P1) 
0.5*((dist_matrix[5,1])+(dist_matrix[6,1]))

#merge cluster function 
merge_cluster <- function(mat, datapoint) {
  min_dist <- min(mat[mat > 0])
  index <- which(mat==min_dist, arr.ind=TRUE)[1,]
  val <- mat[index[["row"]], index[["col"]]]
  new_val <- 0.5*((mat[index[["row"]],datapoint]) + (mat[index[["col"]],datapoint])) 
  cluster_name <- paste0(paste0(index[["row"]], "_", index[["col"]],"_cluster"))
}


updated_matrix <- dist_matrix
for (i in 1:10){
    cluster <- merge_cluster(updated_matrix, i)
    print(cluster)
}

##hclust()
tree <- hclust(as.dist(dist_matrix), method = "average")
dend_plot <- as.dendrogram(tree)
plot(dend_plot)
rect.hclust(tree, k = 3, border=color_blind_palette[1:3]) # draw rectangles

