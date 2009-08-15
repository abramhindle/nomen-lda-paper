module TestTime where
import System.Time
import Time
import System.Locale

main = 
  let ti = toUTCTime (TOD 1234567890 0)
      cs = Time.calendarTimeToString ti
      cs2 = Time.formatCalendarTime System.Locale.defaultTimeLocale "%Y %M %D" ti
  in do
    print cs;
    print cs2;
    print (show (Time.ctMonth ti));
    return ()
