module Lda_report where
import System.IO
import Data.List
import Char
import Monad
import Array
import Graphics.Rendering.Cairo
import qualified Graphics.Rendering.Cairo.Matrix as M
import Lda_parser
import Lda_layout
import EqClass
import Data.Map (Map)
import qualified Data.Map as Map
import Control.Concurrent
import Control.Parallel
import Control.Parallel.Strategies

textBounds (TextExtents _ _ w h _ _) = (w, h)

replaceChar l c r = map (\x -> if (x == c) then r else x) l

drawText size str x y = do
  lineWidth <- getLineWidth
  setFontSize  size
  stroke
  moveTo x y
  textPath str
  setSourceRGBA 0 0 0 1 -- text
  fillPreserve
  setSourceRGBA 0 0 0 0.5 -- text outline
  setLineWidth 0.5 -- linewidth
  stroke
  return ()

  

drawTopics :: String -> [String] -> Double -> Double -> Render ()
drawTopics text topics x y = do
  save

  lineWidth <- getLineWidth
  setFontSize  bigTopicFontSize
  bigextents <- fontExtents             
  setFontSize  tinyTopicFontSize
  tinyextents <- fontExtents             

  let bigfontHeight = fontExtentsHeight bigextents
  let tinyfontHeight = fontExtentsHeight tinyextents

  (TextExtents xb yb w h _ _) <- textExtents text
  setFontSize tinyTopicFontSize
  textExtentsMonads <- mapM textExtents topics
  let extents = map textBounds textExtentsMonads
  let (topicw,topich) = if (extents == []) 
                        then (0,0) 
                        else foldlOnFirst (\(w,h) (mw,mh) -> ((max mw w),(max mh h))) extents
  let tlen = length topics


  rectangle (x + xb - lineWidth)
                  (y + yb - lineWidth)
                  (w + topicw + 5 * lineWidth)
                  ((max h ((fromInteger (toInteger tlen)) * topich)) + 2 * lineWidth)
  stroke
  moveTo x y
  setFontSize  bigTopicFontSize
  textPath text
  setSourceRGBA 0 0 0 1 -- text
  fillPreserve
  setSourceRGBA 0 0 0 0.5 -- text outline
  setLineWidth 3.0
  stroke
                 
  setFontSize tinyTopicFontSize
  let sx = x + 3 * lineWidth + w 
  let sy = y - h
  let drawTinyTopic (y,word) = do
                               moveTo sx (sy + y)
                               textPath word
                               setSourceRGBA 0 0 0 1
                               fillPreserve
                               setLineWidth 0.5               
                               stroke
                               return ()

  Monad.sequence_ (map (\(i,word) -> drawTinyTopic ((topich * ((fromInteger (toInteger i)))),word)) (zip [1..tlen] topics))
  restore
          
drawRotatedTopics xoff yoff text topics x y = do
  save
  translate xoff yoff
  rotate (-90.0 * pi / 180.0)
  drawTopics text topics x y 
  restore


boxText :: String -> Double -> Double -> Render ()
boxText text x y = do
  save

  lineWidth <- getLineWidth

  (TextExtents xb yb w h _ _) <- textExtents text

  rectangle (x + xb - lineWidth)
            (y + yb - lineWidth)
            (w + 2 * lineWidth)
            (h + 2 * lineWidth)
  stroke
  moveTo x y
  textPath text
  setSourceRGBA 0 0 0 1 -- text
  fillPreserve
  setSourceRGBA 0 0 0 0.5 -- text outline
  setLineWidth 3.0
  stroke

  restore
          

drawBox x y w h (r,g,b) = do
  save
  lineWidth <- getLineWidth
  rectangle (x - lineWidth)
            (y - lineWidth)
            (w + 2 * lineWidth)
            (h + 2 * lineWidth)
  setSourceRGBA r g b 1 
  fillPreserve
  stroke
  restore

drawRectangle x y w h (r,g,b) = do
  save
  lineWidth <- getLineWidth
  rectangle (x - lineWidth)
            (y - lineWidth)
            (w + 2 * lineWidth)
            (h + 2 * lineWidth)
  setSourceRGBA r g b 1 
  stroke
  restore



-- make a transparent surface (stolen from Text.hs)
transpSurface :: Double -> Double -> Render ()
transpSurface w h = do
  save
  rectangle 0 0 w h
  setSourceRGBA 1 1 1 1
  setOperator OperatorSource
  fill
  restore
       


