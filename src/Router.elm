module Router exposing (urlParser)

import App exposing (..)
import Navigation exposing (Location)


urlParser location =
    NewKeys location.hash
