-- The Computer Language Benchmarks Game
-- http://shootout.alioth.debian.org/
-- Contributed by: Sergei Matusevich 2007
-- Parallelised by Tim Newsham using Haskell's parallel strategies

import Control.Parallel.Strategies
import List
import Text.Regex.PCRE          -- requires haskell-regex-pcre-builtin
import qualified Data.ByteString.Char8 as B

variants = [
  "agggtaaa|tttaccct",
  "[cgt]gggtaaa|tttaccc[acg]",
  "a[act]ggtaaa|tttacc[agt]t",
  "ag[act]gtaaa|tttac[agt]ct",
  "agg[act]taaa|ttta[agt]cct",
  "aggg[acg]aaa|ttt[cgt]ccct",
  "agggt[cgt]aa|tt[acg]accct",
  "agggta[cgt]a|t[acg]taccct",
  "agggtaa[cgt]|[acg]ttaccct" ]

main = do
  file <- B.getContents
  let [s1,s2,s3] = map (B.concat . tail) $ groupBy notHeader $ B.split '\n' file
      showVars r = r ++ ' ' : show ((s2 =~ r :: Int) + (s3 =~ r :: Int))
  mapM_ putStrLn $ parMap rnf showVars variants
  putChar '\n'
  print (B.length file)
  print (B.length s1 + B.length s2 + B.length s3)
  print (B.length s1 + B.length s3 + length (B.unpack s2 >>= substCh))
  where notHeader _ s = B.null s || B.head s /= '>'
        substCh 'B' = "(c|g|t)"
        substCh 'D' = "(a|g|t)"
        substCh 'H' = "(a|c|t)"
        substCh 'K' = "(g|t)"
        substCh 'M' = "(a|c)"
        substCh 'N' = "(a|c|g|t)"
        substCh 'R' = "(a|g)"
        substCh 'S' = "(c|g)"
        substCh 'V' = "(a|c|g)"
        substCh 'W' = "(a|t)"
        substCh 'Y' = "(c|t)"
        substCh etc = [etc]

