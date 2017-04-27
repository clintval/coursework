# Clint Valentine
# 10/30/2016

rm(list=ls())
set.seed(1)

cat("Problem 1a\n==========\n")

X_range = c(1, 2, 3)

f.X = function (x) 2.469862 * x * exp(-(x^2))
f_X = function (x) f.X(x) * (x %in% X_range)

X.E = sum(X_range * f_X(X_range))
X.var = sum((X_range - X.E)^2 * f_X(X_range))
X.sd = X.var^0.5

cat("E(X)  =", round(X.E, 4))
cat("\nsd(X) =", round(X.sd, 4))

f_Y = function (y) 2 * y * exp(-(y^2)) * (y > 0)
Y.E = integrate(function(y) y * f_Y(y), lower=0, upper=4)$value
Y.var = integrate(function(y) (y - Y.E)^2 * f_Y(y), lower=0, upper=4)$value
Y.sd = Y.var^0.5

cat("\n\nE(Y)  =", round(Y.E, 4))
cat("\nsd(Y) =", round(Y.sd, 4))

cat("\n\nProblem 1b\n==========\n")

cat("E(2X - 3Y)  =", round(2 * X.E - 3 * Y.E, 4))
cat("\nsd(2X - 3Y) =", round(2 * X.sd - 3 * Y.sd, 4))


cat("\n\nProblem 2\n=========\n")
draws = 20000
X.E = mean(rnorm(draws, mean=0, sd=1))
Y.E = mean(rchisq(draws, df=4))
cat("E(X^2/(X^2 + Y)) =", round(X.E^2 / (X.E^2 + Y.E), 2))


cat("\n\nProblem 3\n=========\n")
cat("P(X>940) =", round((1- pbinom(940, 1000, 0.92)) * 100, 4), "%")

cat("\n\nProblem 4\n=========\n")

y = as.numeric(t(read.table(file="normalData.txt", header=T)))
nloglik = function(theta) -sum(log(dnorm(y, theta, theta)))
result = optimize(interval=c(min(y), max(y)), nloglik)
cat("MLE point estimator for theta:", round(result$minimum, 4))


cat("\n\nProblem 5a\n==========\n")

data(golub, package = "multtest")
gol.fac = factor(golub.cl, levels=0:1, labels=c("ALL","AML"))

level = 0.1
p.values = apply(golub, 1, function(X) { t.test(X, mu=0.6, alternative="greater")$p.value })
p.values.adj = p.adjust(p.values, method="fdr")

cat("Genes with mean expression values greater than 0.6:\n",
    sum(p.values.adj < level))

cat("\n\nProblem 5b\n==========\n")

cat("Top five genes with mean expression values > 0.6:\n ")
cat(golub.gnames[order(p.values.adj)[1:5],2], sep='\n ')


cat("\n\nProblem 6a\n==========\n")
cat("See plot")

data(golub, package = "multtest")
gol.fac = factor(golub.cl, levels=0:1, labels=c("ALL","AML"))

iloc.1 = 2715
iloc.2 = 2302

hist(golub[iloc.1,],
     main="Histogram of GRO3 Gene Expression Values",
     xlab="GRO3 Gene Expression Values")

cat("\n\nProblem 6b\n==========\n")
cat("See plot")

plot(x=golub[iloc.1,],
     y=golub[iloc.2,],
     main="GRO3 vs. MYC Gene Expression",
     xlab="GRO3 Gene Expression Values",
     ylab="MYC Gene Expression Values",
     pch=1,
     col=gol.fac)

legend("topright",
       col=factor(levels(gol.fac)), 
       pch=c(1, 1), 
       legend=c("ALL Patients", "AML Patients"))

cat("\n\nProblem 6c\n==========\n")

test.result = t.test(golub[iloc.1,], golub[iloc.2,], paired=T, alternative='less')
cat("Ho: The mean expression value of the GRO3 gene is the same or greater
    than the mean expression value of the MYC gene ( p-value:", round(test.result$p.value, 4), ")\n")

cat("HA: The mean expression value of the GRO3 gene is less
    than the mean expression value of the MYC gene ( p-value:", 1 - round(test.result$p.value, 4), ")")

cat("\n\nProblem 6d\n==========\n")

test.result = shapiro.test(golub[iloc.1,])
cat("Ho: The GRO3 gene expression values are
    normally distributed.          ( p-value:",
    format.pval(test.result$p.value), ")\n")

test.result = shapiro.test(golub[iloc.2,])
cat("Ho: The MYC gene expression values are
    normally distributed.          ( p-value:",
     format.pval(test.result$p.value), ")\n")

test.result = var.test(golub[iloc.1,], golub[iloc.2,])
cat("Ho: The GRO3 and MYC gene expression
    values have the same variance. ( p-value:",
    format.pval(test.result$p.value), ")")

cat("\n\nProblem 6e\n==========\n")

diff = golub[iloc.1,] - golub[iloc.2,]
test.result = binom.test(x=sum(diff<0), n=length(diff), p=0.5, alternative="less")

cat("Ho: The median difference between the GRO3 and MYC gene
    expression values are greater than or equal to zero.
    ( p-value:", format.pval(test.result$p.value), ")\n")

cat("\n\nProblem 6f\n==========\n")

diff = golub[iloc.1,] - golub[iloc.2,]
test.result = binom.test(x=sum(diff>0), n=length(diff), p=0.5, conf.level=0.9)

cat("The nonparametric 95% one-sided upper confidence interval
    for the median difference between the GRO3 and MYC gene
    expression values is (", round(test.result$conf.int[1], 4), ", 1", ")")

cat("\n\nProblem 6g\n==========\n")

iterations = 2000
n = length(golub[iloc.1,])
boot.x.u =rep(NA, n)

for (i in 1:iterations) {
  boot.x.u[i] = mean(golub[iloc.1, sample(1:n, replace=T)] - sample(1:n, replace=T))
}
CI.lower = quantile(boot.x.u, 1 - 0.95)

cat("The bootstrapped 95% one-sided upper confidence interval
    for the mean difference between the GRO3 and MYC gene
    expression values is (", round(CI.lower, 4), ", 1",  ")")


cat("\n\nProblem 7a\n==========\n")

gene.id = grep("HPCA Hippocalcin", golub.gnames[,2])
cat("Row number for HPCA Hippocalcin Gene:", gene.id)

cat("\n\nProblem 7b\n==========\n")

proportion = sum(golub[gene.id, gol.fac=="ALL"] < 0)
n = length(golub[gene.id, gol.fac=="ALL"])

cat("Proportion of ALL patients in which HPCA Hippocalcin
     is negatively expressed:", proportion, '/', n, "at",
    round(100*proportion/n, 2), "%\n")

cat("\n\nProblem 7c\n==========\n")

test.result = prop.test(proportion, n=n, p=0.5, alternative="greater")

cat("Ho: The HIPCA Hippocalcin gene is negatively expressed in 
    at least half of the population of ALL patients.",
    "\n    ( p-value=",
    round(test.result$p.value, 4), ")\n")

cat("\n\nProblem 7d\n==========\n")

prop1 = sum(golub[gene.id, gol.fac=="ALL"] < 0)


test.result = prop.test(prop1, n=n, p=0.5)

cat("The 95% confidence interval for the difference of proportions",
    "\nin the ALL group versus in the AML group of patients with negatively",
    "\n expressed 'HPCA Hippocalcin' gene is: \n(",
    round(test.result$conf.int, 4), ")\n")
