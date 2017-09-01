module Components.Items exposing (..)

import Config exposing (backend_address)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import List exposing (..)
import Model exposing (..)
import Update exposing (..)


-- Get al the items in the store.


getAllItems : List Item -> Html Msg
getAllItems itemList =
    let
        listOfItems =
            split 3 itemList
    in
    div []
        (List.map
            (\items ->
                div [ class "row items-wrapper" ]
                    (List.map (\item -> div [ class "col-md-4" ] [ singleItem item True ]) items)
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



-- Items pager


pager : Int -> Int -> Html Msg
pager itemsNumber perPage =
    let
        pages =
            floor (toFloat itemsNumber / toFloat perPage)

        items =
            List.range 0 pages

        pageLInks =
            List.map (\page -> li [ class "", onClick (GetItemsAtPage page) ] [ text (toString (page + 1)) ]) items
    in
    ul [ class "pagiation" ] pageLInks



-- Single item display.


singleItem : Item -> Bool -> Html Msg
singleItem item showAddToCart =
    let
        addToCartButton =
            if showAddToCart == True then
                div [ class "row" ]
                    [ div [ class "col-md-12" ]
                        [ button [ class "btn btn-info", onClick <| AddItems item ]
                            [ i [ class "fa fa-plus" ]
                                []
                            , span [] [ text "Add to cart" ]
                            ]
                        ]
                    ]
            else
                button
                    [ class "btn btn-danger", onClick (RemoveItemFromCart item) ]
                    [ span [ class "fa fa-trash-o" ] []
                    , text "Remove from cart"
                    ]

        imageAddress =
            backend_address ++ "/" ++ item.image
    in
    div [ class "item" ]
        [ div [ class "row" ]
            [ div [ class "col-md-4 first" ] [ img [ src imageAddress, class "img-responsive" ] [] ]
            , div [ class "col-md-8 second" ]
                [ div []
                    [ div [ class "title" ] [ text item.title ]
                    , div [ class "description" ] [ text item.description ]
                    , div [ class "price" ] [ text (toString item.price ++ " $") ]
                    ]
                , div [ class "add-to-cart" ] [ addToCartButton ]
                ]
            ]
        ]



-- Display all the items in the cart.


currentItems : Model -> Html Msg
currentItems model =
    let
        classes =
            [ ( "cart-items arrow", True ), ( "hidden", model.hideCart ) ]

        cart_items =
            if length model.cartItems == 0 then
                div
                    [ classList classes ]
                    [ div [ class "no-items" ] [ text "Whoops... Your cart is empty." ]
                    ]
            else
                div
                    [ classList classes ]
                    [ div [ class "items-list" ]
                        (List.map (\item -> div [] [ singleItem item False ]) model.cartItems)
                    , div [ class "actions" ]
                        [ button [ class "btn btn-success" ]
                            [ span [ class "fa fa-sign-in" ] []
                            , text "To checkout"
                            ]
                        , button [ class "btn btn-danger", onClick (ClearCart model) ]
                            [ span [ class "fa fa-trash-o" ] []
                            , text "Clear cart"
                            ]
                        ]
                    ]
    in
    cart_items
