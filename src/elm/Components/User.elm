module Components.User exposing (..)

import Components.Items exposing (currentItems)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import List exposing (length)
import Model exposing (Action, Model)
import Update exposing (..)


-- User bar


userBar : Html a
userBar =
    div [ class "user-bar" ]
        [ span [ class "welcome-guest" ] [ text "Welcome Guest" ]
        , a [ href "/user/login", class "login" ] [ text "Login" ]
        , a [ href "/user/register", class "register" ] [ text "Register" ]
        ]
