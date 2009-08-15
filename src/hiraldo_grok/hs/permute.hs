-- 
--             DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
--                     Version 2, December 2004
-- 
--  Copyright (C) 2009 Abram Hindle
--  Everyone is permitted to copy and distribute verbatim or modified
--  copies of this license document, and changing it is allowed as long
--  as the name is changed.
-- 
--             DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
--    TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
-- 
--   0. You just DO WHAT THE FUCK YOU WANT TO. 
-- 
-- This program is free software. It comes without any warranty, to
-- the extent permitted by applicable law. You can redistribute it
-- and/or modify it under the terms of the Do What The Fuck You Want
-- To Public License, Version 2, as published by Sam Hocevar. See
-- http://sam.zoy.org/wtfpl/COPYING for more details. */

module Permute where 
import System.Random
import qualified Data.Map as Map

-- Taken from
-- http://en.wikipedia.org/wiki/Fisher-Yates_shuffle

--     public static void shuffle (int[] array) 
--     {
--         Random rng = new Random();   // i.e., java.util.Random.
--         int n = array.length;        // The number of items left to shuffle (loop invariant).
--         while (n > 1) 
--         {
--             int k = rng.nextInt(n);  // 0 <= k < n.
--             n--;                     // n is now the last pertinent index;
--             int temp = array[n];     // swap array[n] with array[k] (does nothing if k == n).
--             array[n] = array[k];
--             array[k] = temp;
--         }
--     }


-- Given a seed, permute the list l 
permuteList seed l = map snd $ loop len dm rl
    where len = length l 
          rl   = randoms (mkStdGen seed)
          indexed_list = zip [0..] l
          dm = Map.fromAscList indexed_list
          -- this is basically a fold that decrements n each time
          -- and pops a new random number off the random list 
          loop n dm rl = 
              if (n > 1) 
              then let r' = mod (head rl) n  -- danger
                       (Just x) = Map.lookup (n - 1) dm
                       (Just y) = Map.lookup r' dm
                       dm' = Map.insert (n - 1) y (Map.insert r' x dm) in
                   loop (n - 1) dm' (tail rl)
              else Map.toAscList dm

    
                   
