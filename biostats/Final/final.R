# Clint Valentine
# 12/14/2016

#set.seed(1)
rm(list=ls())
options(digits=4)

cat("Problem 1a\n==========\n")

data = read.table('DataPois.txt', header=T)$y
n = length(data)
cat("\nSample size:", n)
cat("\nSample mean:", mean(data))

cat("\n\nProblem 1b\n==========\n")

lik = function(x) prod(dpois(data, lambda=x))
lik.maximum = optimize(lik, interval=c(min(data), max(data)), tol=0.0001, maximum=T)
cat("\nMLE of Theta:", lik.maximum$maximum)

cat("\n\nProblem 1c\n==========\n\n")

alpha = 0.05
iterations = 1000
theta.boot = rep(NA, iterations)

for (i in 1:iterations) {
  lik = function(x) prod(dpois(data[sample(1:length(data), replace=T)], lambda=x))
  theta.boot[i] = optimize(lik, interval=c(min(data), max(data)), tol=0.0001, maximum=T)$maximum
}
CI = quantile(theta.boot, c(alpha / 2, 1 - (alpha / 2)))
cat((1 - alpha) * 100, "percent confidence interval of theta from bootstrap:\n",
    "(", CI[1], ",", CI[2], ")")
cat("\n\nHo: Theta is equal to one\np-value:", t.test(theta.boot, mu=1)$p.value)


cat("\n\nProblem 2a\n==========\n") 

library(ISLR)
library(lmtest)
library(cluster)

ncidata = NCI60$data
ncilabs = NCI60$labs

counts = table(ncilabs)
ix = ncilabs %in% names(counts[counts > 3])

data = ncidata[ix,]
labs = factor(ncilabs[ix])

cat("\n\nProblem 2b\n==========\n\n") 

y = data[, 1]
print(anova(lm(y ~ labs)))

print(pairwise.t.test(y, labs, p.adjust.method='fdr'))

cat("\nProblem 2c\n==========\n\n") 

print(shapiro.test(residuals(lm(y ~ labs))))

print(bptest(lm(y ~ labs), studentize=FALSE))

cat("\nProblem 2d\n==========\n")

p.values = apply(data, 2, function(y) anova(lm(y ~ labs))$`Pr(>F)`[1])
p.adj = p.adjust(p.values, method='fdr')
cat("\nThe number of genes that express differently among different cancer types is:",
    length(p.adj[p.adj < 0.05]))

cat("\n\nProblem 3a\n==========\n") 

names = gsub(" ", "", names(state.x77[1,]))
data = as.data.frame(state.x77)
names(data) = names
pairs(data)

# Corr. with Life Expect = Income, Murder, HS Grad

cat("\n\nProblem 3b\n==========\n") 

fit.lin.reg = lm(LifeExp ~ Income + Illiteracy + Frost,
                 data=data)
print(summary(fit.lin.reg))

cat("\n\nProblem 3c\n==========\n") 

MSE = function(sm) mean(sm$residuals^2)

mse = rep(NA,nrow(data))

for (i in 1:nrow(data)) {
  data.star = data[-i,]
  fit.star = lm(LifeExp ~ Income + Illiteracy + Frost,
                data=data.star)
  mse[i] = MSE(summary(fit.star))
}
cat("\n")
cat(mse)

cat("\n\nThe average MSE is", mean(mse))


cat("\n\nProblem 4a\n==========\n")

library(cluster)
library(ALL); data(ALL)

IsB = substr(ALL$BT, 1, 1) %in% "B"
data = exprs(ALL)[, which(IsB)]

names = as.character(ALL$BT[IsB])
mol.biol = as.character(ALL$mol.biol[IsB])

cat("\n\nProblem 4b\n==========\n")

filter = apply(data, 1, function(x) sd(x) / mean(x) > 0.2)
data.filtered = data[which(filter), ]
partb.names = row.names(data.filtered)

cat("\nThere are", nrow(data.filtered), "genes with a coefficient of variance greater than 0.2.")

cat("\n\nProblem 4c\n==========\n")

# Genes that are not normally distributed

cat("\n\nProblem 4d\n==========\n")

par(mfrow=c(2, 1))

hc1 = hclust(dist(t(data.frame(data.filtered)), method="euclidian"), method="ward.D2")
plot(hc1, labels=names, xlab="B Stages")
rect.hclust(hc1, 4)

hc1 = hclust(dist(t(data.frame(data.filtered)), method="euclidian"), method="ward.D2")
plot(hc1, labels=mol.biol, xlab="Molecule Biology", main="")
rect.hclust(hc1, 4)

