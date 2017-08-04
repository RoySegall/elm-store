module Main exposing (..)

-- component import example

import Components.Items exposing (items)
import Components.User exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Model exposing (..)
import Update exposing (..)


-- APP


main : Program Never Model Msg
main =
    Html.beginnerProgram { model = model, view = view, update = update }



-- MODEL


model : Model
model =
    { cartItems = Int
    , items = List Item
    }



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
                            [ div [ class "col-md-6" ] [ cart model.cartItems ]
                            , div [ class "col-md-6" ] [ userBar ]
                            ]
                        ]
                    ]
                ]
            ]
        , div [ class "row content" ]
            [ div [ class "col-md-12" ]
                [ div [ class "jumbotron" ]
                    [ items
                    ]
                ]
            ]
        ]
