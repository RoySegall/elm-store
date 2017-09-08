module Views.ItemPage exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Model exposing (..)
import Update exposing (..)


view : Model -> Html Msg
view model =
    div [ class "content items" ]
        [ section [ onClick HideCart ]
            [ div
                [ class "container main" ]
                [ div [ class "row" ]
                    [ div [ class "col-md-12" ] [ text model.id ]
                    ]
                ]
            ]
        ]
