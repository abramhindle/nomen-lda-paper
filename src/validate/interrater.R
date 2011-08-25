#neil and abram annotations!
pgsqln <- read.csv("output/pgsqln.arff.csv",header=TRUE)
pgsqla <- read.csv("output/pgsqla.arff.csv",header=TRUE)
nn <- length(pgsqln)
na <- length(pgsqla)
pn <- pgsqln[,(nn-6):nn]
pa <- pgsqla[,(na-6):na]

library(irr)

# http://en.wikipedia.org/wiki/Fleiss%27_kappa
# http://en.wikipedia.org/wiki/Cohen%27s_kappa
# http://en.wikipedia.org/wiki/Inter-rater_reliability#Kappa_statistics
kappa2(matrix(c(c(1:100)*0,c(1:100)*1),ncol=2))
kappa2(matrix(c(c(1:100)*1,c(1:100)*1),ncol=2))
kappa2(matrix(c(c(1:100)*0,c(1:100)*0),ncol=2))
kappa2(matrix(c( 1*(runif(600)>.9), 1*(runif(600)>.9)), ncol=2))
kappa2(matrix(c( 1*(runif(600)>.99), 1*(runif(600)>.99)), ncol=2))
kappa2(matrix(c( (runif(600)>.5), (runif(600)>.5)), ncol=2))

weight <- "unweighted"
#for (weight in c("unweighted","equal","squared")) {
  for (i in c(1:7)) {
    print(paste(names(pa)[[i]],weight))
    mat <- matrix(c( pa[,i], pn[,i] ), ncol=2)
    print(kappa2(mat, weight=weight))
    print(kappam.fleiss(mat))
    #print(cor(pa[,i],pn[,i]))
    print(cor(pa[,i],pn[,i],method="spearman"))
    #print(paste("Difference: ",abs(sum(pa[,i] - pn[,i]))))
    #print(paste("Matching: ",length(pa[pa[,i]==pn[,i],i])))
    #print(paste("Not Matching: ",length(pa[pa[,i]!=pn[,i],i])))
    print(paste("Pos Disagree: ",length(pa[pa[,i]+pn[,i]==1,i])))
    print(paste("Pos Agree: ",length(pa[pa[,i]+pn[,i]==2,i])))

  }
#}

sapply(names(pa),function(i) {
  mat <- matrix(c( as.factor(pa[,i]), as.factor(pn[,i]) ), ncol=2)
  kappam.fleiss(mat)$value
})
sapply(names(pa),function(i) {
  mat <- matrix(c( as.factor(pa[,i]), as.factor(pn[,i]) ), ncol=2)
  kappa2(mat)$value
})
sapply(names(pa),function(i) {
  cor(pa[,i],pn[,i],method="spearman")
})
paall <- sapply(c(1:7),function(x){ pa[,x] })
pnall <- sapply(c(1:7),function(x){ pn[,x] })


mat <- matrix(c( paall, pnall ), ncol=2)
kappam.fleiss(mat)$value
kappa2(mat)$value

  for (i in c(1:7)) {
    print(paste(names(pa)[[i]]))
    print(paste("Pos Disagree: ",length(pa[pa[,i]+pn[,i]==1,i])))
    print(paste("Pos Agree: ",length(pa[pa[,i]+pn[,i]==2,i])))
    print(paste("Neg Agree: ",length(pa[pa[,i]+pn[,i]==0,i])))
  }
