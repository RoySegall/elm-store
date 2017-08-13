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
    div [ class "container main" ]
        [ div [ class "row upper-strip" ]
            [ div [ class "col-md-12" ]
                [ div [ class "row content-upper" ]
                    [ div [ class "col-md-10" ]
                        [ span [ class "logo" ] [ text "GoStore" ]
                        ]
                    , div [ class "col-md-2" ]
                        [ div [ class "row" ]
                            [ div [ class "col-md-6" ]
                                [ div [ class "row cart-wrapper" ]
                                    [ cart model.cartItems
                                    , currentItems model
                                    ]
                                ]
                            , div [ class "col-md-6" ] [ userBar ]
                            ]
                        ]
                    ]
                ]
            ]
        , div [ class "row content", onClick HideCart ]
            [ div [ class "col-md-12" ]
                [ div [ class "jumbotron" ]
                    [ items model.items
                    ]
                ]
            ]
        ]
