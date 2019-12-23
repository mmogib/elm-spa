port module Api exposing (storeCache)
import Json.Encode exposing (Value)

port storeCache : Maybe Value -> Cmd msg
