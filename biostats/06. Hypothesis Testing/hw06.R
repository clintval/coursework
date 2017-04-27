# Clint Valentine
# 10/16/2016
rm(list=ls())
set.seed(1)

data(golub, package = "multtest")
gol.fac = factor(golub.cl, levels=0:1, labels=c("ALL","AML"))

cat("Problem 1a\n==========")

gene1.loc = grep("H4/j", golub.gnames[,2])
gene2.loc = grep("APS Prostate specific antigen", golub.gnames[,2])

x = golub[gene1.loc, gol.fac=="ALL"]
results = t.test(x, mu=-0.9, alternative='greater')
print(results)

cat("Problem 1b\n==========")

x = golub[gene1.loc, gol.fac=="ALL"]
y = golub[gene1.loc, gol.fac=="AML"]
results = t.test(x, y)
print(results)

cat("Problem 1c\n==========")

x = golub[gene1.loc, gol.fac=="ALL"]
y = golub[gene2.loc, gol.fac=="ALL"]
results = t.test(x, y, alternative='less', paired=T, var.equal=F)
print(results)

cat("Problem 1d\n==========")

samples = golub[gene1.loc, gol.fac=="ALL"]
y.mean = mean(golub[gene2.loc, gol.fac=="ALL"])

samples.success = length(samples[samples < y.mean])

results = prop.test(samples.success, n=length(samples), p=0.5, alternative='greater')
print(results)

cat("Problem 1e\n==========")

samples = golub[gene1.loc, gol.fac=="ALL"]
samples.success = length(samples[samples > -0.6])

results = prop.test(samples.success, n=length(samples), p=0.5, alternative='less')
print(results)

cat("Problem 1f\n==========")

ALL.samples = golub[gene1.loc, gol.fac=="ALL"]
ALL.samples.success = length(ALL.samples[ALL.samples > -0.6])

AML.samples = golub[gene1.loc, gol.fac=="AML"]
AML.samples.success = length(AML.samples[AML.samples > -0.6])

results = prop.test(x=c(ALL.samples.success, AML.samples.success),
                    n=c(length(ALL.samples), length(AML.samples)),
                    alternative="two.sided")
print(results)


cat("Problem 2a\n==========")

p.reject = 0.05
trials = 2000

cat("\nWith a reject probability of", p.reject, "we expect to see",
    p.reject * trials, "rejections\nin", trials, "trials.\n\n")

cat("Problem 2b\n==========")

cat("\nProbability of less than 90 rejections P(X<90):\n")
prob = pbinom(90, size=2000, p=0.05)
print(prob)


cat("\nProblem 3a\n==========\n")

u = 3
s = 4
n = 20
alpha = 0.1
iterations = 10000
confidence = 0.95


tstat = function(x) {
  return((mean(x) - 3) / sd(x) * sqrt(length(x)))
}

x.sim = matrix(rnorm(iterations*n, mean=u, sd=s), ncol=n)

# Calculate t-test statistic for each data set
tstat.sim = apply(x.sim, 1, tstat)
# Calculate the rejection rate (Type I)
power.sim = mean(tstat.sim < qt(0.4, df=n - 1) & tstat.sim > qt(0.3, df=n - 1))

CI = power.sim + c(-1, 1) * qnorm((1 - confidence) / 2 + confidence) * sqrt(power.sim * (1 - power.sim) / 10000)
cat("The Type I error rate is:\n", round(power.sim, 4), "\n")
cat("\nThe two-sided 95% CI of the numerical estimate for the TYPE I error rate is:\n")
cat("(", round(CI[1], 4), ",", round(CI[2], 4), ")\n")

cat("\nIs alpha =", alpha, "in the CI for this test?\n")
cat(alpha > CI[1] & alpha < CI[2], "\n")


cat("\nProblem 4a\n==========\n")

level = 0.05
p.values = rep(NA, nrow(golub))

for (i in 1:nrow(golub)) {
  results = t.test(golub[i,] ~ gol.fac )
  p.values[i] = results$p.value
}

p.bon = p.adjust(p=p.values, method="bonferroni")
p.fdr = p.adjust(p=p.values, method="fdr")

cat("Genes with different expressions in AML vs. AML:\n",
    sum(p.values < level))
cat("\nWith Bonferroni adjustment:\n",
    sum(p.bon < level))
cat("\nWith FDR adjustment\n",
    sum(p.fdr < level))
cat("\nDifference between Bonferroni and FDR adjustments\n",
    sum(p.fdr < level) - sum(p.bon < level), "\n")

cat("\nProblem 4b\n==========\n")

cat("Gene names with the top three strongest differentially expressed genes:\n ")
cat(golub.gnames[order(p.bon)[1:3],2], sep='\n ')


cat("\nProblem 5a\n==========\n")

CI.wald = function(X, n, confidence=0.95) {
  p = X / n
  q = 1 - p
  
  kappa = qnorm((1 - confidence) / 2 + confidence)
  
  CI = list(
    lower = p - kappa * sqrt(p * q / n),
    upper = p + kappa * sqrt(p * q / n)
  )
  return(CI)
}

CI.wilson = function(X, n, confidence=0.95) {
  kappa = qnorm((1 - confidence) / 2 + confidence)
  
  p = X / n
  q = 1 - p
  
  CI = list(
    lower = (X + kappa^2 / 2) / (n + kappa^2) - kappa * sqrt(n) * sqrt(p * q + kappa^2 / (4 * n)) / (n + kappa^2),
    upper = (X + kappa^2 / 2) / (n + kappa^2) + kappa * sqrt(n) * sqrt(p * q + kappa^2 / (4 * n)) / (n + kappa^2)
  )
  return(CI)
}

CI.agresti.coull = function(X, n, confidence=0.95) {
  kappa = qnorm((1 - confidence) / 2 + confidence)

  X.tilde = X + kappa^2 / 2
  n.tilde = n + kappa^2
  p.tilde = X.tilde / n.tilde
  q.tilde = 1 - p.tilde
  
  CI = list(
    lower = p.tilde - kappa * sqrt(p.tilde * q.tilde / n.tilde),
    upper = p.tilde + kappa * sqrt(p.tilde * q.tilde / n.tilde)
  )
  return(CI)
}




CI.coverage = function(n, p, confidence, iterations, CI.func) {
  passed = 0
  for (i in 1:iterations) {
    
    samples = rbinom(n, size=1, prob=p)
    
    num.success = length(samples[samples > 0])
    p.success = num.success / n

    CI = CI.func(num.success, n, confidence)

    if (CI$lower < p.success & p.success < CI$upper) {
      passed = passed + 1
    }
  }
  return(passed / iterations)
}

n = 40
p = 0.2
confidence = 0.95
iterations = 10000

cat("Coverage for 95% Wald CI:\n ",
    round(CI.coverage(n, p, confidence, iterations, CI.wald), 4))
cat("\nCoverage for 95% Agresti-Coull CI:\n ",
    round(CI.coverage(n, p, confidence, iterations, CI.agresti.coull), 4))
cat("\nCoverage for 95% Wilson CI:\n ",
    round(CI.coverage(n, p, confidence, iterations, CI.wilson), 4))