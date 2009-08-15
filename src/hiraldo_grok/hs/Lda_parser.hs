module Lda_parser where
import System.IO
import System.Locale
import System.Time
import Data.List
import Time
import Data.Map (Map)
import qualified Data.Map as Map
import Char
import Monad
import Array
import EqClass

data Window = EmptyWindow | TopicWindow String [[String]]

showsTopicWindow (TopicWindow time topics) = "TopicWindow [" ++ time ++ "] [" 
                                                            ++ (concat (map unwords topics))
                                                            ++ "]"

showsTopicWindow (EmptyWindow) = "EmptyWindow"

instance Show Window where 
    show = show . showsTopicWindow



data Topic = Topic [String]

showsTopic (Topic x) = "Topic "++(show x)
instance Show Topic where 
    show = show . showsTopic


topicCompare (Topic topic1) (Topic topic2) = compare topic1 topic2
-- I don't like this, also, I think topics should be sets.
topicEq (Topic topic1) (Topic topic2) = topic1 == topic2
instance Eq Topic where
    (==) = topicEq
instance Ord Topic where
    compare = topicCompare


topicWords (Topic words) = words

isEmptyTopic EmptyWindow = True
isEmptyTopic _  = False                 

addTopic (TopicWindow topicTime wordwords) topicNumber words = 
    if (timeToYearInt (strToTime topicTime) < 1981) 
    then error (show (topicTime,topicNumber,words))
    else (TopicWindow topicTime (words:wordwords))

makeTopicWindow time number words  = 
    if (timeToYearInt (strToTime time) < 1981) 
    then error (show (time,number,(TopicWindow time [words])))
    else (TopicWindow time [words])
              

emptyTopicWindow = EmptyWindow
--getTopics (TopicWindow time words)
getTopics (TopicWindow time words) = words
getTime (TopicWindow time words) = time

getIDTopics (TopicWindow time words) = map (\x -> (time, x)) words

-- Start w/ EmptyWindow and lines
lineParser EmptyWindow [] = [] 
lineParser x [] = [x]
lineParser current (x:xs) = 
    case words x of
      []  -> current : (lineParser emptyTopicWindow xs)
      y:z:zs | (isMyFloatStr y) && (isIntStr z) -> 
                 lineParser (makeTopicWindow y z zs) xs
             | (isIntStr y) -> 
                 lineParser (addTopic current y (z:zs) ) xs
      y:[] -> lineParser (addTopic current y []) xs
      z -> error ((show z) ++ " Don't know")

                                     
isMyFloatStr [] = True
isMyFloatStr (x:[]) = (x == '.')
isMyFloatStr (x:xs) = if ((Char.isDigit x) || x == '.') 
                            then isMyFloatStr xs
                            else False

isIntStr [] = True
isIntStr (x:xs) = if (Char.isDigit x) 
                            then isIntStr xs
                            else False



parseLDAFile file = 
       do contents <- readFile file
          let lines = Data.List.lines contents in
              return (lineParser EmptyWindow lines)
                       
topicWindowToString (TopicWindow time wordwords) =
    concat (map (\x -> x ++ "\n")
                    ((show time):(map unwords wordwords)))
         


-- mainloop [] = return ()
-- mainloop (x:xs) = do 
--                    putStrLn (topicWindowToString x)
--                    mainloop xs
-- 

-- make a sequence of putstrln monads then run them in order
load_report_and_print = do l <- parseLDAFile "lda.report" 
                           Monad.sequence_
                                    (map 
                                     (\x -> putStrLn (topicWindowToString x)) 
                                     l)
id_topic_similarity (id1,words1) (id2,words2) =
    topic_similarity words1 words2

topic_similarity [] []  = 0.0
topic_similarity [] _  = 0.0
topic_similarity _ []  = 0.0

topic_similarity topic1 topic2 =
    let len1 = length topic1 
        len2 = length topic2 
        mlen = max len1 len2 
        sect = intersect topic1 topic2 
        sectlen = length sect 
    in
      if mlen > 0 
      then (toRational sectlen) / (toRational mlen)
      else 0.0 :: Rational

minTopicSimilarity sim topic1 topic2 =
    let s = topicSimilarity topic1 topic2 in
    s >= sim
    
-- What do we want?
-- We want to see smears, runs of topic similarity
--  lets make a sim matrix
--    maybe select the top  most popular?


topicsWindowsToListofTopicsWithIds topics = 
    concatMap getIDTopics topics


-- squares  =  array (1,100) [(i, i*i) | i <- [1..100]]

