module Views.Profile exposing (..)

import Components.Items exposing (currentItems, singleItem)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import List exposing (length)
import Model exposing (..)


view : Model -> Html Msg
view model =
    let
        items =
            if length model.cartItems == 0 then
                div
                    []
                    [ div [ class "no-items" ] [ text "Whoops... Your cart is empty." ]
                    ]
            else
                div [ class "items-list" ]
                    (List.map (\item -> div [] [ singleItem model item False ]) model.cartItems)
    in
    div [ class "content profile" ]
        [ section [ onClick HideCart ]
            [ h1 [] [ text model.loggedUser.username ]
            , div [ class "row" ]
                [ div [ class "col-md-6" ] [ img [ src (model.backendAddress ++ "/" ++ model.loggedUser.image), class "img-responsive" ] [] ]
                , div [ class "col-md-6" ]
                    [ h4 [] [ text "Your current cart:" ]
                    , items
                    ]
                ]
            ]
        ]
