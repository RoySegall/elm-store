module Views.Items exposing (..)

import Components.Items exposing (getAllItems, pager)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Model exposing (..)
import Update exposing (..)


view : Model -> Html Msg
view model =
    div [ class "content" ]
        [ section
            [ class "download bg-primary text-center", id "download", onClick HideCart ]
            [ div [ class "container" ]
                [ div [ class "row" ]
                    [ div [ class "col-md-8 mx-auto" ]
                        [ h2 [ class "section-heading" ] [ text "Discover what all the buzz is about!" ]
                        , p [] [ text "Our app is available on any mobile device! Download now to get started!" ]
                        , div [ class "badges" ]
                            [ a [ class "badge-link" ] [ img [ src "static/img/google-play-badge.svg" ] [] ]
                            , a [ class "badge-link" ] [ img [ src "static/img/app-store-badge.svg" ] [] ]
                            ]
                        ]
                    ]
                ]
            ]
        , section [ class "features", onClick HideCart ]
            [ div []
                [ div [ class "section-heading text-center" ]
                    [ h2 [] [ text "Browse our books" ]
                    , p [] [ text "We have a huge library. You probably find something!" ]
                    , i [ class "icon-screen-smartphone text-primary" ] []
                    ]
                , div [ class "container main" ]
                    [ div [ class "row" ]
                        [ div [ class "col-md-12" ] [ getAllItems model.items ]
                        , div [ class "col-md-12" ] [ pager model.itemsNumber model.perpage ]
                        ]
                    ]
                ]
            ]
        ]
