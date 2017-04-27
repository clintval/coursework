# Clint Valentine
# 10/24/2016

rm(list=ls())
set.seed(1)
options(warn=0)
data(golub, package = "multtest")
gol.fac = factor(golub.cl, levels=0:1, labels=c("ALL","AML"))

cat("Problem 1\n=========\n")
level = 0.05
p.values = rep(NA, nrow(golub))
means.diff = rep(NA, nrow(golub))

for (i in 1:nrow(golub)) {
  p.values[i] = wilcox.test(golub[i,] ~ gol.fac, paired=F, alternative="greater")$p.value
  means.diff[i] = abs(mean(golub[i, gol.fac=='AML']) - mean(golub[i, gol.fac=='ALL']))
}

p.fdr = p.adjust(p=p.values, method="fdr")
cat(length(p.fdr[p.fdr < level]), "genes expressed higher in the ALL group.\n")

cat("\nThe three genes with the smallest p-values are:\n ")
cat(golub.gnames[order(p.fdr)[1:3], 2], sep='\n ')

cat("\nThe three genes with the greatest difference in means between groups are:\n ")
cat(golub.gnames[order(means.diff, decreasing=T)[1:3], 2], sep='\n ')


cat("\nProblem 2\n=========\n")
level = 0.05
p.values = rep(NA, nrow(golub))

for (i in 1:nrow(golub)) {
  p.values[i] = shapiro.test(golub[i, gol.fac=='AML'])$p.value
}

cat(length(p.fdr[p.fdr < level]), "genes expressed did not pass a normality test in the AML group.\n")


cat("\nProblem 3\n=========\n")
gene1 = "HOXA9 Homeo box A9"
gene2 = "CD33"

gene1.loc = grep(gene1, golub.gnames[, 2])
gene2.loc = grep(gene2, golub.gnames[, 2])

result = wilcox.test(golub[gene1.loc, gol.fac=="ALL"],
                     golub[gene2.loc, gol.fac=="ALL"],
                     paired=T,
                     alternative="two.sided")

cat("Gene", gene1, "and", gene2,
    "are significantly different ( p-value:", round(result$p.value, 4), ").\n")


cat("\nProblem 4\n=========\n")

num.departments = dim(UCBAdmissions)[3]

for (i in 1:num.departments) {
  cat("\n  Department", chartr("123456789", "ABCDEFGHI", i), "\n")
  cat("  P-value:", round(fisher.test(UCBAdmissions[,,i])$p.value, 4))
}


cat("\n\nProblem 5\n=========\n")

gene = "CD33"
gene.loc = grep(gene, golub.gnames[, 2])

div = var(golub[gene.loc, gol.fac=="ALL"]) / var(golub[gene.loc, gol.fac=="AML"])

many.var.compare = replicate(100000,
  {gol.fac.shuffle = sample(gol.fac)
   var(golub[gene.loc, gol.fac.shuffle=="ALL"]) / var(golub[gene.loc, gol.fac.shuffle=="AML"])}
)

hist(many.var.compare, breaks=200)
abline(v=div, col='red')
p.value = mean(many.var.compare < div)
cat("Variance in the CD333 gene expression data for ALL is smaller than in the AML group ( p-value:", p.value, ")\n")

legend('topright',
       c('Variance of Real Data'),
       lty=1,
       col=c('red'),
       bty='n',
       cex=.75)