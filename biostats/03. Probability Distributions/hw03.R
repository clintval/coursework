# Clint Valentine
# 09/21/2016
#78%
# 1 should be (b), because x>1 and we cannot start from 0 (-5)
# 2(b) is slightly higher than what I would expect.
# 6) Var(Y) will be 16*10=160 and it won't be chi-sq (-4)
# 7(c) should be dbinom (-3)
# 8) I see the code. I don't see any answers or output. (-10)

rm(list=ls())

# Problem 1
cat("Problem 1: \nAnswer: a\n\n")

# Problem 2

cat("Problem 2:\n")
cat("For f(x)=2^x/x!e^-2:\n")

f.x = function (x) ((2^x) / factorial(x) * exp(-2))

cat("P(X=1) is:\n  ")
print(round(f.x(1), 4))
cat("P(-2<X<4) is:\n  ")
X_range <-  0:4
print(round(sum(f.x(X_range)), 4))

# Problem 3
cat("\nProblem 3:\n")
cat("n = 3 children\n")
cat("p = 0.25 probability of being albino\n")

# Problem 4
cat("\nProblem 4:\n")
cat("For Y following a binomial (n=3, p=0.25) distribution:\n")
n = 3
p = 0.25
cat("P(Y=<2)\n  ")
print(round(pbinom(2, n, p), 4))
cat("E(Y)\n  ")
print(round(n * p, 4), 4)
cat("Var(Y)\n  ")
print(round(n * p * (1 - p)), 4)

# Problem 5
cat("\nProblem 5:")
cat("\nX following a Chi-square distribution with m = 3\n")
m = 3
cat("P(1<X<4)\n  ")
print(round(pchisq(4, m) - pchisq(1, m), 4))
cat("E(X)\n  ")
print(m)
cat("Var(X)\n  ")
print(2 * m)

cat("100,000 random draws and P(1<X<4)\n  ")
set.seed(1)
iterations = 100000
draws = rchisq(iterations, m)
print(round(sum(1 < draws & draws < 4) / iterations, 4))

# Problem 6
cat("\nProblem 6:")
cat("\nX is Chi-square distribution with E(X) = 5 and Var(X) = 10 and Y = 4X - 10\n")
x.m = 5
y.m = 4 * x.m - 10
cat("E(Y)\n  ")
print(y.m)
cat("Var(Y)\n  ")
print(y.m * 2)
cat("Does E(Y) == 10?\n  ")
print(y.m == 10)

# Problem 7
cat("\nProblem 7:")
cat("\nP(1<X<1.6)\n  ")
mean = 1.6
sd = 0.4
print(round(pnorm(1.6, mean, sd) - pnorm(1, mean, sd), 4))

cat("500000 random draws and P(1<X<1.6)\n  ")
set.seed(1)
iterations = 500000
draws = rnorm(iterations, mean, sd)
p = sum(1 < draws & draws < 1.6) / iterations
print(round(p, 4))

cat("\nProbability that 2 out of 5 patients have gene expression value (1.0, 1.6)\n")
cat("binomial (n = 5, p = 0.4321)\n  ")
q = 2
n = 5
print(round(pbinom(q, n, p), 4))

# Problem 8
cat("\nProblem 8:\n")
cat("Function based Mean and Variance of X~F(m = 2, n = 5) and Y~F(m = 10, n = 5)\n")

X.m = 2
X.n = 5
Y.m = 10
Y.n = 5

F.mean = function(n) n / (n - 2)

F.var = function(m, n) {
  (2 * n^2 * (m + n - 2)) /
  (m * (n - 2)^2 * (n - 4))
}

set.seed(1)
cat("Function calculated Mean of X\n  ")
print(round(mean(rf(1000000, X.m, X.n)), 4))
cat("Function calculated Variance of X\n  ")
print(round(var(rf(1000000, X.m, X.n)), 4))
cat("Function calculated Mean of Y\n  ")
print(round(mean(rf(1000000, Y.m, Y.n)), 4))
cat("Function calculated Variance of Y\n  ")
print(round(var(rf(1000000, Y.m, Y.n)), 4))
hist(rf(1000000, X.m, X.n))

cat("\nFormulaic Mean of X\n  ")
print(round(F.mean(X.n), 4))
cat("Formulaic Variance of X\n  ")
print(round(F.var(X.m, X.n), 4))
cat("Formulaic Mean of Y\n  ")
print(round(F.mean(Y.n), 4))
cat("Formulaic Variance of Y\n  ")
print(round(F.var(Y.m, Y.n), 4))

cat("\nMeans are highly accurate yet variances are not!")