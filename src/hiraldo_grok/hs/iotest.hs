import Data.Char

run =  getLine 
       >>= \x -> 
           let c = x!!2 in
           putStrLn (if isLower c then "LOWER" else "UPPER")

run2 = do x <- getLine
          let c = x !! 2 in
              putStrLn (if isLower c then "LOWER" else "UPPER")

main = run2
       

