module Main exposing (..)

import App exposing (..)
import Navigation exposing (program, Location)
import Router exposing (urlParser)


main : Program Never Model Msg
main =
    program urlParser
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
