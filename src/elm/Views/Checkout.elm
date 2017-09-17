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
        , div [ class "element" ]
            [ div [ class "title" ] [ text "Go store card" ]
            , div [ class "inputs-upper row" ]
                [ div [ class "col-md-10 number" ]
                    [ div []
                        [ input [ type_ "text", placeholder "0000", maxlength 4 ] []
                        , input [ type_ "text", placeholder "0000", maxlength 4 ] []
                        , input [ type_ "text", placeholder "0000", maxlength 4 ] []
                        , input [ type_ "text", placeholder "0000", maxlength 4 ] []
                        ]
                    ]
                , div [ class "col-md-2 cv" ]
                    [ div [] [ input [ type_ "text", maxlength 3, placeholder "CV" ] [] ]
                    ]
                ]
            , div [ class "inputs-footer row" ]
                [ div [ class "col-md-8 name" ] [ input [ placeholder "First name", class "first-name" ] [], input [ placeholder "Last name", class "last-name" ] [] ]
                , div [ class "col-md-4 exp" ]
                    [ select [ class "month" ]
                        [ option [ value "MM" ] [ text "MM" ]
                        , option [ value "01" ] [ text "01" ]
                        , option [ value "02" ] [ text "02" ]
                        , option [ value "03" ] [ text "03" ]
                        , option [ value "04" ] [ text "04" ]
                        , option [ value "05" ] [ text "05" ]
                        , option [ value "06" ] [ text "06" ]
                        , option [ value "07" ] [ text "07" ]
                        , option [ value "09" ] [ text "09" ]
                        , option [ value "10" ] [ text "10" ]
                        , option [ value "11" ] [ text "11" ]
                        , option [ value "12" ] [ text "12" ]
                        ]
                    , select [ class "year" ]
                        [ option [ value "YYYY" ] [ text "YYYY" ]
                        , option [ value "2017" ] [ text "2017" ]
                        , option [ value "2017" ] [ text "2018" ]
                        , option [ value "2017" ] [ text "2019" ]
                        ]
                    ]
                ]
            ]
        , div [ class "actions row" ]
            [ div [ class "col-md-3 text-left" ] [ button [ class "btn btn-primary", onClick <| ChangeCheckoutStep 1 ] [ text "Return to items" ] ]
            , div [ class "col-md-9 text-right" ] [ button [ class "btn btn-success", onClick <| ChangeCheckoutStep 1 ] [ text "I'm done!" ] ]
            ]
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
