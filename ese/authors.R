v <- read.table("authors.csv")
x <- c()
x$counts <- v$V1
x$author <- v$V2
tm <- sum(x$counts[x$author %in% c("tgl","momjian")])
tmp <- sum(x$counts[x$author %in% c("tgl","momjian","petere")])

ts <- sum(x$counts)
tm/ts
