{-# LANGUAGE OverloadedStrings #-}

import Control.Concurrent
import Control.Monad
import Control.Exception

import GHC.Conc (labelThread)

import System.Remote.Monitoring

dumbloop = forever $ threadDelay 10000000 >> dumbloop
forkDumbIO = forkIO dumbloop >>= \tid -> labelThread tid "dumb" >> print tid >> return tid

bomb = mapM (\_ -> forkDumbIO) [1..]

main = do
     forkServer "localhost" 5555
     replicateM 200 forkDumbIO
     dumbloop
