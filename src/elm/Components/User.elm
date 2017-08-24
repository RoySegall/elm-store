module Components.User exposing (..)

import Components.Items exposing (currentItems)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Model exposing (Model)
import Update exposing (..)


-- Cart component


cart : Model -> Html Msg
cart model =
    div
        [ class "cart-component" ]
        [ a [ onClick ToggleCart ]
            [ span [ class "shopping-cart" ] [ text "Shopping cart" ]
            , span [ class "shopping-cart-counter" ] [ text (toString model.cartItems) ]
            , currentItems model
            ]
        ]



-- User bar


userBar : Html a
userBar =
    div [ class "user-bar" ]
        [ a [] [ text "Welcome Guest" ] ]
