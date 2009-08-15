module Ranked where
import System.IO
import System.Locale
import System.Time
import Time
import Data.List
import Data.Map (Map)
import qualified Data.Map as Map
import Time
import Char
import Monad
import Array
import ATime
import Lda_layout
import Lda_report

read_ocaml_float :: String -> Double
read_ocaml_float str =
    let len = length str in
    read (if (last str == '.') 
          then take (len - 1) str
          else str)


parse_ranked_docs filename = do
  contents <- readFile filename
  let lines = Data.List.lines contents in
    return (map (\line ->
                      case words line of
                        []    -> error "Bad line, no elements"
                        x:y:_ -> (((read x)::Integer) , (floor (read_ocaml_float y)))) lines)

-- Stupid Ord
-- (Int, Integer) is TOPIC, TIME
-- output is (bucketlabel, [(Topic Time)])
-- This is ignoring topics
-- bucketize_by :: (Ord a) => ((Integer, Integer) -> a) -> [(Integer, Integer)] -> [ ( a,  [(Integer, Integer)]) ]
bucketize_by f l = buckets
    where m = foldl (\m x -> 
                       let key = (f x) 
                       in Map.insert key (x : (Map.findWithDefault [] key m)) m)
                   Map.empty l
          buckets = Map.toAscList m


bucket_key_day (topic,ptime) = toUTCTime (System.Time.TOD ptime 0)

bucket_key (topic,ptime) = ATime.fromPOSIXTime ptime

bucketize_by_month l = bucketize_by month_key l
    where month_key = ATime.toAMonth . bucket_key 

bucketize_by_year l = bucketize_by year_key l
    where year_key = ATime.toAYear . bucket_key 

bucketize_by_day l = bucketize_by day_key l
    where day_key = bucket_key

data PlotSettings = 
    PlotSettings { pWidth :: Double
                 , pHeight :: Double
                 }


-- addGaps takes 2 lists and shoves the missing elements of (in list y) into list x
-- Assumptions:
--  First list is increasing succ x > x
--  Second list is increasing succ y > y
--  x maps to y 1 to 1 but y can be larger
--  y is a range of x (domain?)
--  thus X can only be equal to y or greater than y
addGaps cmp [] ys = ys
addGaps cmp xs [] = error ("We are now out of range.. in addGaps " ++ (show xs))
addGaps cmp xo@(x:xs) (y:ys) = if (cmp x  y)
                        then x : addGaps cmp xs ys -- note we dropped y here
                        else y : addGaps cmp xo ys

-- LocList is [((Num, Num), v)]
gridLayout ::  [ ( (Double, Double), DrawObj ) ] -> [ DrawObj ]
gridLayout locList =  (map f locList)
    where spots = (map fst locList)
          vals = (map snd locList)
          minb = Data.List.minimum spots
          maxb = maximum spots
          (minx,miny) = minb
          (maxx,maxy) = maxb
          -- arr = array (minb,maxb) locList
          maxbounds = maximumBoundsOfDrawObjs vals
          eWidth = widthOfBound maxbounds
          eHeight = heightOfBound maxbounds
          -- places = [ (x,y) | xs <- [minx..maxx], ys <- [miny..maxy] ]
          --f loc@(x,y) = let elm = arr!loc
          f ((x,y),v) = Translate v (Point ((x - minx) * (eWidth)) ((y - miny) * (eHeight)))
                           
-- O(n log n)              
histogram l =
    Map.toAscList $ foldl 
           (\m key -> Map.insert key (1 + (Map.findWithDefault 0 key m)) m)
           Map.empty l

make_plot_of_topic_events bucketizer plotsettings l = objTransList
    where buckets = bucketizer l 
          -- get histograms for the topics
          cBuckets = map (\(bucket,l) -> (bucket,((histogram (map fst l))))) buckets
          topicListsWoCount = map (map fst) $ map snd cBuckets
          minTopic = minimum $ map minimum topicListsWoCount
          maxTopic = maximum $ map maximum topicListsWoCount
          -- need these to calculate coloranges
          minCount = minimum (map (\(bucket,hist) -> minimum (map snd hist)) cBuckets)
          maxCount = maximum (map (\(bucket,hist) -> maximum (map snd hist)) cBuckets)
          rangeCount = maxCount - minCount
          --calculate the range of the time units
          lastElm = last buckets
          firstElm = head buckets
          range = [(fst firstElm) .. (fst lastElm)] -- haha I love enum so clever
          -- fill in missing date ranges
          emptyTopics  = [(topic,(0)) | topic <- [minTopic..maxTopic]]
          bucketsWGaps = addGaps (\x y -> fst x == fst y) cBuckets gapRange 
              where gapRange = map (\x -> (x, emptyTopics)) range 
          width = pWidth plotsettings
          height = pHeight plotsettings
          -- generate the labels
          labels = map (\x -> Lda_layout.mkLabel (ATime.toStr x) 0 0) range
          biggestLabelBounds = maximumBoundsOfDrawObjs labels
          labelWidth = widthOfBound biggestLabelBounds
          labelHeight = heightOfBound biggestLabelBounds
          colorOf count = (c,c,c) where c = (fromInteger (count - minCount))/(fromInteger rangeCount)
          boxHeight = labelHeight
          boxWidth = labelHeight -- max 64 (min labelWidth labelHeight)
          -- Generate the boxes :D (assume bucketsWGaps sorted
          boxes :: [((Double, Double), DrawObj)]
          boxes = concatMap f  (zip [1..]  bucketsWGaps) 
          f (i,(date,hist)) = map (\(j,c) -> (((fromInteger j),(fromInteger i)),(Box (colorOf c) (Region (Point 0 0) (Bounds boxWidth boxHeight))))) hist
          realLabels = map (\(i,l) -> ((0,i),l)) $ zip [1..] labels
          realLabelsTrans = map (\((x,y),v) -> Translate v (Point (x * labelWidth) (y * labelHeight))) realLabels
          boxesTrans = map (\((x,y),v) -> Translate v (Point (labelWidth + x * boxWidth) (y * labelHeight))) boxes
          -- objList :: [((Double, Double), DrawObj)]
          -- objList = realLabels ++ boxes
          objTransList = realLabelsTrans ++ boxesTrans

rankedPlotter inFilename outFilename fileType f = do
      l <- parse_ranked_docs inFilename
      let objs = make_plot_of_topic_events f (PlotSettings {pWidth = 4000 , pHeight = 4000}) l 
      Lda_report.plotSomeObjs fileType outFilename objs

main_ranked () =
    do 
      rankedPlotter "ranked-docs.report" "year.png" Lda_report.PNG bucketize_by_year
      rankedPlotter "ranked-docs.report" "month.png" Lda_report.PNG bucketize_by_month
      rankedPlotter "ranked-docs.report" "day.png" Lda_report.PNG bucketize_by_day
      
