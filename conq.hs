{-# LANGUAGE OverloadedStrings #-}

import Control.Concurrent
import Control.Monad

import System.Remote.Monitoring

forkDumbIO = newEmptyMVar >>= \mv -> forkIO (takeMVar mv >> yield) >>= print

bomb = mapM (\_ -> forkDumbIO) [1..]

main = do
     forkServer "localhost" 5555
     bomb
