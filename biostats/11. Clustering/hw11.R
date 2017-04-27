# Clint Valentine
# 11/17/2016

rm(list=ls())
set.seed(1)

library(ISLR)
library(cluster)

data(golub, package = "multtest")
gol.fac = factor(golub.cl, levels=0:1, labels=c("ALL","AML"))

cat("Problem 1a\n==========\n\n")

gene1 = "CCND3 Cyclin D3"
gene2 = "Zyxin"
gene1.loc = grep(gene1, golub.gnames[,2])
gene2.loc = grep(gene2, golub.gnames[,2])


clusdata = data.frame(golub[gene1.loc,], golub[gene2.loc,])
colnames(clusdata) = c(gene1, gene2)

hc1 = hclust(dist(clusdata, method="euclidian"), method="single")
hc2 = hclust(dist(clusdata, method="euclidian"), method="ward.D2")

par(mfrow=c(1, 2))
plot(hc1, labels=gol.fac); rect.hclust(hc1, 2)
plot(hc2, labels=gol.fac); rect.hclust(hc2, 2)

single.k2 = cutree(hc1, 2)
ward.k2   = cutree(hc2, 2)
print(table(gol.fac, single.k2)); cat("\n")
print(table(gol.fac, ward.k2)); cat("\n")

cat("Problem 1b\n==========\n")

kc = kmeans(clusdata, 2)
print(table(gol.fac, kc$cluster)); cat("\n")

cat("Problem 1c\n==========\n\n")

cat("Problem 1d\n==========\n")

iterations = 1000
initial = kc$centers
n = dim(clusdata)[1]
boot.cl = matrix(NA, nrow=iterations, ncol=4)

for (i in 1:iterations) {
  dat.star = clusdata[sample(1:n, replace=TRUE),]
  cl = kmeans(dat.star, initial, nstart=10)
  boot.cl[i,] = c(cl$centers[, 1], cl$centers[, 2])
}

boot.centers = matrix(apply(boot.cl, 2, mean),
                      nrow=2,
                      dimnames=list(c("1", "2"),
                                    c(gene1, gene2)))

cat("\nCenters from observed data (k=2):\n\n")
print(kc$centers)

confidence = 0.95
lower.bound = (1 - confidence) / 2
upper.bound = 1 - lower.bound

cat("\nThe", confidence * 100, "percent confidence intervals for each bootstrapped estimator (k=2):\n" )
for (i in 1:prod(dim(boot.centers))) {
  cat("\nMean:", round(c(boot.centers)[i], 4), "\t",
      "(", round(quantile(boot.cl[, i], c(lower.bound, upper.bound)), 4), ")")
}

cat("\n\nProblem 1e\n==========\n")

K.max = 30
sse = rep(NA, length(K.max))
for (k in 1:K.max) {
  sse[k] = kmeans(clusdata, centers=k, nstart=10)$tot.withinss
}

par(mfrow=c(1, 1))
plot(1:K.max, sse, type='o', xaxt='n')
axis(1, at=1:K.max, las=2)


cat("\nProblem 2a\n==========\n")

attr1 = "oncogene"
attr2 = "antigen"
attr1.loc = grep(attr1, golub.gnames[,2])
attr2.loc = grep(attr2, golub.gnames[,2])

cat("\nProblem 2b\n==========\n")

attr.fac = factor(c(rep(0, length(attr1.loc)),
                    rep(1, length(attr2.loc))),
                  levels=0:1,
                  labels=c(attr1, attr2))

cat("\nComparison of oncogenes and antigens as clustered by k-means (k=2):\n")
clusdata = data.frame(golub[c(attr1.loc, attr2.loc),])
kc = kmeans(clusdata, 2)
kc.table = table(attr.fac, kc$cluster)
print(kc.table)

cat("\nComparison of oncogenes and antigens as clustered by k-medoids (k=2):\n")
km = pam(clusdata, 2)
km.table = table(attr.fac, km$cluster)
print(km.table)

cat("\nProblem 2c\n==========\n\n")

cat("Ho: Antigens and oncogenes are not independently clustered data. K-means (k=2).",
    "\np-value:", format.pval(fisher.test(kc.table)$p.value), "\n\n")

cat("Ho: Antigens and oncogenes are not independently clustered data. K-medioids (k=2).",
    "\np-value:", format.pval(fisher.test(km.table)$p.value), "\n")

cat("\nProblem 2d\n==========\n")

hc1 = hclust(dist(clusdata, method="euclidian"), method="single")
hc2 = hclust(dist(clusdata, method="euclidian"), method="complete")

plot(hc1, labels=attr.fac)
plot(hc2, labels=attr.fac)


cat("\nProblem 3a\n==========\n")

ncidata = NCI60$data
ncilabs = NCI60$labs

K.max = 30
sse = rep(NA, length(K.max))
for (k in 1:K.max) {
  sse[k] = kmeans(ncidata, centers=k, nstart=10)$tot.withinss
}

plot(1:K.max, sse, type='o', xaxt='n')
axis(1, at=1:K.max, las=2)

cat("\nProblem 3b\n==========\n")

km = pam(as.dist(1 - cor(t(ncidata))), 7)
km.table = table(ncilabs, km$cluster)
print(km.table)