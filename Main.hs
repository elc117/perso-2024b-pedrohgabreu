{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

import Web.Scotty
import Data.Aeson (ToJSON, FromJSON, encode, decode)
import Control.Monad.IO.Class (liftIO)
import Data.Text.Lazy (Text)
import Data.Text.Lazy.Encoding (decodeUtf8, encodeUtf8)
import qualified Data.ByteString.Lazy as B
import Data.Maybe (fromMaybe)
import Control.Monad (when)
import Control.Concurrent.MVar
import System.IO (hFlush, stdout)
import System.Directory (doesFileExist)
import GHC.Generics (Generic)
import Control.Exception (finally)

-- Definindo a estrutura da Task com DeriveGeneric para derivar Generic, ToJSON e FromJSON
data Task = Task
  { taskId :: Int
  , taskDescription :: String
  , isCompleted :: Bool
  } deriving (Show, Eq, Generic)

-- Instâncias automáticas para conversão de JSON
instance ToJSON Task
instance FromJSON Task

-- Função para salvar tarefas em um arquivo com controle de acesso
saveTasksToFile :: FilePath -> [Task] -> MVar () -> IO ()
saveTasksToFile filePath tasks fileLock = do
  -- Garantindo que só uma thread acesse o arquivo de cada vez
  takeMVar fileLock `finally` putMVar fileLock ()
  B.writeFile filePath (encode tasks)

-- Função para carregar tarefas de um arquivo com controle de acesso
loadTasksFromFile :: FilePath -> MVar () -> IO (Maybe [Task])
loadTasksFromFile filePath fileLock = do
  -- Garantindo que só uma thread acesse o arquivo de cada vez
  takeMVar fileLock `finally` putMVar fileLock ()
  content <- B.readFile filePath
  return (decode content)

-- Função para inicializar o arquivo caso não exista
initTasksFile :: FilePath -> MVar () -> IO ()
initTasksFile filePath fileLock = do
  exists <- doesFileExist filePath
  when (not exists) $ saveTasksToFile filePath [] fileLock

main :: IO ()
main = do
  let filePath = "tasks.json"
  fileLock <- newMVar ()  -- Inicializa o MVar
  initTasksFile filePath fileLock  -- Inicializar o arquivo se não existir

  scotty 3000 $ do
    -- Endpoint para listar todas as tarefas
    get "/tasks" $ do
      tasks <- liftIO (loadTasksFromFile filePath fileLock)
      json $ fromMaybe ([] :: [Task]) tasks

    -- Endpoint para adicionar uma nova tarefa
    post "/tasks" $ do
      newTask <- jsonData :: ActionM Task
      tasks <- liftIO (loadTasksFromFile filePath fileLock)
      let updatedTasks = fromMaybe [] tasks ++ [newTask]
      liftIO (saveTasksToFile filePath updatedTasks fileLock)
      json updatedTasks
