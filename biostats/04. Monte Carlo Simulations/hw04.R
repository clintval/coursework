# Clint Valentine
# 09/30/2016
rm(list=ls())

require(mvtnorm)

set.seed(1)

# Problem 1
cat("Problem 1b\n")
u = 3
sd = 3 / 5^0.5
cat("P(2 < <X> =< 5.1) for N(u=3, sd=3/5^0.5) is:\n")
print(round(pnorm(5.1, u, sd) - pnorm(2, u, sd), 4))

# Problem 2
cat("\nProblem 2\n")
cat("P(Y > 15) for 100 trials of binom(size=20, p=0.7)\n")
n = 20
p = 0.7
nsims = 100

b.mean = n * p
b.var = n * p * (1 - p)

n.sd = b.var / sqrt(nsims)

print(pnorm(20, mean=b.mean, sd=n.sd) - pnorm(15, mean=b.mean, sd=n.sd))

# Problem 3
cat("\nProblem 3\n")
cat("P(X + 0.5 < Y) for (X_1, Y_1), ..., (X_50, Y_50):")

means = c()
for (i in 1:1000) {
  p = c()
  for (j in 1:10){
    trials = rmvnorm(50, mean=c(9, 10), sigma=matrix(c(3, 2, 2, 5), nrow=2))
    p = c(p, c(length(which(trials[, 1] + 0.5 < trials[, 2]))))
  }
  means = c(means, mean(p))
}

cat("\nSample mean: \n")
print(mean(means))
cat("Sample 95% Confidence Intervals: \n")
print(mean(means) + c(-1,1) * 1.96 * sqrt(var(means) / 1000))

# Problem 4
cat("\nProblem 4")
X1 = matrix(rchisq(10000*1000, df=10), nrow=1000)
X2 = matrix(rgamma(10000*1000, shape=1, scale=2), nrow=1000)
X3 = matrix(rt(10000*1000, df=3), nrow=1000)

Y = sqrt(X1) * X2  + 4 * (X3 ^ 2)

mean.y = apply(Y, 1, mean)
cat("\nSample mean: \n")
print(mean(mean.y))
cat("Sample 95% Confidence Intervals: \n")
print(mean(mean.y) + c(-1,1) * 1.96 * sqrt(var(mean.y) / 1000))

# Problem 5
an = function(n) {
  return(sqrt(2 * log(n)) - 0.5 * (log(log(n)) + log(4 * pi)) * (2 * log(n))^(-1 / 2))
}

bn = function(n) {
  return((2 * log(n))^(-1 / 2))
}

maximas = apply(matrix(rnorm(1000 * 1000, mean=0, sd=1), nrow=1000), 2, max)
maximas.normalized = (maximas - an(maximas)) / bn(maximas)

hist(maximas.normalized)

f.x_extreme = function(x) {
  return(exp(-x) * exp(-exp(-x)))
}

plot(density(maximas.normalized), main="Density of Normalized Maximas", xlab="N", ylab="p(N)")