drawTest width height = 
    -- withImageSurface FormatARGB32 width height $ \surface -> do
    withSVGSurface "Text.svg" width height $ \surface -> do
      renderWith surface $ do
        setSourceRGB 0.0 0.0 0.0
        setLineWidth 2.0        

        transpSurface width height

        selectFontFace "sans" FontSlantNormal FontWeightNormal
        setFontSize 40

        extents <- fontExtents

        let fontHeight = fontExtentsHeight extents

        -- boxText "Howdy, world!" 10 fontHeight
        -- Monad.sequence_ (map (\y -> boxText (show y) 0 (y*fontHeight)) [1..10])
        drawTopics "LOL" ["1 HYH", "2 LOL", "3 WHAT", "4 ZUH"] 40 40 
        

      --surfaceWriteToPNG surface "Text.png"

      return ()

-- main = drawTest 800 600

data FileType = SVG | PNG

-- drawOnCanvas :: FileType -> String -> Int -> Int -> (() -> Render ()) -> [a]
drawOnCanvas SVG filename width height f = 
    withSVGSurface filename   width  height $ \surface -> do
      renderWith surface $ do
        setSourceRGB 0.0 0.0 0.0
        setLineWidth 2.0        
        transpSurface width height
        selectFontFace "sans" FontSlantNormal FontWeightNormal
        setFontSize 40
        f

      --surfaceWriteToPNG surface "Text.png"
      return ()

drawOnCanvas PNG filename width height f = 
    withImageSurface FormatARGB32 (floor width) (floor height) $ \surface -> do
      renderWith surface $ do
        setSourceRGB 1.0 1.0 1.0
        setLineWidth 2.0        
        transpSurface width height
        selectFontFace "sans" FontSlantNormal FontWeightNormal
        setFontSize 40
        f

      surfaceWriteToPNG surface filename
      return ()

drawMatrixTopic lda = do
    let matrix = matrixTopic lda
    let colorfun x = (x,x,x)
    let apply3 f (a,b,c) = f a b c
    let topics  = topicsWindowsToListofTopicsWithIds lda
    let n = length topics

    save
    scale 0.1 0.1
    setFontSize bigTopicFontSize
    extents <- fontExtents
    let fontHeight = fontExtentsHeight extents
    let boxheight = 3 * fontHeight
    let boxwidth = boxheight
    let yoff = 350
    let xoff = 300
    let rotyoff = 400
    -- draw topics
    let drawIt xoff yoff f =  Monad.sequence_ (map (\(i,(time,topics)) -> 
                              f ((show i) ++ ": " ++ time)
                                topics (xoff + 0) (yoff + 3 * fontHeight * (fromInteger (toInteger i))))
                         (zip [1..n] topics))
    drawIt 0 yoff drawTopics
    -- draw sideways topics
    drawIt 0 0 (drawRotatedTopics xoff rotyoff)
    let (_,firstTopic) = x where (x:xs) = topics
    let matacc x y = (matrix!x)!y
    --drawRotatedTopics "TEST400" firstTopic 400 400
    --drawRotatedTopics "TEST00" firstTopic 0 0 

    -- NOW WE DRAW THE MATRIX!!!
   
    let elms = [(i,j) | i <- [1..n], j <- [1..n]]
    Monad.sequence_ (map (\(x,y) -> drawBox 
                                      (xoff + (fromIntegral x) * boxwidth)     
                                      (yoff + (fromIntegral y) * boxheight)                   
                                      boxwidth                   
                                      boxheight                    
                                      (colorfun (fromRational (matacc x y)))) 
                         elms)


    restore

    

plotMatrixTopicTest width height = do 
  l <- parseLDAFile "lda.report"
  drawOnCanvas PNG "plotmatrix.png" width height (drawMatrixTopic l)

-- data TopicPlotInstance = TopicSmear [Topic [string]] | TopicSplotch (Topic [string])
-- -- the X coord and the Y coord
-- data TopicPlacement = TopicPlacement Int Int TopicPlotInstance
-- data TopicPlot = TopicPlot labels [TopicSmears]
-- 
-- smearFinder lda =
--     let topics  = topicsWindowsToListofTopicsWithIds lda
--     let matrix = matrixTopic lda
--     let topicPlot = TopicPlot labels smears where
--             labels = map getTime lda
--             initSmears = 
--         
-- 
--                
-- main = plotMatrixTopicTest 4000 4000

-- stupid text on top
drawObj xoff yoff (DrawString str size (Point x y) (Bounds w h)) = drawText size str (xoff+x) (y+yoff + h)

