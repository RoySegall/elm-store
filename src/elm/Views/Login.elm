module Views.Login exposing (..)

import Components.Items exposing (getAllItems, itemsPager)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Model exposing (..)
import Update exposing (..)


view : Model -> Html Msg
view model =
    div [ class "content" ]
        [ section []
            [ text "a"
            ]
        ]
