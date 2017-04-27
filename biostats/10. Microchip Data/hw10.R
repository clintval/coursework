# Clint Valentine
# 11/13/2016

rm(list=ls())
set.seed(1)

library(affy)
library(limma)
library(annotate)
library(ArrayExpress)
library(ALL); data(ALL)
annotation_pkg.ALL = annotation(ALL)

path = 'Cyeast'
expression_ID = 'E-MEXP-1551'

if (!dir.exists(path)) {
  dir.create(path)
  getAE(expression_ID, path=path, type='full')
}

yeast.raw = ReadAffy(celfile.path=path)
annotation_pkg.yeast = annotation(yeast.raw)

source("https://bioconductor.org/biocLite.R")
biocLite(paste(annotation_pkg.ALL,   '.db', sep=''), sep='')
biocLite(paste(annotation_pkg.yeast, '.db', sep=''), sep='')
library(paste(annotation_pkg.ALL,    '.db', sep=''), character.only=T)
library(paste(annotation_pkg.yeast,  '.db', sep=''), character.only=T)

biocLite("GO.db");      library("GO.db")
biocLite("limma");      library("limma")
biocLite("genefilter"); library("genefilter")

cat("Problem 1a\n==========\n\n")

eset = expresso(yeast.raw,
                bgcorrect.method="mas",
                normalize.method="quantiles",
                pmcorrect.method="pmonly",
                summary.method="medianpolish")

cat("\nProblem 1b\n==========\n")

cat("\nThe mean expression values for the first five genes across all samples is:\n")
cat(" ", round(apply(exprs(eset)[1:5,], 1, mean), 4), sep="\n ")

cat("\nProblem 1c\n==========\n")

cat("The number of genes in the preprocessed samples is:\n")
cat(dim(exprs(eset))[1])

cat("\n\nThe number of samples in the preprocessed samples is:\n")
cat(dim(exprs(eset))[2])


cat("\n\nProblem 2a\n==========\n")

cat("\nThe annotation package for the above yeast data set is:\n")
cat(annotation_pkg.yeast)

cat("\n\nProblem 2b\n==========\n")

gene = "1769308_at"
go.terms = get(gene, env=eval(parse(text=paste(annotation_pkg.yeast, 'GO', sep=''))))
go.terms.MF = getOntology(go.terms, "MF")
cat("\nThere are", length(go.terms.MF), "GO numbers related to MF in the", gene, "gene\n\n ")

cat("\nProblem 2c\n==========\n")

go.terms.MF.parents = unlist(lapply(go.terms.MF, function(x) get(x, GOMFPARENTS)))
cat("\nThere are", length(go.terms.MF.parents[!is.na(go.terms.MF.parents)]),
    "parents from the GO terms in 2b (excluding NA)\n")

cat("\nProblem 2d\n==========\n")

go.terms.MF.children = unlist(lapply(go.terms.MF, function(x) get(x, GOMFCHILDREN)))
cat("\nThere are", length(go.terms.MF.children[!is.na(go.terms.MF.children)]),
    "children from the GO terms in 2b (excluding NA)\n")


cat("\nProblem 3a\n==========\n")

ALL.fac = factor(ALL$BT %in% c("B2", "B3"))
f1 = function(x) (wilcox.test(x ~ ALL.fac, exact=F)$p.value < 0.001)
f2 = function(x) (t.test(x ~ ALL.fac)$p.value < 0.001)
sel1 = genefilter(exprs(ALL), filterfun(f1))
sel2 = genefilter(exprs(ALL), filterfun(f2))
selected = sel1 & sel2
ALLs = ALL[selected,]

cat("\nProblem 3b\n==========\n")

x = apply(cbind(sel1, sel2), 2, as.integer)
vc = vennCounts(x, include="both")
vennDiagram(vc, names=c('Wilcoxon', 'T-test'))

cat("\nProblem 3c\n==========\n")

cat("There are", sum(sel1), "genes that pass the Wilcoxon test filter.\n")
cat("There are", sum(sel1 & sel2), "genes that pass the Wilcoxon and t-test filter.\n")

cat("\nProblem 3d\n==========\n")

cat("\nThe annotation package for the ALL data set is:\n")
cat(annotation_pkg.ALL)

GOTerm2Tag = function(term) {
  GTL = eapply(GOTERM,
               function(x) {grep(term, x@Term, value=T)})
  Gl = sapply(GTL, length)
  names(GTL[Gl > 0])
}

term = "oncogene"
GO.ids = GOTerm2Tag(term)
cat("\nThere are", length(GO.ids), "GO numbers for the term", term, ".\n")

cat("\nProblem 3e\n==========\n")

tran = unlist(lapply(GO.ids, function(x) get(x, eval(parse(text=paste(annotation_pkg.ALL,
                                                           'GO2ALLPROBES',
                                                           sep=''))))))
in.ALLs = tran %in% row.names(exprs(ALLs))
cat("There are", sum(in.ALLs), "oncogenes passing the filters in 3a.\n")


cat("\nProblem 4a\n==========\n")

selection = c("B1","B2","B3")
ALL.selection = ALL[, which(ALL$BT %in% selection)] 

cat("\nProblem 4b\n==========\n")

design.ma = model.matrix(~ 0 + factor(ALL.selection$BT))
colnames(design.ma) = selection
fit = lmFit(ALL.selection, design.ma) 
fit = eBayes(fit)

cat("\nHo: The B3 group of patients mean expression is zero. Top five results:\n")
print(topTable(fit, coef=3, number=5, adjust.method="fdr"), digits=4)

cat("\nProblem 4c\n==========\n")

cont.ma = makeContrasts(B1-B2,B2-B3, levels=factor(ALL.selection$BT))
fit.cont.ma = contrasts.fit(fit, cont.ma)
fit.cont.ma = eBayes(fit.cont.ma)

cat("Differentially expressed genes in", selection, 
    "using a FDR rate of 0.01 and a two contrast linear model:\n")
cat(dim(topTable(fit.cont.ma, number=Inf, p.value=0.01, adjust.method="fdr"))[1])

cat("\n\nHo: Gene expression between", selection, "is the same. Top five results:\n")
print(topTable(fit.cont.ma, coef=2, number=5, adjust.method="fdr"), digits=4)