v <- read.csv("Author_NFRs.csv")
vv <- v[1:18,]
for (i in 2:17) {
  vv[,i] <- as.numeric(vv[,i])
}
tv <- t(vv[,2:8])
authors <- matrix(tv,nrow=7,dimnames=list(labels(tv)[[1]],vv[,1]))
#hc <- hclust(as.dist(cor(authors)),method="ward")
#hc <- hclust(as.dist(cor(authors)),method="centroid")
#
hc <- hclust(as.dist(cor(authors)),method="ward")
pdf("postgresql-author-cluster.pdf")
plot(hc,sub="Organized into 2 and 6 clusters",xlab="PostgreSQL Authors")
rect.hclust(hc,k=2,border="blue")
#rect.hclust(hc,k=3,border="red")
#rect.hclust(hc,k=4,border="green")
rect.hclust(hc,k=6,border="purple")
dev.off()

nauthors <- authors
normalize <- function(x) { x / sum(x) }
for (author in labels(nauthors)[[2]]) { nauthors[,author] <-
                                          normalize(authors[,author])
                                      }
nauthor <- length(labels(authors)[[2]])
authorNames = labels(authors)[[2]]
chisqm <- matrix(c(1:(nauthor*nauthor))*0,ncol=nauthor,dimnames=list(authorNames,authorNames))
ksm <- matrix(c(1:(nauthor*nauthor))*0,ncol=nauthor,dimnames=list(authorNames,authorNames))

for (author1 in labels(authors)[[2]]) {
  for (author2 in labels(authors)[[2]]) {
    print(paste(author1,author2))
    pv   <- chisq.test(authors[,c(author1,author2)])$p.value
    kspv <- ks.test(as.numeric(makeAuthorData(authors[,author1])),
                    as.numeric(makeAuthorData(authors[,author2])))$p.value
    print(paste(pv,kspv))
    chisqm[author1,author2] <- pv
    ksm[author1,author2] <- pv
  }
}
chisqm[!is.finite(chisqm)] <- 0
ksm[!is.finite(ksm)] <- 0

makeAuthorData <- function(x) {
  l <- as.factor(labels(nauthors)[[1]])
  unlist(sapply(c(1:length(l)), function(i) { rep(l[i], x[i]) }))
}

sapply( authorNames, function(x) { median(chisqm[,x]) })
#
#v
#v[,1:18]
#v[c(2:8),1:18]
#v[1:18,]
#v[1:18,c(2:8)] 
#cor(v[1:18,c(2:8)])
#cor(as.numeric(v[1:18,c(2:8)]))
#v
#v[1:18,]
#vv <- v[1:18,]
#v[,2]
#v[,3]
#vv[,3]
#vv[,3]
#length(vv)
#sapply(2:17,function(x) { vv[,x] <- as.numeric(vv[,x]) })
#vv
#cor(vv[,c(2:8)]
#)
#vv[,8]
#summary(vv[,8])
#summary(vv[,2])
#summary(vv[,3])
#vv[,2] <- as.numeric(vv[,2])
#cor(vv[,c(2:8)]
#)
#vv[,2:8]
#t(vv[,2:8])
#t(vv[,1:8])
#t(vv[,2:8])
#cor(t(vv[,2:8]))
#history
#history(show.max=Inf)
#t(vv[,2:8])
#labels(t(vv[,2:8]))
#labels(t(vv[,2:8]))[[2]] <- v[,1]
#matrix(t(vv[,2:8]),nrow=7)
#tv <- t(vv[,2:8])
#labels(tv)
#labels(tv)[[1]]
#matrix(tv,nrow=7,labels=(vv[,1],labels(tv)[[1]]))
#matrix(tv,nrow=7,labels=list(vv[,1],labels(tv)[[1]]))
#help(matrix)
#matrix(tv,nrow=7,dimnames=list(vv[,1],labels(tv)[[1]]))
#matrix(tv,nrow=7,dimnames=list(labels(tv)[[1]],vv[,1]))
#authors <- matrix(tv,nrow=7,dimnames=list(labels(tv)[[1]],vv[,1]))
#cor(authors)
#image(authors)
#image(cor(authors))
#hclust(cor(authors))
#hclust(authors)
#hclust(cor(authors))
#help(hclust)
#hclust(cor(authors))
#hclust(as.dist(cor(authors)))
#hc <- hclust(as.dist(cor(authors)))
#plot(hc)
#pdf("author-cluster.pdf")
#plot(hc)
#dev.off()
#history(max.show=Inf)
#write(history(max.show=Inf),file="Rcommands")
#help(write)
#history(max.show=Inf,file="Rcommands")
#help(history)
#savehistory("Rcommands.txt")
