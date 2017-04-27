# Clint Valentine
# 11/27/2016

set.seed(1)
rm(list=ls())
options(digits=4)

library(ALL)
library(scatterplot3d)

cat("Problem 1a\n==========\n\n")

data(ALL)
labels = sapply(ALL$BT, function (x) substr(x, 1, 1))
ALL.fac = as.factor(as.integer(labels %in% "B") + 1)

cat("Problem 1b\n==========\n\n")

par(mfrow=c(1, 3))
for (i in 1:3) hist(exprs(ALL)[i,], nclass=10, main=paste(row.names(exprs(ALL))[i], "Expression Values"))

cat("Problem 1c\n==========\n\n")

par(mfrow=c(1, 1))
pairs(t(exprs(ALL)[1:5,]), main="Pairwise  Scaterrplots for\nFirst Five Genes")

cat("Problem 1d\n==========\n\n")

genes = c("39317_at", "32649_at", "481_at")
ix = sapply(genes, function(x) grep(paste("\\b", x, "\\b", sep=""), row.names(exprs(ALL))))
par(mfrow=c(1, 1))
scatterplot3d(t(exprs(ALL)[ix,]), color=as.numeric(ALL.fac), box=F, grid=T, angle=40)

cat("Problem 1e\n==========\n")

for (i in 2:3) {
  cluster.km2 = kmeans(t(exprs(ALL)[ix,]), i)
  cat("\nK-means clustering of", genes, "genes ( k =", i, "):\n\n")
  print(table(cluster.km2$cluster, labels))
}

cat("\nProblem 1f\n==========\n\n")

pc = prcomp(exprs(ALL), scale=TRUE)
print(summary(pc)$importance[, 1:3])

cat("\nProblem 1g\n==========\n\n")

biplot(pc,
       cex=0.2,
       expand=3,
       xlim=c(-0.05, 0.05),
       ylim=c(-0.05, 0.05),
       main="Biplot of PCA on ALL Data\n")

cat("\nProblem 1h\n==========\n\n")

cat("The three genes with the biggest PC2 values are:\n\n")
cat(head(row.names(exprs(ALL))[order(pc$x[,2])], 3), sep="\n")

cat("\nThe three genes with the smallest PC2 values are:\n\n")
cat(tail(row.names(exprs(ALL))[order(pc$x[,2])], 3), sep="\n")

cat("\nProblem 1i\n==========\n\n")

get.chrom = function (gene, annotation.pkg) {
  library(paste(annotation(ALL), '.db', sep=''), character.only=T)
  get(gene, env=eval(parse(text=paste(annotation.pkg, 'CHR', sep=''))))
}

get.genename = function (gene, annotation.pkg) {
  library(paste(annotation(ALL), '.db', sep=''), character.only=T)
  get(gene, env=eval(parse(text=paste(annotation.pkg, 'GENENAME', sep=''))))
}

biggest = head(row.names(exprs(ALL))[order(pc$x[,2])], 1)
smallest = tail(row.names(exprs(ALL))[order(pc$x[,2])], 1)

cat("Gene with biggest PC2 value",
    "\n ID:", biggest,
    "\n Chromosome:", get.chrom(biggest, annotation(ALL)),
    "\n Name:", get.genename(biggest, annotation(ALL)))

cat("\n\nGene with smallest PC2 value",
    "\n ID:", smallest,
    "\n Chromosome:", get.chrom(smallest, annotation(ALL)),
    "\n Name:", get.genename(smallest, annotation(ALL)))


cat("\n\nProblem 2a\n==========\n")

iris.data = iris[, 1:3]
iris.data.scaled = scale(iris.data)

cat("\nProblem 2b\n==========\n\n")

cat("Pairwise correlation of unscaled data:\n")
print(cor(iris.data))

cat("\n\nPairwise correlation of scaled data:\n")
print(cor(iris.data.scaled))

cat("\n\nProblem 2c\n==========\n\n")

dist.scaled.euclid.squared = dist(t(iris.data.scaled), method='euclidian')**2
dist.minus.cor = as.dist(1 - cor(iris.data.scaled))

cat("Distances of Scaled Data Squared (Euclidian):\n\n")
print(dist.scaled.euclid.squared)

cat("\n1-Correlation Distances of Scaled Data:\n\n")
print(dist.minus.cor)

cat("\nScaling Factor:",
    median(dist.scaled.euclid.squared / dist.minus.cor))

cat("\n\nProblem 2d\n==========\n\n")

cat("PCA of Unscaled Data:\n\n")
pc.unscaled = prcomp(iris.data, scale=F)
print(summary(pc.unscaled))

cat("\nPCA of Scaled Data:\n\n")
pc.scaled = prcomp(iris.data.scaled, scale=F)
print(summary(pc.scaled))

cat("\nProblem 2e\n==========\n")

cat("\nProblem 2f\n==========\n\n")

confidence = 0.95
lower.bound = (1 - confidence) / 2
upper.bound = 1 - lower.bound

iterations = 1000
n = nrow(iris.data.scaled)
pc2.importance = rep(NA, iterations)

for (i in 1:iterations) {
  data.star = iris.data.scaled[sample(1:n, replace=TRUE),]
  pc2.importance[i] = summary(prcomp(data.star, scale=F))$importance[2,2]
}

CI = quantile(pc2.importance, c(lower.bound, upper.bound))

cat("Proportion of variance explained by PC2:\n")
cat(summary(pc.scaled)$importance[2,2])

cat("\n\nBootstrapped", confidence * 100, "percent CI:\n")
cat("(", CI[1], ",", CI[2], ")")
