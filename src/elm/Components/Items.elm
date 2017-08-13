module Components.Items exposing (..)

import Debug exposing (log)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Http
import List exposing (..)
import Model exposing (..)
import Update exposing (..)


-- Cart Items.


items : List Item -> Html Msg
items itemList =
    div [] [ getAllItems itemList ]



-- Get al the items in the store.


getAllItems : List Item -> Html Msg
getAllItems itemList =
    let
        listOfItems =
            split 4 itemList
    in
    div []
        (List.map
            (\items ->
                div [ class "row" ]
                    (List.map (\item -> div [ class "col-md-3" ] [ singleItem item True ]) items)
            )
            listOfItems
        )


split : Int -> List a -> List (List a)
split i list =
    case take i list of
        [] ->
            []

        listHead ->
            listHead :: split i (drop i list)



-- Single item display.


singleItem : Item -> Bool -> Html Msg
singleItem item showAddToCart =
    let
        addToCartButton =
            if showAddToCart == True then
                div [ class "row" ]
                    [ div [ class "col-md-12" ]
                        [ button [ class "btn", onClick <| AddItems item ] [ text "Add to cart" ]
                        ]
                    ]
            else
                Html.text ""
    in
    div [ class "item" ]
        [ div [ class "row" ]
            [ div [ class "col-md-6" ] [ img [ src item.image, class "img-responsive" ] [] ]
            , div [ class "col-md-6" ]
                [ div [] [ text item.title ]
                , div [] [ text (toString item.price) ]
                ]
            ]
        , addToCartButton
        ]



-- Display all the items in the cart.


currentItems : Model -> Html Msg
currentItems model =
    let
        classes =
            [ ( "cart-items arrow", True ), ( "hidden", model.hideCart ) ]
    in
    div
        [ classList classes ]
        [ div [ class "close" ]
            [ a [ onClick HideCart ] [ span [ class "glyphicon glyphicon-remove" ] [] ]
            ]
        , div [ class "items-list" ]
            (List.map (\item -> div [] [ singleItem item False ]) model.cartItemsList)
        , div [ class "actions" ]
            [ button [ class "btn btn-success" ]
                [ span [ class "glyphicon glyphicon-ok" ] []
                , text "To checkout"
                ]
            ]
        ]
