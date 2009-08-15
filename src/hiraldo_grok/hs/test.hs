import System.IO
import Monad
import List

data Huh = Lol | Hy

test1 Lol = Hy
test1 Hy =  Lol
test2 Lol = "Lol"
test2 Hy = "Hy"

p1 = sequence_ (map 
                     (\x -> putStrLn (test2 (test1 x)))
                     [ Hy, Lol, Hy, Lol ])
  
p2 = sequence_ (map (\x -> putStrLn (show x))  (intersect ["a","b","c"] ["b","c","c","d"]))

main = p2
