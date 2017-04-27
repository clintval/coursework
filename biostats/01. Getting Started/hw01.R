# Clint Valentine
# MATH7340
# 9/13/2016

rm(list = ls())

print("Question 1a:")
vec = c(5, TRUE)
print(class(vec))

print("Question 1b:")
x = 1:4
y = 1:2
print(class(x + y))
print(x + y)

print("Question 1c:")
fsin = function(x) sin(pi * x)
if (fsin(1) <= .Machine$double.eps) {
  print(0)
} else {
  print(fsin(1))
}

print("Question 1d:")
print(c(1,2) %*% t(c(1,2)))

print("Question 1e:")
f = function(x) {
  g = function(y) {
    y + z
  }
  z = 4
  x + g(x)
}
z = 15
print(f(3))

print("Question 2:")
print(sum(seq(1, 1000)^2) == sum(seq(1, 1000)^2))

print("Question 3a:")
X = seq(1, 20) * 2
print(X)

print("Question 3b:")
Y = rep(0, 20)
print(Y)

print("Question 3c:")
integrand = function(t) sqrt(t)
for (k in 1:20) {
  Y[k] = k
  if (k < 12) {
    Y[k] = cos(3 * k)
  } else if (k >= 12) {
    Y[k] = integrate(integrand, lower=0, upper=k)[['value']]
  }
}
print(Y)
