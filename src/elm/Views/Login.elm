module Views.Login exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Model exposing (..)
import Update exposing (..)


view : Model -> Html Msg
view model =
    section [ class "content login" ]
        [ Html.form []
            [ h1 [] [ text "Login" ]
            , p [] [ span [] [ text "Forgot your password? Why not " ], a [ href "" ] [ text "reset" ], span [] [ text " your password?" ] ]
            , div [ class "input-group" ]
                [ span [ class "input-group-addon", id "basic-addon1" ] [ i [ class "fa fa-user" ] [] ]
                , input [ type_ "text", class "form-control", placeholder "Username" ] []
                ]
            , div [ class "input-group" ]
                [ span [ class "input-group-addon", id "basic-addon1" ] [ i [ class "fa fa-key" ] [] ]
                , input [ type_ "password", class "form-control", placeholder "" ] []
                ]
            , div [ class "actions" ] [ button [ class "btn btn-success" ] [ text "login" ] ]
            ]
        ]
