module Components.Items exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import List exposing (..)
import Markdown exposing (toHtml)
import String


type alias Item =
    { id : String
    , title : String
    , description : String
    , price : Float
    , image : String
    }



-- Cart Items


items : Html a
items =
    div [] [ getAllItems ]



-- Get al the items in the store.


getAllItems : Html a
getAllItems =
    let
        pizza =
            Item "sdasd2334431221" "Pizza" "Yummy!" 10.45 "https://sep.yimg.com/ay/yhst-19802326331255/pizza-slice-pennant-3x5-9.jpg"

        coke =
            Item "3343dcc334" "Coca Cola" "Tasty!" 8.8 "https://upload.wikimedia.org/wikipedia/commons/thumb/2/2c/Flasche_Coca-Cola_0%2C2_Liter.jpg/220px-Flasche_Coca-Cola_0%2C2_Liter.jpg"

        allItems =
            [ pizza, pizza, pizza, pizza, pizza, pizza, pizza, pizza, coke ]

        listOfItems =
            split 4 allItems
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



-- Single item display


singleItem : Item -> Bool -> Html a
singleItem item showAddToCart =
    let
        addToCartButton =
            if showAddToCart == True then
                div [ class "row" ]
                    [ div [ class "col-md-12" ]
                        [ button [ class "btn" ] [ text "Add to cart" ]
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
                , div [] [ text item.description ]
                , div [] [ text (toString item.price) ]
                ]
            ]
        , addToCartButton
        ]
