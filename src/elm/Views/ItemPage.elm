module Views.ItemPage exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Model exposing (..)
import Update exposing (..)


view : Model -> Html Msg
view model =
    section [ class "content item" ]
        [ div [] [ text "a" ]
        ]
