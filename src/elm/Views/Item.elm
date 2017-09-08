module Views.Item exposing (..)

import Components.Items exposing (singleItem)
import Config exposing (backend_address)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Model exposing (..)
import Update exposing (..)


view : Model -> Html Msg
view model =
    let
        item =
            model.selectedItem

        imageAddress =
            backend_address ++ "/" ++ item.image

        price =
            toString item.price
    in
    div [ class "content items" ]
        [ section [ onClick HideCart ]
            [ div
                [ class "container main" ]
                [ div [ class "row" ]
                    [ div [ class "col-md-12" ] [ h1 [] [ text item.title ] ]
                    ]
                , div [ class "row" ]
                    [ div [ class "col-md-4" ] [ img [ src imageAddress, class "img-responsive" ] [] ]
                    , div [ class "col-md-8" ]
                        [ p [ class "description" ] [ text item.description ]
                        , p [ class "price" ] [ text ("Price: " ++ price ++ "$") ]
                        ]
                    ]
                ]
            ]
        ]