matrixTopic topicWindows = 
    let topics  = topicsWindowsToListofTopicsWithIds topicWindows 
        ntopics = length topics
        ztopics = zip [1..ntopics] topics
        sim x (j,y) = (j, (id_topic_similarity x y))
        mkarr (i,x) = (i, (array (1,ntopics) (map (sim x) ztopics)))
        matrix = array (1,ntopics) (map mkarr ztopics)
        threshold = 8 / 10
    in
      matrix

-- TODO
-- Plot matrix
-- Plot Similar topics over time

loadReportMatrixTopic = do l <- parseLDAFile "lda.report" 
                           putStrLn (show (matrixTopic l))

getDefaultLdaTopics () = do l <- parseLDAFile "lda.report" 
                            return l

-- main = load_report_and_print
-- main = loadReportMatrixTopic

-- FIRST will be default
foldlOnFirst f [] = error "No elements to fold on!"
foldlOnFirst f (x:xs)  = foldl f x xs



testData = 
    [ (TopicWindow "Jan" [ ["huh", "lol", "hy"],
                           ["huh", "lol", "hy"],
                           ["eggplants","pearling","buncombe's","Iqbal","lumpiest","eyepiece","alums","cocktail's","threat's","unzip"],
                           ["Neapolitan's","Irma's","wag","rumps","mercy's","Honiara","Piraeus","Terence","routes","Dirk's"]]),
      (TopicWindow "Feb" [ ["Neapolitan's","Irma's","wag","rumps","mercy's","Honiara","Piraeus","Terence","routes","Dirk's"],
                           ["atrophied","suborning","unceremoniously","untied","aphid's","Eva","ambrosia","bologna","marring","incorrigibly"],
                           ["huh", "lol", "hy"]]),
      (TopicWindow "Mar" [ ["huh", "lol", "hy"],
                           ["eggplants","pearling","buncombe's","Iqbal","lumpiest","eyepiece","alums","cocktail's","threat's","unzip"],
                           ["Neapolitan's","Irma's","wag","rumps","mercy's","Honiara","Piraeus","Terence","routes","Dirk's"]]),
      (TopicWindow "Apr" [ ["huh", "lol"],
                           ["eggplants","pearling","buncombe's","Iqbal","lumpiest","eyepiece"],
                           ["Neapolitan's","Irma's","wag","rumps","mercy's","Honiara","Piraeus","Terence"]])
    ]

    


data TopicSmear = TopicSmear Int [Topic] | TopicSplotch Topic
-- -- the X coord and the Y coord
data TopicPlacement = TopicPlacement Int Int TopicSmear
data TopicPlot = TopicPlot [String] [TopicPlacement]


placementGetTopics (TopicPlacement _ _ (TopicSmear _ x)) = x
placementGetTopics (TopicPlacement _ _ (TopicSplotch x)) = [x]
placementGetSmear (TopicPlacement _ _  x) = x

instance Ord TopicPlacement where
    compare = topicPlacementCompare



topicSimilarity (Topic t1) (Topic t2) = topic_similarity t1 t2
topicsSimilarity topics  topic2 = maximum (map (topicSimilarity topic2) topics)

maxTopicSimilarity [] _ = 0.0
maxTopicSimilarity _ [] = 0.0
maxTopicSimilarity topics1 topics2 =
   maximum [ (topicSimilarity x y) | x <- topics1, y <- topics2 ]

tpSimilarity tp1 tp2 = maxTopicSimilarity (placementGetTopics tp1) (placementGetTopics tp2)
    

splotchTopic (TopicSplotch (Topic x)) = x
placementSplotchTopic (TopicPlacement _ _ x) = splotchTopic x
replaceTopicSmear (TopicPlacement x y _) r = TopicPlacement x y r

-- BROKEN
topicPlacementEq t1 t2 =
    let (TopicPlacement x1 y1 s1) = t1
        (TopicPlacement x2 y2 s2) = t2
    in
    (x1,y1) == (x2,y2) && ((placementGetTopics t1) == (placementGetTopics t2))

instance Eq TopicPlacement where
    (==) = topicPlacementEq

-- Work's slightly better?
topicPlacementCompare t1 t2 =
    let (TopicPlacement x1 y1 s1) = t1
        (TopicPlacement x2 y2 s2) = t2
    in
    case (compare (x1,y1) (x2,y2)) of
      EQ -> compare (placementGetTopics t1) (placementGetTopics t2)
      x -> x

showTopic (Topic words) = unwords words

