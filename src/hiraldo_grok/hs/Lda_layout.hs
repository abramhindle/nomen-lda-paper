module Lda_layout where
import Array
import Lda_parser
import System.Random
import Data.List
import Data.Map (Map)
import qualified Data.Map as Map

intToDouble:: Int -> Double
intToDouble x =    fromInteger  $ toInteger x



tinyTopicFontSize = 10.0
bigTopicFontSize = 30.0
defaultSplotchWidth = 150.0
defaultSplotchHeight = 150.0

type Color = (Double,Double,Double)

data Point = Point Double Double deriving (Ord, Show, Eq)
data Bounds = Bounds Double Double deriving (Ord, Show, Eq)
data Region = Region Point Bounds deriving (Ord, Show, Eq)
-- The bounds of a label Include the space for the text
data DrawObj = DrawString String Double Point Bounds |
               Label DrawObj Point Bounds | -- DrawString
               Smear (Double,Double,Double) DrawObj [DrawObj] Region | -- DrawString Label and Topic
               DTopic [DrawObj] Region |
               Box (Double, Double, Double) Region |
               Translate DrawObj Point

drawObjWidth (DrawString _ _ _ (Bounds w _)) = w
drawObjWidth (Label _ _ (Bounds w _)) = w
drawObjWidth (Smear _ _ _ (Region _ (Bounds w _))) = w
drawObjWidth (DTopic _ (Region _ (Bounds w _))) = w
drawObjWidth (Box _ (Region _ (Bounds w _))) = w
drawObjWidth (Translate x _) = drawObjWidth x

drawObjRegion (DrawString _ _ pts bds) = Region pts bds
drawObjRegion (Label _ pts bds ) = Region pts bds
drawObjRegion (Smear _ _ _ r) = r
drawObjRegion (DTopic _ r) = r
drawObjRegion (Box _ r) = r
drawObjRegion (Translate v pt) = Region pt bds
    where (Region _ bds) = drawObjRegion v

-- makes an assumption of 0,0 existing
enclosingRegion objs =
    let l = map drawObjRegion objs in
    foldl combineRegions (Region (Point 0 0) (Bounds 0 0)) l

combineRegions (Region (Point x1 y1) (Bounds w1 h1)) (Region (Point x2 y2) (Bounds w2 h2)) =
    let nx = min x1 x2
        ny = min y1 y2
        mx = max (x1 + w1) (x2 + w2)
        my = max (y1 + h1) (y2 + h2)
    in
      Region (Point nx ny) (Bounds (mx - nx) (my - ny))



getMaxXofRegion (Region (Point x y) (Bounds w h)) =    x + w
getMaxYofRegion (Region (Point x y) (Bounds w h)) =    y + h
getMinYofRegion (Region (Point x y) (Bounds w h)) =    y
getMinXofRegion (Region (Point x y) (Bounds w h)) =    x
getCorners (Region (Point x y) (Bounds w h)) = (x,y,x+w,y+h)
getRegionOf (Label _ pt bds) =  Region pt bds
getRegionOf (DrawString str size pt bds) =  Region pt bds
getRegionOf (Smear _ _ _ region) =    region

boundsOf (Label _ pt bds) = bds
boundsOf (DrawString _ _ pt bds) = bds
boundsOf (Smear _ _ _ (Region _ bounds)) = bounds
boundsOf (DTopic _ (Region _ bounds)) = bounds
boundsOf (Box _ (Region _ bounds)) = bounds
boundsOf (Translate x pt) = boundsOf x


getBoundBounds (Bounds x y) = (x,y)
widthOfBound (Bounds w _) = w
heightOfBound (Bounds _ h) = h

calcFontExtents size s = fontSize Sans size s

calculateBounds [] = (0,0,0,0)
calculateBounds drawobjs = 
    foldl1 (\(x,y,xx,yy) (ox,oy,oxx,oyy) -> ((min x ox),(min x oy),(max xx oxx),(max yy oyy))) drawobjs

