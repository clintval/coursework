# Clint Valentine
# 12/04/2016

set.seed(1)
rm(list=ls())
options(digits=4)

library(ALL)
library(ROCR)
library(VGAM)
library(caret)
library(e1071)
library(rpart)
library(hgu95av2.db)

cat("Problem 1a\n==========\n\n")

data(ALL)
IsB = as.factor(substr(ALL$BT, 1, 1) %in% "B")

cat("Problem 1b\n==========\n\n")

probes = c('39317_at', '38018_g_at')
gene.names = mget(probes, env = hgu95av2SYMBOL)
probe.data = as.matrix(exprs(ALL[probes,]))
row.names(probe.data) = unlist(gene.names)

probe.c.tree = rpart(IsB ~ ., data=data.frame(t(probe.data)))
plot(probe.c.tree, branch=0, margin=0.1)
text(probe.c.tree, digits=3)
probe.predict = predict(probe.c.tree, type="class")
probe.confusion = table(probe.predict, IsB)

probe.prediction = prediction(predict(probe.c.tree)[, "TRUE"], IsB)
probe.performance = performance(probe.prediction, measure="tpr", x.measure="fpr")
plot(probe.performance, main="ROC for Probe Classification Tree")
print(probe.confusion)

cat("\nProblem 1c\n==========\n\n")

probe.mcr = sum(probe.confusion['TRUE', 'FALSE'],
                probe.confusion['FALSE', 'TRUE']) / sum(probe.confusion)
probe.fnr = probe.confusion['FALSE', 'TRUE'] / sum(probe.confusion[, 'FALSE'])
probe.tnr = probe.confusion['FALSE', 'FALSE'] / sum(probe.confusion[, 'FALSE'])
auc = performance(probe.prediction, measure="auc")

cat("The Misclassification Rate (MR) is:", probe.mcr)
cat("\nThe False Negative Rate (FNR) is:", probe.fnr)
cat("\nThe True Negative Rate (TNR) is:", probe.tnr)
cat("\nThe AUC is:", unlist(auc@y.values))

cat("\n\nProblem 1d\n==========\n\n")

k = 10
n =  ncol(probe.data)

index = 1:n
probe.fnr.raw = rep(NA, k)
folds = createFolds(index, k=k)

for (i in 1:k) {
  test.set = folds[[i]]
  data.test = probe.data[, test.set]
  data.training = probe.data[, -test.set]
  data.tree = rpart(IsB[-test.set] ~ ., data=data.frame(t(data.training)))
  
  data.predict = predict(data.tree, newdata=data.frame(t(data.test)), type="class")
  data.confusion = table(data.predict, IsB[test.set])
  probe.fnr.raw[i] = data.confusion['FALSE', 'TRUE'] / sum(data.confusion[, 'FALSE'])
}

cat("The average FNR of a 10-fold cross-validation is:",
    mean(probe.fnr.raw))

cat("\n\nProblem 1e\n==========\n\n")

data = data.frame(IsB, t(probe.data))
fit.logit = glm(formula = IsB ~ ., family=binomial(link="logit"), data=data)
print(confint(fit.logit, level=0.8)[gene.names$`39317_at`, ])

cat("\nProblem 1f\n==========\n\n")

n =  ncol(probe.data)

index = 1:n
results.logit = rep(NA, n)

for (i in 1:n) {
  IsB.test = IsB[i]
  IsB.train = IsB[-i]
  data.test = data.frame(t(probe.data[, i]))
  data.train = data.frame(IsB.train, t(probe.data[, -i]))
  
  fit.logit = glm(formula=IsB.train ~ .,
                  family=binomial(link="logit"),
                  data=data.train,
                  maxit=1000)
  
  data.predict = predict(fit.logit, newdata=data.test, type="response")
  results.logit[i] = (data.predict > 0.5) == IsB[i]
}

cat("The average MCR of a n-fold cross-validation is:",
     mean(!results.logit))

cat("\n\nProblem 1g\n==========\n\n")

pc = prcomp(t(as.matrix(exprs(ALL))), scale=TRUE)
plot(summary(pc)$importance[3,],
     xlab="Principal Component",
     ylab="Cumulative Proportion of Variance",
     main="Variance Explained by PC")

cat("It takes",
    unname(which(summary(pc)$importance[3,] > 0.95)[1]),
    "principal components to explain 95% of the variance.")

cat("\n\nProblem 1h\n==========\n\n")

data.pca.ALL = pc$x[,1:5]
ALL.svm = svm(data.pca.ALL, IsB, type="C-classification", kernel="linear")
ALL.predict = predict(ALL.svm, data.pca.ALL)

cat("The sensitivity of the SVM on the first 5 PC is:",
    sensitivity(ALL.predict, IsB))

cat("\n\nProblem 1i\n==========\n\n")

n = nrow(data.pca.ALL)

index = 1:n
results.svm = rep(NA, n)

for (i in 1:n) {
  fit.svm = svm(data.pca.ALL[-i,],
                IsB[-i],
                type="C-classification",
                kernel="linear")
  
  data.predict = predict(fit.svm, t(data.pca.ALL[i,]))
  results.svm[i] = (data.predict == IsB[i])
}