showTopicPlot (TopicPlot labels smears) =
    "TopicPlot " ++ (show labels) ++ ":" ++ show smears

showTopicPlacement (TopicPlacement x y smear) =
    "TopicPlacement " ++ (show x) ++ "," ++ (show y) ++ ": "++ (show smear)

showTopicSmear (TopicSmear n topics) = "TopicSmear " ++ (show n) ++ " " ++ (show (map showTopic topics))
showTopicSmear (TopicSplotch topic) = "TopicSplotch " ++ (showTopic topic)
    
topicPlacementX (TopicPlacement x y smear) = x
topicPlacementY (TopicPlacement x y smear) = y
topicPlacementSmear (TopicPlacement x y smear) = smear

instance Show TopicPlot where 
    show = show . showTopicPlot
instance Show TopicPlacement where 
    show = show . showTopicPlacement
instance Show TopicSmear where 
    show = show . showTopicSmear


-- (load "/usr/share/emacs/site-lisp/haskell-mode/haskell-site-file.el")

mkTopicPlacementSplotch i j topic  = TopicPlacement i j (TopicSplotch (Topic topic))
mkTopicPlacementSmear   i j topics = TopicPlacement i j (TopicSmear 1 (map (\x -> Topic x) topics))

enumTopicsOfWindow (TopicWindow time topics) = zip [1..(length topics)] topics

tuple2Apply f (a,b) = f a b



-- splotchJoiner :: [TopicPlacement] -> [TopicPlacement]
splotchJoiner :: Rational -> [String] -> [TopicPlacement] -> [[TopicPlacement]]
splotchJoiner similarity labels topics =
    let len = length labels 
        --splotchArray =  array (1,len) $ map (\i -> (i,[x | x <- topics, (i == topicPlacementX x)])) [1..len]
        splotchL =  map (\i -> [x | x <- topics, (i == topicPlacementX x)]) [1..len]
        -- do we need to test internal similarity?  
        pTopicSim x y = topic_similarity (placementSplotchTopic x) (placementSplotchTopic y)
        getTopicSmear l = TopicSmear 1 (map (\x -> Topic (placementSplotchTopic x)) l)
        simReducer [] = []
        simReducer (x:xs) = -- x is a TopicPlacement
            let (simx,notsim) = partition (\y ->  (pTopicSim x y) >= similarity ) xs  in
            case simx of
              [] -> x : (simReducer notsim)
              ys -> TopicPlacement tx ty (getTopicSmear (x:ys)) : (simReducer notsim) where
                                         TopicPlacement tx ty _ = x
        reducedL = map simReducer splotchL
    in
      reducedL

        -- now we move forward into the future til we get x:[]
-- We want to be left with the world that wasn't smeared sucked up + the smeared world
-- world should be list of lists of topicplacements

smearAcross :: Rational -> [[TopicPlacement]] -> [[TopicPlacement]] 
smearAcross similarity [] = []
smearAcross similarity ([]:xs) = -- start here x is a list of unique topics 
   []:(smearAcross similarity xs)
smearAcross similarity (x:xs) = -- start here x is a list of unique topics 
   -- so for each topic in this window..   
   let (accum,worldleft) = 
           foldl (\(accum,world) topic -> 
                      let (matching,didntmatch) = grabTopicsThatMatch similarity topic world      
                          newworld = didntmatch
                          newtopic = mergeTopics topic matching
                      in
                      ((newtopic:accum),newworld) 
                 ) ([],xs) x 
   in
     accum:(smearAcross similarity worldleft)



--- XXX: TODO smearAcross needs to be done
 
-- given a similarity measure and a topic plus a word structure of [[TopicPlacement]]
--   find and remove the continuous matching smears
--     return the matching
--     return the world without the matching
--grabtopicsThatMatch :: TopicPlacement -> [[TopicPlacement]] -> ([TopicPlacement],[[TopicPlacement]])
grabTopicsThatMatch similarity topic topics = 
    let partFun a =  (tpSimilarity topic a) >= similarity
        helper matched world [] = ((reverse matched),(reverse world))
        helper matched world (x:xs) = 
            let (matches,doesntmatch) = partition partFun x in
            case matches of
              [] -> ((reverse matched), ((reverse (doesntmatch:world)) ++ xs)) -- return the world?
              y:ys -> -- this means we matched some 
                helper ((y:ys) : matched) (doesntmatch : world) xs
    in
      helper [] [] topics