calcBigFontExtents = calcFontExtents bigTopicFontSize
calcTinyFontExtents = calcFontExtents tinyTopicFontSize
calcManyTinyFontExtents strs = getFontExtents tinyTopicFontSize strs

mkLabel s  x y = 
    let size = bigTopicFontSize
        textObj = convertTextToDrawObj 0 0 size s
        bounds = boundsOf textObj
    in
    Label textObj (Point x y) bounds

maxBoundsOf objs = 
    let (sx,sy,bx,by) = calculateBounds objs in
      ((bx - sx),(by - sy))

maximumBoundsOfDrawObjs objs = 
    maximumOfBounds (map boundsOf objs)

maximumOfBounds bounds =
    foldl1 (\(Bounds w1 h1) (Bounds w2 h2) -> Bounds (max w1 w2) (max h1 h2)) bounds


-- like a concat of bounds
boundsAdd (Bounds w1 h1) (Bounds w2 h2) = Bounds (w1 + w2) (max h1 h2)
-- Stack bounds ontop of each other
boundsStackAdd (Bounds w1 h1) (Bounds w2 h2) = Bounds (max w1 w2) (h1 + h2)



-- assume topics are plotted on top of each other
calcTopicExtents topic = 
    let extents = calcManyTinyFontExtents topic in
    let finalbounds = foldl1 (\(Bounds ww hh) (Bounds w h) -> (Bounds (max ww w) (max h hh))) extents in
    finalbounds

-- Watch for magic numbers!
topicTextResizer text =
    let len = length text 
    in
      if (length text > 26)
      then ((take 10 text) ++ "..." ++ (reverse $ take 10 $ reverse text))
      else text

convertTextToDrawObj x y size label = DrawString label size (Point x y) (calcFontExtents size label)
    
convertTopicTextToTopic x y topic =
    let h = fontHeight Sans tinyTopicFontSize 
        totalh = (intToDouble (length topic)) * h
        objs = map (\(y,text) -> convertTextToDrawObj 0 (h*(intToDouble y)) tinyTopicFontSize (topicTextResizer text)) $ zip [0..((length topic)-1)] topic
        totalw = case objs of 
                   [] -> 0
                   x:xs -> maximum $ map drawObjWidth objs
    in
      DTopic objs (Region (Point x y) (Bounds totalw totalh))
             

convertSmearToDrawObj :: (Double,Double,Double) -> Double -> Double -> String -> TopicSmear -> DrawObj 
convertSmearToDrawObj color x y label (TopicSplotch (Topic topic)) = 
    let labelObj = convertTextToDrawObj 0 0 bigTopicFontSize label
        (Bounds labelw _) = boundsOf labelObj
        topicObj = convertTopicTextToTopic labelw 0 topic
        totalBounds = boundsAdd (boundsOf labelObj) (boundsOf topicObj)
    in
      Smear color labelObj [topicObj] (Region (Point x y) totalBounds)

convertSmearToDrawObj color x y label (TopicSmear range topics) = 
    let labelObj = convertTextToDrawObj 0 0 bigTopicFontSize label
        labelBounds = boundsOf labelObj
        (Bounds labelw _) = labelBounds
        f::Double -> Lda_parser.Topic -> DrawObj
        f lastx (Lda_parser.Topic topic) = convertTopicTextToTopic lastx 0 topic
        topicObjs = concatLayoutMap labelw f topics
        tbounds = (foldl boundsAdd labelBounds (map boundsOf topicObjs)) -- minWidthBounds (foldl boundsAdd labelBounds (map boundsOf topicObjs)) ((intToDouble range) * defaultSplotchWidth)
        (Bounds nw nh) = tbounds
        totalBounds = (Bounds ((intToDouble range) * defaultSplotchWidth) nh)
    in
      Smear color labelObj topicObjs (Region (Point x y) totalBounds)

