module OurTime where
import System.Locale
import System.Time
import Time
import Char
import Data.List

strToInt:: String -> Integer
strToInt str =
    let len = length str in
    read (if (last str == '.') 
          then take (len - 1) str
          else str)
strToTime str =
    toUTCTime (TOD x 0) where 
                   x = strToInt str
        
timeToMonthStr time =
    formatCalendarTime System.Locale.defaultTimeLocale "%Y %b" time

isFloatStr [] = True
isFloatStr (x:xs) = if ((Char.isDigit x) || x == '.') 
                            then isFloatStr xs
                            else False
isIntStr [] = True
isIntStr (x:xs) = if (Char.isDigit x) 
                            then isFloatStr xs
                            else False

epochToTimeString = timeToMonthStr . strToTime 

timeTest = do
  contents <- readFile "timetest.txt"
  let lines = Data.List.lines contents in
      return (map epochToTimeString lines)


    