cat("The average MCR of a n-fold cross-validation is:",
    mean(!results.svm))

cat("\n\nProblem 1j\n==========\n")


cat("\nProblem 2\n==========\n\n")

data(iris)
species = iris$Species
pca.iris = prcomp(iris[, 1:4], scale=T)

K = 4

MCR.empirical = matrix(ncol=K, nrow=3)
MCR.fitted = matrix(ncol=K, nrow=3)

for (k in 1:K) {
  data.pca = pca.iris$x[,1:k]
  data.response = data.frame(species, data.pca)
  
  #####################
  # Classification Tree
  #####################
  fit.tree = rpart(species ~ ., data=data.response, method= "class")
  pred.tree = predict(fit.tree, data.response, type="class")
  
  mcr.tree.empirical = mean(pred.tree != species)
  mcr.tree.raw = rep(NA, length(species))
  
  # Classification Tree N-fold cross-validation
  for (i in 1:length(species)) {
    fit.tree = rpart(species ~ ., data=data.response[-i,], method="class")
    pred.tree = predict(fit.tree, data.response[i,], type="class")
    mcr.tree.raw[i] = mean(pred.tree != species[i])
  }
  
  #################################
  # Logistic Multinomial Regression
  #################################
  fit.logit = vglm(species ~ .,
                   family=multinomial,
                   data=data.response,
                   maxit=1000)
  
  if (k == 1) {
    data = data.frame(t(data.response[,-1]))
  } else {
    data = data.response[,-1]
  }
  
  pred.logit = predict(fit.logit, data, type="response")
  pred.logit.class = factor(apply(pred.logit, 1, which.max),
                            levels=c("1","2","3"),
                            labels=levels(species))
  
  mcr.logit.empirical = mean(pred.logit.class != species)
  mcr.logit.raw = rep(NA, length(species))
  
  # Logistic Multinomial Regression N-fold cross-validation
  for (i in 1:length(species)) {
    
    fit.logit = vglm(species ~ .,
                     family=multinomial,
                     data=data.response,
                     maxit=1000)
    
    if (k == 1) {
      data = data.frame(t(data.response[,-1]))
    } else {
      data = data.response[,-1]
    }
    
    pred.logit = predict(fit.logit, data, type="response")
    pred.logit.class = factor(apply(pred.logit, 1, which.max),
                              levels=c("1","2","3"), 
                              labels=levels(species))
    mcr.logit.raw[i] = mean(pred.logit.class != species[i])
  }
  
  ########################
  # Support Vector Machine
  ########################
  fit.svm = svm(data.pca,
                species,
                type="C-classification",
                kernel="linear")
  pred.svm = predict(fit.svm, data.pca)
  
  mcr.svm.empirical = mean(pred.svm != species)
  mcr.svm.raw = rep(NA, length(species))
  
  # Support Vector Machine N-fold cross-validation
  for (i in 1:length(species)) {
    if (k == 1) {
      data.train = data.pca[-i]
      data.test = data.pca[i]
    } else {
      data.train = data.pca[-i,]
      data.test = data.pca[i,]
    }
    
    fit.svm = svm(data.train,
                  species[-i],
                  type="C-classification",
                  kernel="linear")
    pred.svm = predict(fit.svm, t(data.test))
    mcr.svm.raw[i] = mean(pred.svm != species[i])
  }
  
  MCR.empirical[, k] = c(mcr.tree.empirical,
                         mcr.logit.empirical,
                         mcr.svm.empirical)
  MCR.fitted[, k] = c(mean(mcr.tree.raw),
                      mean(mcr.logit.raw),
                      mean(mcr.svm.raw))
}

MCR.empirical = data.frame(MCR.empirical,
                           row.names=c('Tree Empirical',
                                       'Logit Empirical',
                                       'SVM Empirical'))
MCR.fitted = data.frame(MCR.fitted,
                        row.names=c('Tree Fitted',
                                    'Logit Fitted',
                                    'SVM Fitted'))

colnames(MCR.empirical) = paste("K =", 1:K)
colnames(MCR.fitted) = paste("K =", 1:K)

cat("\nEmpirical MCR values:\n"); print(MCR.empirical)
cat("\nFitted MCR values:\n"); print(MCR.fitted)

ymax = 1.2 * round(10 * max(max(MCR.empirical, MCR.fitted))) / 10
colors = c("aquamarine3", "coral", "red")
algorithms = c("Tree", "Logistic Regression", "SVM")

barplot(as.matrix(MCR.empirical),
        beside=T,
        ylim=c(0, ymax),
        col=colors,
        ylab="Empirical MCR",
        xlab="Principal Components Used",
        main="Effect of Algorithm and K on Empirical MCR")

legend("topright",
       algorithms,
       pch=15, 
       col=colors, 
       bty="n")

barplot(as.matrix(MCR.fitted),
        beside=T,
        ylim=c(0, ymax),
        col=colors,
        ylab="N-Fold Cross-Validated MCR",
        xlab="Principal Components Used",
        main="Effect of Algorithm and K on N-Fold Cross-Validated MCR")

legend("topright",
       algorithms,
       pch=15, 
       col=colors, 
       bty="n")