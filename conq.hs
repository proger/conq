{-# LANGUAGE OverloadedStrings #-}

import Control.Concurrent
import Control.Monad
import Control.Exception

import GHC.Conc (labelThread)
import Data.IORef
import System.Mem.Weak

import System.Posix.Signals
import System.Remote.Monitoring

-- import GHC.Stats (getThreadStats)
getThreadStats = return Nothing :: IO (Maybe ())

dumbloop' = forever $ threadDelay 1000000
dumbloop = (newEmptyMVar >>= takeMVar) `finally` (putStr "#")
forkDumbIO = forkIO dumbloop >>= \tid -> labelThread tid "dumb" >> print tid >> return tid

bomb = mapM (\_ -> forkDumbIO) [1..]

start = do
    forkServer "localhost" 5555
    tids <- replicateM 200 forkDumbIO
    getThreadStats >>= print
    return tids
 

main = do
    tref <- (newIORef [] :: IO (IORef [ThreadId]))
    threads' <- start >>= evaluate
    writeIORef tref threads'
    weaks <- mapM mkWeakThreadId threads'

    wkt <- mkWeakIORef tref $ do
        putStrLn "IOREF DIED BITCH"

    readIORef tref >>= print

    awaitSignal $ Just $ addSignal keyboardTermination emptySignalSet
    yield
