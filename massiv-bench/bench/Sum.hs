{-# LANGUAGE BangPatterns     #-}
module Main where

import           Criterion.Main
import           Data.Massiv.Array as A
import           Data.Massiv.Bench as A
import           Prelude           as P



main :: IO ()
main = do
  let !sz = 1600 :. 1200
  defaultMain
    [ bgroup
        "Sum"
        [ env (return (arrRLightIx2 U Seq sz)) $ \arr ->
            bgroup
              "Seq"
              [ bench "foldlS" $ whnf (A.foldlS (+) 0) arr
              , bench "foldrS" $ whnf (A.foldrS (+) 0) arr
              , bench "sum" $ whnf A.sum arr
              , bench "foldlS . foldlWithin Dim2" $ whnf (A.foldlS (+) 0 . foldlWithin Dim2 (+) 0) arr
              , bench "foldlS . foldlInner" $ whnf (A.foldlS (+) 0 . foldlInner (+) 0) arr
              ]
        , env (return (arrRLightIx2 U Par sz)) $ \arr ->
            bgroup
              "Par"
              [ bench "foldlP" $ whnfIO (A.foldlP (+) 0 (+) 0 arr)
              , bench "foldrP" $ whnfIO (A.foldrP (+) 0 (+) 0 arr)
              , bench "sum" $ whnf A.sum arr
              , bench "foldlS . foldlWithin Dim2" $
                whnfIO (A.foldlP (+) 0 (+) 0 $ foldlWithin Dim2 (+) 0 arr)
              , bench "foldlS . foldlInner" $
                whnfIO (A.foldlP (+) 0 (+) 0 $ foldlInner (+) 0 arr)
              ]
        ]
    ]
