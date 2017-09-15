module Views.Item exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Model exposing (..)


view : Model -> Html Msg
view model =
    let
        item =
            model.selectedItem

        imageAddress =
            model.backendAddress ++ "/" ++ item.image

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
