{-# LANGUAGE BangPatterns, MagicHash #-}
{-# OPTIONS -fvia-C -fexcess-precision #-}
--
-- The Computer Language Benchmarks Game
-- http://shootout.alioth.debian.org/
--
-- Translation from Clean by Don Stewart
-- Modified by Ryan Trinkle: 1) change from divInt# to uncheckedIShiftRA#
--                           2) changed -optc-O to -optc-O3
--                           3) added -optc-ffast-math
-- Parallelised by Don Stewart
--
-- Should be compiled with:
--      -O2 -threaded --make
--      -optc-O2 -optc-march=native -optc-mfpmath=sse -optc-msse2 -optc-ffast-math
--

import System
import Foreign.Marshal.Array
import Foreign
import Text.Printf
import Control.Monad
import Data.ByteString.Internal

import GHC.Base
import GHC.Float
import GHC.Int

import Control.Concurrent
import Control.Exception

type Reals = Ptr Double

main = do
    n <- getArgs >>= readIO . head

    u <- mallocArray n :: IO Reals
    forM_ [0..n-1] $ \i -> pokeElemOff u i 1
    v <- mallocArray n :: IO Reals
    forM_ [0..n-1] $ \i -> pokeElemOff v i 0

    powerMethod 10 n u v
    printf "%.9f\n" (eigenvalue n u v 0 0 0)

------------------------------------------------------------------------

eigenvalue :: Int -> Reals -> Reals -> Int -> Double -> Double -> Double
eigenvalue !n !u !v !i !vBv !vv
    | i < n     = eigenvalue n u v (i+1) (vBv + ui * vi) (vv + vi * vi)
    | otherwise = sqrt $! vBv / vv
    where
       ui = inlinePerformIO (peekElemOff u i)
       vi = inlinePerformIO (peekElemOff v i)

------------------------------------------------------------------------

powerMethod :: Int -> Int -> Reals -> Reals -> IO ()
powerMethod i n u v = do
    -- roll our own synchronisation
    children <- newMVar []
    replicateM_ i $ do
        me <- newEmptyMVar
        cs <- takeMVar children
        putMVar children (me : cs)
        forkIO (child `finally` putMVar me ())
    wait children
  where
    child = allocaArray n $ \t -> timesAtAv t n u v >> timesAtAv t n v u

    -- wait on children
    wait box = do
      cs <- takeMVar box
      case cs of
        []   -> return ()
        m:ms -> putMVar box ms >> takeMVar m >> wait box

-- multiply vector v by matrix A and then by matrix A transposed
timesAtAv :: Reals -> Int -> Reals -> Reals -> IO ()
timesAtAv !t !n !u !atau = do
    timesAv  n u t
    timesAtv n t atau

timesAv :: Int -> Reals -> Reals -> IO ()
timesAv !n !u !au = go 0
  where
    go :: Int -> IO ()
    go !i = when (i < n) $ do
        pokeElemOff au i (avsum i 0 0)
        go (i+1)

    avsum :: Int -> Int -> Double -> Double
    avsum !i !j !acc
        | j < n = avsum i (j+1) (acc + ((aij i j) * uj))
        | otherwise = acc
        where uj = inlinePerformIO (peekElemOff u j)

timesAtv :: Int -> Reals -> Reals -> IO ()
timesAtv !n !u !a = go 0
  where
    go :: Int -> IO ()
    go !i = when (i < n) $ do
        pokeElemOff a i (atvsum i 0 0)
        go (i+1)

    atvsum :: Int -> Int -> Double -> Double
    atvsum !i !j !acc
        | j < n     = atvsum i (j+1) (acc + ((aij j i) * uj))
        | otherwise = acc
        where uj = inlinePerformIO (peekElemOff u j)

--
-- manually unbox the inner loop:
-- aij i j = 1 / fromIntegral ((i+j) * (i+j+1) `div` 2 + i + 1)
--
aij (I# i) (I# j) = D# (
    case i +# j of
        n -> case n *# (n+#1#) of
                t -> case t `uncheckedIShiftRA#` 1# of
                        u -> case u +# (i +# 1#) of
                                r -> 1.0## /## (int2Double# r))

