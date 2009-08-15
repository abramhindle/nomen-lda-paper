import System.IO

slurpFile file = 
    do fd <- openFile file ReadMode
       let reader = do eof <- hIsEOF fd
                       if eof
                         then return []
                         else (do x <- hGetLine fd
                                  xs <- reader
                                  return (x:xs))
       do x <- reader 
          hClose fd;
          return x

testSlurpFile = do lines <- slurpFile "bigfile" 
                   putStrLn (lines!!100)

main = testSlurpFile