-- DOES NOT GUARANTEE ORDER
-- Lays out the topics side by side
concatLayoutMap:: Double -> (Double -> Lda_parser.Topic -> DrawObj) -> [Lda_parser.Topic] -> [DrawObj]
concatLayoutMap startx f l =
    let foldf::Lda_parser.Topic -> (Double, [DrawObj]) -> (Double, [DrawObj])
        foldf newval (lastx,accum)  = 
            let obj = f lastx newval
                w = drawObjWidth obj
                nl = obj:accum
                nx = w + lastx
            in
              (nx, nl)
        (lastx,objs) = foldr foldf (startx,[]) l
                            
    in
    objs




maxWidthBounds (Bounds w h) maxWidth = (Bounds (max w maxWidth) h)

minWidthBounds (Bounds w h) maxWidth = (Bounds (min w maxWidth) h)


moveSmear (Smear color label strTopics (Region pt bounds)) newpt =    
    Smear color label strTopics (Region newpt bounds)

-- We have to do a constraint solver, we have to make sure there wasn't already a smear..


layoutSmears smears =
    let getXYL (TopicPlacement x y smear) = (x,y,(smearLength smear))
        conflicts x y [] = False
        conflicts x y (z:zs) =
            let (zx,zy,l) = getXYL z in
            if ((zy == y) && (x >= zx && x < (zx + l))) then True
            else conflicts x y zs
        findSpot oldsmears x y =
            if (conflicts x y oldsmears) 
            then (findSpot oldsmears x (y + 1))
            else (x,y)
        helper oldsmears [] = oldsmears
        helper oldsmears (x:xs) = 
            let (TopicPlacement tx ty smear) = x 
                len = smearLength smear
            in
              --if (conflicts tx ty oldsmears) then                  
              let (nx,ny) = findSpot oldsmears tx 1 in
              helper ((TopicPlacement nx ny smear):oldsmears) xs
              --else
              --    helper (x:oldsmears) xs
    in
      reverse (helper [] smears)
        
emptyTopic plot =
        0 == maximum (map (length . topicWords) $ placementGetTopics plot)

layoutTopicPlot sim (tp,maxcolor,topicmap) =
    let (TopicPlot labels plots) = tp 
        labellen = length labels
        labelmap = array (1,labellen) $ zip [1..labellen] labels 
        filteredPlots = filter (not . emptyTopic) plots
        laidPlots = layoutSmears filteredPlots
        -- I'd like to refactor this because we already do this..
        colordTopics = colorTopics sim laidPlots topicmap
        smears = map (\(color,(TopicPlacement x y smear)) ->
                          convertSmearToDrawObj color ((intToDouble x) * defaultSplotchWidth) ((intToDouble y) * defaultSplotchHeight) "" smear) colordTopics
    in
      smears



countBy elmf l =
    let counter [] = error "Empty List ? WTF?"
        counter (x:xs) = (x,(length (x:xs)))
    in
      map counter $ group $ sort $ map elmf l
            

tupleCompare1 (i,_) (j,_) = compare i j
tupleCompare2 (_,i) (_,j) = compare i j
revTupleCompare2 (_,i) (_,j) = compare j i


tuple1eq (i,_) (j,_) = i == j
tuple2eq (_,i) (_,j) = i == j

mapi f l = map f (zip [1..] l)

-- Scatter Plot
layoutByClass sim (tp,maxcolor,topicmap) =
    let innermapfunc i rgbcolor l =
            map (\(_,(TopicPlacement x y smear)) ->
                     convertSmearToDrawObj rgbcolor 
                       ((intToDouble x) * defaultSplotchWidth) 
                       ((intToDouble i) * defaultSplotchHeight) 
                       "" 
                       smear)
                l
    in    
    genericLayoutByClass innermapfunc sim (tp,maxcolor,topicmap)
    
