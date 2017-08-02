module Main exposing (..)

import Components.Items exposing (items)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)


-- component import example

import Components.User exposing (..)


-- APP


main : Program Never Int Msg
main =
    Html.beginnerProgram { model = model, view = view, update = update }



-- MODEL


type alias Model =
    Int


model : number
model =
    0



-- UPDATE


type Msg
    = NoOp
    | Increment


update : Msg -> Model -> Model
update msg model =
    case msg of
        NoOp ->
            model

        Increment ->
            model + 1



-- VIEW


view : Model -> Html Msg
view model =
    div [ class "container main" ]
        [ div [ class "row upper-strip" ]
            [ div [ class "col-md-12" ]
                [ div [ class "row content-upper" ]
                    [ div [ class "col-md-10" ]
                        [ span [ class "logo" ] [ text "GoStore" ]
                        ]
                    , div [ class "col-md-2" ]
                        [ div [ class "row" ]
                            [ div [ class "col-md-6" ] [ cart 0 ]
                            , div [ class "col-md-6" ] [ userBar ]
                            ]
                        ]
                    ]
                ]
            ]
        , div [ class "row content" ]
            [ div [ class "col-md-12" ]
                [ div [ class "jumbotron" ]
                    [ items
                    ]
                ]
            ]
        ]
