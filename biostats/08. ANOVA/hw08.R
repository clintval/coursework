# Clint Valentine
# 10/30/2016

rm(list=ls())
set.seed(1)

library(lmtest)
library(ALL)
data(ALL)

probe = "109_at"
ALL.selection = ALL[,ALL$BT %in% c("B", "B1", "B2", "B3", "B4")] 

cat("Problem 1a\n==========\n")

y = exprs(ALL.selection)[probe,]
test_result = anova(lm(y ~ ALL.selection$BT))
cat("Probe `109_at` in groups B, B1, B2, B3, and B4:\n")
cat("Pr(>F) =", round(test_result$`Pr(>F)`[1], 4), "via ANOVA\n")

cat("\nProblem 1b\n==========\n")

B3.mean = summary(lm(y ~ ALL.selection$BT))$coefficients["ALL.selection$BTB3", "Estimate"]
cat("B3 Estimate Mean:", round(B3.mean, 4), "\n")

cat("\nProblem 1c\n==========\n")

ALL.selection.pairs = pairwise.t.test(y, ALL.selection$BT)
cat("B2's mean gene expression is most different to\nB's mean gene expression ( p-value:",
    round(ALL.selection.pairs$p.value["B2", "B"], 4), ")\n")

cat("\nProblem 1d\n==========\n")

cat("Pairwise t-test with FDR correction of B, B1, B2,\nB3, and B4 mean expression values:\n\n")
ALL.selection.pairs.fdr = pairwise.t.test(y, ALL.selection$BT, p.adjust.method="fdr")
print(round(ALL.selection.pairs.fdr$p.value, 4))

sig.ind = which(ALL.selection.pairs.fdr$p.value < 0.05, arr.ind = TRUE)
significant.p = ALL.selection.pairs.fdr$p.value[sig.ind]
cat("\nThere are", length(significant.p), "p-values < 0.05\np-values:\n",
    paste(round(significant.p, 4), collapse="\n "), "\n")

cat("\nProblem 1e\n==========\n")

test.result = shapiro.test(residuals(lm(y ~ ALL.selection$BT)))
cat("Ho: The residuals of the linear fit follow a normal dist. ( p-value:",
    round(test.result$p.value, 4), ")\n\n")

test.result = bptest(lm(y ~ ALL.selection$BT), studentize=FALSE)
cat("Ho: The residuals of the linear fit are homoscedastic ( p-value:",
    round(test.result$p.value, 4), ")\n")


cat("\nProblem 2a\n==========\n")

p.values = apply(exprs(ALL.selection), 1, function(X) { kruskal.test(X ~ ALL.selection$BT)$p.value })
p.values.adj = p.adjust(p.values, method="fdr")
significant.p = p.values.adj[p.values.adj < 0.05]
cat("There are", length(significant.p), "p-values less than 0.05\n")

cat("\nProblem 2b\n==========\n")

cat("The top five probe names for genes with the smallest p-values are:\n ")
cat(paste(names(significant.p[order(significant.p)[1:5]]), collapse="\n "), "\n")


cat("\nProblem 3a\n==========\n")

probe = "38555_at"
ALL.selection = ALL[,which(ALL$BT %in% c("B1","B2","B3","B4") &
                           ALL$sex %in% c("M","F"))]
y = exprs(ALL.selection)[probe,]
test_result = anova(lm(y ~ ALL.selection$BT*ALL.selection$sex))
print(test_result)

cat("\nProblem 3b\n==========\n")

test.result = shapiro.test(residuals(lm(y ~ ALL.selection$BT*ALL.selection$sex)))
cat("Ho: The residuals of the linear fit follow a normal dist. ( p-value:",
    round(test.result$p.value, 4), ")\n\n")

test.result = bptest(lm(y ~ ALL.selection$BT*ALL.selection$sex), studentize=FALSE)
cat("Ho: The residuals of the linear fit are homoscedastic ( p-value:",
    round(test.result$p.value, 4), ")\n")


cat("\nProblem 4\n=========\n")

probe = "1242_at"
iterations = 2000
ALL.selection = ALL[,ALL$BT %in% c("B1","B2","B3")]

y = exprs(ALL.selection)["1866_g_at",]
group = ALL.selection$BT[, drop=T]

T.obs = sum((by(y, group, mean) - mean(by(y, group, mean))^2)) / (length(levels(group)) - 1)

T.perm = rep(NA, iterations)

for(i in 1:iterations) {
  y.perm = sample(y, length(y), replace=F)
  T.perm[i] = sum((by(y.perm, group, mean) - mean(by(y.perm, group, mean))^2)) / (length(levels(group)) - 1)
}
cat("P(F>=F_obs) = p-value =", mean(T.perm >= T.obs))

