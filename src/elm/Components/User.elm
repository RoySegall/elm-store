module Components.User exposing (..)

import Components.Items exposing (currentItems)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import List exposing (length)
import Model exposing (..)
import UpdateHelper exposing (onLinkClick)


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


userBar : Model -> Html Msg
userBar model =
    let
        greeting =
            if model.accessToken == "" then
                "Welcoem Guest"
            else
                model.loggedUser.username

        links =
            if model.accessToken == "" then
                div [ class "links" ]
                    [ a [ href "/#login", onLinkClick (ChangeLocation "/#login"), class "/#login" ] [ text "Login" ]
                    , a [ href "/#register", onLinkClick (ChangeLocation "register"), class "/#register" ] [ text "Register" ]
                    ]
            else
                div [ class "links" ]
                    [ a [ href "/#profile", class "profile", onLinkClick (ChangeLocation "login") ] [ text "Profile" ]
                    , a [ href "/#", class "logout", onClick Logout ] [ text "Logout" ]
                    ]
    in
    div [ class "user-bar" ]
        [ span [ class "welcome-text" ] [ text greeting ]
        , links
        ]