drawObj xoff yoff (Translate obj pt@(Point x y)) =
    drawObj (xoff+x) (yoff+y) obj    

drawObj xoff yoff (Label label (Point x y) (Bounds w h)) = do
  let (rx,ry) = (x + xoff, y + yoff)
  let black = (0,0,0)
  drawRectangle rx ry w h black
  drawObj (xoff+x) (yoff+y) label
  return ()

drawObj xoff yoff (DTopic topics (Region (Point x y) (Bounds w h))) = do
  let (rx,ry) = (x + xoff, y + yoff)
  Monad.sequence_ $ map (drawObj rx ry) topics
  return ()

drawObj xoff yoff (Box color (Region (Point x y) (Bounds w h))) = do
  save
  let (rx,ry) = (x + xoff, y + yoff)
  let black = (0,0,0)
  drawBox rx ry w h color
  drawRectangle rx ry w h black
  restore




drawObj xoff yoff (Smear color label topics (Region (Point x y) (Bounds w h))) = do
  save
  let (rx,ry) = (x + xoff, y + yoff)
  let black = (0,0,0)
  -- let red = (1,0,0)
  -- let blue = (0,0,1)
  -- let green = (0,1,0)
  -- let len = 6
  -- let colors = array (1,len) [(1,red),(2,blue),(3,green),(4,(1,1,0)),(5,(1,0,1)),(6,(0,1,1))]
  -- let ch = colorHash ((show rx)++(show xoff)++(show yoff)++(show x)++(show y))
  -- drawBox rx ry w h (colors!(1 + (mod ch len)))
  drawBox rx ry w h color
  drawRectangle rx ry w h black
  drawObj rx ry label
  Monad.sequence_ (map (drawObj rx ry) topics)
  restore

colorHash x =
    let helper h [] = h + (div h 32)
        helper h (x:xs) =
            helper (h * 33 + (Char.ord x)) xs
    in
      helper 0 x

    



drawTimeSmearPlot w h tp plotElements = do
  let (TopicPlot labels smears) = tp 
  save
  setFontSize bigTopicFontSize
  Monad.sequence_ $ map (drawObj 0 0) plotElements
  Monad.sequence_ $ map (\(x,label) -> drawObj 0 0 
                                    (mkLabel label ((intToDouble x) * defaultSplotchWidth)   0)) $
                      zip [1..(length labels)] labels
  restore

testBucketLDA () = do
  l <- parseLDAFile "lda.report"
  let sim = 7/10     
  let smearplot = smearFinder l
  let (TopicPlot labels smears) = smearplot
  let topics = concatMap placementGetTopics smears        
  let (maxcolors,topicmap) = getEqClasses (minTopicSimilarity sim)  topics
        --placements = smearFinder topicmap labels smears
  let   placements = bucketify topicmap labels smears
  putStrLn (show (length (placements!!0)))
  putStrLn (show (placements!!0))
  return ()

testLoadLDA () = do
  l <- parseLDAFile "lda.report"
  let sim = 7/10     
  let smearplot = smearFinder l
  let (tp,_,topicmap) = processSmearPlot sim smearplot
  let (TopicPlot labels smears) = tp
  let subsmears = [ x | x <- smears, (topicPlacementX x) == 1]
  let subsubsmears1 = [ (x,y) | x <- subsmears, y <- subsmears, (not (x == y)), ((tpSimilarity x y) >= sim) ]
  let subsubsmears2 = [ (x,y) | x <- subsmears, y <- subsmears, (not (x == y)), (placementIsSim topicmap x y)  ]
  let easyout1 = map (\(x,y) -> ((topicPlacementY x),(topicPlacementY y))) subsubsmears1
  let easyout2 = map (\(x,y) -> ((topicPlacementY x),(topicPlacementY y))) subsubsmears2
  return ((easyout1 \\ easyout2),(easyout2 \\ easyout1),(length easyout1),(length easyout2))


strOfRational sim = replaceChar (show sim) ' ' '_'