cat("\n\nProblem 4e\n==========\n\n")

pred.groups = cutree(hc1, k=4)
print(table(names, pred.groups))

pred.groups = cutree(hc1, k=4)
print(table(mol.biol, pred.groups))

colors = 1:length(unique(names))
names(colors) = unique(names)

heatmap(as.matrix(scale(data.filtered)), Colv=T, Rowv=T,
        ColSideColors=as.character(colors[names]),
        distfun=function(x) dist(x, method='euclidian'),
        hclustfun=function(x) hclust(x, method="ward.D2"))

legend("topright",
       legend = unique(names),
       col=colors,
       lty=1,
       lwd=10)


colors = 1:length(unique(mol.biol))
names(colors) = unique(mol.biol)

heatmap(as.matrix(scale(data.filtered)), Colv=T, Rowv=T,
        ColSideColors=as.character(colors[mol.biol]),
        distfun=function(x) dist(x, method='euclidian'),
        hclustfun=function(x) hclust(x, method="ward.D2"))

legend("topright",
       legend = unique(mol.biol),
       col=colors,
       lty=1,
       lwd=10)

cat("\n\nProblem 4f\n==========\n")

library(limma)

# Remove B class from data
data = data[, which(names != 'B')]
names = names[which(names != 'B')]

# Merge B3 and B4 classes to B34
names[names == 'B3' | names == 'B4'] = 'B34'

design.matrix = model.matrix(~ 0 + factor(names))
colnames(design.matrix) = sort(unique(names))
fit = lmFit(data, design.matrix)
fit = eBayes(fit)

cont.matrix = makeContrasts(B1-B2, B1-B34, levels=factor(names))
fit = contrasts.fit(fit, cont.matrix)
fit = eBayes(fit)

top.genes = topTable(fit, number=Inf, p.value=0.05, adjust.method="fdr")

cat("\nThere are", nrow(top.genes), "genes at FDR p-value < 0.05 that are sig. different among the classes", sort(unique(names)))

cat("\n\nProblem 4g\n==========\n")

library(e1071)
library(rpart)

data.selected = data.frame(data[rownames(top.genes),])

N = ncol(data.selected)
mcr.svm.raw = rep(NA, N)

########################
# Support Vector Machine
########################

for (i in 1:N) {
  fit.svm = svm(t(data.selected[, -i]),
                factor(names[-i]),
                type="C-classification",
                kernel="linear")
  
  data.predict = predict(fit.svm, t(data.selected[, i]))
  mcr.svm.raw[i] = mean(data.predict != factor(names)[i])
}

cat("\nThe average MCR of a n-fold cross-validation for SVM classification is:",
    mean(mcr.svm.raw))

#####################
# Classification Tree
#####################

data.response = data.frame(names, t(data.selected))
mcr.tree.raw = rep(NA, N)

for (i in 1:N) {
  fit.tree = rpart(names ~ ., data=data.response[-i,], method="class")
  pred.tree = predict(fit.tree, data.response[i,], type="class")
  mcr.tree.raw[i] = mean(pred.tree != factor(names)[i])
}

cat("\n\nThe average MCR of a n-fold cross-validation for tree classification is:",
    mean(mcr.tree.raw))

cat("\n\nProblem 4h\n==========\n")

partf.names = rownames(top.genes)
final.genes = intersect(partb.names, partf.names)
final.data = data[final.genes,]

cat("\nThere are", length(final.genes), "genes that pass the filters in 4b and 4f")


N = ncol(final.data)
mcr.svm.raw = rep(NA, N)

########################
# Support Vector Machine
########################

for (i in 1:N) {
  fit.svm = svm(t(final.data[, -i]),
                factor(names[-i]),
                type="C-classification",
                kernel="linear")
  
  data.predict = predict(fit.svm, t(final.data[, i]))
  mcr.svm.raw[i] = mean(data.predict != factor(names)[i])
}

cat("\nThe average MCR of a n-fold cross-validation for SVM classification is:",
    mean(mcr.svm.raw))

#####################
# Classification Tree
#####################

data.response = data.frame(names, t(final.data))
mcr.tree.raw = rep(NA, N)

for (i in 1:N) {
  fit.tree = rpart(names ~ ., data=data.response[-i,], method="class")
  pred.tree = predict(fit.tree, data.response[i,], type="class")
  mcr.tree.raw[i] = mean(pred.tree != factor(names)[i])
}

cat("\n\nThe average MCR of a n-fold cross-validation for tree classification is:",
    mean(mcr.tree.raw))
