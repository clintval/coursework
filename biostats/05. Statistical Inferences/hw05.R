# Clint Valentine
# 10/09/2016
rm(list=ls())
set.seed(1)

# Problem 1b
cat("Problem 1b\n")
n = 1
obs = c(1.636, 0.374, 0.534, 3.015, 0.932, 0.179)

# Numerical Optimization
lik = function(lam) prod(dexp(obs), lambda=lam)

# Find the maximum likelihood function
lik.maximum = optimize(lik, interval=c(0, 1), tol=0.0001, maximum=TRUE)
cat("Numerical Optimization result: lambda=")
cat(round(lik.maximum$maximum, 4))

# Analytic Formula
cat("\nAnalytical Calculation result: lambda=")
cat(round(n / mean(obs), 4), '\n')


# Problem 2a
cat("\nProblem 2a\n")
n = 53
sample.sd = 12.4
sample.mean = 100.8
cat("For", n, "realizations of a chi-squared distribution X
with a sample mean of", sample.mean, "and st.dev", sample.sd, "Method of Moment \
estimator of population mean m is given by the sample mean:\n")
cat("Solution: m =", sample.mean, "\n")

# Problem 2b
cat("\nProblem 2b\n")
cat("The one-sided lower 90% CI of m is:\n")
cat("(", c(round(sample.mean + qt(0.1, df=n-1) * sample.sd / sqrt(n), 4), ",", Inf, ")\n"))


# Problem 3a, 3b, and 3c
cat("\nProblem 3a, 3b, and 3c\n")
data(golub, package = "multtest")
gol.fac = factor(golub.cl, levels=0:1, labels=c("ALL","AML"))

gene = "Zyxin"
gene.loc = grep("Zyxin", golub.gnames[,2])

min_x = min(golub[gene.loc,]) * 1.7
max_x = max(golub[gene.loc,]) * 1.7

plot(density(golub[gene.loc, gol.fac=='AML']),
     main='Densities of Zyxin Gene Expression',
     col='red',
     xlab='Expression',
     ylab='Probabiltiy',
     xlim=c(min_x , max_x))
lines(density(golub[gene.loc, gol.fac=='ALL']),
      col='blue')
legend('topright',
       c('ALL', 'AML'),
       lty=1,
       col=c('red', 'blue'),
       bty='n',
       cex=.75)



iterations = 1000
for (classification in c('ALL', 'AML')) {
  # Isolate Zyxin gene expression values for either classification
  zyxin = golub[gene.loc, gol.fac==classification]
  n = length(zyxin)
  

  
  # Empty vectors for storing simulated means, medians, and variances
  averages = rep(NA, iterations)
  medians = rep(NA, iterations)
  variances = rep(NA, iterations)
  
  # Bootstrap the expression values and store qualities
  for (i in 1:iterations) {
    zyxin.s = zyxin[sample(1:n, replace=TRUE)]
    averages[i] = mean(zyxin.s)
    medians[i] = median(zyxin.s)
    variances[i] = var(zyxin.s)
  }
  
  # Settings for CI  
  confidence = 0.95
  alpha = 1 - confidence
  probs = c(alpha / 2, 1 - alpha / 2)

  # Bootstrap Solutions
  zyxin.mean.CI.B = quantile(averages, probs)
  zyxin.median.CI.B = quantile(medians, probs)
  zyxin.var.CI.B = quantile(variances, probs)
  
  zyxin.mean.CI.P = mean(zyxin) + qt(probs, df=n - 1) * sd(zyxin) / sqrt(n)
  zyxin.median.CI.P = median(zyxin) + qnorm(probs, sd=sd(zyxin)) * (1 / (2 * dnorm(probs, sd=sd(zyxin)) * sqrt(n)))
  zyxin.var.CI.P = ((n - 1) * sd(zyxin)^2) / (qchisq(rev(probs), df=n - 1))

  cat("CLASSIFICATION", classification, "\n")
  cat("##################\n\n")
  cat("\tThe sample mean is:", round(mean(zyxin), 4), "\n")
  cat("\tThe sample median is:", round(median(zyxin), 4), "\n")
  cat("\tThe sample variance is:", round(var(zyxin), 4), "\n\n")
  
  cat("\tThe bootsrapped two-sided 95% CI of the sample mean is:\n")
  cat("\t(", round(zyxin.mean.CI.B[1], 4), ",", round(zyxin.mean.CI.B[2], 4), ")\n")
  cat("\tThe parametric two-sided 95% CI of the sample mean is:\n")
  cat("\t(", round(zyxin.mean.CI.P[1], 4), ",", round(zyxin.mean.CI.P[2], 4), ")\n\n")

  cat("\tThe bootsrapped two-sided 95% CI of the sample median is:\n")
  cat("\t(", round(zyxin.median.CI.B[1], 4), ",", round(zyxin.median.CI.B[2], 4), ")\n")
  cat("\tThe parametric two-sided 95% CI of the sample median is:\n")
  cat("\t(", round(zyxin.median.CI.P[1], 4), ",", round(zyxin.median.CI.P[2], 4), ")\n\n")
  
  cat("\tThe bootstrapped two-sided 95% CI of the sample variance is:\n")
  cat("\t(", round(zyxin.var.CI.B[1], 4), ",", round(zyxin.var.CI.B[2], 4), ")\n")
  cat("\tThe parametric two-sided 95% CI of the sample variance is:\n")
  cat("\t(", round(zyxin.var.CI.P[1], 4), ",", round(zyxin.var.CI.P[2], 4), ")\n\n")
}

# Problem 4
cat("\nProblem 4a\n")
n = 50
iterations = 1000

# Settings for CI  
confidence = 0.90
alpha = 1 - confidence
probs = c(alpha / 2, 1 - alpha / 2)

CI.sample.mean = function (X, probs) mean(X) + qt(probs, df=n - 1) * sqrt(mean(X) / length(X))
CI.sample.var = function (X, probs) (length(X) - 1) * sd(X)^2 / qchisq(rev(probs), df=length(X) - 1)

compare.pois.intervals = function(n, iterations, lambda, CI.func, probs) {
  success = 0
  for (i in 1:iterations) {
    CI = CI.func(rpois(n, lambda=lambda), probs)
    if (CI[1] < lambda & lambda < CI[2]) {
      success = success + 1
    }
  }
  return(success / iterations)
}

for (lambda in c(0.11, 1, 10)) {
  cat("For lambda:", lambda, "\n")
  m = compare.pois.intervals(n, iterations, lambda=lambda, CI.sample.mean, probs)
  cat("\tCoverage Probability (Mean):", paste(m *100, '%', sep=''), "\n")
  v = compare.pois.intervals(n, iterations, lambda=lambda, CI.sample.var, probs)
  cat("\tCoverage Probability (Var): ", paste(v *100, '%', sep=''), "\n")
}