layoutByClassHistogram sim (tp,maxcolor,topicmap) =
    let innermapfunc i rgbcolor l =
            let (len,lo) = foldl (\(len',l') (_,(TopicPlacement x y smear)) ->
                                 let len = smearLength smear
                                     tlen = len' + len
                                     drobj = convertSmearToDrawObj rgbcolor 
                                             ((intToDouble len') * defaultSplotchWidth) 
                                             ((intToDouble i) * defaultSplotchHeight)
                                             ""
                                             smear
                                     ol = drobj:l'
                                 in
                                   (tlen,ol))
                                (1,([] :: [DrawObj]))
                                l
            in
              reverse lo
    in    
    genericLayoutByClass innermapfunc sim (tp,maxcolor,topicmap)

-- This orders counts of Colors from LARGEST to SMALLEST
-- countColors is CountID (Int) mapped to a count (Int) we return a map of Int -> (color)
colorOrderFromCounts ::  [(Int,Int)]-> [Int]
colorOrderFromCounts countedColors =
    let sortedColorCount = sortBy  revTupleCompare2 countedColors
        colorOrder :: [Int]
        colorOrder = map fst sortedColorCount
    in
      colorOrder

randomColors = (r,g,b) where
        r = randoms   (mkStdGen 69534)
        b = randoms  (mkStdGen 33432)
        g = randoms (mkStdGen 54392)

-- This is a color function it maps topics & topic counts to colors
-- countColors is CountID (Int) mapped to a count (Int) we return a map of Int -> (color)
randomColorMap :: [(Int,Int)] -> Map Int Color
randomColorMap countedColors =
    let colorOrder = colorOrderFromCounts countedColors 
        (r,g,b)    = randomColors
        colormap   = Map.fromList $ zip colorOrder (zip3 r g b)
    in
      colormap

-- This is a color function it maps topics & topic counts to colors
-- it is like randomColorMap EXCEPT it colors other topics a default color
-- unless they are a trend
-- countColors is CountID (Int) mapped to a count (Int) we return a map of Int -> (color)
randomColorMapForTrendsOnly :: Color -> [(Int,Int)] -> Map Int Color
randomColorMapForTrendsOnly defaultColor countedColors =
    let colorOrder = colorOrderFromCounts countedColors 
        countMap = Map.fromList countedColors
        (r,g,b)    = randomColors
        cl = map (\(c,color) -> 
                      let cnt = (Map.!) countMap c  
                          newcolor = if (cnt > 1) 
                                     then color 
                                     else defaultColor
                      in
                        (c,newcolor)
                 ) $ zip colorOrder (zip3 r g b)
        colormap = Map.fromList cl
    in
      colormap

-- Default color of medium grey
greyRandomColorMapForTrendsOnly = randomColorMapForTrendsOnly (0.9, 0.9, 0.9)


genericLayoutByClass innermapfunc sim (tp,maxcolor,topicmap) =
    let (TopicPlot labels unfilteredplots) = tp 
        plots = filter (not . emptyTopic) unfilteredplots
        labellen = length labels
        (classPlacement, colorToTopic) = getTopicColorsAndColorTopTopic topicmap plots
        -- classPlacement = zip (map (topicColorOfPlacement topicmap) plots) plots
        -- colorToTopic = map (\x -> ((topicColor topicmap x),x)) (concatMap placementGetTopics plots)
        sortedByColor = sortBy tupleCompare1 classPlacement
        groupedByColor = groupBy tuple1eq sortedByColor
        tupledGBC = map (\x -> case x of
                                 (color,_):xs -> (color,x)
                                 _ -> error "Unknown input in tupledGBC")
                        groupedByColor
        -- This is color NAME (partition) mapped to the entities
        gbsmap = Map.fromList tupledGBC
        -- (color,count)
        countedColors = countBy fst colorToTopic
        colormap = greyRandomColorMapForTrendsOnly
                   -- randomColorMap 
                   countedColors
        colorOrder = colorOrderFromCounts countedColors
        -- sortedColorCount = sortBy  revTupleCompare2 countedColors
        -- colorOrder :: [Int]
        -- colorOrder = map fst sortedColorCount
        -- this N^2 because I don't care enough right now
        -- could easier be N with a color array
        -- colorlists = map (\c -> [x | x <- colorToTopic, fst x == c]) colorToTopic
        -- r = randoms   (mkStdGen 69534)
        -- b = randoms  (mkStdGen 33432)
        -- g = randoms (mkStdGen 54392)
        -- colormap = Map.fromList $ zip colorOrder (zip3 r g b)
    in
      concat $ mapi (\(i,color) -> 
                     let l = (Map.!) gbsmap color 
                         rgbcolor = (Map.!) colormap color
                     in
                       innermapfunc i rgbcolor l)
                    colorOrder 
                     




-- clever but will we use it?
-- data LinOp = Translate Point LinOp | Scale Double Double LinOp | LinNop
-- centerScaleXYwithAspect (x,y,xx,yy) w h =
--     let sfactor = (xx - x)/(yy - y)
--         ssfactor = w / h
--         scale = sfactor / ssfactor
--     in
--       (Scale scale scale (Translate (Point (-1 * x) (-1 * y)) LinNop))

-- Should return a tuple..
getFontExtents :: Double -> [String] -> [Bounds]
getFontExtents size strings = map (fontSize Sans size) strings

-- stupid hack because cairo can't give us font details!
data Fonts = Sans
fontSize :: Fonts -> Double -> String -> Bounds
fontSize Sans size string = Bounds (0.6 * size * (intToDouble (length string))) (size * 1.2)
fontHeight Sans size = 1.2 * size 






--        let (TopicPlot labels unfilteredplots) = tp 
--            plots = filter (not . emptyTopic) unfilteredplots
--            classPlacement = zip (map (topicColorOfPlacement topicmap) plots) plots
--            colorToTopic = map (\x -> ((topicColor topicmap x),x)) (concatMap placementGetTopics plots)
--            -- (color,count)
--            countedColors = countBy fst colorToTopic
--            colormap = randomColorMap countedColors

-- This is a block of shared code I pulled out. This code zip's a bunch
-- of topicPlacements against the topicColor (an integer representing
-- an equiviliance class of topics), it returns that, AND it returns
-- a colorToTopic map which has all of your topics, but they are associated
-- with a color I think so it can be counted and then mapped.

getTopicColorsAndColorTopTopic topicmap placements =
    let 
        ztopics = zip (map (topicColorOfPlacement topicmap) placements) placements
        colorToTopic = map (\x -> ((topicColor topicmap x),x)) (concatMap placementGetTopics placements)
    in
      (ztopics, colorToTopic)


-- Try to include counts in here
colorTopics sim placements topicmap =
    let -- reds = randoms   (mkStdGen 69534)
        -- blues = randoms  (mkStdGen 33432)
        -- greens = randoms (mkStdGen 54392)
        (ztopics, colorToTopic) = getTopicColorsAndColorTopTopic topicmap placements 
        countedColors = countBy fst colorToTopic
        colormap = greyRandomColorMapForTrendsOnly
                   -- randomColorMap 
                   countedColors
        colorfun i = (Map.!) colormap i


        --    len = length placements
        --    ztopics = zip [1..len] placements
        --    
        --    simf (_,t1) (_,t2) = (tpSimilarity t1 t2) >= sim
        --    -- this is simply enumerating topics
        --    -- have we seen it before
        --    -- this effectively colors the topics?
        --    mapping = foldr (\(i,x) olist ->
        --                     case (Data.List.find (simf (i,x)) olist) of
        --                       Nothing -> ((i,x) : olist)
        --                       Just (j,y) -> ((j,x) : olist))
        --                    [] ztopics
        --    countedColors = countBy fst mapping
        --    colormap = randomColorMap countedColors
        --    colorfun i = (Map.!) colormap i
        
        -- maxmap = maximum (map fst mapping)
        -- (r:g:b:_) = map (take maxmap) [reds, greens, blues]
        -- rgbs = zip3 r g b
        -- irgbs = zip [1..maxmap] rgbs
        -- argbs = array (1,maxmap) irgbs
        -- oldcolorfun i = argbs!i
    in
      -- map (\(i,m) -> ((colorfun i),m)) mapping
      map (\(i,m) -> ((colorfun i),m)) ztopics

