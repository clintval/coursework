Module 1
---
90%
I don't see an output for question 2. You should see a number. For example if you do the first 3 numbers you should see the output as 14 (which is 1+4+9). Your output shows True?

Module 2
---
98%
4(a) should be typeof(trees) which will give "list" (-2)
Very good and clear presentation. Easy to grade. Thanks.

Module 3
---
78%
1 should be (b), because x>1 and we cannot start from 0 (-5)
2(b) is slightly higher than what I would expect.
6) Var(Y) will be 16*10=160 and it won't be chi-sq (-4)
7(c) should be dbinom (-3)

8) I see the code. I don't see any answers or output. (-10)

Module 4
---
84%
1 b) NO. n=5 is too small for CLT.(-6)

3) (-10) you should do something like
require(mvtnorm)
nsim=10000
XmeanLess.sim<- rep(NA,nsim)
for (i in 1:nsim) {
  data.sim<-rmvnorm(50, mean=c(9,10), sigma=matrix(c(3,2,2,5), nrow=2))
   mean.sim<-apply(data.sim,2,mean)
   Xmean<-mean.sim[1]....

5) It would have been better if all three plots were on top of each other.

Module 5
---
100%
In prob 3 you just had to find the mean etc in (a) and (b) separately. No need to do
zyxin.mean.CI.P = mean(zyxin) + qt(probs, df=n - 1) * sd(zyxin) / sqrt(n) etc.

Module 6
---
96%
2(b) should be (-4)
pbinom(89,size=2000, prob=0.05)
There are mistakes in #5. You shouldn't be getting 1 for these values. Here is what I would have done
Wald.ci<- function(x, n, conf.level = 0.95) {
p<-x/n
z<-qnorm(1-(1-conf.level)/2)
p+c(-1,1)*z*sqrt(p*(1-p)/n)
}
n<-40
p<-0.2
x.sim<-rbinom(10000,size=n,prob=p)
Wald.sim<-matrix(Wald.ci(x.sim,n=n, conf.level=0.95),nrow=2)
mean((Wald.sim[1,]p))

Module 7
---
100%

Module 8
---
100%

Module 9
---
97%
1d) (-3)
This is a one-sided test. Ho:rho=0.64 versus HA:rho>0.64.
We reject Ho if sample correlation  rho > cutoff. The question is how to select the cutoff?
Recall the equivalence between the (1-α) confidence interval and the α level hypothesis test. We can build a (1-α) lower CI  then P(.64 )=1-α under . So rejecting Ho  when 0.64  
α = 0.05, we want a (1-α)=95% CI. In part (c), we have a two-sided 90% confident interval . Therefore  is a 95% lower CI, and we do not need to recalculate.
I have (0.58, 0.89) from part (c). So (0.58,∞) is the 90% CI we want. (This is bootstrapped, so your number may differ, but only slightly like 0.57 or 0.59.) The 0.64 is inside this interval. So there is not enough evidence to reject the null hypothesis.

Module 10
---
100%

Module 11
---
100%

Module 12
---
100%

Module 13
---
90%
1) Some mistakes in (d) and (e)
K<-
flds <- createFolds(index, k=K)
fnr.raw<-rep(NA, K)
for (i in 1:K) {
  testID<-flds[[i]] 
 fit.tr <- rpart(IsB ~ ., data = ALL2[-testID,], method = "class")
 pred <- predict(fit.tr, ALL2[testID,], type = "class")
 fnr.raw[i]<- sum( pred==FALSE & IsB[testID])/sum(IsB[testID])
}
fnr.cv<-mean(fnr.raw)
fnr.cv
[1] 0.1236111




(e)
ALL2.lgr <- glm(IsB~., family=binomial, data=ALL2)
summary(ALL2.lgr)
confint(ALL2.lgr, level=0.8)

We see that our 80% CI for the coefficient of gene “39317 at” is approximately
(-1.427, -.605)
97 PCs? That is way too high. 7 or 8 is reasonable. Your plot is going the opposite way.
(g)
pca.ALL<-prcomp(t(expr.ALL), scale=T)
PropVar<-summary(pca.ALL)$importance[2,]
plot(1:length(PropVar),PropVar, xlab='number of principal components', ylab='proportion of variance explained')
summary(pca.ALL)$importance[,1:20]

Midterm
---
90%
1b) (-2)
Sd(2X-3Y)= Sqrt(var(2X-3Y)) = sqrt(4var(X)+9var(Y)) =sqrt(4*0.0856+9*0.2146) = 1.508
2) (-8)
nsim<-1000000
X<-rnorm(nsim,mean=0,sd=1)
Y<-rchisq(nsim,df=4)
Z<-X^2/(2*X^2+Y)
mean(Z)+c(-1,1)*1.96*sqrt(var(Z)/nsim)

Answer to 7(d) is not correct. You have done the right test.

Final
---
87%
1c) will be 0.45 to 0.7 (-3)
3c) will be 0.134 (-4)
4d) There are mistakes in the values and heatmap (-6)