grabTopicsThatMatchTest = grabTopicsThatMatch (2/3) topic topics where
    topic = TopicPlacement 1 1 (TopicSmear 1 [ (Topic ["Lol","hy","what"]), (Topic ["Lol","hy","zuh"]) ])
    topics = [ [TopicPlacement 2 1 (TopicSplotch (Topic ["Lol","hy","poo"]))],
               [TopicPlacement 3 1 (TopicSplotch (Topic ["Lol","hy","zuh"])),
                TopicPlacement 3 2 (TopicSplotch (Topic ["Lol","hy","roo"]))],
               [TopicPlacement 4 1 (TopicSplotch (Topic ["Lol","hy","zuh"])),
                TopicPlacement 4 2 (TopicSplotch (Topic ["On","me","please"]))]
             ]


smearLength (TopicSplotch _) = 1
smearLength (TopicSmear n _) = n

-- This gets the real length of the smear, especially important if we're 
--  dealing with smears being joined together
getTopicSmearListLength [] = 0
getTopicSmearListLength ([]:xs) = 0
getTopicSmearListLength (x:xs) = 
    let getLen = smearLength . placementGetSmear in
    max (maximum (map getLen x)) (1 + (getTopicSmearListLength xs))


-- Complication, what if we merge smears!, 
--   we really need the sum of the max length of smears 
--    need to handle the case where we have smear 3, smear 3, smear 3
mergeTopics :: TopicPlacement -> [[TopicPlacement]] -> TopicPlacement
mergeTopics (TopicPlacement x y ts) lotopics =
    TopicPlacement x y smear where 
        len = getTopicSmearListLength lotopics
        flattopics = concat $ map placementGetTopics $ concat  lotopics
        smear = case(ts) of
                TopicSplotch topic ->
                    TopicSmear (1 + len) ( topic:flattopics )
                TopicSmear n topics ->
                    TopicSmear (max n (len + 1)) (topics  ++ flattopics)

-- @TestCode
mergeTopicsTest = mergeTopics tp topicsToMerge where
    (topicsToMerge,_) = grabTopicsThatMatchTest
    tp = TopicPlacement 1 1 (TopicSplotch (Topic ["HEY","LOL","HY"]))
    
-- @TestCode
stest = splotchJoiner (8/10) x y where TopicPlot x y = test    

-- @TestCode
stes = (> 0) $ length $ [x | x <- stest, 0 < length [y | y <- x, case y of 
                                       TopicPlacement _ _ (TopicSmear _ _) -> True
                                       _ -> False]]

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

timeToYearStr time =   
    formatCalendarTime System.Locale.defaultTimeLocale "%Y" time

timeToYearInt = strToInt . timeToYearStr

-- Doesn't do anything except convert an LDA to a TopicPlot
-- Which means Labels + topic placement splotches
smearFinder  lda =
    let labels = map (timeToMonthStr . strToTime . getTime) lda
        n = length lda
        splotches = concatMap (\(i,topicw) -> 
                                (map (tuple2Apply (mkTopicPlacementSplotch i))) $ 
                                enumTopicsOfWindow topicw) $
                           zip [1..n] lda         
    in
      TopicPlot labels splotches

-- @TestCode
test = smearFinder  testData


testBucket similarity smearplot =
    let (TopicPlot labels smears) = smearplot
        -- [Topic]
        topics = concatMap placementGetTopics smears        
        (maxcolors,topicmap) = getEqClasses (minTopicSimilarity similarity)  topics
        --placements = smearFinder topicmap labels smears
        placements = bucketify topicmap labels smears
    in
      (topicmap, placements)



processSmearPlot similarity smearplot =
    let (TopicPlot labels smears) = smearplot
        -- [Topic]
        topics = concatMap placementGetTopics smears        
        (maxcolors,topicmap) = getEqClasses (minTopicSimilarity similarity)  topics
        --placements = smearFinder topicmap labels smears
        placements = bucketify topicmap labels smears
        -- placed = smearAcross similarity placements
        placed = growSmears topicmap placements
        joinedAndPlaced = concat placed
        -- joinedAndPlaced = concat placements
    in
      (TopicPlot labels joinedAndPlaced, maxcolors, topicmap)

processLDA similarity lda =
    let smearplot = smearFinder lda in
    let tpmctm = processSmearPlot similarity smearplot in
    tpmctm

