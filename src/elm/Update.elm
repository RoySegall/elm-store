module Update exposing (..)

import Model exposing (..)


-- UPDATE


type Msg
    = AddItems Item


update : Msg -> Model -> Model
update msg model =
    case msg of
        AddItems item ->
            { model | cartItems = model.cartItems + 1, items = model.items ++ [ item ] }
