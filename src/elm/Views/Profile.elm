module Views.Profile exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Model exposing (..)


view : Model -> Html Msg
view model =
    div [ class "content profile" ]
        [ section [ onClick HideCart ]
            [ text "a"
            ]
        ]
