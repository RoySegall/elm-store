module Views.Login exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Model exposing (..)
import Update exposing (..)


view : Model -> Html Msg
view model =
    let
        error =
            if model.error == "" then
                Html.text ""
            else
                div [ class "alert alert-danger" ] [ text model.error ]
    in
    section [ class "content login" ]
        [ Html.form [ onSubmit UserLogin ]
            [ h1 [] [ text "Login" ]
            , p [] [ span [] [ text "Forgot your password? Why not " ], a [ href "" ] [ text "reset" ], span [] [ text " your password?" ] ]
            , error
            , div [ class "input-group" ]
                [ span [ class "input-group-addon", id "basic-addon1" ] [ i [ class "fa fa-user" ] [] ]
                , input [ type_ "text", class "form-control", placeholder "Username", onInput UpdateUsername ] []
                ]
            , div [ class "input-group" ]
                [ span [ class "input-group-addon", id "basic-addon1" ] [ i [ class "fa fa-key" ] [] ]
                , input [ type_ "password", class "form-control", placeholder "", onInput UpdatePassword ] []
                ]
            , div [ class "actions" ] [ button [ class "btn btn-success" ] [ text "login" ] ]
            ]
        ]