plotSmears sim = genericPlotSmears sim layoutTopicPlot --(\sim (tp,maxcolor,topicmap) -> layoutTopicPlot sim (tp,maxcolor,topicmap)
                  ("time-smear-plot-" ++ (strOfRational sim) ++ ".png")
                
plotSmearClass sim = genericPlotSmears sim layoutByClass 
                       ("class-smear-plot-" ++ (strOfRational sim)  ++ ".png")

plotSmearClassHistogram sim = genericPlotSmears sim layoutByClassHistogram 
                               ("histogram-smear-plot-"++(strOfRational sim) ++ ".png")


genericPlotSmears:: Rational -> (Rational -> (TopicPlot, Int, Map Topic Int) -> [DrawObj]) -> String -> IO ()
genericPlotSmears sim f fileout = do
      l <- parseLDAFile "lda.report"
      --let sim = 7/10 
      let plda = processLDA sim l
      let (tp,maxcolor,topicmap) = plda
      let (TopicPlot labels smears) = tp
      let plotElements = f sim plda
      let (Region _ (Bounds width' height')) = enclosingRegion plotElements
      -- let width = 4000
      -- let height = 4000
      let width = min width' width' -- 10000
      let height = min height' 16000
      drawOnCanvas PNG fileout (width + defaultSplotchWidth) (height + defaultSplotchHeight) $ 
                       drawTimeSmearPlot width height tp plotElements


testData1 = let l1 = (map (\i -> 
                               let di = intToDouble i in
                               DrawString ("STR:"++(show di)) di (Point (100.0 * di) (100.0 * di)) (Bounds 0 0))
                      [1..40])
                l2 =  (map (\i -> let di = intToDouble i in
                         --Label (convertTextToDrawObj 0 0 di ("LABEL"++(show di))) (Point (50* di) (200* di)) (Bounds 0 0))
                         mkLabel ("LABEL"++(show di))  (50* di) (200* di))
                       [1..40])
                l3 = (map (\i -> let di = intToDouble i in
                        convertTopicTextToTopic (200*di) (50*di) (map (\i -> "topic:"++(show i)) [i..(i+5)]))
                      [1..40])
                l4 = (map (\i -> let di = intToDouble i in
                        convertSmearToDrawObj (0.0,1.0,0.0) (50*di) (4000 - 100 * di) "S" (TopicSplotch (Topic (map show [1..5]))))
                      [1..20])
                
                l5 = (map (\i -> let di = intToDouble i in
                                 convertSmearToDrawObj (1.0,0.0,0.0) (50*di) (4000 - 100 * di) "S" (TopicSmear (1 + (mod i 3)) (map (\i -> Topic (map show [1..5])) [1..(2+(mod (i+2) 3))])))
                      [20..40])
            in
              l1 ++ l2 ++ l3 ++ l4 ++ l5

testDrawObjs testData = do
  let width = 4000
  let height = 4000
  drawOnCanvas PNG "test-plot.png" width height $ 
               do
                 save
                 Monad.sequence_ $ map (drawObj 0 0) testData
                 restore
           
-- main = plotSmears ()
lda_report_main = do
  -- testDrawObjs testData1
  Monad.mapM_ 
           (\sim -> do
              (putStrLn (show sim))
              (plotSmears sim)     
              (plotSmearClass sim) 
              (plotSmearClassHistogram sim)
              return ()
           )
           (reverse [x/10 | x <- [1..10]])

defaultSurfaceSetup width height = do
        setSourceRGB 0.0 0.0 0.0
        setLineWidth 2.0        
        transpSurface width height
        selectFontFace "sans" FontSlantNormal FontWeightNormal
        setFontSize bigTopicFontSize
    
-- Maybe we have to eval f in some way
runInTempSurface f = do
  v <- renderWithSimilarSurface ContentAlpha 200 200 $ \tmpSurface -> do
                       res <- renderWith tmpSurface $ do
                                defaultSurfaceSetup 200 200;
                                res <- f ()
                                return res
                       return res
  return v

plotSomeObjs fileType outFilename objs = do
      let (Region _ (Bounds width' height')) = enclosingRegion objs
      -- let width = min width' 10000
      let width = width'
      let height = min height' 10000
      drawOnCanvas fileType outFilename width height $
                   do
                     save
                     Monad.sequence_ $ map (drawObj 0 0) objs
                     restore


-- Fuck Monads
--   IO Monad never exits, either we do everything monadically..
--     Or we don't
-- getFontExtents size strings = do
--     let f () = do
--           setFontSize size
--           textExtentsMonads <- mapM textExtents strings
--           let extents = map textBounds textExtentsMonads
--           setFontSize bigTopicFontSize
--           return extents
--     -- stupid monads..
--     l <- runInTempSurface f
--     return ll

-- Notes: getting font size is a pain in the butt
--        it might be really slow. so may be we should care..
--        it'd be nice to memoize it all but maybe haskell does
