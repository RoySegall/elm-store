module Components.User exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Update exposing (..)


-- Cart component


cart : Int -> Html Msg
cart items =
    div
        [ class "cart-component" ]
        [ a [ onClick ToggleCart ] [ span [ class "glyphicon glyphicon-shopping-cart" ] [] ]
        , span [ class "number-of-items" ] [ text (toString items) ]
        ]



-- User bar


userBar : Html a
userBar =
    div [ class "user-bar" ]
        [ text "Welcome Guest" ]
