module App exposing (..)

import Html exposing (Html, Attribute, button, div, text)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import Svg exposing (svg, rect)
import Svg.Attributes exposing (..)
import Set exposing (Set)
import Navigation exposing (Location, modifyUrl)


type alias Key =
    Int


type alias Model =
    { selectedKeys : Set Key
    }


init : Location -> ( Model, Cmd Msg )
init location =
    ( fromUrl location.hash
    , Cmd.none
    )


type Msg
    = Select Key
    | Deselect Key
    | NewKeys String


toUrl : Model -> String
toUrl model =
    if Set.isEmpty model.selectedKeys then
        "/#"
    else
        let
            keys =
                List.map toString (Set.toList model.selectedKeys)
        in
            "#" ++ String.join "," keys


withoutHash : String -> String
withoutHash hash =
    (String.dropLeft 1 hash)


toNotes : String -> Set Int
toNotes hash =
    String.split "," (withoutHash hash)
        |> List.map String.toInt
        |> List.map Result.toMaybe
        |> List.filterMap identity
        |> Set.fromList


fromUrl : String -> Model
fromUrl hash =
    { selectedKeys = toNotes hash
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Select key ->
            let
                nextModel =
                    { model | selectedKeys = Set.insert key model.selectedKeys }
            in
                ( nextModel
                , modifyUrl (toUrl nextModel)
                )

        Deselect key ->
            let
                nextModel =
                    { model | selectedKeys = Set.remove key model.selectedKeys }
            in
                ( nextModel
                , modifyUrl (toUrl nextModel)
                )

        NewKeys hash ->
            ( fromUrl hash
            , Cmd.none
            )


rootStyle : Attribute msg
rootStyle =
    Html.Attributes.style
        [ ( "margin", "50px" ) ]


blackKey : Key -> Bool -> Html Msg
blackKey key selected =
    svg
        [ width "40", height "120", viewBox "0 0 40 120" ]
        [ rect
            [ x "10"
            , y "10"
            , width "20"
            , height "100"
            , rx "15"
            , ry "15"
            , onClick
                (if selected then
                    Deselect key
                 else
                    Select key
                )
            , fill
                (if selected then
                    "yellow"
                 else
                    "black"
                )
            ]
            []
        ]


view : Model -> Html Msg
view model =
    div [ rootStyle ]
        (List.map
            (\key -> blackKey key (Set.member key model.selectedKeys))
            [ 1, 2, 3 ]
        )


subscriptions =
    (always Sub.none)
