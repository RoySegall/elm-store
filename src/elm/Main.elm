module Main exposing (..)

-- component import example

import Components.Items exposing (..)
import Components.User exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Model exposing (..)
import Update exposing (..)


-- MODEL


model : Model
model =
    { cartItems = 0
    , cartItemsList = []
    , items = []
    , hideCart = True
    , text = ""
    }



-- APP


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- INIT


init : ( Model, Cmd Msg )
init =
    ( model
    , getItems
    )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ nav [ class "navbar navbar-expand-lg navbar-light fixed-top", id "mainNav" ]
            [ div [ class "container" ]
                [ a [ class "navbar-brand js-scroll-trigger" ] [ text "Go store" ]
                , div [ class "collapse navbar-collapse", id "navbarResponsive" ]
                    [ ul [ class "navbar-nav ml-auto" ]
                        [ li [ class "nav-item" ] [ a [] [ text "Download" ] ]
                        , li [ class "nav-item" ] [ a [] [ text "Download" ] ]
                        ]
                    ]
                ]
            ]
        , section [ class "download bg-primary text-center", id "download" ]
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
        , section [ class "features" ]
            [ div []
                [ div [ class "section-heading text-center" ]
                    [ h2 [] [ text "Browse our books" ]
                    , p [] [ text "We have a huge library. You probably find something!" ]
                    , i [ class "icon-screen-smartphone text-primary" ] []
                    ]
                , div [ class "container main" ]
                    [ div [ class "row" ]
                        [ div [ class "col-md-12" ] [ getAllItems model.items ]
                        ]
                    ]
                ]
            ]
        , section [ class "contact bg-primary" ]
            [ div [ class "container" ]
                [ h2 [] [ span [] [ text "Did you " ], i [ class "fa fa-heart" ] [], span [] [ text " one of our books?" ] ]
                ]
            ]
        ]



--    div [ class "container main" ]
--        [ div [ class "row upper-strip" ]
--            [ div [ class "col-md-12" ]
--                [ div [ class "row content-upper" ]
--                    [ div [ class "col-md-10" ]
--                        [ span [ class "logo" ] [ text "GoStore" ]
--                        ]
--                    , div [ class "col-md-2" ]
--                        [ div [ class "row" ]
--                            [ div [ class "col-md-6" ]
--                                [ div [ class "row cart-wrapper" ]
--                                    [ cart model.cartItems
--                                    , currentItems model
--                                    ]
--                                ]
--                            , div [ class "col-md-6" ] [ userBar ]
--                            ]
--                        ]
--                    ]
--                ]
--            ]
--        , div [ class "row content", onClick HideCart ]
--            [ div [ class "col-md-12" ]
--                [ div [ class "jumbotron" ]
--                    [ items model.items
--                    ]
--                ]
--            ]
--        ]
