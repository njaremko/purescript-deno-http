module Main
  ( Resp
  , main
  ) where

import Prelude
import Data.Map as Map
import Data.Maybe (Maybe(..))
import Data.String (Replacement(..), Pattern(..), replace)
import Deno as Deno
import Deno.Http (Response, createResponse, hContentTypeHtml, serveListener)
import Deno.Http.Request as Request
import Effect (Effect)
import Effect.Aff (launchAff_)
import Effect.Class (liftEffect)
import Effect.Console (log)

type Resp
  = { error :: String
    }

main :: Effect Unit
main = do
  log "🍝"
  listener <- Deno.listen { port: 3001 }
  let
    replacer = replace (Pattern "http://localhost:3001") (Replacement "")
  launchAff_
    $ serveListener listener
        ( \req ->
            liftEffect
              $ pure
              $ router
              $ replacer
              $ Request.url req
        )
        Nothing

router :: String -> Response
router "/" =
  let
    payload = "<html><head></head><body><div>Hello World!</div></body></html>"

    headers = Just $ Map.fromFoldable [ hContentTypeHtml ]

    response_options = Just { headers, status: Nothing, statusText: Nothing }
  in
    createResponse payload response_options

router _ = createResponse "Fallthrough!" Nothing
