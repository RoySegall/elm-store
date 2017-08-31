module Main exposing (..)

-- component import example

import Components.Items exposing (..)
import Components.User exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Model exposing (..)
import Ports exposing (getItemsFromStorage)
import Update exposing (..)


-- INIT


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( { model | cartItems = flags.items }, getItems )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    getItemsFromStorage InitItems



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ nav [ class "navbar navbar-expand-lg navbar-light fixed-top", id "mainNav" ]
            [ div [ class "container" ]
                [ a [ class "navbar-brand js-scroll-trigger" ] [ text "Go store" ]
                , div [ class "collapse navbar-collapse", id "navbarResponsive" ]
                    [ ul [ class "navbar-nav ml-auto" ]
                        [ li [ class "nav-item" ] [ userBar ]
                        , li [ class "nav-item cart-wrapper" ] [ cart model ]
                        ]
                    ]
                ]
            ]
        , section [ class "download bg-primary text-center", id "download", onClick HideCart ]
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
                        , div [ class "col-md-12" ] [ itemsPager model.itemsNumber model.perpage ]
                        ]
                    ]
                ]
            ]
        , section [ class "contact bg-primary", onClick HideCart ]
            [ div [ class "container" ]
                [ h2 []
                    [ span [] [ text "Did you " ]
                    , i [ class "fa fa-heart" ] []
                    , span [] [ text " one of our books?" ]
                    ]
                , ul [ class "list-inline list-social" ]
                    [ li [ class "list-inline-item social-twitter" ] [ a [] [ i [ class "fa fa-twitter" ] [] ] ]
                    , li [ class "list-inline-item social-facebook" ] [ a [] [ i [ class "fa fa-facebook" ] [] ] ]
                    , li [ class "list-inline-item social-google-plus" ] [ a [] [ i [ class "fa fa-google-plus" ] [] ] ]
                    ]
                ]
            ]
        , footer []
            [ div [ class "container", onClick HideCart ]
                [ p [] [ text "Created by Roy Segall" ]
                , ul [ class "list-inline" ]
                    [ li [ class "fa fa-github" ] []
                    , a [ href "https://github.com/roysegall/go-store" ] [ text "Fork the backend" ]
                    , li [ class "fa fa-github" ] []
                    , a [ href "https://github.com/roysegall/elm-store" ] [ text "Fork this frontend" ]
                    ]
                ]
            ]
        ]
