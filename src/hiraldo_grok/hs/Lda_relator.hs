import Lda_parser
import List
import Data.List
import Directory
import Char
import Monad

data WordList = WordList String [String]
wordListName (WordList name _) = name
wordListWords (WordList _ words) = words

-- ranks by number of hits
topicWordListSimilarity (Topic topicWords) (WordList name words) =
    length $ List.intersect topicWords words



-- Ok left to do 
-- it should work?
-- it has to load the wordlist and iterate per each topic seeing if it is similar
-- then we'll make it print a report

sim = 7 / 10

getWordListFileNames () = do
  d <- getCurrentDirectory
  l <- getDirectoryContents d
  return (filter (isPrefixOf "wordlist.") l)

getWordLists () = do
  fileNames <- getWordListFileNames ()
  wordList <- mapM parseWordList fileNames
  return wordList

processWord word = 
    map (\c -> if (c == '_') then ' ' else toLower c) word

parseWordList file = do
  contents <- readFile file
  let lines = Data.List.lines contents
  let words = map processWord lines 
  return (WordList (head words) (nub words))

isTopicSimilarToWordList topic wordList =  (topicWordListSimilarity topic wordList) > 0

topicRelations sim l wl =
  let plda = processLDA sim l
      -- topicmap is a Data.Map that maps from a topic to a color
      (tp,maxcolor,topicmap) = plda
      -- labels are basically the names of the months and years.. (great)..
      -- smears are Topic Placements 
      (TopicPlot labels smears) = tp
      topics = concatMap placementGetTopics smears        
      topicRelations = map (\topic -> 
                                let relatedWordLists = filter (isTopicSimilarToWordList topic) wl
                                in
                                (topic, relatedWordLists) 
                                
                           ) topics
  in
    topicRelations

presentTopicRelations tr =
    map (\((Topic topicWords), wls) ->
            concat [ "Topic: " , 
                     (intercalate ", " $ map wordListName wls) , 
                     " [ " , 
                     (intercalate ", " topicWords) , 
                     "]" ]) tr

wordListCorrelation :: [(Topic,[WordList])] -> [((String,String),Int)]
wordListCorrelation tr =
    let names = map (\(_,x) -> map wordListName x ) tr
        tupleify l = [(x,y) | x <- l, y <- l, x <= y] -- implies it sorts them
        tuples = concatMap tupleify names 
        histogram = mkHistogram tuples 
    in
      histogram

-- list of strings 
showWordListCorrelation :: [((String,String),Int)] -> [String]
showWordListCorrelation histogram =
   let showTuples (a,b) = concat [a ,", ",b]
       showCountTuples (t,c) = concat [(showTuples t), " ", show (c)]
   in
     map showCountTuples histogram

topicRelationSummary tr = 
    let totalTopics = countTopics tr :: Int
        unNamedTopics = countUnNamedTopics tr :: Int
        emptyTopics = countEmptyTopics tr :: Int
        namedTopics = totalTopics - unNamedTopics :: Int
        totalUnNamedNotEMpty = unNamedTopics - emptyTopics
        header = [["Total Topics:", (show totalTopics )],
                  ["Total Named Topics:", (show namedTopics)],
                  ["Total UnNamed Topics:", (show unNamedTopics)],
                  ["Total Empty Topics:", (show emptyTopics)],
                  ["Total UnNamed Non-empty Topics:", (show totalUnNamedNotEMpty)]

                 ]  :: [[String]] -- what follows is just pairs of tuples
    in
    intercalate "\n" 
        $ map (intercalate " ")
        $ concat [header, (map (\(str,len) -> [ str , show len ]) (countNamings tr))]

   
countTopics tr = length tr


countUnNamedTopics tr =
    let f (_,[]) cnt = 1 + cnt
        f (_,(x:xs)) cnt = 0 + cnt
    in
      foldr f 0 tr

-- from elems
mkHistogram l  =
  sortBy (\x y -> compare (snd x) (snd y)) 
             $ map (\(x:xs) -> (x,length (x:xs))) 
             $ group 
             $ sort l


countNamings tr =
    mkHistogram $ concatMap (\(topic, wl) -> map wordListName wl) tr
  -- sortBy (\x y -> compare (snd x) (snd y)) 
  --            $ map (\(x:xs) -> (x,length (x:xs))) 
  --            $ group 
  --            $ sort 
  --            $ concatMap (\(topic,wl) -> map wordListName wl) tr


countEmptyTopics tr =
    let f ((Topic []),_) cnt = 1 + cnt
        f _ cnt = 0 + cnt
    in
      foldr f 0 tr


ldaRealtorMain sim = do
  l  <- getDefaultLdaTopics ()
  wl <- getWordLists ()
  let tr = topicRelations sim l wl 
  Monad.mapM_ putStrLn $ presentTopicRelations tr
  putStrLn $ topicRelationSummary tr
  Monad.mapM_ putStrLn $ showWordListCorrelation $ wordListCorrelation tr
  
  
main = ldaRealtorMain sim
