# Clint Valentine
# 11/06/2016

rm(list=ls())
set.seed(1)

data(golub, package = "multtest")
gol.fac = factor(golub.cl, levels=0:1, labels=c("ALL","AML"))

cat("Problem 1a\n==========\n")

gene1 = "GRO2 GRO2 oncogene"
gene2 = "GRO3 GRO3 oncogene"
gene1.loc = grep(gene1, golub.gnames[, 2])
gene2.loc = grep(gene2, golub.gnames[, 2])
correlation = cor(golub[gene1.loc,], golub[gene2.loc,])

cat("Correlation of", gene1, "and", gene2, "\nexpression values:\n")
cat(round(correlation, 4), "\n")

cat("\nProblem 1b\n==========\n")

confidence = 0.90
test.results = cor.test(golub[gene1.loc,], golub[gene2.loc,], conf.level=confidence)

cat("Parametric", confidence * 100, "percent conf. interval for the correlation\nof",
    gene1, "and", gene2, "expression values:\n")
cat("(", round(test.results$conf.int[1], 4),
    round(test.results$conf.int[2], 4), ")\n")

cat("\nProblem 1c\n==========\n")

confidence = 0.90
alpha = (1 - confidence) / 2

iterations = 20000
boot.cor = rep(NA, iterations)
data = cbind(golub[gene1.loc,], golub[gene2.loc,]) 
for (i in 1:iterations){
  dat.star = data[sample(1:nrow(data),replace=TRUE), ]
  boot.cor[i] = cor(dat.star[,1], dat.star[,2]) 
}
CI = quantile(boot.cor, c(alpha, 1 - alpha))
cat("Nonparametric", confidence * 100, "percent conf. interval for the correlation\nof",
    gene1, "and", gene2, "expression values:\n")
cat("(", round(CI[1], 4), round(CI[2], 4), ")\n")

cat("\nProblem 1d\n==========\n")

iterations = 20000
n = length(golub[gene1.loc,])
T.perm = rep(NA, iterations)
for (i in 1:iterations) {
  X.perm = sample(golub[gene1.loc,], n, replace=F)
  T.perm[i] = cor(X.perm, golub[gene2.loc,])
}
p.value = mean(T.perm>0.64)
cat("Ho: The correlation is 0.64 or less
HA: The correlation is greater than 0.64\n")
cat("P-value: ", round(p.value, 4), "\n")


cat("\nProblem 2a\n==========\n")

gene = "Zyxin"
gene.loc = grep('Zyxin', golub.gnames[, 2])
correlations = rep(NA, length(golub[,1]) - 1)
p.values = rep(NA, length(golub[,1] - 1))
for (i in 1:length(golub[,1])) {
  correlations[i] = cor(golub[i,], golub[gene.loc,])
  p.values[i] = cor.test(golub[i,],
                         golub[gene.loc,],
                         alternative='less')$p.value
}
p.fdr = p.adjust(p.values, method='fdr')
count.neg.0.5 = sum(correlations < -0.5)
count.p.val.0.05 = sum(p.fdr < 0.05)

cat("There are", count.neg.0.5, "genes highly negatively correlated",
"with", gene, "\n(correlation < -0.5)\n")

cat("\nProblem 2b\n==========\n")

top.five = golub.gnames[order(correlations)[1:5], 2]

cat("Top five genes that are most negatively correlated with", gene, "\n\n")
for (i in 1:length(top.five)) {
  cat(i, ")", top.five[i], "\n")
}

cat("\nProblem 2c\n==========\n")

cat("There are", count.p.val.0.05, "genes significantly negatively correlated",
    "with", gene, "\n(FDR adjusted p-value < 0.05)\n")


cat("\nProblem 3a\n==========\n")

reg.fit = lm(golub[gene1.loc,] ~ golub[gene2.loc,])
p.values = summary(reg.fit)$coefficients[, 'Pr(>|t|)']
r.squared = summary(reg.fit)$r.squared

cat("P-values for the linear model of the", gene1,
    "\npredicting the", gene2, "\n\n")
print(p.values, 4)

cat("\nThe proportion of the", gene1, "expression's variation can
be explained by the", gene2, "expression's variation is:\n")
cat(round(r.squared, 4), "\n")

cat("\nProblem 3b\n==========\n")

null = 0.5
slope = reg.fit$coefficients[2]
std.error = summary(reg.fit)$coefficients[, 'Std. Error'][2]
t = (slope - null) / std.error
p.value = pt(t, df=length(golub[1,]) - 1)

cat("Ho: The slope parameter is 0.5 or greater
HA: The slope parameter is less than 0.5\n")
cat("P-value: ", format.pval(p.value), "\n")

cat("\nProblem 3c\n==========\n")

level = 0.8
x = golub[gene1.loc,]
y = golub[gene2.loc,]
pred.plim <- predict.lm(lm(x ~ y),
                        data.frame(y=0),
                        interval = "prediction",
                        level=level)

cat("The", level * 100, "percent prediction interval for the", gene2, "expression
when", gene1, "is not expressed is:\n")
cat("(", round(pred.plim[2], 4), round(pred.plim[3], 4), ")\n")

cat("\nProblem 3d\n==========\n")

plot(reg.fit, which=1)
plot(reg.fit, which=2)
p.value = shapiro.test(summary(reg.fit)$residuals)$p.value

cat("Ho: The residuals of the linear fit follow a normal distribution
HA: The residuals of the linear fit do not follow a normal distribution\n")
cat("P-value: ", format.pval(p.value), "\n")


cat("\nProblem 4\n==========\n")

level = 0.90
reg.fit = lm(stack.loss ~ Air.Flow + Water.Temp + Acid.Conc., data=stackloss)
pred.clim = predict.lm(reg.fit,
                       new=data.frame(Air.Flow=60, Water.Temp=20, Acid.Conc.=90),
                       interval="confidence",
                       level=level)

pred.clim = predict.lm(reg.fit,
                       new=data.frame(Air.Flow=60, Water.Temp=20, Acid.Conc.=90),
                       interval="prediction",
                       level=level)

print(summary(reg.fit))


cat("\nThe", level * 100, "percent confidence interval for stackloss
when Air Flow is 60, Water Temp is 20, and Acid Concentration is 90 is:\n")
cat("(", round(pred.clim[2], 4), round(pred.clim[3], 4), ")\n\n")

cat("The", level * 100, "percent prediction interval for stackloss
when Air Flow is 60, Water Temp is 20, and Acid Concentration is 90 is:\n")
cat("(", round(pred.plim[2], 4), round(pred.plim[3], 4), ")\n")
