module Views.Checkout exposing (..)

import Components.Items exposing (currentItems, singleItem)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import List exposing (length)
import Model exposing (..)


view : Model -> Html Msg
view model =
    div [ class "content checkout" ]
        [ checkoutItems model, creditCard model ]


checkoutItems : Model -> Html Msg
checkoutItems model =
    section [ onClick HideCart, class "checkout_items" ]
        [ h1 [] [ text "Checkout" ]
        , p [] [ text "Let's have a quick look on your products. You can remove items you don't want." ]
        , div [ class "checkout-items" ] [ itemsTable model ]
        , div [ class "sum" ]
            [ div [ class "sum-content" ]
                [ div [ class "row" ]
                    [ div [ class "col-md-9" ] [ strong [] [ text ("Total: " ++ toString (totalToPay model)) ] ]
                    , div [ class "col-md-3 text-right" ] [ button [ class "btn btn-success", onClick <| ChangeCheckoutStep 2 ] [ text "Go to payment method" ] ]
                    ]
                ]
            ]
        ]


creditCard : Model -> Html Msg
creditCard model =
    section [ onClick HideCart, class "credit_card" ]
        [ h1 [] [ text "Checkout" ]
        , p [] [ text "Now, let's select a way to pay for the products!" ]
        , div [ class "col-md-3 text-left" ] [ button [ class "btn btn-info", onClick <| ChangeCheckoutStep 1 ] [ text "Return to items" ] ]
        ]


totalToPay : Model -> Float
totalToPay model =
    let
        price =
            List.sum (List.map (\item -> item.price) model.cartItems)
    in
    price


itemsTable : Model -> Html Msg
itemsTable model =
    let
        items =
            List.map (\item -> itemTr model item) model.cartItems
    in
    table [ class "table table-striped table-hover table-responsive" ]
        [ thead []
            [ tr []
                [ th [ colspan 2 ] [ text "Title" ]
                , th [] [ text "Description" ]
                , th [ colspan 2 ] [ text "Price" ]
                ]
            ]
        , tbody []
            items
        ]


itemTr : Model -> Item -> Html Msg
itemTr model item =
    let
        imageAddress =
            model.backendAddress ++ "/" ++ item.image
    in
    tr []
        [ td [ class "image" ] [ img [ src imageAddress, class "img-responsive" ] [] ]
        , td [ class "title" ] [ text item.title ]
        , td [ class "description" ] [ text item.description ]
        , td [ class "price" ] [ text (toString item.price) ]
        , td [ class "button" ]
            [ button
                [ class "btn btn-danger", onClick (RemoveItemFromCart item) ]
                [ span [ class "fa fa-trash-o" ] []
                ]
            ]
        ]