testProcessSmearPlot =
    let sim = 2/3 
        topics = [ 
          TopicPlacement 2 1 (TopicSplotch (Topic ["Lol","hy","poo"])),
          TopicPlacement 2 2 (TopicSplotch (Topic ["Lol","hy","poo"])),
          TopicPlacement 2 3 (TopicSplotch (Topic ["Lol","poo","joo"])),
          TopicPlacement 2 4 (TopicSplotch (Topic ["what","hy","poo"])),
          TopicPlacement 2 5 (TopicSplotch (Topic ["Lol","MOO","GOO"])),
          TopicPlacement 3 1 (TopicSplotch (Topic ["IIII","AAAA","EEEE"])),
          TopicPlacement 3 2 (TopicSplotch (Topic ["JJJJ","BBBB","FFFF"])),
          TopicPlacement 4 1 (TopicSplotch (Topic ["KKKK","CCCC","GGGG"])),
          TopicPlacement 4 2 (TopicSplotch (Topic ["LLLL","DDDD","HHHH"]))]
        tp = TopicPlot ["two","three","four"] topics
    in
      processSmearPlot sim tp
      


topicColorOfPlacement topicmap a =
    let (x:_) =  placementGetTopics a -- DANGER WILL ROBINSON!
        am = Map.lookup x topicmap
    in
      case am of
        Just x -> x
        _ -> error "Could not find color!"

topicColor topicmap topic = 
    let am = Map.lookup topic topicmap in
    case am of
      Just x -> x
      _ -> error "Could not find color!"


placementIsSim topicmap a b =
    let l1 =  placementGetTopics a -- DANGER WILL ROBINSON!
        l2 =  placementGetTopics b
        jeq (Just x) (Just y) = x == y
        jeq _ _ = error "jeq failure"
        look a = Map.lookup a topicmap
    in
      case (l1,l2) of
        ([],_) -> False
        (_,[]) -> False
--         (l1,l2) ->
--             let xs = [ x | ae <- l1, be <- l2, x <- (jeq (look ae) (look be)) ]
--             in
--               foldl (\x o -> x || o) False xs
        ((t1s:_),(t2s:_)) -> let am = Map.lookup t1s topicmap
                                 bm = Map.lookup t2s topicmap
                              in
                                case (am,bm) of
                                  ((Just x),(Just y)) -> x == y
                                  _ -> error "isSim 2 failed Maybes"

bucketify :: (Map Topic Int) -> [String] -> [TopicPlacement] -> [[TopicPlacement]]
bucketify topicmap labels topics =
    let len = length labels 
        splotchL = map (\i -> [x | x <- topics, (i == topicPlacementX x)]) [1..len]
        isSim = placementIsSim topicmap
        -- recv's a list of topicplacements
        groupSimilar l =
            let colormap = groupBy (\(i,_) (j,_) -> i == j) $ sortBy (\(i,_) (j,_) -> compare i j) $ map (\x -> ((topicColorOfPlacement topicmap x),x)) l 
                partitions = map (map snd) colormap
            in
            map (\(y,x:xs) -> 
                     let (TopicPlacement tx _ _) = x in
                     TopicPlacement tx y (TopicSmear 1 (concatMap placementGetTopics (x:xs))))
               (zip [1..] partitions)
    in
      -- map (\x -> map collapseSmears (groupBy isSim x)) splotchL
      map groupSimilar splotchL

growSmears :: (Map Topic Int) -> [[TopicPlacement]] -> [[TopicPlacement]] 
growSmears topicmap [] = []
growSmears topicmap ([]:xs) = -- start here x is a list of unique topics 
   []:(growSmears topicmap xs)
growSmears topicmap (x:xs) = -- start here x is a list of unique topics 
   -- so for each topic in this window..   
   let (accum,worldleft) = 
           foldl (\(accum,world) topic -> 
                      let (matching,didntmatch) = matchingSmears topicmap topic world      
                          newworld = didntmatch
                          newtopic = mergeTopics topic matching
                      in
                      ((newtopic:accum),newworld) 
                 ) ([],xs) x 
   in
     accum:(growSmears topicmap worldleft)

-- given a similarity measure and a topic plus a word structure of [[TopicPlacement]]
--   find and remove the continuous matching smears
--     return the matching
--     return the world without the matching
matchingSmears topicmap topic topics = 
    let partFun = placementIsSim topicmap topic
        helper matched world [] = ((reverse matched),(reverse world))
        helper matched world (x:xs) = 
            let (matches,doesntmatch) = partition partFun x in
            case matches of
              [] -> ((reverse matched), ((reverse (doesntmatch:world)) ++ xs)) -- return the world?
              y:ys -> -- this means we matched some 
                helper ((y:ys) : matched) (doesntmatch : world) xs
    in
      helper [] [] topics

