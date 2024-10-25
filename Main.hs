{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

import Web.Scotty
import Control.Monad.IO.Class (liftIO)
import Control.Concurrent.MVar (newMVar, withMVar, MVar)
import Control.Exception (catch, IOException)
import Data.Aeson (FromJSON, ToJSON, decode)
import GHC.Generics (Generic)
import System.IO (withFile, IOMode(AppendMode, WriteMode), hPutStr)

taskFilePath :: FilePath
taskFilePath = "tasks.txt"

type FileLock = MVar ()

loadTasks :: FileLock -> IO [String]
loadTasks lock = withMVar lock $ \_ -> do
    contents <- Control.Exception.catch (readFile taskFilePath) handleReadError
    return (lines contents)
  where
    handleReadError :: IOException -> IO String
    handleReadError _ = return []

addTask :: FileLock -> String -> IO ()
addTask lock task = withMVar lock $ \_ -> do
    withFile taskFilePath AppendMode $ \handle -> do
        hPutStr handle (task ++ "\n")

data Task = Task { task :: String } deriving (Show, Generic)

instance FromJSON Task
instance ToJSON Task

main :: IO ()
main = do
    fileLock <- newMVar ()
    scotty 3000 $ do
        get "/tasks" $ do
            tasks <- liftIO $ loadTasks fileLock
            json tasks

        post "/tasks" $ do
            body <- body
            let maybeTask = decode body :: Maybe Task
            case maybeTask of
                Just (Task newTask) -> do
                    liftIO $ addTask fileLock newTask
                    text "Task added successfully!"
                Nothing -> text "Invalid task format!"
