{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

module Main where

import Data.Aeson
import GHC.Generics
import Network.Wai
import Network.Wai.Handler.Warp
import Servant

type MusicAPI = "artists" :> Get '[JSON] [Artist]

data Artist = Artist
  { id :: Int
  , name :: String
  } deriving (Eq, Show, Generic)

instance ToJSON Artist

artists :: [Artist]
artists =
  [ Artist 1 "Juan Atkins"
  , Artist 2 "Larry Heard"
  , Artist 3 "Marcos Valle"
  , Artist 4 "Arthur Russell"
  , Artist 5 "Charles Mingus"
  , Artist 6 "Nils Frahm"
  , Artist 7 "Sun Kil Moon"
  , Artist 8 "Sleaford Mods"
  ]

server :: Server MusicAPI
server =
  return artists

musicAPI :: Proxy MusicAPI
musicAPI = Proxy

app :: Application
app =
  serve musicAPI server

main :: IO ()
main = do
  run 8000 app
