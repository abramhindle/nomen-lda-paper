module EqClass where
import Data.Graph
import Data.Map
import Data.Set
import Array

--
-- ** Labnotes <2008-11-12 Wed 00:10> Global versus local comparison?     :smearer:
--    I think there's some problem with the algorithm, there might be a difference between local
--    comparison and global. Maybe pre-coloring would be a better idea, where topics are
--    globally compared to each, equivilence classes found and then maybe it'll be easier
--    to find smears
--  So we're here to find equivilance classes where if you are reachable (like a fill flood)
--  you are color'd the same

-- notes: reachable means itself and itschildren and their children

-- getEqClasses:: (a -> a -> Bool) -> [a] -> [[a]]
-- getEqClasses simf elms =
reachableFromRoot simf elms =
    let len = length elms
        simftuple (_,x) (_,y) = simf x y                                
        enumelms = zip [1..len] elms
        simlist = Prelude.map (\(i,elm) -> (i,elm,(Prelude.filter (simftuple (i,elm)) enumelms))) enumelms
        -- simlist = [ (elm,sims) | elm <- enumelms, sims <- (filter (simftuple elm) enumelms) ] -- could be smarter, do we care?
        edgelist = concatMap (\(i,_,ls) -> 
                                  Prelude.map (\(j,_) -> (i,j)) ls) simlist
        graph = Data.Graph.buildG (1,len) edgelist
    in
      reachable graph 1


getEqClasses:: Ord a => (a -> a -> Bool) -> [a] -> (Int,(Data.Map.Map a Int))
getEqClasses simf elms =
    let len = length elms
        simftuple (_,x) (_,y) = simf x y                                
        enumelms = zip [1..len] elms
        elmarray = array (1,len) enumelms
        simlist = Prelude.map (\(i,elm) -> (i,elm,(Prelude.filter (simftuple (i,elm)) enumelms))) enumelms
        -- simlist = [ (elm,sims) | elm <- enumelms, sims <- (filter (simftuple elm) enumelms) ] -- could be smarter, do we care?
        halflist = concatMap (\(i,_,ls) -> 
                                  Prelude.map (\(j,_) -> (i,j)) ls) simlist
        edgelist = halflist ++ (Prelude.map (\(i,j) -> (j,i)) halflist)
        graph = Data.Graph.buildG (1,len) edgelist
        (s,partitions) = foldl (\(s,xs) x ->
                                if (Data.Set.member x s) 
                                then (s,xs)
                                else (let reached = Data.Graph.reachable graph x
                                          rl = reached:xs
                                          newset = Data.Set.union s (Data.Set.fromList reached)
                                      in
                                        (newset,rl)))
                           (Data.Set.empty,[])
                           [1..len]

        coloredpartitions = zip [1..] partitions
        dlist = concatMap (\(color,elms) ->
                               Prelude.map (\elmindex ->
                                            let elm = elmarray Array.! elmindex in
                                            (elm,color)) 
                               elms) coloredpartitions
        dmap = Data.Map.fromList dlist
      in
        ((length coloredpartitions), dmap)


        
eqClassTest = reachableFromRoot (\x y -> x < y && x + 2 >= y) [1..10]
    
eqClassTestEq = getEqClasses (\x y -> 
                           if (x >= 5 && y >= 5) then x < y
                           else if (x < 5 && y < 5) then x < y
                           else False
                      ) [1..20]
    