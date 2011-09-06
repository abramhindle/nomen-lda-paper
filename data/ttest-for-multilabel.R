Abram.microAUC <- c(0.81 , 0.81 , 0.79 , 0.70 , 0.73  , 0.84 , 0.80)
Abram.macroAUC <- c(0.63 , 0.56 , 0.54 , 0.51 , 0.54  , 0.54 , 0.53)
Neil.macroAUC  <- c( 0.64 , 0.58 , 0.58 , 0.55 , 0.53 , 0.53 , 0.56 )
Neil.microAUC  <- c( 0.65 , 0.60 , 0.60 , 0.56 , 0.55 , 0.59 , 0.58 )


pvalues <- c(
  t.test(Abram.microAUC,Neil.microAUC)$p.value,
  t.test(Abram.macroAUC,Neil.macroAUC)$p.value,
  wilcox.test(Abram.microAUC,Neil.microAUC)$p.value,
  wilcox.test(Abram.macroAUC,Neil.macroAUC)$p.value
             )
tests <- as.factor(c("t.test","t.test","wilcox.test","wilcox.test"))
x <- c()
x$tests <- tests
x$pvalues <- pvalues
             
