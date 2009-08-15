import System.Random
lol = [1..]
z = [(i,j,k) | x <- lol, i <- (3*(x-1) + 1), j <- (i + 1), k <- (j + 1)]

rs = randoms (mkStdGen 4)
main = do print $ take 10 (rs :: [Double])
