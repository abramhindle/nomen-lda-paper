module ATime where
import Time
import System.Time

-- Todo remove time, set it day year month

--data atime = AMonth { year :: Int, 
--                      month :: Time.Month } |
--             AYear { year :: Int } |
--             ADay { time :: CalendarTime }
--                  deriving (Eq, Ord, Read, Show)
data ATime = 
    AMonth { year :: Int
           , month:: Time.Month 
           } |
    AYear { year :: Int } |
    ADay  { year :: Int, 
            month :: Time.Month, 
            day :: Int }
          deriving (Ord, Read, Show)

fromPOSIXTime time = let nt = (toUTCTime (System.Time.TOD time 0))
                         day = (Time.ctDay nt)
                         month = (Time.ctMonth nt)
                         year = (Time.ctYear nt)
                     in ADay { year = year , month = month , day = day }
fromPOSIXTimeToDay = fromPOSIXTime 
fromPOSIXTimeToMonth = toAMonth . fromPOSIXTime
fromPOSIXTimeToYear = toAYear . fromPOSIXTime

toAMonth x@(AMonth { year = year , month = month }) = x
toAMonth (AYear { year = year }) = AMonth { year = year , month = Time.January }
toAMonth (ADay { year = year, month = month, day = day }) = AMonth { year = year, month = month }

ymdToCalendarTime year month day = ct
    where ct = CalendarTime {     ctYear  = year
                            ,     ctMonth = month
                            ,     ctDay = day 
                            ,     ctHour = 0
                            ,     ctMin = 0
                            ,     ctSec = 0
                            ,     ctPicosec = 0
                            ,     ctWDay = Sunday -- lol
                            ,     ctYDay = 0 -- lol 
                            ,     ctTZName = "" -- lol
                            ,     ctTZ = 0 -- lol
                            ,     ctIsDST = False -- lol
                            }

toADay (AMonth { year = year , month = month }) = ADay { year = year, month = month, day = 1 }
toADay (AYear { year = year }) = ADay { year = year, month = January, day = 1 }
toADay day@(ADay { year = year, month = month, day = day'}) = day

toAYear year@(AYear _) = year
toAYear (AMonth { year = year, month = month }) = AYear { year = year }
toAYear (ADay { year = year, month = month, day = day }) = AYear { year = year }

atimeEq (AMonth { year = y, month = m })  (AMonth { year = y2, month = m2 }) =  
    y == y2 && m == m2
atimeEq (AYear { year = y }) (AYear { year = y2 }) = y == y2
atimeEq (ADay { year = year, month = month, day = day }) 
        (ADay { year = year1, month = month1, day = day1 }) = 
            day == day1 && month == month1 && year == year1 

instance Eq ATime where
    (==) = atimeEq

atimeSucc (AMonth { year = year , month = December }) = AMonth { year = (succ year), month = January }
atimeSucc (AMonth { year = year , month = month }) = AMonth { year = year,  month = (succ month)}
atimeSucc AYear { year = year } = AYear { year = (succ year) }
atimeSucc ADay { year = year, month = month, day = day } = ADay { year = newyear, month = newmonth, day = newday }
    where td = Time.TimeDiff { tdYear = 0 , tdMonth = 0, tdDay = 1
                             , tdHour = 0, tdMin = 0
                             , tdSec = 0, tdPicosec = 0 }
          ct = Time.toClockTime (ymdToCalendarTime year month day)
          newct = Time.addToClockTime td ct
          newcal = Time.toUTCTime newct
          newday = Time.ctDay newcal
          newmonth = Time.ctMonth newcal
          newyear = Time.ctYear newcal

atimePred (AMonth { year = year , month = January }) = AMonth { year = (pred year), month = Time.December }
atimePred (AMonth { year = year , month = month }) = AMonth { year = year,  month = (pred month)}
atimePred AYear { year = year } = AYear { year = (pred year) }

atimePred ADay { year = year, month = month, day = day } = ADay { year = newyear, month = newmonth, day = newday }
    where td = Time.TimeDiff { tdYear = 0 , tdMonth = 0, tdDay = (-1)
                             , tdHour = 0, tdMin = 0
                             , tdSec = 0, tdPicosec = 0 }
          ct = Time.toClockTime (ymdToCalendarTime year month day)
          newct = Time.addToClockTime td ct
          newcal = Time.toUTCTime newct
          newday = Time.ctDay newcal
          newmonth = Time.ctMonth newcal
          newyear = Time.ctYear newcal



atimeFromEnum (AMonth { year = year , month = month }) = year * 12 + (fromEnum month)
atimeFromEnum (AYear { year = year }) = year * 366
atimeFromEnum (ADay { year = year , month = month, day = day }) = year * (12*31) + 31 * (fromEnum month) + day

toStr (AYear { year = year }) = show year
toStr (AMonth { year = year, month = month}) = (show year) ++ " " ++ (show month)
toStr (ADay { year = year, month = month, day = day }) = (show year) ++ " " ++ (show month) ++ " " ++ (show day)

atimeToEnum  x = error "Unimplemented" 

atimeFrom x = x : atimeFrom (succ x)

atimeFromTo x y = x : (if (x == y) 
                       then []
                       else atimeFromTo (succ x) y)

-- I don't really trust this
instance Enum ATime where
    succ = atimeSucc
    pred = atimePred
    enumFrom = atimeFrom
    enumFromTo = atimeFromTo
    toEnum = atimeToEnum
    fromEnum = atimeFromEnum

atimeTest () = (y,m,d) where
    y = enumFromTo start end where
        start = (AYear { year = 1999})
        end = (AYear { year = 2009})
    m = enumFromTo start end where
        start = (AMonth { year = 1999 , month = Time.December }) 
        end = (AMonth { year = 2000, month = Time.July })
    d  = enumFromTo start end where
        start = (fromPOSIXTime 1234567890)
        end = (fromPOSIXTime 1234767890)

-- instance Enum ATime where
    
--     succ, pred     :: a -> a
--     toEnum         :: Int -> a
--     fromEnum       :: a -> Int
--     enumFrom       :: a -> [a]            -- [n..]
--     enumFromThen   :: a -> a -> [a]       -- [n,n'..]
--     enumFromTo     :: a -> a -> [a]       -- [n..m]
--     enumFromThenTo :: a -> a -> a -> [a]  -- [n,n'..m]

