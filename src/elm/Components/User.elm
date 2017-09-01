module Components.User exposing (..)

import Components.Items exposing (currentItems)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import List exposing (length)
import Model exposing (Model)
import Update exposing (..)


-- Cart component


cart : Model -> Html Msg
cart model =
    div
        [ class "cart-component" ]
        [ a [ onClick ToggleCart ]
            [ span [ class "shopping-cart" ] [ text "Shopping cart" ]
            , span [ class "shopping-cart-counter" ] [ text (toString (length model.cartItems)) ]
            ]
        , currentItems model
        ]



-- User bar


userBar : Html Msg
userBar =
    div [ class "user-bar" ]
        [ span [ class "welcome-guest" ] [ text "Welcome Guest" ]
        , a [ href "/login", onLinkClick (ChangeLocation "login"), class "login" ] [ text "Login" ]
        , a [ href "/register", onLinkClick (ChangeLocation "register"), class "register" ] [ text "Register" ]
        ]
