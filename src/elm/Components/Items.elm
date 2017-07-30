module Components.Items exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Markdown exposing (toHtml)
import String

type alias Item =
  {
    id : String
    , title : String
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
    pizza = Item "sdasd2334431221" "Pizza" 10.45 "https://sep.yimg.com/ay/yhst-19802326331255/pizza-slice-pennant-3x5-9.jpg"
    coke = Item "3343dcc334" "Coca Cola" 8.8 "https://upload.wikimedia.org/wikipedia/commons/thumb/2/2c/Flasche_Coca-Cola_0%2C2_Liter.jpg/220px-Flasche_Coca-Cola_0%2C2_Liter.jpg"

    listOfItems = [pizza, pizza, pizza, coke]

  in
    div [ class "row" ]
    [
      ul []
        (List.map (\l -> li [] [ singleItem l ]) listOfItems)
    ]

-- Single item display
singleItem : Item -> Html a
singleItem item =
  div [ class "item" ]
  [
    div [] [ text item.title ]
    , div [] [ text ( toString item.price ) ]
    , div [] [ img [ src item.image ] [] ]
  ]
