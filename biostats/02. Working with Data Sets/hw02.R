rm(list=ls())
library(multtest); data(golub)

gol.fac = factor(golub.cl, levels=0:1, labels=c("ALL", "AML"))

# Problem 1a
ALL.means = apply(golub[, gol.fac=="ALL"], 1, mean)

# Problem 1b
AML.means = apply(golub[, gol.fac=="AML"], 1, mean)

# Problem 1c and 1d
ALL.top.three.ix = sort(ALL.means, index.return=TRUE, decreasing=TRUE)$ix[1:3]
AML.top.three.ix = sort(AML.means, index.return=TRUE, decreasing=TRUE)$ix[1:3]

cat("Top Three Genes with Largest Mean Expression in ALL Patients: \n")
print(golub.gnames[ALL.top.three.ix, 2])
cat("\n")
cat("Top Three Genes with Largest Mean Expression in ALL Patients: \n")
print(golub.gnames[AML.top.three.ix, 2])
cat("\n")

# Problem 2a
ALL.first.five = golub[1:5, gol.fac=="ALL"]
write.table(ALL.first.five, file="ALL5.csv", sep=',')

# Problem 2b
AML.first.five = golub[1:5, gol.fac=="AML"]
write.table(AML.first.five, file="AML5.txt")

# Problem 2c
cat("Standard Deviation of the Expression Values for the First Patient: \n")
print(sd(golub[100:200, 1]))
cat("\n")

# Problem 2d
cat("Number of Genes with a Standard Deviation Greater than 1 for ALL Patients\n")
print(length(which(apply(golub, 1, sd) > 1)))
cat("\n")

# Problem 2e
x = golub[101,]
y = golub[102,]
plot(x, y, main='Comparing Two Gene Expressions', xlab=golub.gnames[101, 2], ylab=golub.gnames[102, 2])

# Problem 3a
library("ALL"); data("ALL")
#print(show(ALL))
B1.gene.exprs = exprs(ALL[,ALL$BT=="B1"])
hist(B1.gene.exprs)

# Problem 3b
B1.gene.exprs.means = apply(B1.gene.exprs, 1, mean)

# Problem 3c
B1.gene.exprs.top.three.ix = sort(B1.gene.exprs.means, index.return=TRUE, decreasing=TRUE)$ix[1:3]
cat("Top Three Genes IDs with Largest Mean Expression in B1 Stage Patients: \n")
print(row.names(B1.gene.exprs[B1.gene.exprs.top.three.ix,]))
cat("\n")

# Problem 4a
cat("Type of the Trees Data Object:\n")
print(class(trees))
cat("\n")
par(mfrow=c(1,1), mar=rep(4, 4))

# Problem 4b
plot(trees$Girth,
     trees$Height,
     main="Height and Volume of Tree\nRelated to Girth",
     xlab="Girth",
     ylab="Height",
     pch=3,
     col="blue")

mtext("Volume", side=4, line=2)

axis(4)

par(new=TRUE)

plot(trees$Girth,
     trees$Volume,
     axes=F,
     xlab='',
     ylab='',
     pch=1,
     col="red")

legend("topleft",
       col=c("blue", "red"), 
       pch=c(3, 1), 
       legend=c("Height", "Volume"))